<?php
// MH CreationX - Login Endpoint

require_once __DIR__ . '/../config/Database.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$data = json_decode(file_get_contents("php://input"));

if (!isset($data->email) || !isset($data->password)) {
    http_response_code(400);
    echo json_encode(["error" => "Email and password are required"]);
    exit;
}

$db = new Database();
$conn = $db->connect();
$jwtHelper = new JWTHandler();
require_once __DIR__ . '/../utils/RateLimiter.php';
$rateLimiter = new RateLimiter($conn);

$email = $data->email;
$password = $data->password;
$ip_address = $_SERVER['REMOTE_ADDR'];

// Check Rate Limiting
if (!$rateLimiter->checkLoginAttempts($ip_address, $email)) {
    http_response_code(429);
    echo json_encode(["error" => "Too many login attempts. Please try again in 15 minutes."]);
    exit;
}

// 1. Check Users (Staff)
$sql = "SELECT * FROM users WHERE email = :email LIMIT 1";
$stmt = $conn->prepare($sql);
$stmt->bindParam(':email', $email);
$stmt->execute();

if ($stmt->rowCount() > 0) {
    $user = $stmt->fetch(PDO::FETCH_ASSOC);
    
    if (password_verify($password, $user['password'])) {
        if (!$user['is_active']) {
           http_response_code(403);
           echo json_encode(["error" => "Account is deactivated"]);
           exit; 
        }

        // Clear failed attempts on success
        $rateLimiter->clearAttempts($ip_address);

        // CHECK TRUSTED DEVICE - DISABLED FOR SIMPLICITY
        // User requested to keep things simple without device verification
        $requireOtp = false; // Disabled device verification

        if ($requireOtp) {
            // Generate OTP
            $otp = sprintf("%06d", mt_rand(1, 999999));
            $expiry = date('Y-m-d H:i:s', strtotime('+10 minutes'));
            
            // In a real app, send email here. For now, we simulate sending.
            // Store OTP
            $otpSql = "INSERT INTO password_resets (email, otp, expires_at) VALUES (:email, :otp, :expiry)";
            $otpStmt = $conn->prepare($otpSql);
            $otpStmt->execute([':email' => $email, ':otp' => $otp, ':expiry' => $expiry]);

            // SEND EMAIL LOGIC HERE (Placeholder)
            // mail($email, "Login Verification Code", "Your code is: $otp");

            // Return OTP required response
            // For testing convenience, we might Log it to error_log or just assume email works.
            // Using error_log to see OTP in server logs for testing without email setup.
            error_log("OTP for $email: $otp"); 

            echo json_encode([
                "requires_otp" => true,
                "message" => "New device detected. Verification code sent to your email."
            ]);
            exit;
        }

        $tokenPayload = [
            'id' => $user['id'],
            'email' => $user['email'],
            'role' => $user['role'],
            'type' => 'staff'
        ];

        $token = $jwtHelper->generate($tokenPayload);

        // Don't send password back
        unset($user['password']);

        // Log audit
        try {
            $logSql = "INSERT INTO audit_logs (action, details, user_name, actor_type, actor_id, category)
                      VALUES ('Login', 'Staff Login Success', :user_name, 'staff', :actor_id, 'user')";
            $logStmt = $conn->prepare($logSql);
            $logStmt->execute([
                ':user_name' => $user['name'],
                ':actor_id' => $user['id']
            ]);
        } catch (PDOException $e) {
            $logSql = "INSERT INTO audit_logs (action, details, user_name, category) VALUES ('Login', 'Staff Login Success', :name, 'user')";
            $logStmt = $conn->prepare($logSql);
            $logStmt->execute([':name' => $user['name']]);
        }

        echo json_encode([
            "token" => $token,
            "user" => $user
        ]);
        exit;
    } else {
        // Record failed attempt
        $rateLimiter->recordAttempt($ip_address, $email);
    }
}

// 2. Check Customers (if login type allows or handled here)
// For now, assuming distinct login or shared. If shared:
// Logic for customer login would go here similar to above.

http_response_code(401);
echo json_encode(["error" => "Invalid credentials"]);
?>
