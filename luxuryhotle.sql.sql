-- =====================================================
-- XÓA DATABASE CŨ (NẾU CÓ)
-- =====================================================
DROP DATABASE IF EXISTS luxuryhotel;
CREATE DATABASE luxuryhotel;
USE luxuryhotel;

-- =====================================================
-- 1. BẢNG KHÁCH SẠN (KS)
-- =====================================================
CREATE TABLE KS (
    maKS INT AUTO_INCREMENT PRIMARY KEY,
    tenKS NVARCHAR(100) NOT NULL,
    diaChi NVARCHAR(200) NOT NULL,
    sdtKS VARCHAR(20) NOT NULL,
    ghiChu NVARCHAR(500) NULL
);

-- =====================================================
-- 2. BẢNG LOẠI PHÒNG (LP)
-- =====================================================
CREATE TABLE LP (
    maLP INT AUTO_INCREMENT PRIMARY KEY,
    tenLP NVARCHAR(50) NOT NULL,
    gia DECIMAL(18,2) NOT NULL,
    sucChua INT NOT NULL,
    moTa NVARCHAR(200) NULL
);

-- =====================================================
-- 3. BẢNG PHÒNG (P)
-- =====================================================
CREATE TABLE P (
    maP INT AUTO_INCREMENT PRIMARY KEY,
    soP NVARCHAR(10) NOT NULL UNIQUE,
    tang INT NOT NULL,
    trangThaiP NVARCHAR(20) DEFAULT N'Trống',
    maLP INT NOT NULL,
    maKS INT NOT NULL,
    FOREIGN KEY (maLP) REFERENCES LP(maLP),
    FOREIGN KEY (maKS) REFERENCES KS(maKS)
);

-- =====================================================
-- 4. BẢNG KHÁCH HÀNG (KHACH)
-- =====================================================
CREATE TABLE KHACH (
    maKH INT AUTO_INCREMENT PRIMARY KEY,
    tenKH NVARCHAR(100) NOT NULL,
    cmnd VARCHAR(20) NOT NULL UNIQUE,
    sdt VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    diemTL INT DEFAULT 0,
    ghiChu NVARCHAR(200) NULL
);

-- =====================================================
-- 5. BẢNG ĐẶT PHÒNG (DP)
-- =====================================================
CREATE TABLE DP (
    maDP INT AUTO_INCREMENT PRIMARY KEY,
    maDPHienThi VARCHAR(20) NOT NULL UNIQUE,
    ngayNhan DATE NOT NULL,
    ngayTra DATE NOT NULL,
    soKhach INT NOT NULL,
    trangThai NVARCHAR(20) DEFAULT 'Pending',
    maKH INT NOT NULL,
    maP INT NOT NULL,
    soBoGiat INT DEFAULT 0,
    soNgayWifi INT DEFAULT 0,
    soLuotSpa INT DEFAULT 0,
    tongTienDV DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (maKH) REFERENCES KHACH(maKH),
    FOREIGN KEY (maP) REFERENCES P(maP)
);

-- =====================================================
-- 6. BẢNG NHÂN VIÊN (NV)
-- =====================================================
CREATE TABLE NV (
    maNV INT AUTO_INCREMENT PRIMARY KEY,
    tenNV NVARCHAR(100) NOT NULL,
    chucVu NVARCHAR(50) NOT NULL,
    sdtNV VARCHAR(20) NOT NULL,
    maKS INT NOT NULL,
    FOREIGN KEY (maKS) REFERENCES KS(maKS)
);

-- =====================================================
-- 7. BẢNG HÓA ĐƠN (HD)
-- =====================================================
CREATE TABLE HD (
    maHD INT AUTO_INCREMENT PRIMARY KEY,
    maDP INT NOT NULL,
    ngayXuat DATE DEFAULT CURRENT_DATE,
    tienP DECIMAL(18,2) DEFAULT 0,
    tienDV DECIMAL(18,2) DEFAULT 0,
    giamGia DECIMAL(18,2) DEFAULT 0,
    tongTien DECIMAL(18,2) DEFAULT 0,
    ttThanhToan NVARCHAR(20) DEFAULT 'Pending',
    ghiChu NVARCHAR(200) NULL,
    FOREIGN KEY (maDP) REFERENCES DP(maDP)
);

