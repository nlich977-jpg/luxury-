
-- XÓA DATABASE CŨ NẾU CÓ (TÙY CHỌN)

DROP DATABASE IF EXISTS LuxuryHotel;
CREATE DATABASE LuxuryHotel;
USE LuxuryHotel;


-- 1. BẢNG KHÁCH SẠN (KS)

CREATE TABLE KS (
    maKS INT AUTO_INCREMENT PRIMARY KEY,
    tenKS NVARCHAR(100) NOT NULL,
    diaChi NVARCHAR(200) NOT NULL,
    sdtKS VARCHAR(20) NOT NULL,
    ghiChu NVARCHAR(500) NULL
);


-- 2. BẢNG LOẠI PHÒNG (LP)

CREATE TABLE LP (
    maLP INT AUTO_INCREMENT PRIMARY KEY,
    tenLP NVARCHAR(50) NOT NULL,
    gia DECIMAL(18,2) NOT NULL,
    sucChua INT NOT NULL,
    moTa NVARCHAR(200) NULL
);


-- 3. BẢNG PHÒNG (P)

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


-- 4. BẢNG KHÁCH HÀNG (KHACH)

CREATE TABLE KHACH (
    maKH INT AUTO_INCREMENT PRIMARY KEY,
    tenKH NVARCHAR(100) NOT NULL,
    cmnd VARCHAR(20) NOT NULL UNIQUE,
    sdt VARCHAR(20) NOT NULL,
    email VARCHAR(100) NULL,
    diemTL INT DEFAULT 0,
    ghiChu NVARCHAR(200) NULL
);


-- 5. BẢNG ĐẶT PHÒNG (DP)
CREATE TABLE DP (
    maDP INT AUTO_INCREMENT PRIMARY KEY,
    maDPHienThi VARCHAR(20) NOT NULL UNIQUE,
    ngayNhan DATE NOT NULL,
    ngayTra DATE NOT NULL,
    soKhach INT NOT NULL,
    trangThai NVARCHAR(20) DEFAULT 'Pending',
    maKH INT NOT NULL,
    maP  INT NOT NULL,
    soBoGiat INT DEFAULT 0,
    soNgayWifi INT DEFAULT 0,
    soLuotSpa INT DEFAULT 0,
    tongTienDV DECIMAL(18,2) DEFAULT 0,
    FOREIGN KEY (maKH) REFERENCES KHACH(maKH),
    FOREIGN KEY (maP) REFERENCES P(maP)
);


-- 6. BẢNG NHÂN VIÊN (NV)

CREATE TABLE NV (
    maNV INT AUTO_INCREMENT PRIMARY KEY,
    tenNV NVARCHAR(100) NOT NULL,
    chucVu NVARCHAR(50) NOT NULL,
    sdtNV VARCHAR(20) NOT NULL,
    maKS INT NOT NULL,
    FOREIGN KEY (maKS) REFERENCES KS(maKS)
);


-- 7. BẢNG HÓA ĐƠN (HD)

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


-- 8. BẢNG THANH TOÁN (TT)

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
-- 1. CHÈN KHÁCH SẠN (KS)
-- =====================================================
INSERT INTO KS (tenKS, diaChi, sdtKS) VALUES
(N'Luxury Hotel Sài Gòn', N'123 Nguyễn Huệ, Quận 1, TP.HCM', '0281234567'),
(N'Luxury Hotel Hà Nội', N'45 Tràng Tiền, Hoàn Kiếm, Hà Nội', '0241234567'),
(N'Luxury Hotel Đà Nẵng', N'67 Võ Nguyên Giáp, Ngũ Hành Sơn, Đà Nẵng', '02361234567');


-- 2. CHÈN LOẠI PHÒNG (LP)

INSERT INTO LP (tenLP, gia, sucChua, moTa) VALUES
(N'Suite', 1200000, 2, N'Phòng Suite cao cấp view biển'),
(N'Deluxe', 800000, 2, N'Phòng Deluxe tiện nghi'),
(N'Premier', 1500000, 4, N'Phòng Premier sang trọng');


-- 3. CHÈN PHÒNG (P)

INSERT INTO P (soP, tang, trangThaiP, maLP, maKS) VALUES
('501', 5, N'Trống', 1, 1),
('502', 5, N'Trống', 1, 1),
('503', 5, N'Đang dùng', 2, 1),
('401', 4, N'Trống', 2, 2),
('402', 4, N'Trống', 2, 2),
('301', 3, N'Trống', 3, 3);


-- 4. CHÈN KHÁCH HÀNG (KHACH)

