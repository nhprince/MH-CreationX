<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, X-Device-Fingerprint");

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';

$headers = function_exists('getallheaders') ? getallheaders() : [];
$authHeader = $headers['Authorization'] ?? ($headers['authorization'] ?? '');
$jwtToken = str_replace('Bearer ', '', $authHeader);
$jwt = new JWTHandler();
$userData = $jwt->verify($jwtToken);

if (!$userData || $userData->role !== 'Admin') {
    http_response_code(403);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "User ID required"]);
    exit;
}

if ($data->id === $userData->id) {
    http_response_code(400);
    echo json_encode(["error" => "Cannot delete yourself"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Only the first (earliest created) admin can delete other admins.
try {
    $mainStmt = $conn->prepare("SELECT id FROM users WHERE role = 'Admin' ORDER BY created_at ASC LIMIT 1");
    $mainStmt->execute();
    $mainAdminId = $mainStmt->fetchColumn() ?: null;
} catch (PDOException $e) {
    $mainAdminId = null;
}

// Fetch target user's role
try {
    $targetStmt = $conn->prepare("SELECT id, role FROM users WHERE id = :id LIMIT 1");
    $targetStmt->execute([':id' => $data->id]);
    $target = $targetStmt->fetch(PDO::FETCH_ASSOC);
    if (!$target) {
        http_response_code(404);
        echo json_encode(["error" => "User not found"]);
        exit;
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error"]);
    exit;
}

if (($target['role'] ?? '') === 'Admin' && $mainAdminId && ($userData->id ?? null) !== $mainAdminId) {
    // Audit Log: denied
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Delete User Denied', :details, :user_name, 'staff', :actor_id, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Denied attempt to delete admin user {$data->id}",
            ':user_name' => $userData->email ?? ($userData->id ?? 'unknown'),
            ':actor_id' => $userData->id ?? null
        ]);
    } catch (PDOException $e) {
        // ignore
    }

    http_response_code(403);
    echo json_encode(["error" => "Only the main admin can delete other admins"]);
    exit;
}

$query = "DELETE FROM users WHERE id = :id";
$stmt = $conn->prepare($query);
$stmt->bindParam(':id', $data->id);

if ($stmt->execute()) {
    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Delete User', :details, :user_name, 'staff', :actor_id, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted user {$data->id}",
            ':user_name' => $userData->email ?? ($userData->id ?? 'unknown'),
            ':actor_id' => $userData->id ?? null
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Delete User', :details, :user, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted user {$data->id}",
            ':user' => $userData->email ?? ($userData->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "User deleted successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Unable to delete user"]);
}
?>
