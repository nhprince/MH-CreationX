<?php
// MH CreationX - Delete Project Endpoint

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
    echo json_encode(["error" => "Project ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

try {
    // Database constraint ON DELETE CASCADE handles child records (images), but logic might need to explicit delete for Cloudinary later
    $sql = "DELETE FROM projects WHERE id = :id";
    $stmt = $conn->prepare($sql);
    $stmt->execute([':id' => $data->id]);

    if ($stmt->rowCount() > 0) {
        // Audit Log
        try {
            $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, project_id, category)
                      VALUES ('Delete Project', :details, :user_name, 'staff', :actor_id, :project_id, 'project')";
            $logStmt = $conn->prepare($logSql);
            $logStmt->execute([
                ':details' => "Deleted project {$data->id}",
                ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
                ':actor_id' => $userToken->id ?? null,
                ':project_id' => $data->id
            ]);
        } catch (PDOException $e) {
            // Backward compatibility if migration columns are not applied yet
            $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Delete Project', :details, :user, 'project')";
            $logStmt = $conn->prepare($logSql);
            $logStmt->execute([
                ':details' => "Deleted project {$data->id}",
                ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
            ]);
        }

        echo json_encode(["message" => "Project deleted successfully"]);
    } else {
        http_response_code(404);
        echo json_encode(["error" => "Project not found"]);
    }
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Delete failed: " . $e->getMessage()]);
}
?>