INSERT INTO KHACH (tenKH, cmnd, sdt, email, diemTL) VALUES
(N'Nguyễn Văn An', '0123456789', '0909123456', 'an.nguyen@email.com', 100),
(N'Trần Thị Bình', '9876543210', '0912987654', 'binh.tran@email.com', 250),
(N'Lê Văn Cường', '9988776655', '0933456789', 'cuong.le@email.com', 50),
(N'Phạm Thị Dung', '1122334455', '0909876543', 'dung.pham@email.com', 0);


--chèn đặt phòng (DP)
INSERT INTO DP (maDPHienThi, ngayNhan, ngayTra, soKhach, trangThai, maKH, maP, soBoGiat, soNgayWifi, soLuotSpa, tongTienDV) VALUES
('LUX-2026-001', '2026-06-01', '2026-06-06', 2, N'CheckedOut', 1, 1, 3, 2, 1, 410000),
('LUX-2026-002', '2026-06-05', '2026-06-08', 1, N'CheckedIn', 2, 2, 0, 3, 0, 90000),
('LUX-2026-003', '2026-06-10', '2026-06-12', 2, N'Pending', 3, 3, 2, 0, 1, 300000),
('LUX-2026-004', '2026-06-15', '2026-06-18', 3, N'Confirmed', 4, 4, 0, 0, 0, 0);


-- 6. CHÈN NHÂN VIÊN (NV)

INSERT INTO NV (tenNV, chucVu, sdtNV, maKS) VALUES
(N'Nguyễn Thị Mai', N'Receptionist', '0909111222', 1),
(N'Trần Văn Nam', N'Cashier', '0909333444', 1),
(N'Lê Thị Hoa', N'Housekeeping', '0909555666', 1),
(N'Phạm Văn Hùng', N'Receptionist', '0911777888', 2),
(N'Hoàng Thị Lan', N'Cashier', '0911999000', 2);


-- 7. CHÈN HÓA ĐƠN (HD)

INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, giamGia, tongTien, ttThanhToan) VALUES
(1, '2026-06-06', 6000000, 410000, 0, 6410000, N'Paid'),
(2, '2026-06-08', 2400000, 90000, 50000, 2440000, N'Pending');


-- 8. CHÈN THANH TOÁN (TT)

INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT, ghiChu) VALUES
(1, N'Cash', 6410000, '2026-06-06', N'Thanh toán bằng tiền mặt'),
(2, N'Card', 2440000, '2026-06-08', N'Thanh toán bằng thẻ tín dụng');

-- VIEW 1: DS ĐẶT PHÒNG ĐẦY ĐỦ

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


-- VIEW 2: HÓA ĐƠN ĐẦY ĐỦ

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


--   PHÒNG ĐANG TRỐNG

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

--: THỐNG KÊ DỊCH VỤ THEO PHÒNG

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

-- SP 1: TẠO ĐẶT PHÒNG MỚI

DELIMITER //
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
DELIMITER ;


-- SP 2: XÁC NHẬN NHẬN PHÒNG (CHECK-IN)
DELIMITER //
CREATE PROCEDURE sp_CheckIn(
    p_maDP INT
)
BEGIN
    START TRANSACTION;
        UPDATE DP SET trangThai = 'CheckedIn' WHERE maDP = p_maDP;
        UPDATE P 
        SET trangThaiP = N'Đang dùng' 
        WHERE maP = (SELECT maP FROM DP WHERE maDP = p_maDP);
    COMMIT;
END //
DELIMITER ;


-- SP 3: XÁC NHẬN TRẢ PHÒNG (CHECK-OUT)
DELIMITER //
CREATE PROCEDURE sp_CheckOut(
    p_maDP INT
)
BEGIN
    START TRANSACTION;
        UPDATE DP SET trangThai = 'CheckedOut' WHERE maDP = p_maDP;
        UPDATE P 
        SET trangThaiP = N'Đang dọn' 
        WHERE maP = (SELECT maP FROM DP WHERE maDP = p_maDP);
    COMMIT;
END //
DELIMITER ;


-- SP 4: THÊM DỊCH VỤ CHO ĐẶT PHÒNG

DELIMITER //
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
    
    UPDATE DP 
    SET tongTienDV = tongTienDV + v_tienDV 
    WHERE maDP = p_maDP;
END //
DELIMITER ;


-- SP 5: TẠO HÓA ĐƠN
DELIMITER //
CREATE PROCEDURE sp_TaoHD(
    p_maDP INT
)
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
DELIMITER ;


