<?php
/**
 * Get Projects for Specific Customer
 * Used by client dashboard to show customer-specific projects
 */

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

// Verify JWT from customer login
$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$customerToken = $jwtHelper->verify($jwt);

if (!$customerToken || !isset($customerToken->customer_id)) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized - Customer login required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$customerId = $customerToken->customer_id;

// Get all projects for this customer
$sql = "SELECT 
    p.*,
    c.name as customer_name,
    c.phone as customer_phone,
    c.email as customer_email
FROM projects p
LEFT JOIN customers c ON p.customer_id = c.id
WHERE p.customer_id = :customer_id
ORDER BY p.created_at DESC";

$stmt = $conn->prepare($sql);
$stmt->execute([':customer_id' => $customerId]);

$projects = [];

while ($row = $stmt->fetch(PDO::FETCH_ASSOC)) {
    // Get project images
    $imgSql = "SELECT image_url, type FROM project_images WHERE project_id = :pid";
    $imgStmt = $conn->prepare($imgSql);
    $imgStmt->execute([':pid' => $row['id']]);
    $images = $imgStmt->fetchAll(PDO::FETCH_ASSOC);

    $projects[] = [
        'id' => $row['id'],
        'serial_number' => $row['serial_number'],
        'title' => $row['title'],
        'customer_id' => $row['customer_id'],
        'customer_name' => $row['customer_name'],
        'customer_phone' => $row['customer_phone'],
        'customer_email' => $row['customer_email'],
        'category' => $row['category'],
        'description' => $row['description'],
        'director' => $row['director'],
        'status' => $row['status'],
        'price' => (float)$row['price'],
        'advance_amount' => (float)$row['advance_amount'],
        'paid_amount' => (float)$row['paid_amount'],
        'discount' => (float)$row['discount'],
        'payment_status' => $row['payment_status'],
        'payment_method' => $row['payment_method'],
        'delivery_date' => $row['delivery_date'],
        'drive_link' => $row['drive_link'],
        'designer_name' => $row['designer_name'],
        'assistant_name' => $row['assistant_name'],
        'created_at' => $row['created_at'],
        'images' => $images
    ];
}

echo json_encode([
    'success' => true,
    'projects' => $projects,
    'customer_id' => $customerId
]);
?>
