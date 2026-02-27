<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");
header("Access-Control-Allow-Methods: POST");
header("Access-Control-Allow-Headers: Content-Type, Access-Control-Allow-Headers, Authorization, X-Requested-With, X-Device-Fingerprint");

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);

$jwtHelper = new JWTHandler();
$userData = $jwtHelper->verify($jwt);

if (!$userData || $userData->role !== 'Admin') {
    http_response_code(403);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->name) || !isset($data->email) || !isset($data->password) || !isset($data->role)) {
    http_response_code(400);
    echo json_encode(["error" => "Incomplete data"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

// Check if email exists
$checkSql = "SELECT id FROM users WHERE email = :email";
$stmt = $conn->prepare($checkSql);
$stmt->bindParam(':email', $data->email);
$stmt->execute();
if ($stmt->rowCount() > 0) {
    http_response_code(409);
    echo json_encode(["error" => "Email already exists"]);
    exit;
}

$query = "INSERT INTO users (id, name, email, password, role) VALUES (UUID(), :name, :email, :password, :role)";
$stmt = $conn->prepare($query);

$password_hash = password_hash($data->password, PASSWORD_BCRYPT);

$stmt->bindParam(':name', $data->name);
$stmt->bindParam(':email', $data->email);
$stmt->bindParam(':password', $password_hash);
$stmt->bindParam(':role', $data->role);

if ($stmt->execute()) {
    // Retrieve the created user
    $lastIdSql = "SELECT id, name as username, email, role, created_at as createdAt FROM users WHERE email = :email";
    $stm = $conn->prepare($lastIdSql);
    $stm->execute([':email' => $data->email]);
    $user = $stm->fetch(PDO::FETCH_ASSOC);

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Create User', :details, :user_name, 'staff', :actor_id, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Created user {$data->name} ({$user['id']}) with role {$data->role}",
            ':user_name' => $userData->email ?? ($userData->id ?? 'unknown'),
            ':actor_id' => $userData->id ?? null
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Create User', :details, :user, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Created user {$data->name} ({$user['id']}) with role {$data->role}",
            ':user' => $userData->email ?? ($userData->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "User created successfully", "user" => $user]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Unable to create user"]);
}
?>
