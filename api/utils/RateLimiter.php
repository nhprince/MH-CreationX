<?php
header("Access-Control-Allow-Origin: *");
header("Content-Type: application/json; charset=UTF-8");

class RateLimiter {
    private $conn;
    private $table_name = "login_attempts";
    private $max_attempts = 5;
    private $lockout_minutes = 15;

    public function __construct($db) {
        $this->conn = $db;
    }

    // Check if IP is currently locked out
    public function checkLoginAttempts($ip, $email = null) {
        // Delete old attempts to keep table clean
        $this->cleanupAttempts();

        // Count recent attempts for this IP
        $query = "SELECT COUNT(*) as count FROM " . $this->table_name . " 
                  WHERE ip_address = :ip 
                  AND attempt_time > DATE_SUB(NOW(), INTERVAL :minutes MINUTE)";
        
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":ip", $ip);
        $stmt->bindParam(":minutes", $this->lockout_minutes);
        $stmt->execute();
        $row = $stmt->fetch(PDO::FETCH_ASSOC);

        if ($row['count'] >= $this->max_attempts) {
            return false; // Locked out
        }

        return true; // Allowed
    }

    // Record a failed attempt
    public function recordAttempt($ip, $email = null) {
        $query = "INSERT INTO " . $this->table_name . " (ip_address, email) VALUES (:ip, :email)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":ip", $ip);
        $stmt->bindParam(":email", $email);
        return $stmt->execute();
    }

    // Clear attempts on successful login
    public function clearAttempts($ip, $email = null) {
        $query = "DELETE FROM " . $this->table_name . " WHERE ip_address = :ip";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":ip", $ip);
        $stmt->execute();
    }

    private function cleanupAttempts() {
        // Delete attempts older than lockout time
        $query = "DELETE FROM " . $this->table_name . " WHERE attempt_time < DATE_SUB(NOW(), INTERVAL :minutes MINUTE)";
        $stmt = $this->conn->prepare($query);
        $stmt->bindParam(":minutes", $this->lockout_minutes);
        $stmt->execute();
    }
}
?>