-- =====================================================
-- 8. BẢNG THANH TOÁN (TT)
-- =====================================================
CREATE TABLE TT (
    maTT INT AUTO_INCREMENT PRIMARY KEY,
    maHD INT NOT NULL,
    hinhThuc NVARCHAR(30) NOT NULL,
    soTien DECIMAL(18,2) NOT NULL,
    ngayTT DATE DEFAULT CURRENT_DATE,
    ghiChu NVARCHAR(200) NULL,
    FOREIGN KEY (maHD) REFERENCES HD(maHD)
);

-- =====================================================
-- CHÈN DỮ LIỆU MẪU
-- =====================================================

-- 1. KHÁCH SẠN
INSERT INTO KS (tenKS, diaChi, sdtKS) VALUES
(N'Luxury Hotel Sài Gòn', N'123 Nguyễn Huệ, Quận 1, TP.HCM', '0281234567'),
(N'Luxury Hotel Hà Nội', N'45 Tràng Tiền, Hoàn Kiếm, Hà Nội', '0241234567'),
(N'Luxury Hotel Đà Nẵng', N'67 Võ Nguyên Giáp, Ngũ Hành Sơn, Đà Nẵng', '02361234567');

-- 2. LOẠI PHÒNG
INSERT INTO LP (tenLP, gia, sucChua, moTa) VALUES
(N'Suite', 1200000, 2, N'Phòng Suite cao cấp view biển'),
(N'Deluxe', 800000, 2, N'Phòng Deluxe tiện nghi'),
(N'Premier', 1500000, 4, N'Phòng Premier sang trọng');

-- 3. PHÒNG
INSERT INTO P (soP, tang, trangThaiP, maLP, maKS) VALUES
('501', 5, N'Trống', 1, 1),
('502', 5, N'Trống', 1, 1),
('503', 5, N'Đang dùng', 2, 1),
('401', 4, N'Trống', 2, 2),
('402', 4, N'Trống', 2, 2),
('301', 3, N'Trống', 3, 3);

-- 4. KHÁCH HÀNG
INSERT INTO KHACH (tenKH, cmnd, sdt, email, diemTL) VALUES
(N'Nguyễn Văn An', '0123456789', '0909123456', 'an.nguyen@email.com', 100),
(N'Trần Thị Bình', '9876543210', '0912987654', 'binh.tran@email.com', 250),
(N'Lê Văn Cường', '9988776655', '0933456789', 'cuong.le@email.com', 50),
(N'Phạm Thị Dung', '1122334455', '0909876543', 'dung.pham@email.com', 0);

-- 5. ĐẶT PHÒNG
INSERT INTO DP (maDPHienThi, ngayNhan, ngayTra, soKhach, trangThai, maKH, maP, soBoGiat, soNgayWifi, soLuotSpa, tongTienDV) VALUES
('LUX-2026-001', '2026-06-01', '2026-06-06', 2, N'CheckedOut', 1, 1, 3, 2, 1, 410000),
('LUX-2026-002', '2026-06-05', '2026-06-08', 1, N'CheckedIn', 2, 2, 0, 3, 0, 90000),
('LUX-2026-003', '2026-06-10', '2026-06-12', 2, N'Pending', 3, 3, 2, 0, 1, 300000),
('LUX-2026-004', '2026-06-15', '2026-06-18', 3, N'Confirmed', 4, 4, 0, 0, 0, 0);

