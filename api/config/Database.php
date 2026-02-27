<?php
// MH CreationX - Database Connection Class

require_once __DIR__ . '/Config.php';

class Database {
    private $host;
    private $db_name;
    private $username;
    private $password;
    private $conn;

    public function __construct() {
        $this->host = Config::get('DB_HOST');
        $this->db_name = Config::get('DB_NAME');
        $this->username = Config::get('DB_USER');
        $this->password = Config::get('DB_PASS');
    }

    public function connect() {
        $this->conn = null;

        try {
            $dsn = "mysql:host=" . $this->host . ";dbname=" . $this->db_name . ";charset=utf8mb4";
            
            $options = [
                PDO::ATTR_ERRMODE => PDO::ERRMODE_EXCEPTION,
                PDO::ATTR_DEFAULT_FETCH_MODE => PDO::FETCH_ASSOC,
                PDO::ATTR_EMULATE_PREPARES => false,
                PDO::ATTR_PERSISTENT => true // Enable connection pooling
            ];

            $this->conn = new PDO($dsn, $this->username, $this->password, $options);
            
        } catch(PDOException $e) {
            // Log error safely without exposing credentials
            error_log("Database Connection Error: " . $e->getMessage());
            
            // Return JSON error if API request
            if (php_sapi_name() !== 'cli') {
                http_response_code(500);
                echo json_encode(['error' => 'Database connection failed. Please check server logs.']);
                exit;
            }
            return null;
        }

        return $this->conn;
    }
}
?>
