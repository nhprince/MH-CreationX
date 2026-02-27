<?php
// MH CreationX - CORS Middleware

require_once __DIR__ . '/../config/Config.php';

function handleCORS() {
    $origin = $_SERVER['HTTP_ORIGIN'] ?? '';
    
    // Production allowed origins
    $allowed_origins = [
        'https://mhcreationx.top',
        'https://www.mhcreationx.top',
        'http://localhost:5173',  // Vite dev
        'http://localhost:3000'   // Alternative dev port
    ];
    
    // Check if origin is allowed
    if (in_array($origin, $allowed_origins)) {
        header("Access-Control-Allow-Origin: $origin");
        header("Access-Control-Allow-Credentials: true");
    } else {
        // Fallback to main domain for direct access
        header("Access-Control-Allow-Origin: https://mhcreationx.top");
    }
    
    header("Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS");
    header("Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With, X-Device-Fingerprint");
    
    // Handle Preflight Request
    if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
        http_response_code(200);
        exit;
    }
}

// Execute CORS handling immediately
handleCORS();

// Set default Content-Type to JSON for all API responses
header('Content-Type: application/json; charset=UTF-8');
?>
