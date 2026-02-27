<?php
/**
 * Change Password Endpoint
 * Allows authenticated users to change their password
 */

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

if (!isset($data->current_password) || !isset($data->new_password)) {
    http_response_code(400);
    echo json_encode(["error" => "Current password and new password are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Get current user
$stmt = $conn->prepare("SELECT * FROM users WHERE email = :email");
$stmt->execute([':email' => $userToken->email]);
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(["error" => "User not found"]);
    exit;
}

// Verify current password
if (!password_verify($data->current_password, $user['password'])) {
    http_response_code(400);
    echo json_encode(["error" => "Current password is incorrect"]);
    exit;
}

// Validate new password strength
if (strlen($data->new_password) < 6) {
    http_response_code(400);
    echo json_encode(["error" => "New password must be at least 6 characters"]);
    exit;
}

// Hash new password
$newPasswordHash = password_hash($data->new_password, PASSWORD_BCRYPT);

// Update password
$updateSql = "UPDATE users SET password = :password WHERE id = :id";
$updateStmt = $conn->prepare($updateSql);

try {
    $updateStmt->execute([
        ':password' => $newPasswordHash,
        ':id' => $user['id']
    ]);

    // Audit log
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Change Password', :details, :user, 'security')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "User {$user['email']} changed their password",
        ':user' => $user['email']
    ]);

    echo json_encode(["message" => "Password updated successfully"]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update password: " . $e->getMessage()]);
}
?>
