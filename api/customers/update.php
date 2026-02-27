<?php
// MH CreationX - Update Customer Endpoint

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

$isAdmin = (isset($userToken->role) && $userToken->role === 'Admin');
$isTeam = (isset($userToken->role) && $userToken->role === 'Team');
$staffUserId = isset($userToken->id) ? $userToken->id : null;

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "Customer ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Team members can only update customers that belong to their own projects
if ($isTeam && $staffUserId) {
    $relStmt = $conn->prepare("SELECT 1 FROM projects WHERE customer_id = :cid AND created_by = :uid LIMIT 1");
    $relStmt->execute([':cid' => $data->id, ':uid' => $staffUserId]);
    if ($relStmt->rowCount() === 0) {
        http_response_code(403);
        echo json_encode(["error" => "Access denied"]);
        exit;
    }
}

$fields = [];
$params = [':id' => $data->id];
$allowedFields = ['name', 'type', 'phone', 'email', 'address', 'status'];

foreach ($allowedFields as $field) {
    if (isset($data->$field)) {
        $fields[] = "$field = :$field";
        $params[":$field"] = $data->$field;
    }
}

// Handle 'isActive' boolean from frontend
if (isset($data->isActive)) {
    // Only add if status wasn't already added
    if (!in_array('status = :status', $fields)) {
        $fields[] = "status = :status";
        $params[':status'] = $data->isActive ? 'Active' : 'Inactive';
    }
}

if (empty($fields)) {
    echo json_encode(["message" => "No changes provided"]);
    exit;
}

$sql = "UPDATE customers SET " . implode(', ', $fields) . " WHERE id = :id";
$stmt = $conn->prepare($sql);

try {
    $stmt->execute($params);

    // Audit Log
    try {
        $updatedFields = array_keys($params);
        // Remove :id from updated fields
        $updatedFields = array_filter($updatedFields, function($f) { return $f !== ':id'; });
        $fieldNames = array_map(function($f) { return str_replace(':', '', $f); }, $updatedFields);
        $details = "Updated fields: " . implode(', ', $fieldNames) . " for customer {$data->id}";

        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, customer_id, category)
                  VALUES ('Update Customer', :details, :user_name, 'staff', :actor_id, :customer_id, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => $details,
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null,
            ':customer_id' => $data->id
        ]);
    } catch (PDOException $e) {
        // Backward compatibility if migration columns are not applied yet
        $details = "Updated customer {$data->id}";
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Update Customer', :details, :user, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => $details,
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Customer updated successfully"]);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Update failed: " . $e->getMessage()]);
}
?>
