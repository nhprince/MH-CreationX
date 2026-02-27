<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: GET");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, X-Device-Fingerprint");

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';

$jwt = new JWTHandler();
$userData = $jwt->validateToken();

if (!$userData) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

// Only Admin can list users? Or Team too?
if ($userData->role !== 'Admin') {
    // For now, let's allow all staff to read.
}

$db = new Database();
$conn = $db->connect();

$query = "SELECT id, name as username, email, `password` as pass, role, avatar as profilePic, created_at as createdAt, is_active FROM users ORDER BY created_at DESC";
$stmt = $conn->prepare($query);
$stmt->execute();

$users = [];
while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    // Map fields if needed or select as above
    $users[] = $row;
}

echo json_encode($users);
?>
