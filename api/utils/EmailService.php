<?php
// MH CreationX - Email Service

require_once __DIR__ . '/../config/Config.php';

class EmailService {
    private $smtp_host;
    private $smtp_port;
    private $smtp_user;
    private $smtp_pass;
    private $from_email;
    private $from_name;
    
    public function __construct() {
        $this->smtp_host = Config::get('EMAIL_HOST', 'mhcreationx.top');
        $this->smtp_port = Config::get('EMAIL_PORT', 465);
        $this->smtp_user = Config::get('EMAIL_USERNAME', 'contact@mhcreationx.top');
        $this->smtp_pass = Config::get('EMAIL_PASSWORD', 'mhcreation@1982');
        $this->from_email = Config::get('EMAIL_FROM', 'contact@mhcreationx.top');
        $this->from_name = Config::get('EMAIL_FROM_NAME', 'MH Creation X');
    }
    
    public function sendOTP($to, $otp, $type = 'password_reset') {
        // ALWAYS LOG OTP to file for manual retrieval
        $prefix = ($type === 'email_change') ? 'Email Change' : 'Password Reset';
        $logEntry = "[" . date('Y-m-d H:i:s') . "] $prefix: $to | OTP: $otp" . PHP_EOL;
        file_put_contents(__DIR__ . '/../otp_logs.txt', $logEntry, FILE_APPEND);
        
        $subject = ($type === 'email_change') ? "Email Change Verification - MH CreationX" : "Password Reset OTP - MH CreationX";
        $title = ($type === 'email_change') ? "Verify Email Change" : "Password Reset";
        $body = ($type === 'email_change') ? "You requested to change your email address." : "You requested a password reset for your MH CreationX account.";
        
        $message = $this->getOTPEmailTemplate($otp, $title, $body);
        return $this->sendSMTP($to, $subject, $message);
    }
    
    private function getOTPEmailTemplate($otp, $title, $bodyText) {
        return "<html><body style='font-family: Arial, sans-serif;'>
            <div style='max-width: 500px; margin: 0 auto; padding: 20px; border: 1px solid #eee; border-radius: 10px;'>
                <h2 style='color: #6366f1;'>{$title}</h2>
                <p>{$bodyText}</p>
                <p>Your verification code is:</p>
                <div style='font-size: 32px; font-weight: bold; color: #6366f1; letter-spacing: 5px; margin: 20px 0;'>{$otp}</div>
                <p>This code will expire in 15 minutes.</p>
                <p style='color: #888; font-size: 12px; margin-top: 30px;'>If you didn't request this, please ignore this message.</p>
            </div>
        </body></html>";
    }
    
    private function sendSMTP($to, $subject, $htmlBody) {
        $socket = fsockopen('ssl://' . $this->smtp_host, $this->smtp_port, $errno, $errstr, 30);
        
        if (!$socket) {
            $errorMsg = "SMTP Connection failed: $errstr ($errno)";
            error_log($errorMsg);
            file_put_contents(__DIR__ . '/../../email_debug.log', date('[Y-m-d H:i:s] ') . $errorMsg . "\n", FILE_APPEND);
            return false;
        }
        
        // Read server greeting
        $this->readSMTP($socket);
        
        // Send EHLO
        fputs($socket, "EHLO " . $_SERVER['SERVER_NAME'] . "\r\n");
        $this->readSMTP($socket);
        
        // Authenticate
        fputs($socket, "AUTH LOGIN\r\n");
        $this->readSMTP($socket);
        
        fputs($socket, base64_encode($this->smtp_user) . "\r\n");
        $this->readSMTP($socket);
        
        fputs($socket, base64_encode($this->smtp_pass) . "\r\n");
        $response = $this->readSMTP($socket);
        
        if (strpos($response, '235') === false) {
            error_log("SMTP Auth failed: $response");
            fclose($socket);
            return false;
        }
        
        // Send email
        fputs($socket, "MAIL FROM: <{$this->from_email}>\r\n");
        $this->readSMTP($socket);
        
        fputs($socket, "RCPT TO: <{$to}>\r\n");
        $this->readSMTP($socket);
        
        fputs($socket, "DATA\r\n");
        $this->readSMTP($socket);
        
        // Email headers and body
        $headers = "From: {$this->from_name} <{$this->from_email}>\r\n";
        $headers .= "Reply-To: {$this->from_email}\r\n";
        $headers .= "MIME-Version: 1.0\r\n";
        $headers .= "Content-Type: text/html; charset=UTF-8\r\n";
        $headers .= "Subject: {$subject}\r\n\r\n";
        
        fputs($socket, $headers . $htmlBody . "\r\n.\r\n");
        $this->readSMTP($socket);
        
        fputs($socket, "QUIT\r\n");
        fclose($socket);
        
        return true;
    }
    
    private function readSMTP($socket) {
        $response = '';
        while ($line = fgets($socket, 515)) {
            $response .= $line;
            if ($line[3] == ' ') break;
        }
        return $response;
    }
}
?>
