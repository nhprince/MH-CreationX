<?php
// MH CreationX - Upload Customer Profile Image (Admin Only)

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken || !isset($userToken->type) || $userToken->type !== 'staff' || !isset($userToken->role) || $userToken->role !== 'Admin') {
    http_response_code(403);
    echo json_encode(["error" => "Access denied. Admin privileges required."]);
    exit;
}

$customerId = $_POST['customer_id'] ?? null;
if (!$customerId) {
    http_response_code(400);
    echo json_encode(["error" => "customer_id is required"]);
    exit;
}

if (!isset($_FILES['image'])) {
    http_response_code(400);
    echo json_encode(["error" => "image file is required"]);
    exit;
}

$file = $_FILES['image'];
if ($file['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(["error" => "Upload failed"]);
    exit;
}

$allowed = [
    'image/jpeg' => 'jpg',
    'image/png' => 'png',
    'image/webp' => 'webp',
    'image/gif' => 'gif'
];

$finfo = finfo_open(FILEINFO_MIME_TYPE);
$mime = finfo_file($finfo, $file['tmp_name']);
finfo_close($finfo);

if (!isset($allowed[$mime])) {
    http_response_code(400);
    echo json_encode(["error" => "Invalid file type"]);
    exit;
}

// 5MB limit
$maxSize = 5 * 1024 * 1024;
if ($file['size'] > $maxSize) {
    http_response_code(400);
    echo json_encode(["error" => "File too large. Max 5MB"]);
    exit;
}

$ext = $allowed[$mime];
$baseDir = realpath(__DIR__ . '/../uploads');
if (!$baseDir) {
    // Create uploads dir if missing
    $baseDir = __DIR__ . '/../uploads';
    if (!is_dir($baseDir) && !mkdir($baseDir, 0775, true)) {
        http_response_code(500);
        echo json_encode(["error" => "Failed to prepare upload directory"]);
        exit;
    }
}

$targetDir = rtrim($baseDir, '/') . '/customers/' . preg_replace('/[^a-zA-Z0-9\-]/', '', $customerId);
if (!is_dir($targetDir) && !mkdir($targetDir, 0775, true)) {
    http_response_code(500);
    echo json_encode(["error" => "Failed to create customer upload directory"]);
    exit;
}

$filename = 'profile_' . date('Ymd_His') . '_' . bin2hex(random_bytes(4)) . '.' . $ext;
$targetPath = $targetDir . '/' . $filename;

if (!move_uploaded_file($file['tmp_name'], $targetPath)) {
    http_response_code(500);
    echo json_encode(["error" => "Failed to save file"]);
    exit;
}

// Build a URL path relative to /api
$relativePath = '/uploads/customers/' . preg_replace('/[^a-zA-Z0-9\-]/', '', $customerId) . '/' . $filename;

$db = new Database();
$conn = $db->connect();

try {
    $stmt = $conn->prepare("UPDATE customers SET profile_image_url = :url WHERE id = :id");
    $stmt->execute([':url' => $relativePath, ':id' => $customerId]);

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, customer_id, category)
                  VALUES ('Upload Client Photo', :details, :user_name, 'staff', :actor_id, :customer_id, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Uploaded profile image for customer {$customerId}",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null,
            ':customer_id' => $customerId
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Upload Client Photo', :details, :user, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Uploaded profile image for customer {$customerId}",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode([
        'success' => true,
        'url' => $relativePath,
        'path' => $relativePath,
        'filename' => $filename
    ]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error"]);
}
?>
