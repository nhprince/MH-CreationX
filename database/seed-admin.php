<?php
/**
 * MH CreationX - Admin User Seed Script
 * 
 * This script will:
 * 1. Delete all existing users from the database
 * 2. Create a fresh admin user with the specified credentials
 * 
 * USAGE: php database/seed-admin.php
 * WARNING: This will delete ALL existing users!
 */

require_once __DIR__ . '/../api/config/Database.php';

echo "\n=== MH CreationX - Admin User Seed Script ===\n\n";

// Admin credentials
$adminEmail = 'contact@nhprince.dpdns.org';
$adminPassword = 'admin123';  // Change this after first login!
$adminName = 'Administrator';
$adminRole = 'Admin';

// Connect to database
$db = new Database();
$conn = $db->connect();

if (!$conn) {
    die("❌ Database connection failed!\n");
}

try {
    // Start transaction
    $conn->beginTransaction();
    
    // Step 1: Delete all existing users
    echo "🗑️  Deleting all existing users...\n";
    $deleteStmt = $conn->prepare("DELETE FROM users");
    $deleteStmt->execute();
    $deletedCount = $deleteStmt->rowCount();
    echo "✅ Deleted $deletedCount existing user(s)\n\n";
    
    // Step 2: Create new admin user
    echo "👤 Creating fresh admin user...\n";
    echo "   Email: $adminEmail\n";
    echo "   Password: $adminPassword\n";
    echo "   Role: $adminRole\n\n";
    
    // Generate UUID for user ID
    $userId = sprintf(
        '%04x%04x-%04x-%04x-%04x-%04x%04x%04x',
        mt_rand(0, 0xffff), mt_rand(0, 0xffff),
        mt_rand(0, 0xffff),
        mt_rand(0, 0x0fff) | 0x4000,
        mt_rand(0, 0x3fff) | 0x8000,
        mt_rand(0, 0xffff), mt_rand(0, 0xffff), mt_rand(0, 0xffff)
    );
    
    // Hash password using bcrypt
    $hashedPassword = password_hash($adminPassword, PASSWORD_BCRYPT);
    
    // Insert admin user
    $insertSql = "INSERT INTO users (id, name, email, password, role, is_active, created_at) 
                  VALUES (:id, :name, :email, :password, :role, 1, NOW())";
    $insertStmt = $conn->prepare($insertSql);
    $insertStmt->execute([
        ':id' => $userId,
        ':name' => $adminName,
        ':email' => $adminEmail,
        ':password' => $hashedPassword,
        ':role' => $adminRole
    ]);
    
    // Commit transaction
    $conn->commit();
    
    echo "✅ Admin user created successfully!\n\n";
    echo "=== Login Credentials ===\n";
    echo "Email: $adminEmail\n";
    echo "Password: $adminPassword\n";
    echo "⚠️  IMPORTANT: Change this password after first login!\n\n";
    echo "✅ Seed script completed successfully!\n";
    
} catch (Exception $e) {
    // Rollback on error
    $conn->rollBack();
    echo "❌ Error: " . $e->getMessage() . "\n";
    exit(1);
}
?>
