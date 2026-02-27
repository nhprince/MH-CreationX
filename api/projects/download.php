<?php
// MH CreationX - Download Project Assets Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken || !isset($userToken->type) || $userToken->type !== 'customer') {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$projectId = $_GET['projectId'] ?? null;

if (!$projectId) {
    http_response_code(400);
    echo json_encode(["error" => "Project ID required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Check if project belongs to customer
$sql = "SELECT id, title, download_link FROM projects WHERE id = :id AND customer_id = :cid LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->execute([':id' => $projectId, ':cid' => $userToken->customer_id]);

if ($stmt->rowCount() == 0) {
    http_response_code(404);
    echo json_encode(["error" => "Project not found or access denied"]);
    exit;
}

$project = $stmt->fetch(PDO::FETCH_ASSOC);

// Audit Log
try {
    $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, customer_id, project_id, category)
              VALUES ('Download Assets', :details, :user_name, 'client', :customer_id, :project_id, 'project')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "Downloaded assets for project {$project['title']} ({$projectId})",
        ':user_name' => $userToken->customer_name ?? 'Unknown Client',
        ':customer_id' => $userToken->customer_id,
        ':project_id' => $projectId
    ]);
} catch (PDOException $e) {
    // Backward compatibility
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Download Assets', :details, :user, 'project')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "Downloaded assets for project {$project['title']} ({$projectId})",
        ':user' => $userToken->customer_name ?? 'Unknown Client'
    ]);
}

// Redirect to download link
if ($project['download_link']) {
    echo json_encode(["download_url" => $project['download_link']]);
} else {
    http_response_code(404);
    echo json_encode(["error" => "No download link available"]);
}
?>
