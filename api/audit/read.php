<?php
// MH CreationX - Read Audit Logs Endpoint

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

// FIX: Role check uses the actual DB role string.
// Accepted team-member roles: 'Team', 'TeamMember', 'team_member' — normalise once here.
$userRole    = $userToken->role ?? '';
$isAdmin     = ($userRole === 'Admin');
$isTeam      = in_array($userRole, ['Team', 'TeamMember', 'team_member'], true);
$staffUserId = $userToken->id ?? null;

$db   = new Database();
$conn = $db->connect();

$limit    = isset($_GET['limit'])    ? (int)$_GET['limit']    : 100;
$category = isset($_GET['category']) ? $_GET['category']      : '';

$sql    = "SELECT * FROM audit_logs";
$params = [];
$where  = [];

if ($category && $category !== 'all') {
    $where[]              = "category = :category";
    $params[':category']  = $category;
}

// FIX: PDO does NOT allow the same named placeholder (:team_id) twice.
// Rewrite using :team_id AND :team_id2 for the second occurrence,
// or (cleaner) use a subquery alias so the id only appears once.
if ($isTeam && $staffUserId) {
    $staffEmail = $userToken->email ?? '';

    // Split the OR into three independent conditions with unique param names.
    $where[] = "(
        project_id IN (SELECT id FROM projects WHERE created_by = :team_id)
        OR (actor_type = 'staff' AND actor_id = :team_id2)
        OR (actor_id IS NULL AND user_name = :team_email)
    )";
    $params[':team_id']    = $staffUserId;
    $params[':team_id2']   = $staffUserId;   // <-- unique key for second bind
    $params[':team_email'] = $staffEmail;
}

if (!empty($where)) {
    $sql .= " WHERE " . implode(' AND ', $where);
}

$sql .= " ORDER BY timestamp DESC LIMIT :limit";

try {
    $stmt = $conn->prepare($sql);
    foreach ($params as $k => $v) {
        $stmt->bindValue($k, $v);
    }
    $stmt->bindValue(':limit', $limit, PDO::PARAM_INT);
    $stmt->execute();

    $logs = $stmt->fetchAll(PDO::FETCH_ASSOC);
    echo json_encode($logs);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Fetch failed: " . $e->getMessage()]);
}
?>
