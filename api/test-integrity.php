<?php
// MH Creation X - Integrity & Send Test
// Upload to /public_html/api/test-integrity.php

header('Content-Type: text/plain');
echo "=== MH Creation X Integrity & Send Test ===\n\n";

// 1. Verify Request Email Change File
$file = __DIR__ . '/auth/request-email-change.php';
if (file_exists($file)) {
    $content = file_get_contents($file);
    if (strpos($content, 'EmailService') !== false) {
        echo "✅ request-email-change.php contains 'EmailService' (Good)\n";
    } else {
        echo "❌ request-email-change.php MISSING 'EmailService' code!\n";
        echo "   ACTION: You must upload the updated 'api/auth/request-email-change.php' file.\n";
    }
} else {
    echo "❌ File api/auth/request-email-change.php not found!\n";
}

// 2. Verify EmailService File
$file = __DIR__ . '/utils/EmailService.php';
if (file_exists($file)) {
    $content = file_get_contents($file);
    if (strpos($content, 'mhcreationx.top') !== false) {
        // Checking if default host was updated (though not strictly required if env set)
        echo "ℹ️  EmailService.php default host check: Found mhcreationx.top (Good)\n";
    } else {
        echo "ℹ️  EmailService.php default host check: Using old default (OK if .env is correct)\n";
    }
} else {
    echo "❌ File api/utils/EmailService.php not found!\n";
}

echo "\n--- Attempting to Send Real Email via EmailService ---\n";

require_once __DIR__ . '/utils/EmailService.php';
require_once __DIR__ . '/config/Config.php';

echo "Configured Host: " . Config::get('EMAIL_HOST') . "\n";
echo "Configured User: " . Config::get('EMAIL_USERNAME') . "\n";

class DebugEmailService extends EmailService {
    // Override to expose protected/private if needed or just use as is
    // EmailService methods are private, so we can't easily hook into them 
    // without modifying the class. 
    // We will just try to use the public API and catch errors.
}

try {
    $mailer = new EmailService();
    // Send to the admin email itself
    $to = "contact@mhcreationx.top"; 
    echo "Sending test email to: $to\n";
    
    $result = $mailer->sendOTP($to, "999999");
    
    if ($result) {
        echo "✅ EmailService returned TRUE. Email accepted by server.\n";
    } else {
        echo "❌ EmailService returned FALSE.\n";
    }
} catch (Exception $e) {
    echo "❌ Exception: " . $e->getMessage() . "\n";
}

echo "\n=== Check email_debug.log ===\n";
$logFile = __DIR__ . '/../email_debug.log';
if (file_exists($logFile)) {
    echo "Found log file. Last 5 lines:\n";
    $lines = file($logFile);
    $last = array_slice($lines, -5);
    foreach($last as $line) echo $line;
} else {
    echo "No ../email_debug.log found.\n";
}
?>
