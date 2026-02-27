<?php
// MH CreationX - Database Seeder

require_once __DIR__ . '/../api/config/Database.php';

// Mock environment loading if not running through web server
if (!getenv('DB_HOST')) {
    // You might need to manually set these if running CLI directly without loading .env
    // This is a placeholder for development; in production .env will be used.
    $envPath = __DIR__ . '/../api/.env';
    if (file_exists($envPath)) {
        $lines = file($envPath, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos($line, '=') !== false && substr($line, 0, 1) !== '#') {
                list($key, $value) = explode('=', $line, 2);
                putenv(trim($key) . '=' . trim($value));
            }
        }
    }
}

echo "Starting Database Seed...\n";

$db = new Database();
$conn = $db->connect();

if (!$conn) {
    die("Connection failed. Check your configuration.\n");
}

// 1. Seed Master Admin
$masterEmail = 'moazzem@mahi';
$masterPass = 'MaHi'; // Initial password, should be changed immediately
$hashedPass = password_hash($masterPass, PASSWORD_BCRYPT);
$adminId = 'USR-' . bin2hex(random_bytes(4));

$sqlUser = "INSERT INTO users (id, name, email, password, role, is_active) 
            VALUES (:id, 'Moazzem Hossen', :email, :password, 'Admin', 1)
            ON DUPLICATE KEY UPDATE password = :password";

$stmt = $conn->prepare($sqlUser);
$stmt->execute([
    ':id' => $adminId,
    ':email' => $masterEmail,
    ':password' => $hashedPass
]);

echo "✅ Master Admin seeded (or updated).\n";

// 2. Seed Initial Audit Log
$sqlLog = "INSERT INTO audit_logs (action, details, user_name, category) 
           VALUES ('System Init', 'Database seeded with initial configuration', 'System', 'system')";
$conn->query($sqlLog);

echo "✅ Audit log initialized.\n";

// 3. Create 'General' Customer (for walk-in projects)
$sqlCustomer = "INSERT INTO customers (id, name, type, status) 
                VALUES ('CU-GEN', 'General Client', 'Local Client', 'Active')
                ON DUPLICATE KEY UPDATE name = VALUES(name)";
$conn->query($sqlCustomer);

echo "✅ General client seeded.\n";

echo "Seeding Complete!\n";
?>
