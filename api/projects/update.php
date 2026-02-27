<?php
// MH CreationX - Update Project Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken || !isset($userToken->type) || $userToken->type !== 'staff') {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

// Team members cannot modify payment or public/visibility flags (restricted policy)
$teamBlockedFields = [
    'payment_status',
    'payment_method',
    'payment_details',
    'paid_amount',
    'advance_amount',
    'discount',
    'is_visible_on_public',
    'show_in_animation',
    'show_in_previous'
];

$isAdmin = (isset($userToken->role) && $userToken->role === 'Admin');
$role = $userToken->role ?? '';
$isTeam = in_array($role, ['Team', 'TeamMember', 'team_member'], true);
$staffUserId = isset($userToken->id) ? $userToken->id : null;

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "Project ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Team members can only update their own projects
if ($isTeam && $staffUserId) {
    $ownerStmt = $conn->prepare("SELECT created_by FROM projects WHERE id = :id LIMIT 1");
    $ownerStmt->execute([':id' => $data->id]);
    $ownerRow = $ownerStmt->fetch(PDO::FETCH_ASSOC);
    if (!$ownerRow) {
        http_response_code(404);
        echo json_encode(["error" => "Project not found"]);
        exit;
    }

    if (($ownerRow['created_by'] ?? null) !== $staffUserId) {
        http_response_code(403);
        echo json_encode(["error" => "Access denied"]);
        exit;
    }
}

// Construct Dynamic Update Query
$fields = [];
$params = [':id' => $data->id];

// Helper: read current payment fields for advanced rules
$currentPayment = null;
try {
    $curStmt = $conn->prepare("SELECT price, paid_amount, advance_amount, payment_status FROM projects WHERE id = :id LIMIT 1");
    $curStmt->execute([':id' => $data->id]);
    $currentPayment = $curStmt->fetch(PDO::FETCH_ASSOC);
}
catch (PDOException $e) {
    $currentPayment = null;
}

// Field mapping: camelCase (from frontend) => snake_case (database)
$fieldMap = [
    'customerId' => 'customer_id',
    'deliveryDate' => 'delivery_date',
    'advanceAmount' => 'advance_amount',
    'paidAmount' => 'paid_amount',
    'paymentStatus' => 'payment_status',
    'paymentMethod' => 'payment_method',
    'paymentDetails' => 'payment_details',
    'isVisibleOnPublic' => 'is_visible_on_public',
    'showInAnimation' => 'show_in_animation',
    'showInPrevious' => 'show_in_previous',
    'designerName' => 'designer_name',
    'assistantName' => 'assistant_name',
    'driveLink' => 'drive_link'
];

$allowedFields = ['title', 'customer_id', 'category', 'description', 'director', 'status', 'price',
    'advance_amount', 'paid_amount', 'discount', 'payment_status', 'payment_method',
    'payment_details', 'delivery_date', 'is_visible_on_public',
    'show_in_animation', 'show_in_previous', 'designer_name', 'assistant_name', 'drive_link'];

foreach ($allowedFields as $field) {
    if ($isTeam && in_array($field, $teamBlockedFields, true)) {
        continue;
    }
    // Check both snake_case and camelCase versions
    $camelField = array_search($field, $fieldMap) ?: $field;
    $valueToCheck = null;

    if (isset($data->$field)) {
        $valueToCheck = $data->$field;
    }
    elseif (isset($data->$camelField)) {
        $valueToCheck = $data->$camelField;
    }

    if ($valueToCheck !== null) {
        // Handle JSON fields
        if ($field === 'payment_details' && (is_object($valueToCheck) || is_array($valueToCheck))) {
            $fields[] = "$field = :$field";
            $params[":$field"] = json_encode($valueToCheck);
        }
        else {
            $fields[] = "$field = :$field";
            $params[":$field"] = $valueToCheck;
        }
    }
}

// ── Track which fields the user explicitly sent (for audit log) ──
// This must happen BEFORE any auto-computation adds extra keys to $params.
$userSentFieldKeys = array_keys($params);
$userSentFieldKeys = array_filter($userSentFieldKeys, function ($f) {
    return $f !== ':id';
});

