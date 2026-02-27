<?php
// MH CreationX - Read Customers Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers    = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt        = str_replace('Bearer ', '', $authHeader);
$jwtHelper  = new JWTHandler();
$userToken  = $jwtHelper->verify($jwt);

if (!$userToken || !isset($userToken->type) || $userToken->type !== 'staff') {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$userRole    = $userToken->role ?? '';
$isAdmin     = ($userRole === 'Admin');
// FIX: Accept all team-member role variants
$isTeam      = in_array($userRole, ['Team', 'TeamMember', 'team_member'], true);
$staffUserId = $userToken->id ?? null;

$db   = new Database();
$conn = $db->connect();

$search = $_GET['search'] ?? '';

$sql    = "SELECT * FROM customers WHERE 1=1";
$params = [];

// Team members only see customers linked to their own projects
if ($isTeam && $staffUserId) {
    $sql .= " AND (
        created_by = :created_by
        OR id IN (SELECT DISTINCT customer_id FROM projects WHERE created_by = :created_by2 AND customer_id IS NOT NULL AND customer_id != '')
    )";
    $params[':created_by'] = $staffUserId;
    $params[':created_by2'] = $staffUserId;
}

if (!empty($search)) {
    $sql .= " AND (name LIKE :search OR phone LIKE :search OR email LIKE :search OR id LIKE :search)";
    $params[':search'] = "%$search%";
}

$sql .= " ORDER BY joined_at DESC";

try {
    $stmt = $conn->prepare($sql);
    $stmt->execute($params);
    $customers = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($customers);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Fetch failed: " . $e->getMessage()]);
}
?>
