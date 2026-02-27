<?php
// Database Connection Test - DELETE AFTER DEPLOYMENT VERIFICATION
require_once __DIR__ . '/config/Database.php';

header('Content-Type: application/json');

try {
    $db = new Database();
    $conn = $db->connect();
    
    if ($conn) {
        // Test query
        $stmt = $conn->query("SELECT COUNT(*) as count FROM users");
        $result = $stmt->fetch(PDO::FETCH_ASSOC);
        
        echo json_encode([
            "status" => "success",
            "message" => "Database connected successfully!",
            "user_count" => $result['count'],
            "database" => "mhcreati_studio"
        ]);
    } else {
        echo json_encode([
            "status" => "error",
            "message" => "Connection failed"
        ]);
    }
} catch (Exception $e) {
    echo json_encode([
        "status" => "error",
        "message" => "Error: " . $e->getMessage()
    ]);
}
?>
