<?php

// api.php - XỬ LÝ TẤT CẢ YÊU CẦU TỪ FRONTEND


error_reporting(0);
ini_set('display_errors', 0);

header('Content-Type: application/json; charset=utf-8');
header('Access-Control-Allow-Origin: *');
header('Access-Control-Allow-Methods: GET, POST, PUT, DELETE, OPTIONS');
header('Access-Control-Allow-Headers: Content-Type, Authorization, X-Requested-With');

if ($_SERVER['REQUEST_METHOD'] == 'OPTIONS') {
    http_response_code(200);
    exit();
}

function jsonSuccess($data = [], $message = 'Thành công') {
    echo json_encode([
        'success' => true,
        'message' => $message,
        'data' => $data
    ], JSON_UNESCAPED_UNICODE);
    exit();
}

function jsonError($message = 'Có lỗi xảy ra', $code = 400) {
    http_response_code($code);
    echo json_encode([
        'success' => false,
        'message' => $message,
        'data' => null
    ], JSON_UNESCAPED_UNICODE);
    exit();
}


// KẾT NỐI DATABASE

$host = 'localhost';
$dbname = 'luxuryhotel';   // Tên database của bạn (chữ thường)
$username = 'root';
$password = '';

try {
    $conn = new PDO("mysql:host=$host;dbname=$dbname;charset=utf8mb4", $username, $password);
    $conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
    $conn->setAttribute(PDO::ATTR_DEFAULT_FETCH_MODE, PDO::FETCH_ASSOC);
} catch (PDOException $e) {
    jsonError('Không thể kết nối đến cơ sở dữ liệu: ' . $e->getMessage(), 500);
}

$action = isset($_GET['action']) ? $_GET['action'] : '';
$method = $_SERVER['REQUEST_METHOD'];

