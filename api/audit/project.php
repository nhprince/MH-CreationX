<?php
// MH CreationX - Read Audit Logs for a single project

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$projectId = isset($_GET['project_id']) ? $_GET['project_id'] : null;
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 100;

if (!$projectId) {
    http_response_code(400);
    echo json_encode(["error" => "project_id is required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$isStaff = (isset($userToken->type) && $userToken->type === 'staff');
$isAdmin = ($isStaff && isset($userToken->role) && $userToken->role === 'Admin');
$isTeam = ($isStaff && isset($userToken->role) && $userToken->role === 'Team');
$staffUserId = ($isStaff && isset($userToken->id)) ? $userToken->id : null;

$isClient = (isset($userToken->type) && $userToken->type === 'customer');
$clientCustomerId = $isClient && isset($userToken->customer_id) ? $userToken->customer_id : null;

// Authorization: staff can read; team only if owns project; client only if project belongs to them.
if ($isTeam && $staffUserId) {
    $ownStmt = $conn->prepare("SELECT 1 FROM projects WHERE id = :pid AND created_by = :uid LIMIT 1");
    $ownStmt->execute([':pid' => $projectId, ':uid' => $staffUserId]);
    if ($ownStmt->rowCount() === 0) {
        http_response_code(403);
        echo json_encode(["error" => "Access denied"]);
        exit;
    }
}

if ($isClient && $clientCustomerId) {
    $ownStmt = $conn->prepare("SELECT 1 FROM projects WHERE id = :pid AND customer_id = :cid LIMIT 1");
    $ownStmt->execute([':pid' => $projectId, ':cid' => $clientCustomerId]);
    if ($ownStmt->rowCount() === 0) {
        http_response_code(403);
        echo json_encode(["error" => "Access denied"]);
        exit;
    }
}

if (!$isStaff && !$isClient) {
    http_response_code(403);
    echo json_encode(["error" => "Access denied"]);
    exit;
}

// Prefer the new project_id column when present; fallback to legacy logs by matching details text.
$sql = "SELECT * FROM audit_logs
        WHERE project_id = :pid
           OR (project_id IS NULL AND details LIKE :legacy)
        ORDER BY timestamp DESC
        LIMIT :limit";

$stmt = $conn->prepare($sql);
$stmt->bindValue(':pid', $projectId);
$stmt->bindValue(':legacy', '%' . $projectId . '%');
$stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
$stmt->execute();

$logs = $stmt->fetchAll(PDO::FETCH_ASSOC);

echo json_encode($logs);
?>
