<?php
// config.php - Cấu hình hệ thống


// Cấu hình database
define('DB_HOST', 'localhost');
define('DB_NAME', 'LuxuryHotel');
define('DB_USER', 'root');
define('DB_PASS', '');  // Mặc định XAMPP là rỗng, WAMP thường là rỗng

// Cấu hình ứng dụng
define('APP_NAME', 'Luxury Hotel - Quản lý Lễ tân');
define('TIMEZONE', 'Asia/Ho_Chi_Minh');

// Thiết lập múi giờ
date_default_timezone_set(TIMEZONE);

// Báo lỗi (bật khi dev, tắt khi deploy)
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);
error_reporting(E_ALL);

// CORS - Cho phép gọi API từ frontend
header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

// Xử lý preflight request (OPTIONS)
if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}
?>