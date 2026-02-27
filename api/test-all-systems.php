<?php
// MH Creation X - Ultimate System Diagnostic
// Upload this file to /public_html/api/test-all-systems.php

error_reporting(E_ALL);
ini_set('display_errors', 1);
header('Content-Type: text/plain');

echo "=== MH Creation X Diagnostic Tool ===\n";
echo "Run Time: " . date('Y-m-d H:i:s') . "\n";
echo "Server IP: " . $_SERVER['SERVER_ADDR'] . "\n\n";

// --- STEP 1: LOAD CONFIGURATION ---
echo "--- 1. Configuration Check ---\n";
if (!file_exists(__DIR__ . '/config/Config.php')) {
    die("❌ CRITICAL: config/Config.php not found.\n");
}
require_once __DIR__ . '/config/Config.php';

$host = Config::get('EMAIL_HOST');
$port = Config::get('EMAIL_PORT');
$user = Config::get('EMAIL_USERNAME');
$encryption = Config::get('EMAIL_ENCRYPTION');

echo "SMTP Host: " . ($host ?: '❌ Not Set') . "\n";
echo "SMTP Port: " . ($port ?: '❌ Not Set') . "\n";
echo "SMTP User: " . ($user ?: '❌ Not Set') . "\n";
echo "Encryption: " . ($encryption ?: 'None') . "\n";

if ($host === 'mail.mhcreationx.top') {
    echo "⚠️ WARNING: Host is set to mail.mhcreationx.top. This is known to fail DNS.\n";
} else {
    echo "✅ Host config looks good.\n";
}
echo "\n";

// --- STEP 2: DNS & NETWORK ---
echo "--- 2. Network Connectivity ---\n";
if ($host) {
    echo "Resolving $host... ";
    $ip = gethostbyname($host);
    if ($ip == $host) {
        echo "❌ FAILED (DNS Lookup failed)\n";
    } else {
        echo "✅ OK ($ip)\n";
        
        $socketAddr = ($encryption == 'ssl' ? 'ssl://' : '') . $host;
        echo "Connecting to $socketAddr:$port... ";
        $socket = @fsockopen($socketAddr, $port, $errno, $errstr, 5);
        if ($socket) {
            echo "✅ CONNECTED\n";
            echo "Server Banner: " . fgets($socket, 512) . "\n";
            fclose($socket);
        } else {
            echo "❌ FAILED ($errstr)\n";
        }
    }
}
echo "\n";

// --- STEP 3: FILE INTEGRITY ---
echo "--- 3. Code Integrity Check ---\n";
$issues = 0;

// Check request-email-change.php
$reqFile = __DIR__ . '/auth/request-email-change.php';
if (file_exists($reqFile)) {
    $content = file_get_contents($reqFile);
    if (strpos($content, '$userData->id') !== false) {
         echo "✅ request-email-change.php: Fixed array access (\$userData->id)\n";
    } else {
         echo "❌ request-email-change.php: MISSING FIX (\$userData['id'] detected?)\n";
         $issues++;
    }
    
    if (strpos($content, 'EmailService') !== false) {
         echo "✅ request-email-change.php: Has EmailService integration\n";
    } else {
         echo "❌ request-email-change.php: MISSING EmailService integration\n";
         $issues++;
    }
} else {
    echo "❌ request-email-change.php: File not found\n";
    $issues++;
}

// Check EmailService.php
$svcFile = __DIR__ . '/utils/EmailService.php';
if (file_exists($svcFile)) {
    echo "✅ EmailService.php: Found\n";
} else {
    echo "❌ EmailService.php: Not found\n";
    $issues++;
}

if ($issues == 0) {
    echo "✅ All code files look correct.\n";
} else {
    echo "⚠️ Code files have issues. Please re-upload verified files.\n";
}
echo "\n";

// --- STEP 4: LIVE EMAIL TEST ---
echo "--- 4. Live Send Test ---\n";
if (!file_exists($svcFile)) {
    echo "SKIPPING: EmailService.php missing.\n";
} else {
    require_once $svcFile;
    
    try {
        echo "Initializing EmailService...\n";
        $mailer = new EmailService();
        
        $to = "support@mhcreationx.top"; // Send to self
        echo "Attempting to send test OTP to: $to\n";
        
        // We use sendOTP which uses the public interface
        $result = $mailer->sendOTP($to, "123456");
        
        if ($result) {
            echo "✅ SUCCESS: EmailService returned TRUE.\n";
            echo "   Check the inbox for $to.\n";
        } else {
            echo "❌ FAILED: EmailService returned FALSE.\n";
            echo "   Check error_log or /public_html/email_debug.log\n";
        }
    } catch (Exception $e) {
        echo "❌ EXCEPTION: " . $e->getMessage() . "\n";
    }
}

echo "\n=== End of Diagnostic ===\n";
?>
