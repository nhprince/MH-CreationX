<?php
/**
 * Change Email Endpoint
 * Allows authenticated users to change their email
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

if (!isset($data->new_email) || !isset($data->password)) {
    http_response_code(400);
    echo json_encode(["error" => "New email and password are required"]);
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

// Verify password
if (!password_verify($data->password, $user['password'])) {
    http_response_code(400);
    echo json_encode(["error" => "Password is incorrect"]);
    exit;
}

// Validate email format
if (!filter_var($data->new_email, FILTER_VALIDATE_EMAIL)) {
    http_response_code(400);
    echo json_encode(["error" => "Invalid email format"]);
    exit;
}

// Check if email already exists
$checkSql = "SELECT id FROM users WHERE email = :email AND id != :id";
$checkStmt = $conn->prepare($checkSql);
$checkStmt->execute([':email' => $data->new_email, ':id' => $user['id']]);

if ($checkStmt->rowCount() > 0) {
    http_response_code(400);
    echo json_encode(["error" => "Email already in use"]);
    exit;
}

// Update email
$updateSql = "UPDATE users SET email = :email WHERE id = :id";
$updateStmt = $conn->prepare($updateSql);

try {
    $updateStmt->execute([
        ':email' => $data->new_email,
        ':id' => $user['id']
    ]);

    // Audit log
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Change Email', :details, :user, 'security')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "User changed email from {$user['email']} to {$data->new_email}",
        ':user' => $user['email']
    ]);

    echo json_encode(["message" => "Email updated successfully", "new_email" => $data->new_email]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Failed to update email: " . $e->getMessage()]);
}
?>
