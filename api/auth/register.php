<?php
// MH CreationX - Register Endpoint (Admin Only)

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

// 1. Verify Admin Access
if (!$userToken || $userToken->role !== 'Admin') {
    http_response_code(403);
    echo json_encode(["error" => "Access denied. Admin privileges required."]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->name) || !isset($data->email) || !isset($data->password)) {
    http_response_code(400);
    echo json_encode(["error" => "Name, email, and password are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// 2. Check if email exists
$checkSql = "SELECT id FROM users WHERE email = :email";
$stmt = $conn->prepare($checkSql);
$stmt->execute([':email' => $data->email]);

if ($stmt->rowCount() > 0) {
    http_response_code(409);
    echo json_encode(["error" => "Email already exists"]);
    exit;
}

// 3. Create User
$hashedPass = password_hash($data->password, PASSWORD_BCRYPT);
// Generate UUID-like ID
$userId = 'USR-' . bin2hex(random_bytes(4));

$sql = "INSERT INTO users (id, name, email, password, role) VALUES (:id, :name, :email, :password, :role)";
$stmt = $conn->prepare($sql);

$role = $data->role ?? 'Team'; // Default to Team if not specified

if ($stmt->execute([':id' => $userId, ':name' => $data->name, ':email' => $data->email, ':password' => $hashedPass, ':role' => $role])) {
    // Log audit
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Create User', :details, :admin, 'user')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "Created user {$data->name} ({$userId})", 
        ':admin' => $userToken->email // Using email or name from token if available
    ]);

    http_response_code(201);
    echo json_encode(["message" => "User created successfully", "userId" => $userId]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Failed to create user"]);
}
?>
