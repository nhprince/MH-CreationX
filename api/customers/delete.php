<?php
// MH CreationX - Delete Customer Endpoint

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

if (!isset($data->id) || empty($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "Valid Customer ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

try {
    // Check if customer exists first
    $checkSql = "SELECT id FROM customers WHERE id = :id";
    $checkStmt = $conn->prepare($checkSql);
    $checkStmt->execute([':id' => $data->id]);
    
    if ($checkStmt->rowCount() === 0) {
        http_response_code(404);
        echo json_encode(["error" => "Customer not found"]);
        exit;
    }

    // Check if customer has projects (Prevent orphan records)
    $projCheck = "SELECT COUNT(*) FROM projects WHERE customer_id = :id";
    $projStmt = $conn->prepare($projCheck);
    $projStmt->execute([':id' => $data->id]);
    
    if ($projStmt->fetchColumn() > 0) {
        http_response_code(409);
        echo json_encode(["error" => "Cannot delete customer with active projects. Delete projects first."]);
        exit;
    }

    $sql = "DELETE FROM customers WHERE id = :id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':id' => $data->id]);

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, customer_id, category)
                  VALUES ('Delete Customer', :details, :user_name, 'staff', :actor_id, :customer_id, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted customer {$data->id}",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null,
            ':customer_id' => $data->id
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Delete Customer', :details, :user, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Deleted customer {$data->id}",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Customer deleted successfully"]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Delete failed: " . $e->getMessage()]);
}
?>
