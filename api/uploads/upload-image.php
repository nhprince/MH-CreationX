<?php
/**
 * Image Upload API
 * Handles image uploads to server storage (replaces Cloudinary)
 * Location: public_html/api/uploads/upload-image.php (on cPanel)
 */

header('Content-Type: application/json');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: POST, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Device-Fingerprint');
header('Access-Control-Allow-Credentials: true');

// Handle preflight
if ($_SERVER['REQUEST_METHOD'] === 'OPTIONS') {
    http_response_code(200);
    exit();
}

// Only allow POST
if ($_SERVER['REQUEST_METHOD'] !== 'POST') {
    http_response_code(405);
    echo json_encode(['error' => 'Method not allowed']);
    exit();
}

// Check if file was uploaded
if (!isset($_FILES['image']) || $_FILES['image']['error'] !== UPLOAD_ERR_OK) {
    http_response_code(400);
    echo json_encode(['error' => 'No file uploaded or upload error']);
    exit();
}

// Configuration
$allowed_extensions = ['jpg', 'jpeg', 'png', 'gif', 'webp'];
$max_file_size = 20 * 1024 * 1024; // 20MB
$upload_dir = __DIR__ . '/../../uploads/projects/';

// Create upload directory if it doesn't exist
if (!is_dir($upload_dir)) {
    mkdir($upload_dir, 0755, true);
}

// Get file info
$file = $_FILES['image'];
$original_name = basename($file['name']);
$file_size = $file['size'];
$file_tmp = $file['tmp_name'];

// Validate file extension
$file_ext = strtolower(pathinfo($original_name, PATHINFO_EXTENSION));
if (!in_array($file_ext, $allowed_extensions)) {
    http_response_code(400);
    echo json_encode(['error' => 'Invalid file type. Allowed: ' . implode(', ', $allowed_extensions)]);
    exit();
}

// Validate file size
if ($file_size > $max_file_size) {
    http_response_code(400);
    echo json_encode(['error' => 'File too large. Maximum size: 5MB']);
    exit();
}

// Validate it's actually an image
$image_info = @getimagesize($file_tmp);
if ($image_info === false) {
    http_response_code(400);
    echo json_encode(['error' => 'File is not a valid image']);
    exit();
}

// Generate unique filename
$timestamp = time();
$random = bin2hex(random_bytes(8));
$filename = "{$timestamp}_{$random}.{$file_ext}";
$upload_path = $upload_dir . $filename;

// Move uploaded file
if (!move_uploaded_file($file_tmp, $upload_path)) {
    http_response_code(500);
    echo json_encode(['error' => 'Failed to save file']);
    exit();
}

// Optional: Optimize image (if GD library available)
try {
    optimizeImage($upload_path, $file_ext);
} catch (Exception $e) {
    // Optimization failed, continue anyway
    error_log("Image optimization failed: " . $e->getMessage());
}

// Return success response
echo json_encode([
    'success' => true,
    'url' => '/uploads/projects/' . $filename,
    'path' => 'uploads/projects/' . $filename,
    'filename' => $filename,
    'size' => $file_size,
    'type' => $image_info['mime']
]);

/**
 * Optimize uploaded image (optional)
 */
function optimizeImage($path, $ext) {
    if (!extension_loaded('gd')) {
        return;
    }

    $max_width = 1920;
    $max_height = 1920;
    $quality = 85;

    list($width, $height) = getimagesize($path);

    // Skip if already small enough
    if ($width <= $max_width && $height <= $max_height) {
        return;
    }

    // Calculate new dimensions
    $ratio = min($max_width / $width, $max_height / $height);
    $new_width = (int)($width * $ratio);
    $new_height = (int)($height * $ratio);

    // Create image from file
    switch ($ext) {
        case 'jpg':
        case 'jpeg':
            $source = imagecreatefromjpeg($path);
            break;
        case 'png':
            $source = imagecreatefrompng($path);
            break;
        case 'gif':
            $source = imagecreatefromgif($path);
            break;
        case 'webp':
            $source = imagecreatefromwebp($path);
            break;
        default:
            return;
    }

    // Create resized image
    $resized = imagecreatetruecolor($new_width, $new_height);
    
    // Preserve transparency for PNG
    if ($ext === 'png') {
        imagealphablending($resized, false);
        imagesavealpha($resized, true);
    }

    imagecopyresampled($resized, $source, 0, 0, 0, 0, $new_width, $new_height, $width, $height);

    // Save optimized image
    switch ($ext) {
        case 'jpg':
        case 'jpeg':
            imagejpeg($resized, $path, $quality);
            break;
        case 'png':
            imagepng($resized, $path, 9);
            break;
        case 'gif':
            imagegif($resized, $path);
            break;
        case 'webp':
            imagewebp($resized, $path, $quality);
            break;
    }

    imagedestroy($source);
    imagedestroy($resized);
}
?>
