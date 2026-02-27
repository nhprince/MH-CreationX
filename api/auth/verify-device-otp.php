<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, X-Device-Fingerprint");

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email) || !isset($data->otp) || !isset($_SERVER['HTTP_X_DEVICE_FINGERPRINT'])) {
    http_response_code(400);
    echo json_encode(["error" => "Email, OTP, and Device Fingerprint are required"]);
    exit;
}

$email = $data->email;
$otp = $data->otp;
$deviceFingerprint = $_SERVER['HTTP_X_DEVICE_FINGERPRINT'];
// Optional: Get device name from header or default
$deviceName = $_SERVER['HTTP_X_DEVICE_NAME'] ?? 'Unknown Device';

$db = new Database();
$conn = $db->connect();

// 1. Verify OTP
$sql = "SELECT * FROM password_resets WHERE email = :email AND otp = :otp AND expires_at > NOW() LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':email', $email);
$stmt->bindParam(':otp', $otp);
$stmt->execute();

if ($stmt->rowCount() == 0) {
    http_response_code(400);
    echo json_encode(["error" => "Invalid or expired OTP"]);
    exit;
}

// 2. Get User
$userSql = "SELECT * FROM users WHERE email = :email LIMIT 1";
$userStmt = $conn->prepare($userSql);
$userStmt->bindParam(':email', $email);
$userStmt->execute();
$user = $userStmt->fetch(PDO::FETCH_ASSOC);

if (!$user) {
    http_response_code(404);
    echo json_encode(["error" => "User not found"]);
    exit;
}

// 3. Add to Trusted Devices
try {
    $trustSql = "INSERT INTO trusted_devices (user_id, device_fingerprint, device_name) VALUES (:uid, :fingerprint, :name)
                 ON DUPLICATE KEY UPDATE last_used = NOW(), is_active = 1";
    $trustStmt = $conn->prepare($trustSql);
    $trustStmt->bindParam(':uid', $user['id']);
    $trustStmt->bindParam(':fingerprint', $deviceFingerprint);
    $trustStmt->bindParam(':name', $deviceName);
    $trustStmt->execute();
} catch (Exception $e) {
    // Log error but maybe don't fail login if just tracking fails? 
    // Ideally we should fail if we can't trust the device.
    error_log("Failed to trust device: " . $e->getMessage());
}

// 4. Generate Token
$jwtHelper = new JWTHandler();
$tokenPayload = [
    'id' => $user['id'],
    'email' => $user['email'],
    'role' => $user['role'],
    'type' => 'staff'
];
$token = $jwtHelper->generate($tokenPayload);

// 5. Clean used OTP
$cleanSql = "DELETE FROM password_resets WHERE email = :email AND otp = :otp";
$cleanStmt = $conn->prepare($cleanSql);
$cleanStmt->bindParam(':email', $email);
$cleanStmt->bindParam(':otp', $otp);
$cleanStmt->execute();

// 6. Return Success
unset($user['password']);
echo json_encode([
    "token" => $token,
    "user" => $user,
    "message" => "Device verified and logged in successfully"
]);
?>