// ── Determine incoming values ──
$incomingPaymentStatus = isset($params[':payment_status']) ? $params[':payment_status'] : null;
$incomingAdvance = isset($params[':advance_amount']) ? floatval($params[':advance_amount']) : null;
$incomingPaid = isset($params[':paid_amount']) ? floatval($params[':paid_amount']) : null;

// Helper: get price (incoming or current)
$priceValue = 0;
if (isset($params[':price'])) {
    $priceValue = floatval($params[':price']);
}
elseif ($currentPayment && isset($currentPayment['price'])) {
    $priceValue = floatval($currentPayment['price']);
}

// Validate advance if present
if ($incomingAdvance !== null) {
    if ($incomingAdvance < 0) {
        http_response_code(400);
        echo json_encode(["error" => "Advance cannot be negative"]);
        exit;
    }
    if ($incomingAdvance > $priceValue) {
        http_response_code(400);
        echo json_encode(["error" => "Advance cannot exceed total project price"]);
        exit;
    }
}

// ── Refactored Payment Sync (Ensures Dashboard Accuracy) ──
if (!$isTeam) {
    // 1. Capture current baseline
    $currentStatus = $currentPayment['payment_status'] ?? 'Unpaid';
    $currentPrice = floatval($currentPayment['price'] ?? 0);
    $currentAdvance = floatval($currentPayment['advance_amount'] ?? 0);

    // 2. Determine final state after this update
    $finalStatus = ($incomingPaymentStatus !== null) ? $incomingPaymentStatus : $currentStatus;
    $finalPrice = (isset($params[':price'])) ? floatval($params[':price']) : $currentPrice;
    $finalAdvance = ($incomingAdvance !== null) ? $incomingAdvance : $currentAdvance;

    // 3. Apply User Logic:
    // - If Paid: paid_amount = total price
    // - If Not Paid: paid_amount = advance_amount
    if ($finalStatus === 'Paid') {
        $targetPaid = $finalPrice;
    }
    else {
        $targetPaid = $finalAdvance;
    }

    // 4. Update query parameters
    if (!in_array('paid_amount = :paid_amount', $fields, true)) {
        $fields[] = "paid_amount = :paid_amount";
    }
    $params[':paid_amount'] = $targetPaid;

    // Bonus: If advance was explicitly sent but status wasn't, 
    // and they aren't marked Paid, ensure status remains/becomes consistent.
    if ($finalStatus !== 'Paid') {
        $autoStatus = ($finalAdvance > 0) ? 'Partial' : 'Unpaid';
        if (!in_array('payment_status = :payment_status', $fields, true)) {
            $fields[] = "payment_status = :payment_status";
        }
        $params[':payment_status'] = $autoStatus;
    }
}

if (empty($fields)) {
    echo json_encode(["message" => "No changes provided"]);
    exit;
}

$sql = "UPDATE projects SET " . implode(', ', $fields) . " WHERE id = :id";
$stmt = $conn->prepare($sql);

// ── Snapshot BEFORE update for smart change-detection in audit log ──
$beforeRow = null;
try {
    $bStmt = $conn->prepare("SELECT * FROM projects WHERE id = :id LIMIT 1");
    $bStmt->execute([':id' => $data->id]);
    $beforeRow = $bStmt->fetch(PDO::FETCH_ASSOC);
}
catch (PDOException $e) {
    $beforeRow = null;
}

