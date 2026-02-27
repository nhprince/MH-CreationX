<?php
// MH CreationX - JWT Handler

require_once __DIR__ . '/../config/Config.php';

class JWTHandler {
    private $secret;
    private $expiry;

    public function __construct() {
        $this->secret = Config::get('JWT_SECRET');
        $this->expiry = Config::get('JWT_EXPIRY', 86400); // 24 hours default
    }

    public function generate($data) {
        $header = json_encode(['typ' => 'JWT', 'alg' => 'HS256']);
        $payload = json_encode(array_merge($data, [
            'iat' => time(),
            'exp' => time() + $this->expiry
        ]));

        $base64UrlHeader = $this->base64UrlEncode($header);
        $base64UrlPayload = $this->base64UrlEncode($payload);

        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, $this->secret, true);
        $base64UrlSignature = $this->base64UrlEncode($signature);

        return $base64UrlHeader . "." . $base64UrlPayload . "." . $base64UrlSignature;
    }

    public function verify($jwt) {
        $tokenParts = explode('.', $jwt);
        if (count($tokenParts) !== 3) return false;

        $header = base64_decode($tokenParts[0]);
        $payload = base64_decode($tokenParts[1]);
        $signature_provided = $tokenParts[2];

        // Verify Expiry
        $payloadObj = json_decode($payload);
        if (!$payloadObj || !isset($payloadObj->exp) || $payloadObj->exp < time()) {
            return false;
        }

        // Verify Signature
        $base64UrlHeader = $this->base64UrlEncode($header);
        $base64UrlPayload = $this->base64UrlEncode($payload);
        $signature = hash_hmac('sha256', $base64UrlHeader . "." . $base64UrlPayload, $this->secret, true);
        $base64UrlSignature = $this->base64UrlEncode($signature);

        return ($base64UrlSignature === $signature_provided) ? $payloadObj : false;
    }

    public function validateToken() {
        $headers = function_exists('getallheaders') ? getallheaders() : [];
        $authHeader = $headers['Authorization'] ?? $headers['authorization'] ?? '';
        
        if (empty($authHeader)) {
            $authHeader = $_SERVER['HTTP_AUTHORIZATION'] ?? $_SERVER['Authorization'] ?? '';
        }

        if (empty($authHeader)) {
            return false;
        }

        $jwt = str_replace('Bearer ', '', $authHeader);
        return $this->verify($jwt);
    }

    private function base64UrlEncode($data) {
        return rtrim(strtr(base64_encode($data), '+/', '-_'), '=');
    }
}
?>
