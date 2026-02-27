<?php
// MH CreationX - Cloudinary Signature Endpoint

require_once __DIR__ . '/../config/Config.php';
require_once __DIR__ . '/../utils/JWTHandler.php';
require_once __DIR__ . '/../middleware/CORS.php';

$headers = getallheaders();
$authHeader = $headers['Authorization'] ?? '';
$jwt = str_replace('Bearer ', '', $authHeader);
$jwtHelper = new JWTHandler();
$userToken = $jwtHelper->verify($jwt);

if (!$userToken) {
    http_response_code(401);
    echo json_encode(["error" => "Unauthorized"]);
    exit;
}

$cloudName = Config::get('CLOUDINARY_CLOUD_NAME');
$apiSecret = Config::get('CLOUDINARY_API_SECRET');
$apiKey = Config::get('CLOUDINARY_API_KEY');

if (!$apiSecret) {
    http_response_code(500);
    echo json_encode(["error" => "Server configuration error"]);
    exit;
}

// Generate Signature
$timestamp = time();
$params = [
    'timestamp' => $timestamp,
    'upload_preset' => 'mh_creationx_unsigned' // Optional if using signed
];

// If using signed uploads (preferred for security)
// Signature string: key=value&key=value.... + secret
ksort($params);
$str = "";
foreach ($params as $k => $v) {
    $str .= $k . "=" . $v . "&";
}
$str = rtrim($str, "&");
$signature = sha1($str . $apiSecret);

echo json_encode([
    "signature" => $signature,
    "timestamp" => $timestamp,
    "api_key" => $apiKey,
    "cloud_name" => $cloudName
]);
?>