-- SP 6: THANH TOÁN HÓA ĐƠN

DELIMITER //
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
        
        UPDATE P 
        SET trangThaiP = N'Trống' 
        WHERE maP = (SELECT maP FROM DP WHERE maDP = v_maDP);
    COMMIT;
END //
DELIMITER ;


-- SP 7: LẤY DANH SÁCH PHÒNG TRỐNG

DELIMITER //
CREATE PROCEDURE sp_PhongTrong(
    p_maKS INT,
    p_ngayNhan DATE,
    p_ngayTra DATE
)
BEGIN
    SELECT 
        p.maP,
        p.soP,
        lp.tenLP AS loaiPhong,
        lp.gia
    FROM P p
    JOIN LP lp ON p.maLP = lp.maLP
    WHERE p.maKS = p_maKS
    AND p.trangThaiP = N'Trống'
    AND p.maP NOT IN (
        SELECT maP FROM DP 
        WHERE (ngayNhan < p_ngayTra AND ngayTra > p_ngayNhan)
        AND trangThai IN ('Confirmed', 'CheckedIn')
    );
END //
DELIMITER ;

-- TRIGGER 1: TỰ ĐỘNG TÍNH TỔNG TIỀN DỊCH VỤ
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
DELIMITER ;


-- TRIGGER 2: KIỂM TRA NGÀY NHẬN/TRẢ TRƯỚC KHI THÊM

DELIMITER //
CREATE TRIGGER trg_KiemTraNgayDP
BEFORE INSERT ON DP
FOR EACH ROW
BEGIN
    IF NEW.ngayNhan >= NEW.ngayTra THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ngày nhận phòng phải trước ngày trả phòng!';
    END IF;
    
    IF NEW.ngayNhan < CURRENT_DATE THEN
        SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Ngày nhận phòng không được nhỏ hơn ngày hiện tại!';
    END IF;
END //
DELIMITER ;


-- KIỂM TRA DỮ LIỆU


-- 1. Xem danh sách đặt phòng
SELECT * FROM v_DP_ChiTiet;

-- 2. Xem danh sách hóa đơn
SELECT * FROM v_HD_ChiTiet;

-- 3. Xem phòng đang trống
SELECT * FROM v_PhongTrong;

-- 4. Xem thống kê dịch vụ
SELECT * FROM v_ThongKeDV;

-- 5. Tổng doanh thu
SELECT SUM(tongTien) AS TongDoanhThu FROM HD WHERE ttThanhToan = 'Paid';

-- 6. Thống kê dịch vụ bán chạy
SELECT 'Giặt ủi' AS TenDV,
    SUM(soBoGiat) AS TongSoLuong,
    SUM(soBoGiat * 50000) AS DoanhThu
FROM DP
UNION
SELECT 'Wifi' AS TenDV,
    SUM(soNgayWifi) AS TongSoLuong,
    SUM(soNgayWifi * 30000) AS DoanhThu
FROM DP
UNION
SELECT 'Spa' AS TenDV,
    SUM(soLuotSpa) AS TongSoLuong,
    SUM(soLuotSpa * 200000) AS DoanhThu
FROM DP;
-- Thống kê số lượng đặt phòng theo trạng thái
SELECT 
    trangThai,
    COUNT(*) AS SoLuong
FROM DP
GROUP BY trangThai;

-- 8. Tìm khách hàng theo CMND
SELECT * FROM KHACH WHERE cmnd = '0123456789';
INSERT INTO KS (tenKS, diaChi, sdtKS) VALUES
(N'Luxury Hotel Sài Gòn', N'123 Nguyễn Huệ, Quận 1, TP.HCM', '0281234567'),
(N'Luxury Hotel Hà Nội', N'45 Tràng Tiền, Hoàn Kiếm, Hà Nội', '0241234567'),
(N'Luxury Hotel Đà Nẵng', N'67 Võ Nguyên Giáp, Ngũ Hành Sơn, Đà Nẵng', '02361234567');

INSERT INTO LP (tenLP, gia, sucChua, moTa) VALUES
(N'Suite', 1200000, 2, N'Phòng Suite cao cấp view biển'),
(N'Deluxe', 800000, 2, N'Phòng Deluxe tiện nghi'),
(N'Premier', 1500000, 4, N'Phòng Premier sang trọng');

INSERT INTO P (soP, tang, trangThaiP, maLP, maKS) VALUES
('460', 5, N'Trống', 1, 1),
('356', 5, N'Trống', 1, 1),
('337', 5, N'Đang dùng', 2, 1),
('431', 4, N'Trống', 2, 2),
('437', 4, N'Trống', 2, 2),
('303', 3, N'Trống', 3, 3);