try {
    $stmt->execute($params);

    // Fetch updated project for friendly audit details
    $projectRow = null;
    try {
        $projStmt = $conn->prepare("SELECT title, customer_id, price, paid_amount, payment_status, payment_method FROM projects WHERE id = :id LIMIT 1");
        $projStmt->execute([':id' => $data->id]);
        $projectRow = $projStmt->fetch(PDO::FETCH_ASSOC);
    }
    catch (PDOException $e) {
        $projectRow = null;
    }

    // Handle Image Links if provided (sync with project_images table)
    if (isset($data->images) && is_array($data->images)) {
        $delSql = "DELETE FROM project_images WHERE project_id = :pid";
        $delStmt = $conn->prepare($delSql);
        $delStmt->execute([':pid' => $data->id]);

        $imgSql = "INSERT INTO project_images (project_id, image_url, type) VALUES (:pid, :url, :type)";
        $imgStmt = $conn->prepare($imgSql);
        foreach ($data->images as $img) {
            $imgStmt->execute([
                ':pid' => $data->id,
                ':url' => $img->url,
                ':type' => $img->type ?? 'poster'
            ]);
        }
    }

    // ── Smart Audit Log ──
    try {
        $custStmt = $conn->prepare("SELECT customer_id FROM projects WHERE id = :id LIMIT 1");
        $custStmt->execute([':id' => $data->id]);
        $custRow = $custStmt->fetch(PDO::FETCH_ASSOC);
        $customerId = $custRow['customer_id'] ?? null;

        // Convert param keys to field names (strip leading ':')
        $allSentFields = array_map(function ($f) {
            return str_replace(':', '', $f);
        }, $userSentFieldKeys);

        // ── Compare old vs new: only keep fields that ACTUALLY changed ──
        // Use type-aware comparison so "500" == "500.00" for numeric fields
        $numericFields = ['price', 'paid_amount', 'advance_amount', 'discount'];
        $booleanFields = ['is_visible_on_public', 'show_in_animation', 'show_in_previous'];

        $changedFields = [];
        if ($beforeRow) {
            foreach ($allSentFields as $f) {
                if (!array_key_exists($f, $beforeRow)) {
                    $changedFields[] = $f; // new column the DB didn't have — always report
                    continue;
                }
                $oldVal = $beforeRow[$f];
                $newVal = $params[':' . $f];

                // Numeric fields: compare as floats to avoid "500" vs "500.00" mismatch
                if (in_array($f, $numericFields, true)) {
                    if (abs(floatval($oldVal) - floatval($newVal)) > 0.001) {
                        $changedFields[] = $f;
                    }
                }
                // Boolean/toggle fields: compare as integers (0/1)
                elseif (in_array($f, $booleanFields, true)) {
                    if (intval($oldVal) !== intval($newVal)) {
                        $changedFields[] = $f;
                    }
                }
                // Everything else: plain string comparison (trimmed)
                else {
                    if (trim((string)$oldVal) !== trim((string)$newVal)) {
                        $changedFields[] = $f;
                    }
                }
            }
        }
        else {
            $changedFields = $allSentFields; // no snapshot — fall back to reporting all
        }

        // If nothing actually changed, skip the audit log entirely
        if (empty($changedFields)) {
        // No real changes — don't pollute the log
        }
        else {
            // Friendly display names
            $friendlyMap = [
                'title' => 'Project name',
                'description' => 'Description',
                'category' => 'Category',
                'status' => 'Status',
                'customer_id' => 'Client',
                'delivery_date' => 'Delivery date',
                'price' => 'Price',
                'advance_amount' => 'Advance',
                'paid_amount' => 'Amount received',
                'discount' => 'Discount',
                'payment_status' => 'Payment status',
                'payment_method' => 'Payment method',
                'payment_details' => 'Payment details',
                'drive_link' => 'Download link',
                'designer_name' => 'Designer',
                'assistant_name' => 'Assistant',
                'director' => 'Director',
                'is_visible_on_public' => 'Public visibility',
                'show_in_animation' => 'Animation showcase',
                'show_in_previous' => 'Previous work showcase'
            ];

            // Payment-related fields
            $paymentFields = ['paid_amount', 'payment_status', 'payment_method',
                'payment_details', 'advance_amount', 'price', 'discount'];

            // Check if ANY actually-changed field is payment-related
            $paymentTouched = !empty(array_intersect($changedFields, $paymentFields));

            $projectTitle = $projectRow['title'] ?? ($beforeRow['title'] ?? null);
            $projectLabel = $projectTitle ? "{$projectTitle} ({$data->id})" : "project {$data->id}";

            if ($paymentTouched && $projectRow) {
                // ── Payment-style log: show financial summary ──
                $paid = isset($projectRow['paid_amount']) ? floatval($projectRow['paid_amount']) : 0;
                $price = isset($projectRow['price']) ? floatval($projectRow['price']) : 0;
                $status = $projectRow['payment_status'] ?? '';
                $method = $projectRow['payment_method'] ?? '';

                // List which payment fields changed
                $paymentChanges = [];
                foreach ($changedFields as $f) {
                    if (in_array($f, $paymentFields, true)) {
                        $label = $friendlyMap[$f] ?? $f;
                        if ($beforeRow && isset($beforeRow[$f])) {
                            $oldV = $beforeRow[$f];
                            $newV = $params[':' . $f];
                            // Format currency fields nicely
                            if (in_array($f, ['price', 'paid_amount', 'advance_amount', 'discount'], true)) {
                                $oldV = '৳' . number_format(floatval($oldV), 2, '.', '');
                                $newV = '৳' . number_format(floatval($newV), 2, '.', '');
                            }
                            $paymentChanges[] = "{$label}: {$oldV} → {$newV}";
                        }
                        else {
                            $paymentChanges[] = $label;
                        }
                    }
                }

                $details = "Updated payment for {$projectLabel}. ";
                $details .= implode(', ', $paymentChanges) . ". ";
                $details .= "Balance: ৳" . number_format($paid, 2, '.', '') . " of ৳" . number_format($price, 2, '.', '') . " ({$status})";
                if (!empty($method) && $method !== 'None') {
                    $details .= " via {$method}";
                }

                // Also mention any non-payment fields that changed alongside
                $nonPaymentChanges = array_diff($changedFields, $paymentFields);
                if (!empty($nonPaymentChanges)) {
                    $extras = [];
                    foreach ($nonPaymentChanges as $f) {
                        $extras[] = $friendlyMap[$f] ?? $f;
                    }
                    $details .= ". Also updated: " . implode(', ', $extras);
                }
            }
            else {
                // ── General edit log: show what changed with old → new values ──
                $changeParts = [];
                foreach ($changedFields as $f) {
                    $label = $friendlyMap[$f] ?? $f;
                    if ($beforeRow && isset($beforeRow[$f])) {
                        $oldV = $beforeRow[$f];
                        $newV = $params[':' . $f];

                        // Smart formatting per field type
                        if (in_array($f, ['is_visible_on_public', 'show_in_animation', 'show_in_previous'], true)) {
                            $oldV = intval($oldV) ? 'On' : 'Off';
                            $newV = intval($newV) ? 'On' : 'Off';
                            $changeParts[] = "{$label}: {$oldV} → {$newV}";
                        }
                        elseif ($f === 'status') {
                            $changeParts[] = "Status changed to {$newV}";
                        }
                        elseif ($f === 'title') {
                            $changeParts[] = "Renamed to \"{$newV}\"";
                        }
                        elseif ($f === 'customer_id') {
                            $changeParts[] = "Client changed";
                        }
                        elseif ($f === 'category') {
                            $changeParts[] = "Category changed to {$newV}";
                        }
                        elseif ($f === 'delivery_date') {
                            $changeParts[] = "Delivery date updated";
                        }
                        else {
                            // Generic: show label
                            $changeParts[] = "{$label} updated";
                        }
                    }
                    else {
                        $changeParts[] = "{$label} updated";
                    }
                }

                $details = "Edited {$projectLabel}: " . implode('; ', $changeParts);
            }

            $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, project_id, customer_id, category)
                      VALUES ('Update Project', :details, :user_name, 'staff', :actor_id, :project_id, :customer_id, 'project')";
            $logStmt = $conn->prepare($logSql);
            $logStmt->execute([
                ':details' => $details,
                ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
                ':actor_id' => $userToken->id ?? null,
                ':project_id' => $data->id,
                ':customer_id' => $customerId
            ]);
        }
    }
    catch (PDOException $e) {
        // Backward compatibility if migration columns are not applied yet
        $details = "Updated project {$data->id}";
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Update Project', :details, :user, 'project')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => $details,
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Project updated successfully"]);

}
catch (PDOException $e) {
    http_response_code(500);
    error_log("Project Update Failed: " . $e->getMessage());
    echo json_encode(["error" => "Update failed: " . $e->getMessage()]);
}
?>