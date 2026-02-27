<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
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

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->new_email) || !isset($data->otp)) {
    http_response_code(400);
    echo json_encode(["error" => "New email and OTP are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// 1. Verify OTP
$sql = "SELECT * FROM password_resets WHERE email = :email AND otp = :otp AND expires_at > NOW() LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':email', $data->new_email);
$stmt->bindParam(':otp', $data->otp);
$stmt->execute();

if ($stmt->rowCount() == 0) {
    http_response_code(400);
    echo json_encode(["error" => "Invalid or expired OTP"]);
    exit;
}

// 2. Update Email
$updateSql = "UPDATE users SET email = :email WHERE id = :id";
$updateStmt = $conn->prepare($updateSql);
$updateStmt->bindParam(':email', $data->new_email);
$updateStmt->bindParam(':id', $userData->id);

if ($updateStmt->execute()) {
    // 3. Clean up OTP
    $cleanSql = "DELETE FROM password_resets WHERE email = :email AND otp = :otp";
    $cleanStmt = $conn->prepare($cleanSql);
    $cleanStmt->bindParam(':email', $data->new_email);
    $cleanStmt->bindParam(':otp', $data->otp);
    $cleanStmt->execute();

    // 4. Log Audit
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Update', 'Email changed', :name, 'user')";
    $logStmt = $conn->prepare($logSql);
    // Fetch name for log - redundant but safe
    $nameSql = "SELECT name FROM users WHERE id = :id";
    $nameStmt = $conn->prepare($nameSql);
    $nameStmt->execute([':id' => $userData->id]);
    $user = $nameStmt->fetch(PDO::FETCH_ASSOC);
    
    $logStmt->execute([':name' => $user['name'] ?? 'User']);

    echo json_encode(["message" => "Email updated successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update email"]);
}
?>
