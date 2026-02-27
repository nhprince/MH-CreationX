<?php
// MH CreationX - Create Expense Endpoint

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

// Map reason/title preference. Schema uses 'reason'. 
$reason = $data->reason ?? $data->title ?? null;

if (!$reason || !isset($data->amount) || !isset($data->category)) {
    http_response_code(400);
    echo json_encode(["error" => "Reason, Amount, and Category are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();

$sql = "INSERT INTO expenses (reason, amount, category, date, created_by) 
        VALUES (:reason, :amount, :category, :date, :user)";

$stmt = $conn->prepare($sql);

try {
    $stmt->execute([
        ':reason' => $reason,
        ':amount' => $data->amount,
        ':category' => $data->category,
        ':date' => $data->date ?? date('Y-m-d'),
        ':user' => $userToken->id ?? null
    ]);

    $expenseId = $conn->lastInsertId();

    // Audit Log
    try {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                  VALUES ('Add Expense', :details, :user_name, 'staff', :actor_id, 'finance')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Recorded expense: {$reason} (BDT {$data->amount})",
            ':user_name' => $userToken->email ?? ($userToken->id ?? 'unknown'),
            ':actor_id' => $userToken->id ?? null
        ]);
    } catch (PDOException $e) {
        $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Add Expense', :details, :user, 'finance')";
        $logStmt = $conn->prepare($logSql);
        $logStmt->execute([
            ':details' => "Recorded expense: {$reason} (BDT {$data->amount})",
            ':user' => $userToken->email ?? ($userToken->id ?? 'unknown')
        ]);
    }

    echo json_encode(["message" => "Expense recorded", "id" => $expenseId]);

} catch (PDOException $e) {
    http_response_code(500);
    echo json_encode(["error" => "Database error: " . $e->getMessage()]);
}
?>