-- 6. NHÂN VIÊN
INSERT INTO NV (tenNV, chucVu, sdtNV, maKS) VALUES
(N'Nguyễn Thị Mai', N'Receptionist', '0909111222', 1),
(N'Trần Văn Nam', N'Cashier', '0909333444', 1),
(N'Lê Thị Hoa', N'Housekeeping', '0909555666', 1),
(N'Phạm Văn Hùng', N'Receptionist', '0911777888', 2),
(N'Hoàng Thị Lan', N'Cashier', '0911999000', 2);

-- 7. HÓA ĐƠN (có 1 hóa đơn đã thanh toán, 1 đang chờ)
INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, giamGia, tongTien, ttThanhToan) VALUES
(1, '2026-06-06', 6000000, 410000, 0, 6410000, N'Paid'),
(2, '2026-06-08', 2400000, 90000, 50000, 2440000, N'Pending');

-- 8. THANH TOÁN (cho hóa đơn số 1)
INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT, ghiChu) VALUES
(1, N'Cash', 6410000, '2026-06-06', N'Thanh toán bằng tiền mặt');

-- =====================================================
-- TẠO VIEW
-- =====================================================

-- VIEW: ĐẶT PHÒNG CHI TIẾT
CREATE VIEW v_DP_ChiTiet AS
SELECT 
    dp.maDP,
    dp.maDPHienThi,
    kh.tenKH AS tenKhachHang,
    kh.cmnd,
    kh.sdt,
    p.soP AS soPhong,
    lp.tenLP AS loaiPhong,
    lp.gia AS giaPhong,
    dp.ngayNhan,
    dp.ngayTra,
    DATEDIFF(dp.ngayTra, dp.ngayNhan) AS soDem,
    dp.soKhach,
    dp.trangThai,
    dp.soBoGiat,
    dp.soNgayWifi,
    dp.soLuotSpa,
    dp.tongTienDV
FROM DP dp
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN P p ON dp.maP = p.maP
JOIN LP lp ON p.maLP = lp.maLP;

-- VIEW: HÓA ĐƠN CHI TIẾT
CREATE VIEW v_HD_ChiTiet AS
SELECT 
    hd.maHD,
    dp.maDPHienThi,
    kh.tenKH AS tenKhachHang,
    kh.cmnd,
    p.soP AS soPhong,
    lp.tenLP AS loaiPhong,
    hd.ngayXuat,
    hd.tienP,
    hd.tienDV,
    hd.giamGia,
    hd.tongTien,
    hd.ttThanhToan,
    tt.hinhThuc AS hinhThucThanhToan,
    tt.ngayTT AS ngayThanhToan,
    tt.soTien AS soTienDaThanhToan
FROM HD hd
JOIN DP dp ON hd.maDP = dp.maDP
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN P p ON dp.maP = p.maP
JOIN LP lp ON p.maLP = lp.maLP
LEFT JOIN TT tt ON hd.maHD = tt.maHD;

-- VIEW: PHÒNG TRỐNG
CREATE VIEW v_PhongTrong AS
SELECT 
    p.maP,
    p.soP,
    p.tang,
    lp.tenLP AS loaiPhong,
    lp.gia,
    lp.sucChua,
    ks.tenKS AS khachSan
FROM P p
JOIN LP lp ON p.maLP = lp.maLP
JOIN KS ks ON p.maKS = ks.maKS
WHERE p.trangThaiP = N'Trống';

-- VIEW: THỐNG KÊ DỊCH VỤ
CREATE VIEW v_ThongKeDV AS
SELECT 
    dp.maDP,
    dp.maDPHienThi,
    kh.tenKH AS tenKhachHang,
    p.soP AS soPhong,
    dp.soBoGiat,
    dp.soNgayWifi,
    dp.soLuotSpa,
    dp.tongTienDV
FROM DP dp
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN P p ON dp.maP = p.maP
WHERE dp.tongTienDV > 0;

-- =====================================================
-- TẠO STORED PROCEDURE
-- =====================================================

DELIMITER //

