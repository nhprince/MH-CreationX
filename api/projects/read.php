<?php
// MH CreationX - Read Projects Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$db = new Database();
$conn = $db->connect();

// Auth
$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

$isStaff = ($userToken && isset($userToken->type) && $userToken->type === 'staff');
$isAdmin = ($isStaff && isset($userToken->role) && $userToken->role === 'Admin');
// FIX: Accept all team-member role variants
$isTeam = ($isStaff && isset($userToken->role) && in_array($userToken->role, ['Team', 'TeamMember', 'team_member'], true));
$staffUserId = ($isStaff && isset($userToken->id)) ? $userToken->id : null;
$isCustomer = ($userToken && isset($userToken->type) && $userToken->type === 'customer');
$customerId = ($isCustomer && isset($userToken->customer_id)) ? $userToken->customer_id : null;

// Query Params
$limit = isset($_GET['limit']) ? (int)$_GET['limit'] : 20;
$offset = isset($_GET['offset']) ? (int)$_GET['offset'] : 0;
$search = isset($_GET['search']) ? $_GET['search'] : '';
$category = isset($_GET['category']) ? $_GET['category'] : '';

$sql = "SELECT p.*, c.name as customer_name,
        u.name as created_by_name,
        u.email as created_by_email,
        (SELECT JSON_ARRAYAGG(JSON_OBJECT('id', pi.id, 'url', pi.image_url, 'type', pi.type)) 
         FROM project_images pi WHERE pi.project_id = p.id) as images
        FROM projects p
        LEFT JOIN customers c ON p.customer_id = c.id
        LEFT JOIN users u ON p.created_by = u.id
        WHERE 1=1";

$params = [];

// Visibility / ownership filters
if (!$isStaff) {
    if ($isCustomer && $customerId) {
        $sql .= " AND p.customer_id = :customer_id";
        $params[':customer_id'] = $customerId;
    }
    else {
        $sql .= " AND p.is_visible_on_public = 1";
    }
}

// FIX: Team members see only their own projects — but the condition must come
// AFTER the !$isStaff block so the two don't conflict.
if ($isTeam && $staffUserId) {
    $sql .= " AND p.created_by = :created_by";
    $params[':created_by'] = $staffUserId;
}

if (!empty($search)) {
    $sql .= " AND (p.title LIKE :search OR p.description LIKE :search OR c.name LIKE :search)";
    $params[':search'] = "%$search%";
}

if (!empty($category) && $category !== 'All') {
    $sql .= " AND p.category = :category";
    $params[':category'] = $category;
}

$sql .= " ORDER BY p.created_at DESC LIMIT $limit OFFSET $offset";

try {
    // Auto-enforce slider limit (Admin/Team both benefit)
    if ($isStaff) {
        try {
            $idsStmt = $conn->prepare("SELECT id FROM projects WHERE show_in_animation = 1 ORDER BY created_at DESC LIMIT 1000");
            $idsStmt->execute();
            $ids = $idsStmt->fetchAll(PDO::FETCH_COLUMN);
            if (is_array($ids) && count($ids) > 15) {
                $toDisable = array_slice($ids, 15);
                $placeholders = implode(',', array_fill(0, count($toDisable), '?'));
                $upd = $conn->prepare("UPDATE projects SET show_in_animation = 0 WHERE id IN ($placeholders)");
                $upd->execute($toDisable);
            }
        }
        catch (PDOException $e) {
        // Non-critical; ignore.
        }
    }

    $stmt = $conn->prepare($sql);
    foreach ($params as $key => $val) {
        $stmt->bindValue($key, $val);
    }
    $stmt->execute();
    $projects = $stmt->fetchAll(PDO::FETCH_ASSOC);

    // Decode JSON images string from MySQL
    foreach ($projects as &$project) {
        $project['images'] = $project['images'] ? json_decode($project['images']) : [];
    }
    unset($project);

    echo json_encode($projects);

}
catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Fetch failed: " . $e->getMessage()]);
}
?>
