<?php
// MH CreationX - Verify OTP Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email) || !isset($data->otp)) {
    http_response_code(400);
    echo json_encode(["error" => "Email and OTP are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$email = $data->email;
$otp = $data->otp;

// Verify OTP
$sql = "SELECT * FROM password_resets 
        WHERE email = :email AND otp = :otp AND expires_at > NOW() 
        ORDER BY created_at DESC LIMIT 1";

$stmt = $conn->prepare($sql);
$stmt->execute([':email' => $email, ':otp' => $otp]);

if ($stmt->rowCount() > 0) {
    // OTP Valid - Generate Reset Token
    $resetToken = bin2hex(random_bytes(32));
    
    // Update record with token and invalidate OTP to prevent reuse
    $updateSql = "UPDATE password_resets SET token = :token, otp = NULL WHERE id = :id";
    $updateStmt = $conn->prepare($updateSql);
    $row = $stmt->fetch(PDO::FETCH_ASSOC);
    $updateStmt->execute([':token' => $resetToken, ':id' => $row['id']]);

    echo json_encode([
        "message" => "OTP Verified",
        "reset_token" => $resetToken
    ]);
} else {
    http_response_code(400);
    echo json_encode(["error" => "Invalid or expired OTP"]);
}
?>
