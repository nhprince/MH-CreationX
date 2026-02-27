<?php
// MH CreationX - Change Password Endpoint

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

$data = json_decode(file_get_contents("php://input"));

// Support both snake_case and camelCase from frontend
$currentPassword = $data->current_password ?? $data->currentPassword ?? null;
$newPassword = $data->new_password ?? $data->newPassword ?? null;

if (!$currentPassword || !$newPassword) {
    http_response_code(400);
    echo json_encode(["error" => "Current and new passwords required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Get current user password
$sql = "SELECT password FROM users WHERE id = :id";
$stmt = $conn->prepare($sql);
$stmt->execute([':id' => $userToken->id]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!password_verify($currentPassword, $user['password'])) {
    http_response_code(401);
    echo json_encode(["error" => "Incorrect current password"]);
    exit;
}

// Update Password
$newHash = password_hash($newPassword, PASSWORD_BCRYPT);
$updateSql = "UPDATE users SET password = :password WHERE id = :id";
$stmt = $conn->prepare($updateSql);

if ($stmt->execute([':password' => $newHash, ':id' => $userToken->id])) {
    echo json_encode(["message" => "Password updated successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update password"]);
}
?>
