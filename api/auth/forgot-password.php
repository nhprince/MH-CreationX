<?php
// MH CreationX - Forgot Password Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/EmailService.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email)) {
    http_response_code(400);
    echo json_encode(["error" => "Email is required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$email = $data->email;

// Check if user exists
$stmt = $conn->prepare("SELECT id FROM users WHERE email = :email");
$stmt->execute([':email' => $email]);

if ($stmt->rowCount() == 0) {
    // Log invalid attempt for debugging
    $logEntry = "[" . date('Y-m-d H:i:s') . "] Forgot Password Request: $email | User Not Found" . PHP_EOL;
    file_put_contents(__DIR__ . '/../otp_logs.txt', $logEntry, FILE_APPEND);

    // Return success even if email invalid to prevent enumeration
    echo json_encode(["message" => "If an account exists, an OTP has been sent."]);
    exit;
}

// Generate OTP
$otp = sprintf("%06d", mt_rand(1, 999999));
$expires = date('Y-m-d H:i:s', strtotime('+15 minutes'));

// Store OTP
$sql = "INSERT INTO password_resets (email, otp, expires_at) VALUES (:email, :otp, :expires)";
$stmt = $conn->prepare($sql);
$stmt->execute([':email' => $email, ':otp' => $otp, ':expires' => $expires]);

// Send Email
try {
    $mailer = new EmailService();
    $sent = $mailer->sendOTP($email, $otp);
} catch (Exception $e) {
    $sent = false;
    error_log("Email send failed: " . $e->getMessage());
}

if ($sent) {
    echo json_encode(["message" => "OTP sent successfully."]);
} else {
    // Log OTP to file as fallback (for development/testing)
    error_log("OTP for $email: $otp");
    $logFile = __DIR__ . '/../otp_log.txt';
    file_put_contents($logFile, date('Y-m-d H:i:s') . " - Email: $email, OTP: $otp\n", FILE_APPEND);
    
    // Still return success to user (don't expose email service issues)
    echo json_encode(["message" => "Password reset initiated. Check your email for OTP."]);
}
?>
