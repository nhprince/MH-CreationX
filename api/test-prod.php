<?php
// Production Email Diagnostic Script v2
// Upload this to your /api/ directory as 'test-prod.php' and visit it in your browser

error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: text/plain');

echo "=== MH Creation X SMTP Autodiscovery ===\n";
echo "Server IP: " . $_SERVER['SERVER_ADDR'] . "\n\n";

$hosts = ['mhcreationx.top', 'mail.mhcreationx.top', 'localhost', '127.0.0.1'];
$ports = [465, 587, 25];

echo "Testing configurations...\n";
echo "------------------------------------------------\n";

$workingConfig = null;

foreach ($hosts as $host) {
    foreach ($ports as $port) {
        $prefix = ($port == 465) ? "ssl://" : "";
        $address = $prefix . $host;
        
        echo "Trying: $address : $port ... ";
        
        $timeout = 5;
        $socket = @fsockopen($address, $port, $errno, $errstr, $timeout);
        
        if ($socket) {
            echo "✅ CONNECTED!\n";
            $response = fgets($socket, 512);
            echo "   Server says: $response";
            
            // If we connected, this is likely a good config
            if (!$workingConfig) {
                $workingConfig = [
                    'host' => $host,
                    'port' => $port,
                    'encryption' => ($port == 465) ? 'ssl' : 'tls'
                ];
            }
            
            fclose($socket);
        } else {
            echo "❌ Failed ($errstr)\n";
        }
    }
}

echo "\n------------------------------------------------\n";
if ($workingConfig) {
    echo "🎉 FOUND WORKING CONFIGURATION!\n\n";
    echo "Please update your /api/.env file on the server with:\n";
    echo "EMAIL_HOST=" . $workingConfig['host'] . "\n";
    echo "EMAIL_PORT=" . $workingConfig['port'] . "\n";
    echo "EMAIL_ENCRYPTION=" . $workingConfig['encryption'] . "\n";
} else {
    echo "❌ No working SMTP connection found. Your hosting provider might be blocking outgoing mail ports.\n";
    echo "Try using 'localhost' with port 25 or contact support.\n";
}
echo "\n=== End of Test ===\n";
?>
