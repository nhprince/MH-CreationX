<?php
// MH CreationX - Configuration Manager

class Config {
    private static $env = [];
    private static $isLoaded = false;

    public static function load() {
        if (self::$isLoaded) return;

        $envFile = __DIR__ . '/../.env';
        
        if (!file_exists($envFile)) {
            // In production, variables might be set directly in server environment
            self::$env = getenv(); 
            self::$isLoaded = true;
            return;
        }

        $lines = file($envFile, FILE_IGNORE_NEW_LINES | FILE_SKIP_EMPTY_LINES);
        foreach ($lines as $line) {
            if (strpos(trim($line), '#') === 0) continue; // Skip comments
            
            if (strpos($line, '=') !== false) {
                list($key, $value) = explode('=', $line, 2);
                putenv("$key=$value");
                $_ENV[$key] = $value;
                $_SERVER[$key] = $value;
            }
        }
        
        self::$isLoaded = true;
    }

    public static function get($key, $default = null) {
        if (!self::$isLoaded) self::load();
        
        // Prioritize loaded .env, then system environment
        if (isset(self::$env[$key])) return self::$env[$key];
        
        $usage = getenv($key);
        if ($usage !== false) return $usage;
        
        return $default;
    }
}

// Auto-load on include
Config::load();
?>
