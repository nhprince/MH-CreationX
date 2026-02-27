<?php
// MH CreationX - Delete Expense Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken || $userToken->role !== 'Admin') {
    http_response_code(403);
    echo json_encode(["error" => "Access denied. Admin privileges required."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "Expense ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

try {
    $sql = "DELETE FROM expenses WHERE id = :id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':id' => $data->id]);

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Delete Expense', :details, :user_name, 'staff', :actor_id, 'finance')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted expense ID {$data->id}",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Delete Expense', :details, :user, 'finance')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted expense ID {$data->id}",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Expense deleted successfully"]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Delete failed: " . $e->getMessage()]);
}
?>