switch ($action) {

    
    // 1. ĐĂNG NHẬP (POST)
  
    case 'login':
        if ($method != 'POST') jsonError('Phương thức không được hỗ trợ', 405);
        $input = json_decode(file_get_contents('php://input'), true);
        $username = isset($input['username']) ? trim($input['username']) : '';
        $password = isset($input['password']) ? trim($input['password']) : '';
        if (empty($username) || empty($password)) jsonError('Vui lòng nhập tên đăng nhập và mật khẩu');
        try {
            $sql = "SELECT maNV, tenNV, chucVu FROM NV WHERE tenNV = ? AND sdtNV = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$username, $password]);
            $nv = $stmt->fetch();
            if ($nv) {
                jsonSuccess([
                    'user' => $nv['tenNV'],
                    'role' => $nv['chucVu'],
                    'maNV' => $nv['maNV']
                ], 'Đăng nhập thành công');
            } else {
                jsonError('Tên đăng nhập hoặc mật khẩu không đúng');
            }
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

   
    // 2. TRA CỨU ĐẶT PHÒNG (GET)
    
    case 'search_booking':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        $code = isset($_GET['code']) ? trim($_GET['code']) : '';
        if (empty($code)) jsonError('Vui lòng nhập mã đặt phòng');
        try {
            $sql = "
                SELECT 
                    dp.maDP,
                    dp.maDPHienThi,
                    dp.ngayNhan,
                    dp.ngayTra,
                    dp.soKhach,
                    dp.trangThai,
                    dp.soBoGiat,
                    dp.soNgayWifi,
                    dp.soLuotSpa,
                    dp.tongTienDV,
                    kh.tenKH AS tenKhach,
                    kh.cmnd,
                    kh.sdt,
                    kh.email,
                    p.soP AS soPhong,
                    lp.tenLP AS loaiPhong,
                    lp.gia AS giaPhong,
                    DATEDIFF(dp.ngayTra, dp.ngayNhan) AS soDem
                FROM DP dp
                JOIN KHACH kh ON dp.maKH = kh.maKH
                JOIN P p ON dp.maP = p.maP
                JOIN LP lp ON p.maLP = lp.maLP
                WHERE dp.maDPHienThi = ?
            ";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$code]);
            $result = $stmt->fetch();
            if ($result) {
                jsonSuccess($result, 'Tìm thấy thông tin đặt phòng');
            } else {
                jsonError('Không tìm thấy mã đặt phòng', 404);
            }
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

    
    // 3. NHẬN PHÒNG (CHECK-IN) (PUT)
    
        if ($method != 'PUT') jsonError('Phương thức không được hỗ trợ', 405);
        $input = json_decode(file_get_contents('php://input'), true);
        $bookingCode = isset($input['bookingCode']) ? trim($input['bookingCode']) : '';
        $cmnd = isset($input['cmnd']) ? trim($input['cmnd']) : '';
        if (empty($bookingCode) || empty($cmnd)) jsonError('Vui lòng nhập đầy đủ thông tin');
        try {
            $conn->beginTransaction();
            $sql = "SELECT maDP, maP, maKH FROM DP WHERE maDPHienThi = ? AND trangThai = 'Pending'";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$bookingCode]);
            $booking = $stmt->fetch();
            if (!$booking) jsonError('Không tìm thấy đặt phòng hoặc đã được xử lý');
            $sql = "SELECT maKH, cmnd FROM KHACH WHERE maKH = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maKH']]);
            $khach = $stmt->fetch();
            if ($khach['cmnd'] != $cmnd) jsonError('CMND không trùng khớp. Vui lòng kiểm tra lại!');
            $sql = "UPDATE DP SET trangThai = 'CheckedIn' WHERE maDP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maDP']]);
            $sql = "UPDATE P SET trangThaiP = N'Đang dùng' WHERE maP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maP']]);
            $conn->commit();
            jsonSuccess([
                'bookingCode' => $bookingCode,
                'phong' => $booking['maP']
            ], 'Giao phòng thành công!');
        } catch (PDOException $e) {
            $conn->rollBack();
            jsonError('Lỗi khi giao phòng: ' . $e->getMessage(), 500);
        }
        break;

    
    // 4. TÌM KHÁCH THEO PHÒNG (GET)
   
    case 'find_guest':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        $roomNumber = isset($_GET['room']) ? trim($_GET['room']) : '';
        if (empty($roomNumber)) jsonError('Vui lòng nhập số phòng');
        try {
            $sql = "
                SELECT 
                    dp.maDP,
                    dp.maDPHienThi,
                    dp.ngayNhan,
                    dp.ngayTra,
                    dp.soKhach,
                    dp.trangThai,
                    dp.soBoGiat,
                    dp.soNgayWifi,
                    dp.soLuotSpa,
                    dp.tongTienDV,
                    kh.tenKH AS tenKhach,
                    kh.cmnd,
                    kh.sdt,
                    kh.email,
                    p.soP AS soPhong,
                    lp.tenLP AS loaiPhong,
                    lp.gia AS giaPhong,
                    DATEDIFF(dp.ngayTra, dp.ngayNhan) AS soDem
                FROM DP dp
                JOIN KHACH kh ON dp.maKH = kh.maKH
                JOIN P p ON dp.maP = p.maP
                JOIN LP lp ON p.maLP = lp.maLP
                WHERE p.soP = ? AND dp.trangThai = 'CheckedIn'
            ";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$roomNumber]);
            $result = $stmt->fetch();
            if ($result) {
                jsonSuccess($result, 'Tìm thấy khách');
            } else {
                jsonError('Không tìm thấy khách ở phòng này hoặc phòng đang trống', 404);
            }
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

    
    // 5. THÊM DỊCH VỤ (POST)
   
    case 'add_service':
        if ($method != 'POST') jsonError('Phương thức không được hỗ trợ', 405);
        $input = json_decode(file_get_contents('php://input'), true);
        $bookingCode = isset($input['bookingCode']) ? trim($input['bookingCode']) : '';
        $loaiDV = isset($input['serviceType']) ? trim($input['serviceType']) : '';
        $soLuong = isset($input['quantity']) ? intval($input['quantity']) : 0;
        if (empty($bookingCode) || empty($loaiDV) || $soLuong <= 0) jsonError('Vui lòng nhập đầy đủ thông tin');
        $giaDV = ['Giat' => 50000, 'Wifi' => 30000, 'Spa' => 200000];
        if (!isset($giaDV[$loaiDV])) jsonError('Loại dịch vụ không hợp lệ');
        $gia = $giaDV[$loaiDV];
        $thanhTien = $soLuong * $gia;
        try {
            $conn->beginTransaction();
            $sql = "SELECT maDP FROM DP WHERE maDPHienThi = ? AND trangThai = 'CheckedIn'";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$bookingCode]);
            $booking = $stmt->fetch();
            if (!$booking) jsonError('Không tìm thấy đặt phòng hoặc khách chưa nhận phòng');
            $field = '';
            if ($loaiDV == 'Giat') $field = 'soBoGiat';
            else if ($loaiDV == 'Wifi') $field = 'soNgayWifi';
            else $field = 'soLuotSpa';
            $sql = "UPDATE DP SET $field = $field + ?, tongTienDV = tongTienDV + ? WHERE maDP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$soLuong, $thanhTien, $booking['maDP']]);
            $conn->commit();
            jsonSuccess([
                'loaiDV' => $loaiDV,
                'soLuong' => $soLuong,
                'thanhTien' => $thanhTien
            ], 'Đã ghi nhận dịch vụ thành công');
        } catch (PDOException $e) {
            $conn->rollBack();
            jsonError('Lỗi khi thêm dịch vụ: ' . $e->getMessage(), 500);
        }
        break;

  
    // 6. TÍNH TIỀN CHECKOUT (GET)
    
    case 'calculate_checkout':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        $roomNumber = isset($_GET['room']) ? trim($_GET['room']) : '';
        if (empty($roomNumber)) jsonError('Vui lòng nhập số phòng');
        try {
            $sql = "
                SELECT 
                    dp.maDP,
                    dp.maDPHienThi,
                    kh.tenKH AS tenKhach,
                    kh.cmnd,
                    kh.sdt,
                    p.soP AS soPhong,
                    lp.tenLP AS loaiPhong,
                    lp.gia AS giaPhong,
                    dp.ngayNhan,
                    dp.ngayTra,
                    DATEDIFF(dp.ngayTra, dp.ngayNhan) AS soDem,
                    dp.soBoGiat,
                    dp.soNgayWifi,
                    dp.soLuotSpa,
                    dp.tongTienDV,
                    dp.trangThai
                FROM DP dp
                JOIN KHACH kh ON dp.maKH = kh.maKH
                JOIN P p ON dp.maP = p.maP
                JOIN LP lp ON p.maLP = lp.maLP
                WHERE p.soP = ? AND dp.trangThai = 'CheckedIn'
            ";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$roomNumber]);
            $result = $stmt->fetch();
            if (!$result) jsonError('Không tìm thấy khách ở phòng này');
            $tienPhong = $result['soDem'] * $result['giaPhong'];
            $tienDV = $result['tongTienDV'];
            $tongTien = $tienPhong + $tienDV;
            $result['tienPhong'] = $tienPhong;
            $result['tongTien'] = $tongTien;
            jsonSuccess($result, 'Đã tính tiền thành công');
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

    
    // 7. TRẢ PHÒNG (CHECKOUT) (PUT)
    
    case 'checkout':
        if ($method != 'PUT') jsonError('Phương thức không được hỗ trợ', 405);
        $input = json_decode(file_get_contents('php://input'), true);
        $roomNumber = isset($input['roomNumber']) ? trim($input['roomNumber']) : '';
        $hinhThucTT = isset($input['paymentMethod']) ? trim($input['paymentMethod']) : '';
        $soTien = isset($input['amount']) ? floatval($input['amount']) : 0;
        if (empty($roomNumber) || empty($hinhThucTT) || $soTien <= 0) jsonError('Vui lòng nhập đầy đủ thông tin');
        try {
            $conn->beginTransaction();
            $sql = "SELECT maDP, maP FROM DP WHERE maP = (SELECT maP FROM P WHERE soP = ?) AND trangThai = 'CheckedIn'";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$roomNumber]);
            $booking = $stmt->fetch();
            if (!$booking) jsonError('Không tìm thấy đặt phòng đang ở');
            $sql = "UPDATE DP SET trangThai = 'CheckedOut' WHERE maDP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maDP']]);
            $sql = "INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, tongTien, ttThanhToan) 
                    SELECT maDP, CURDATE(), 
                        DATEDIFF(ngayTra, ngayNhan) * (SELECT gia FROM LP lp JOIN P p ON p.maLP = lp.maLP WHERE p.maP = ?),
                        tongTienDV,
                        (DATEDIFF(ngayTra, ngayNhan) * (SELECT gia FROM LP lp JOIN P p ON p.maLP = lp.maLP WHERE p.maP = ?)) + tongTienDV,
                        'Pending'
                    FROM DP WHERE maDP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maP'], $booking['maP'], $booking['maDP']]);
            $maHD = $conn->lastInsertId();
            $sql = "INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT) VALUES (?, ?, ?, CURDATE())";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$maHD, $hinhThucTT, $soTien]);
            $sql = "UPDATE HD SET ttThanhToan = 'Paid' WHERE maHD = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$maHD]);
            $sql = "UPDATE P SET trangThaiP = N'Trống' WHERE maP = ?";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$booking['maP']]);
            $conn->commit();
            jsonSuccess([
                'maHD' => $maHD,
                'soPhong' => $roomNumber
            ], 'Trả phòng thành công!');
        } catch (PDOException $e) {
            $conn->rollBack();
            jsonError('Lỗi khi trả phòng: ' . $e->getMessage(), 500);
        }
        break;

    
    // 8. DANH SÁCH PHÒNG (GET)
  
    case 'list_rooms':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        $maKS = isset($_GET['khachsan']) ? intval($_GET['khachsan']) : 1;
        try {
            $sql = "
                SELECT 
                    p.maP,
                    p.soP AS soPhong,
                    p.tang,
                    p.trangThaiP,
                    lp.tenLP AS loaiPhong,
                    lp.gia AS giaPhong,
                    ks.tenKS AS khachSan,
                    COALESCE(kh.tenKH, '-') AS tenKhach
                FROM P p
                JOIN LP lp ON p.maLP = lp.maLP
                JOIN KS ks ON p.maKS = ks.maKS
                LEFT JOIN DP dp ON p.maP = dp.maP AND dp.trangThai = 'CheckedIn'
                LEFT JOIN KHACH kh ON dp.maKH = kh.maKH
                WHERE p.maKS = ?
                ORDER BY p.tang, p.soP
            ";
            $stmt = $conn->prepare($sql);
            $stmt->execute([$maKS]);
            $result = $stmt->fetchAll();
            jsonSuccess($result, 'Lấy danh sách phòng thành công');
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

    
    // 9. THỐNG KÊ DASHBOARD (GET)
   
    case 'dashboard_stats':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        try {
            $stats = [];
            $stmt = $conn->query("SELECT COUNT(*) AS count FROM P WHERE trangThaiP = N'Đang dùng'");
            $stats['dangDung'] = $stmt->fetch()['count'] ?? 0;
            $stmt = $conn->query("SELECT COUNT(*) AS count FROM DP WHERE DATE(ngayNhan) = CURDATE() AND trangThai = 'CheckedIn'");
            $stats['checkinHomNay'] = $stmt->fetch()['count'] ?? 0;
            $stmt = $conn->query("SELECT SUM(soBoGiat + soNgayWifi + soLuotSpa) AS count FROM DP WHERE trangThai = 'CheckedIn'");
            $stats['tongDV'] = $stmt->fetch()['count'] ?? 0;
            $stmt = $conn->query("SELECT SUM(tongTien) AS total FROM HD WHERE DATE(ngayXuat) = CURDATE() AND ttThanhToan = 'Paid'");
            $stats['doanhThu'] = number_format($stmt->fetch()['total'] ?? 0, 0, ',', '.');
            jsonSuccess($stats, 'Lấy thống kê thành công');
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

   
    // 10. DANH SÁCH KHÁCH SẠN (GET)
    
    case 'list_hotels':
        if ($method != 'GET') jsonError('Phương thức không được hỗ trợ', 405);
        try {
            $stmt = $conn->query("SELECT maKS, tenKS FROM KS ORDER BY tenKS");
            $result = $stmt->fetchAll();
            jsonSuccess($result, 'Lấy danh sách khách sạn thành công');
        } catch (PDOException $e) {
            jsonError('Lỗi truy vấn: ' . $e->getMessage(), 500);
        }
        break;

    default:
        jsonError('Action không hợp lệ', 400);
        break;
}
?>