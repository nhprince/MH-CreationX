<?php
// MH CreationX - Read Expenses Endpoint

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

$limit  = isset($_GET['limit'])  ? (int)$_GET['limit']  : 50;
$offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
$month  = $_GET['month'] ?? ''; // format YYYY-MM

$sql    = "SELECT * FROM expenses WHERE 1=1";
$params = [];

if ($isTeam && $staffUserId) {
    $sql .= " AND created_by = :created_by";
    $params[':created_by'] = $staffUserId;
}

if (!empty($month)) {
    $sql .= " AND DATE_FORMAT(date, '%Y-%m') = :month";
    $params[':month'] = $month;
}

$sql .= " ORDER BY date DESC, id DESC LIMIT $limit OFFSET $offset";

try {
    $stmt = $conn->prepare($sql);
    foreach ($params as $key => $val) {
        $stmt->bindValue($key, $val);
    }
    $stmt->execute();
    $expenses = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($expenses);
} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Fetch failed: " . $e->getMessage()]);
}
?>