-- SP 1: TẠO ĐẶT PHÒNG
CREATE PROCEDURE sp_TaoDP(
    p_maDPHienThi VARCHAR(20),
    p_ngayNhan DATE,
    p_ngayTra DATE,
    p_soKhach INT,
    p_maKH INT,
    p_maP INT
)
BEGIN
    INSERT INTO DP (maDPHienThi, ngayNhan, ngayTra, soKhach, trangThai, maKH, maP)
    VALUES (p_maDPHienThi, p_ngayNhan, p_ngayTra, p_soKhach, 'Pending', p_maKH, p_maP);
    SELECT LAST_INSERT_ID() AS maDPMoi;
END //

-- SP 2: CHECK-IN
CREATE PROCEDURE sp_CheckIn(p_maDP INT)
BEGIN
    START TRANSACTION;
        UPDATE DP SET trangThai = 'CheckedIn' WHERE maDP = p_maDP;
        UPDATE P SET trangThaiP = N'Đang dùng' WHERE maP = (SELECT maP FROM DP WHERE maDP = p_maDP);
    COMMIT;
END //

-- SP 3: CHECK-OUT
CREATE PROCEDURE sp_CheckOut(p_maDP INT)
BEGIN
    START TRANSACTION;
        UPDATE DP SET trangThai = 'CheckedOut' WHERE maDP = p_maDP;
        UPDATE P SET trangThaiP = N'Đang dọn' WHERE maP = (SELECT maP FROM DP WHERE maDP = p_maDP);
    COMMIT;
END //

-- SP 4: THÊM DỊCH VỤ
CREATE PROCEDURE sp_ThemDV(
    p_maDP INT,
    p_loaiDV NVARCHAR(20),
    p_soLuong INT
)
BEGIN
    DECLARE v_giaGiat INT DEFAULT 50000;
    DECLARE v_giaWifi INT DEFAULT 30000;
    DECLARE v_giaSpa INT DEFAULT 200000;
    DECLARE v_tienDV DECIMAL(18,2) DEFAULT 0;
    
    IF p_loaiDV = 'Giat' THEN
        UPDATE DP SET soBoGiat = soBoGiat + p_soLuong WHERE maDP = p_maDP;
        SET v_tienDV = p_soLuong * v_giaGiat;
    ELSEIF p_loaiDV = 'Wifi' THEN
        UPDATE DP SET soNgayWifi = soNgayWifi + p_soLuong WHERE maDP = p_maDP;
        SET v_tienDV = p_soLuong * v_giaWifi;
    ELSEIF p_loaiDV = 'Spa' THEN
        UPDATE DP SET soLuotSpa = soLuotSpa + p_soLuong WHERE maDP = p_maDP;
        SET v_tienDV = p_soLuong * v_giaSpa;
    END IF;
    
    UPDATE DP SET tongTienDV = tongTienDV + v_tienDV WHERE maDP = p_maDP;
END //

-- SP 5: TẠO HÓA ĐƠN
CREATE PROCEDURE sp_TaoHD(p_maDP INT)
BEGIN
    DECLARE v_tienP DECIMAL(18,2);
    DECLARE v_tienDV DECIMAL(18,2);
    DECLARE v_soDem INT;
    DECLARE v_giaPhong DECIMAL(18,2);
    DECLARE v_tongTien DECIMAL(18,2);
    
    SELECT DATEDIFF(ngayTra, ngayNhan) INTO v_soDem FROM DP WHERE maDP = p_maDP;
    SELECT lp.gia INTO v_giaPhong
    FROM DP dp
    JOIN P p ON dp.maP = p.maP
    JOIN LP lp ON p.maLP = lp.maLP
    WHERE dp.maDP = p_maDP;
    
    SET v_tienP = v_soDem * v_giaPhong;
    SELECT tongTienDV INTO v_tienDV FROM DP WHERE maDP = p_maDP;
    SET v_tongTien = v_tienP + v_tienDV;
    
    INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, tongTien, ttThanhToan)
    VALUES (p_maDP, CURRENT_DATE, v_tienP, v_tienDV, v_tongTien, 'Pending');
    
    SELECT LAST_INSERT_ID() AS maHDMoi;
