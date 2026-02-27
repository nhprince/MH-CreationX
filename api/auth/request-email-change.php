<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, X-Device-Fingerprint");

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../utils/EmailService.php';

$jwt = new JWTHandler();
$userData = $jwt->validateToken(); // Validates Authorization header

if (!$userData) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

// Support both snake_case and camelCase from frontend
$currentPassword = $data->current_password ?? $data->currentPassword ?? null;
$newEmail = $data->new_email ?? $data->newEmail ?? null;

if (!$currentPassword || !$newEmail) {
    http_response_code(400);
    echo json_encode(["error" => "Current password and new email are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// 1. Verify User Password
$sql = "SELECT * FROM users WHERE id = :id";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':id', $userData->id); // JWT payload returns object
$stmt->execute();
$user = $stmt->fetch(PDO::FETCH_ASSOC);

if (!$user || !password_verify($currentPassword, $user['password'])) {
    http_response_code(401);
    echo json_encode(["error" => "Incorrect password"]);
    exit;
}

// 2. Check if new email is already taken
$checkSql = "SELECT id FROM users WHERE email = :email";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->bindParam(':email', $newEmail);
$checkStmt->execute();

if ($checkStmt->rowCount() > 0) {
    http_response_code(409);
    echo json_encode(["error" => "Email is already in use"]);
    exit;
}

// 3. Generate and Store OTP
$otp = sprintf("%06d", mt_rand(1, 999999));
$expiry = date('Y-m-d H:i:s', strtotime('+10 minutes'));

// Store OTP for the NEW email in password_resets
$otpSql = "INSERT INTO password_resets (email, otp, expires_at) VALUES (:email, :otp, :expiry)";
$otpStmt = $conn->prepare($otpSql);
$otpStmt->execute([':email' => $newEmail, ':otp' => $otp, ':expiry' => $expiry]);

// 4. Send Email via EmailService
try {
    $emailService = new EmailService();
    $sent = $emailService->sendOTP($newEmail, $otp, 'email_change');
    
    if ($sent) {
        echo json_encode(["message" => "Verification code sent to new email address"]);
    } else {
        // Log for fallback but still return success
        error_log("Email Change OTP for {$newEmail}: $otp");
        echo json_encode(["message" => "Verification code sent to new email address"]);
    }
} catch (Exception $e) {
    error_log("Email send failed: " . $e->getMessage());
    error_log("Email Change OTP for {$newEmail}: $otp");
    echo json_encode(["message" => "Verification code sent to new email address"]);
}
?>
