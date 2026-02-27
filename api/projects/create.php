<?php
// MH CreationX - Create Project Endpoint

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

$role = $userToken->role ?? '';
$isAdmin = ($role === 'Admin');
$isTeam = in_array($role, ['Team', 'TeamMember', 'team_member'], true);

$data = json_decode(file_get_contents("php://input"));

// Validation
if (!isset($data->title) || !isset($data->category)) {
    http_response_code(400);
    echo json_encode(["error" => "Title and category are required"]);
    exit;
}

// FIX: Accept both snake_case and camelCase customer_id from frontend
$customerId = null;
if (!empty($data->customer_id)) {
    $customerId = $data->customer_id;
} elseif (!empty($data->customerId)) {
    $customerId = $data->customerId;
} elseif (!empty($data->client_id)) {
    $customerId = $data->client_id;
} elseif (!empty($data->clientId)) {
    $customerId = $data->clientId;
}

// Customer is optional — $customerId stays null if not provided
// (Ensure your DB column customer_id allows NULL: ALTER TABLE projects MODIFY customer_id VARCHAR(255) NULL)

$db = new Database();
$conn = $db->connect();

// Generate Project ID
$projectId = 'PRJ-' . bin2hex(random_bytes(4));

// Serial Number Logic
$stmt = $conn->query("SELECT MAX(serial_number) as max_serial FROM projects");
$row = $stmt->fetch(PDO::FETCH_ASSOC);
$serialNumber = ($row['max_serial'] ?? 0) + 1;

$createdBy = (isset($userToken->type) && $userToken->type === 'staff' && isset($userToken->id)) ? $userToken->id : null;

// Restricted policy: team-created projects must be hidden until admin approval
$publicFlag = $data->is_visible_on_public ?? $data->isVisibleOnPublic ?? 1;
$animFlag = $data->show_in_animation ?? $data->showInAnimation ?? 0;
$prevFlag = $data->show_in_previous ?? $data->showInPrevious ?? 1;
if ($isTeam && !$isAdmin) {
    $publicFlag = 0;
    $animFlag = 0;
    $prevFlag = 0;
}

// Payment invariants (paid_amount is total received, includes advance)
$price = isset($data->price) ? floatval($data->price) : 0;
$advance = 0;
if (isset($data->advance_amount)) {
    $advance = floatval($data->advance_amount);
} elseif (isset($data->advanceAmount)) {
    $advance = floatval($data->advanceAmount);
}

if ($advance < 0) {
    http_response_code(400);
    echo json_encode(["error" => "Advance cannot be negative"]);
    exit;
}

if ($price < 0) {
    http_response_code(400);
    echo json_encode(["error" => "Price cannot be negative"]);
    exit;
}

if ($advance > $price) {
    http_response_code(400);
    echo json_encode(["error" => "Advance cannot exceed total project price"]);
    exit;
}

$paidAmount = $advance;
$paymentStatus = 'Unpaid';
if ($paidAmount >= $price && $price > 0) {
    $paymentStatus = 'Paid';
} elseif ($paidAmount > 0) {
    $paymentStatus = 'Partial';
}

$sql = "INSERT INTO projects 
    (id, serial_number, title, customer_id, category, description, director, status, price, advance_amount, paid_amount, payment_status, is_visible_on_public, show_in_animation, show_in_previous, designer_name, assistant_name, created_by)
    VALUES 
    (:id, :serial, :title, :customer, :category, :desc, :director, :status, :price, :advance, :paid_amount, :pay_status, :public, :anim, :prev, :designer, :assistant, :created_by)";

$stmt = $conn->prepare($sql);

try {
    $stmt->execute([
        ':id' => $projectId,
        ':serial' => $serialNumber,
        ':title' => $data->title,
        ':customer' => $customerId,
        ':category' => $data->category,
        ':desc' => $data->description ?? '',
        ':director' => $data->director ?? '',
        ':status' => $data->status ?? 'Pending',
        ':price' => $price,
        ':advance' => $advance,
        ':paid_amount' => $paidAmount,
        ':pay_status' => $paymentStatus,
        ':public' => $publicFlag,
        ':anim' => $animFlag,
        ':prev' => $prevFlag,
        ':designer' => $data->designer_name ?? $data->designerName ?? '',
        ':assistant' => $data->assistant_name ?? $data->assistantName ?? '',
        ':created_by' => $createdBy
    ]);

    // Handle Image Links if provided (assuming array of URLs)
    if (isset($data->images) && is_array($data->images)) {
        $imgSql = "INSERT INTO project_images (project_id, image_url, type) VALUES (:pid, :url, :type)";
        $imgStmt = $conn->prepare($imgSql);
        foreach ($data->images as $img) {
            $imgStmt->execute([
                ':pid' => $projectId,
                ':url' => $img->url,
                ':type' => $img->type ?? 'poster'
            ]);
        }
    }

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, project_id, customer_id, category)
                  VALUES ('Create Project', :details, :user_name, 'staff', :actor_id, :project_id, :customer_id, 'project')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Created project {$data->title} ({$projectId})",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null,
            ':project_id' => $projectId,
            ':customer_id' => $customerId
        ]);
    } catch (PDOException $e) {
        // Backward compatibility if migration columns are not applied yet
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Create Project', :details, :user, 'project')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Created project {$data->title} ({$projectId})",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Project created", "id" => $projectId]);

} catch (PDOException $e) {
    http_response_code(500);
    error_log("Project Create Failed: " . $e->getMessage());
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}
?>