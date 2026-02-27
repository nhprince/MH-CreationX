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

if (!isset($data->id)) {
    http_response_code(400);
    echo json_encode(["error" => "User ID required"]);
    exit;
}

// Only Admin can update others. Users can update themselves.
if ($userData->role !== 'Admin' && $userData->id !== $data->id) {
    http_response_code(403);
    echo json_encode(["error" => "Forbidden"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$fields = [];
$params = [':id' => $data->id];

if (isset($data->username)) {
    $fields[] = "name = :name";
    $params[':name'] = $data->username;
}
if (isset($data->email) && $userData['role'] === 'Admin') { // Only admin can change email via this generic endpoint? Or separate process (we have separate process)
    $fields[] = "email = :email";
    $params[':email'] = $data->email;
}
if (isset($data->role) && $userData['role'] === 'Admin') {
    $fields[] = "role = :role";
    $params[':role'] = $data->role;
}
if (isset($data->password)) {
    $fields[] = "password = :password";
    $params[':password'] = password_hash($data->password, PASSWORD_BCRYPT);
}
if (isset($data->profilePic)) {
    $fields[] = "profile_pic = :pic";
    $params[':pic'] = $data->profilePic;
}
if (isset($data->isActive) && $userData['role'] === 'Admin') { // Assuming is_active column exists
    $fields[] = "is_active = :active";
    $params[':active'] = $data->isActive ? 1 : 0;
}

if (empty($fields)) {
    echo json_encode(["message" => "No changes provided"]);
    exit;
}

$query = "UPDATE users SET " . implode(", ", $fields) . " WHERE id = :id";
$stmt = $conn->prepare($query);

if ($stmt->execute($params)) {
    // Audit Log
    try {
        $updatedFields = array_keys($params);
        // Remove :id from updated fields
        $updatedFields = array_filter($updatedFields, function($f) { return $f !== ':id'; });
        $fieldNames = array_map(function($f) { return str_replace(':', '', $f); }, $updatedFields);
        $details = "Updated fields: " . implode(', ', $fieldNames) . " for user {$data->id}";

        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Update User', :details, :user_name, 'staff', :actor_id, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => $details,
            ':user_name' => $userData->email ?? ($userData->id ?? 'unknown'),
            ':actor_id' => $userData->id ?? null
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Update User', :details, :user, 'user')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => $details,
            ':user' => $userData->email ?? ($userData->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "User updated successfully"]);
} else {
    http_response_code(500);
    echo json_encode(["error" => "Unable to update user"]);
}
?>