END //

-- SP 6: THANH TOÁN
CREATE PROCEDURE sp_ThanhToan(
    p_maHD INT,
    p_hinhThuc NVARCHAR(30),
    p_soTien DECIMAL(18,2)
)
BEGIN
    DECLARE v_maDP INT;
    START TRANSACTION;
        INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT)
        VALUES (p_maHD, p_hinhThuc, p_soTien, CURRENT_DATE);
        UPDATE HD SET ttThanhToan = 'Paid' WHERE maHD = p_maHD;
        SELECT maDP INTO v_maDP FROM HD WHERE maHD = p_maHD;
        UPDATE P SET trangThaiP = N'Trống' WHERE maP = (SELECT maP FROM DP WHERE maDP = v_maDP);
    COMMIT;
END //

DELIMITER ;

-- =====================================================
-- TẠO TRIGGER
-- =====================================================

DELIMITER //

CREATE TRIGGER trg_TinhTongDV
BEFORE UPDATE ON DP
FOR EACH ROW
BEGIN
    IF NEW.soBoGiat <> OLD.soBoGiat 
       OR NEW.soNgayWifi <> OLD.soNgayWifi 
       OR NEW.soLuotSpa <> OLD.soLuotSpa THEN
        SET NEW.tongTienDV = (NEW.soBoGiat * 50000) + (NEW.soNgayWifi * 30000) + (NEW.soLuotSpa * 200000);
    END IF;
END //

CREATE TRIGGER trg_KiemTraNgayDP
BEFORE INSERT ON DP
FOR EACH ROW
BEGIN
    IF NEW.ngayNhan >= NEW.ngayTra THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ngày nhận phòng phải trước ngày trả phòng!';
    END IF;
    IF NEW.ngayNhan < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Ngày nhận phòng không được nhỏ hơn ngày hiện tại!';
    END IF;
END //

DELIMITER ;

-- =====================================================
-- KIỂM TRA DỮ LIỆU (CÁC LỆNH XEM)
-- =====================================================
SELECT * FROM v_DP_ChiTiet;
SELECT * FROM v_HD_ChiTiet;
SELECT * FROM v_PhongTrong;
SELECT * FROM v_ThongKeDV;
SELECT SUM(tongTien) AS TongDoanhThu FROM HD WHERE ttThanhToan = 'Paid';
-- ============================================================
-- THÊM KHÁCH HÀNG MỚI (KHACH)
-- ============================================================
INSERT INTO KHACH (tenKH, cmnd, sdt, email, diemTL) VALUES
(N'Ngô Thị Thanh', '1234567890', '0909123001', 'thanh.ngo@email.com', 50),
(N'Hoàng Văn Minh', '2345678901', '0918123456', 'minh.hoang@email.com', 120),
(N'Trần Thị Thu', '3456789012', '0939456789', 'thu.tran@email.com', 0),
(N'Đỗ Văn Long', '4567890123', '0978123456', 'long.do@email.com', 200),
(N'Bùi Thị Ngọc', '5678901234', '0988123456', 'ngoc.bui@email.com', 30),
(N'Lê Văn Phúc', '6789012345', '0919234567', 'phuc.le@email.com', 80),
(N'Phạm Thị Yến', '7890123456', '0909345678', 'yen.pham@email.com', 10),
(N'Vũ Văn Khánh', '8901234567', '0978456789', 'khanh.vu@email.com', 150),
(N'Đặng Thị Hoa', '9012345678', '0919567890', 'hoa.dang@email.com', 0),
(N'Lý Văn Hùng', '0123456790', '0909678901', 'hung.ly@email.com', 60),
(N'Mai Thị Lan', '1123456791', '0939789012', 'lan.mai@email.com', 40),
(N'Trương Văn Tài', '2123456792', '0978890123', 'tai.truong@email.com', 90),
(N'Võ Thị Tuyết', '3123456793', '0909901234', 'tuyet.vo@email.com', 20),
(N'Hồ Văn Nam', '4123456794', '0919012345', 'nam.ho@email.com', 110),
(N'Đinh Thị Hằng', '5123456795', '0939123456', 'hang.dinh@email.com', 70);

