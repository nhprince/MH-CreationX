<?php
// MH CreationX - Client Login by Access Code

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->access_code)) {
    http_response_code(400);
    echo json_encode(["error" => "Access code is required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();
$jwtHelper = new JWTHandler();

// Find customer by ID (access code is customer ID)
$sql = "SELECT * FROM customers WHERE id = :id AND status = 'Active' LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->execute([':id' => $data->access_code]);

if ($stmt->rowCount() == 0) {
    http_response_code(401);
    echo json_encode(["error" => "Invalid access code or inactive customer"]);
    exit;
}

$customer = $stmt->fetch(PDO::FETCH_ASSOC);

// Audit: client login
try {
    $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, customer_id, category)
              VALUES ('Client Login', :details, :user_name, 'client', :customer_id, 'system')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "Client Login Success ({$customer['id']})",
        ':user_name' => $customer['name'],
        ':customer_id' => $customer['id']
    ]);
} catch (PDOException $e) {
    $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Client Login', :details, :user, 'system')";
    $logStmt = $conn->prepare($logSql);
    $logStmt->execute([
        ':details' => "Client Login Success ({$customer['id']})",
        ':user' => $customer['name']
    ]);
}

// Generate JWT for customer
$tokenPayload = [
    'customer_id' => $customer['id'],
    'customer_name' => $customer['name'],
    'type' => 'customer'
];

$token = $jwtHelper->generate($tokenPayload);

// Fetch projects with images
$projectsSql = "SELECT p.*, 
    (SELECT JSON_ARRAYAGG(JSON_OBJECT('url', image_url, 'type', type))
     FROM project_images WHERE project_id = p.id) as images
FROM projects p 
WHERE p.customer_id = :customer_id 
ORDER BY p.created_at DESC";

$projStmt = $conn->prepare($projectsSql);
$projStmt->execute([':customer_id' => $customer['id']]);
$projects = $projStmt->fetchAll(PDO::FETCH_ASSOC);

// Calculate totals and format images
$totalAmount = 0;
$totalPaid = 0;

foreach ($projects as &$proj) {
    $totalAmount += floatval($proj['price']);
    $totalPaid += floatval($proj['paid_amount']);
    
    // Parse images from JSON string to array
    if (isset($proj['images']) && $proj['images']) {
        $proj['images'] = json_decode($proj['images']);
    } else {
        $proj['images'] = [];
    }
}
unset($proj); 

$balance = $totalAmount - $totalPaid;

echo json_encode([
    "token" => $token,
    "customer" => [
        "id" => $customer['id'],
        "name" => $customer['name'],
        "phone" => $customer['phone'],
        "type" => $customer['type'],
        "email" => $customer['email'] ?? '',
        "profileImageUrl" => $customer['profile_image_url'] ?? ''
    ],
    "projects" => $projects,
    "summary" => [
        "total_projects" => count($projects),
        "total_amount" => $totalAmount,
        "total_paid" => $totalPaid,
        "balance" => $balance
    ]
]);
?>