INSERT INTO KHACH (tenKH, cmnd, sdt, email, diemTL) VALUES
(N'Nguyễn Văn An', '0123456782', '8909123456', 'an.nguyen@email.com', 100),
(N'Trần Thị Bình', '8976543210', '0612987654', 'binh.tran@email.com', 250),
(N'Lê Văn Cường', '9788876655', '0983456789', 'cuong.le@email.com', 50),
(N'Phạm Thị Dung', '1182334485', '0909876543', 'dung.pham@email.com', 0);



INSERT INTO NV (tenNV, chucVu, sdtNV, maKS) VALUES
(N'Nguyễn Thị Mai', N'Receptionist', '0909111222', 1),
(N'Trần Văn Nam', N'Cashier', '0909333444', 1),
(N'Lê Thị Hoa', N'Housekeeping', '0909555666', 1),
(N'Phạm Văn Hùng', N'Receptionist', '0911777888', 2),
(N'Hoàng Thị Lan', N'Cashier', '0911999000', 2);

INSERT INTO HD (maDP, ngayXuat, tienP, tienDV, giamGia, tongTien, ttThanhToan) VALUES
(1, '2026-06-06', 6000000, 410000, 0, 6410000, N'Paid'),
(2, '2026-06-08', 2400000, 90000, 50000, 2440000, N'Pending');

INSERT INTO TT (maHD, hinhThuc, soTien, ngayTT, ghiChu) VALUES
(1, N'Cash', 6410000, '2026-06-06', N'Thanh toán bằng tiền mặt'),
(2, N'Card', 2440000, '2026-06-08', N'Thanh toán bằng thẻ tín dụng');




SHOW COLUMNS FROM nv;

-- Tìm đặt phòng theo mã hiển thị (maDPHienThi)
USE luxuryhotel;
SELECT maDPHienThi FROM DP;
SELECT 
    dp.maDPHienThi AS MaDatPhong,
    kh.cmnd AS CMND,
    kh.tenKH AS TenKhachHang
FROM DP dp
JOIN KHACH kh ON dp.maKH = kh.maKH;
-- Tìm tất cả khách hàng có sử dụng ít nhất 1 dịch vụ (giặt, wifi hoặc spa)
SELECT 
    kh.tenKH AS TenKhachHang,
    kh.cmnd AS CMND,
    kh.sdt AS SoDienThoai,
    p.soP AS SoPhong,
    dp.soBoGiat AS SoBoGiat,
    dp.soNgayWifi AS SoNgayWifi,
    dp.soLuotSpa AS SoLuotSpa,
    dp.tongTienDV AS TongTienDichVu,
    dp.maDPHienThi AS MaDatPhong
FROM DP dp
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN P p ON dp.maP = p.maP
WHERE dp.soBoGiat > 0 
   OR dp.soNgayWifi > 0 
   OR dp.soLuotSpa > 0;
  
  SELECT * FROM NV;
  SELECT maNV, tenNV, chucVu, sdtNV AS MatKhau, maKS FROM NV;
  SELECT 
    p.soP AS SoPhong,
    p.tang AS Tang,
    lp.tenLP AS LoaiPhong,
    lp.gia AS GiaPhong,
    kh.tenKH AS TenKhachHang,
    kh.cmnd AS CMND,
    kh.sdt AS SoDienThoai,
    dp.ngayNhan AS NgayNhanPhong,
    dp.ngayTra AS NgayTraPhong,
    dp.soKhach AS SoLuongKhach,
    dp.maDPHienThi AS MaDatPhong
FROM P p
JOIN DP dp ON p.maP = dp.maP
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN LP lp ON p.maLP = lp.maLP
WHERE dp.trangThai = 'CheckedIn'
ORDER BY p.soP;
SELECT 
    p.soP AS SoPhong,
    lp.tenLP AS LoaiPhong,
    kh.tenKH AS TenKhachHang,
    kh.cmnd AS CMND,
    kh.sdt AS SoDienThoai,
    dp.ngayNhan AS NgayNhan,
    dp.ngayTra AS NgayTra,
    dp.trangThai AS TrangThai
FROM P p
JOIN DP dp ON p.maP = dp.maP
JOIN KHACH kh ON dp.maKH = kh.maKH
JOIN LP lp ON p.maLP = lp.maLP
WHERE dp.trangThai IN ('CheckedIn', 'Confirmed', 'Pending')
ORDER BY p.soP;