-- ============================================================
-- THÊM PHÒNG MỚI (để có thêm lựa chọn đặt phòng)
-- ============================================================
INSERT INTO P (soP, tang, trangThaiP, maLP, maKS) VALUES
('505', 5, N'Trống', 1, 1),
('506', 5, N'Trống', 1, 1),
('507', 5, N'Trống', 2, 1),
('508', 5, N'Trống', 2, 1),
('509', 5, N'Trống', 3, 1),
('510', 5, N'Trống', 3, 1),
('601', 6, N'Trống', 1, 2),
('602', 6, N'Trống', 1, 2),
('603', 6, N'Trống', 2, 2),
('604', 6, N'Trống', 2, 2),
('605', 6, N'Trống', 3, 2),
('701', 7, N'Trống', 1, 3),
('702', 7, N'Trống', 1, 3),
('703', 7, N'Trống', 2, 3),
('704', 7, N'Trống', 2, 3),
('705', 7, N'Trống', 3, 3);

-- ============================================================
-- THÊM CÁC ĐẶT PHÒNG MỚI (DP) với nhiều trạng thái
-- ============================================================
INSERT INTO DP (maDPHienThi, ngayNhan, ngayTra, soKhach, trangThai, maKH, maP, soBoGiat, soNgayWifi, soLuotSpa, tongTienDV) VALUES
-- (maKH tương ứng với thứ tự insert bên trên)
-- 1. Ngô Thị Thanh – đặt phòng đã nhận (CheckedIn)
('LUX-2026-005', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, N'CheckedIn', 6, 7, 1, 1, 0, 80000),
-- 2. Hoàng Văn Minh – đặt phòng đã trả (CheckedOut)
('LUX-2026-006', DATE_SUB(CURDATE(), INTERVAL 4 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, N'CheckedOut', 7, 8, 0, 2, 1, 460000),
-- 3. Trần Thị Thu – đặt phòng chờ xác nhận (Pending)
('LUX-2026-007', DATE_ADD(CURDATE(), INTERVAL 3 DAY), DATE_ADD(CURDATE(), INTERVAL 5 DAY), 2, N'Pending', 8, 9, 0, 0, 0, 0),
-- 4. Đỗ Văn Long – đã xác nhận nhưng chưa nhận (Confirmed)
('LUX-2026-008', DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 4 DAY), 3, N'Confirmed', 9, 10, 2, 1, 1, 330000),
-- 5. Bùi Thị Ngọc – đang ở (CheckedIn)
('LUX-2026-009', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 2, N'CheckedIn', 10, 11, 0, 3, 0, 90000),
-- 6. Lê Văn Phúc – đặt phòng đã trả
('LUX-2026-010', DATE_SUB(CURDATE(), INTERVAL 6 DAY), DATE_SUB(CURDATE(), INTERVAL 3 DAY), 1, N'CheckedOut', 11, 12, 3, 0, 0, 150000),
-- 7. Phạm Thị Yến – đặt phòng chờ xác nhận
('LUX-2026-011', DATE_ADD(CURDATE(), INTERVAL 5 DAY), DATE_ADD(CURDATE(), INTERVAL 7 DAY), 2, N'Pending', 12, 13, 0, 1, 0, 30000),
-- 8. Vũ Văn Khánh – đã xác nhận
('LUX-2026-012', DATE_ADD(CURDATE(), INTERVAL 2 DAY), DATE_ADD(CURDATE(), INTERVAL 6 DAY), 4, N'Confirmed', 13, 14, 1, 2, 1, 310000),
-- 9. Đặng Thị Hoa – đang ở
('LUX-2026-013', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 1 DAY), 2, N'CheckedIn', 14, 15, 0, 0, 0, 0),
-- 10. Lý Văn Hùng – đã trả phòng
('LUX-2026-014', DATE_SUB(CURDATE(), INTERVAL 2 DAY), DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1, N'CheckedOut', 15, 16, 2, 1, 0, 130000),
-- 11. Mai Thị Lan – đặt phòng mới (Pending)
('LUX-2026-015', DATE_ADD(CURDATE(), INTERVAL 4 DAY), DATE_ADD(CURDATE(), INTERVAL 6 DAY), 2, N'Pending', 16, 17, 0, 0, 0, 0),
-- 12. Trương Văn Tài – đã xác nhận
('LUX-2026-016', DATE_ADD(CURDATE(), INTERVAL 1 DAY), DATE_ADD(CURDATE(), INTERVAL 3 DAY), 2, N'Confirmed', 17, 18, 1, 1, 0, 80000),
-- 13. Võ Thị Tuyết – đang ở
('LUX-2026-017', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 2 DAY), 2, N'CheckedIn', 18, 19, 0, 2, 1, 260000),
-- 14. Hồ Văn Nam – đã trả phòng
('LUX-2026-018', DATE_SUB(CURDATE(), INTERVAL 5 DAY), DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1, N'CheckedOut', 19, 20, 4, 0, 0, 200000),
-- 15. Đinh Thị Hằng – đang ở
('LUX-2026-019', CURDATE(), DATE_ADD(CURDATE(), INTERVAL 4 DAY), 2, N'CheckedIn', 20, 21, 2, 3, 0, 190000);

