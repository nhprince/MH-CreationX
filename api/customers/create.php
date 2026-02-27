<?php
// MH CreationX - Create Customer Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken || !isset($userToken->type) || $userToken->type !== 'staff') {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->name) || !isset($data->type)) {
    http_response_code(400);
    echo json_encode(["error" => "Name and Type are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$createdBy = (isset($userToken->type) && $userToken->type === 'staff' && isset($userToken->id)) ? $userToken->id : null;

// Generate Customer ID based on name (e.g., JOHNDOE-042)
function generateClientId($name, $conn) {
    // Clean name: remove special chars, spaces, keep alphanumeric
    $cleanName = preg_replace('/[^a-zA-Z0-9]/', '', $name);
    $shortName = strtoupper(substr($cleanName, 0, 4));
    
    // Generate 3-digit number and check for collision
    $maxAttempts = 100;
    for ($i = 0; $i < $maxAttempts; $i++) {
        $number = str_pad(rand(1, 999), 3, '0', STR_PAD_LEFT);
        $customerId = $shortName . $number;
        
        // Check if ID already exists
        $checkSql = "SELECT id FROM customers WHERE id = :id";
        $checkStmt = $conn->prepare($checkSql);
        $checkStmt->execute([':id' => $customerId]);
        
        if ($checkStmt->rowCount() == 0) {
            return $customerId;
        }
    }
    
    // Fallback to UUID if collision after 100 attempts
    return 'CU-' . bin2hex(random_bytes(4));
}

$customerId = generateClientId($data->name, $conn);

$sql = "INSERT INTO customers (id, name, type, phone, email, address, status, created_by) 
        VALUES (:id, :name, :type, :phone, :email, :address, :status, :created_by)";

$stmt = $conn->prepare($sql);

try {
    $stmt->execute([
        ':id' => $customerId,
        ':name' => $data->name,
        ':type' => $data->type,
        ':phone' => $data->phone ?? null,
        ':email' => $data->email ?? null,
        ':address' => $data->address ?? null,
        ':status' => $data->status ?? 'Active',
        ':created_by' => $createdBy
    ]);

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, customer_id, category)
                  VALUES ('Create Customer', :details, :user_name, 'staff', :actor_id, :customer_id, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Added new customer {$data->name} ({$customerId})",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null,
            ':customer_id' => $customerId
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Create Customer', :details, :user, 'system')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Added new customer {$data->name} ({$customerId})",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Customer created created", "id" => $customerId]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}
?>
