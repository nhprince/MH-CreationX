<?php
// MH CreationX - Reset Password Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email) || !isset($data->password) || !isset($data->reset_token)) {
    http_response_code(400);
    echo json_encode(["error" => "Missing required fields"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Verify Token
$sql = "SELECT * FROM password_resets 
        WHERE email = :email AND token = :token AND expires_at > NOW() 
        ORDER BY created_at DESC LIMIT 1";

$stmt = $conn->prepare($sql);
$stmt->execute([
    ':email' => $data->email,
    ':token' => $data->reset_token
]);

if ($stmt->rowCount() > 0) {
    // Token Valid - Update Password
    $hashedPass = password_hash($data->password, PASSWORD_BCRYPT);
    
    $updateUserSql = "UPDATE users SET password = :password WHERE email = :email";
    $updateStmt = $conn->prepare($updateUserSql);
    $updateStmt->execute([
        ':password' => $hashedPass,
        ':email' => $data->email
    ]);

    // Invalidate token
    $deleteSql = "DELETE FROM password_resets WHERE email = :email";
    $delStmt = $conn->prepare($deleteSql);
    $delStmt->execute([':email' => $data->email]);

    echo json_encode(["message" => "Password successfully reset"]);
} else {
    http_response_code(400);
    echo json_encode(["error" => "Invalid or expired reset token"]);
}
?>