-- ============================================================
-- THÊM HÓA ĐƠN VÀ THANH TOÁN CHO CÁC ĐẶT PHÒNG ĐÃ TRẢ
-- ============================================================
-- Lấy mã DP của các đặt phòng đã trả (CheckedOut)
-- Giả sử các maDP tương ứng là: 6, 10, 14, 18 (tự điều chỉnh theo thứ tự thực tế)
-- Bạn có thể kiểm tra maDP thực tế bằng SELECT maDP, maDPHienThi FROM DP WHERE trangThai = 'CheckedOut';
-- Sau đó thay các giá trị maDP dưới đây cho đúng.

-- Chèn hóa đơn cho các đặt phòng đã trả
INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, giamGia, tongTien, ttThanhToan) VALUES
-- (maDP = 6, ngày xuất = ngày trả)
(6, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 1200000, 460000, 0, 1660000, N'Paid'),
-- (maDP = 10, ngày xuất = ngày trả)
(10, DATE_SUB(CURDATE(), INTERVAL 3 DAY), 2400000, 150000, 50000, 2500000, N'Paid'),
-- (maDP = 14, ngày xuất = ngày trả)
(14, DATE_SUB(CURDATE(), INTERVAL 1 DAY), 800000, 130000, 0, 930000, N'Paid'),
-- (maDP = 18, ngày xuất = ngày trả)
(18, DATE_SUB(CURDATE(), INTERVAL 2 DAY), 1600000, 200000, 0, 1800000, N'Paid');

-- Chèn thanh toán cho các hóa đơn trên (maHD tương ứng)
INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT, ghiChu) VALUES
(3, N'Cash', 1660000, DATE_SUB(CURDATE(), INTERVAL 1 DAY), N'Thanh toán tiền mặt'),
(4, N'Card', 2500000, DATE_SUB(CURDATE(), INTERVAL 3 DAY), N'Thanh toán thẻ tín dụng'),
(5, N'Cash', 930000, DATE_SUB(CURDATE(), INTERVAL 1 DAY), N'Thanh toán tiền mặt'),
(6, N'BankTransfer', 1800000, DATE_SUB(CURDATE(), INTERVAL 2 DAY), N'Chuyển khoản ngân hàng');
