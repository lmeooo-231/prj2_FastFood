create database QLBanDoAn;

use QLBanDoAn;

-- Bảng Khách hàng
CREATE TABLE KhachHang (
    MaKH INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    SDT NVARCHAR(15),
    MatKhau NVARCHAR(255) NOT NULL,
    DiaChiMacDinh NVARCHAR(255)
);

-- Bảng Danh mục sản phẩm
CREATE TABLE DanhMuc (
    MaDM INT PRIMARY KEY IDENTITY(1,1),
    TenDM NVARCHAR(100) NOT NULL
);

-- Bảng Sản phẩm
CREATE TABLE SanPham (
    MaSP INT PRIMARY KEY IDENTITY(1,1),
    TenSP NVARCHAR(100) NOT NULL,
    MoTa NVARCHAR(MAX),
    Gia DECIMAL(12,2) NOT NULL,
    Anh NVARCHAR(255),
    MaDM INT,
    FOREIGN KEY (MaDM) REFERENCES DanhMuc(MaDM)
);

-- Bảng Giỏ hàng
CREATE TABLE GioHang (
    MaGH INT PRIMARY KEY IDENTITY(1,1),
    MaKH INT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng Chi tiết giỏ hàng
CREATE TABLE ChiTietGioHang (
    MaGH INT,
    MaSP INT,
    SoLuong INT CHECK (SoLuong > 0),
    PRIMARY KEY (MaGH, MaSP),
    FOREIGN KEY (MaGH) REFERENCES GioHang(MaGH),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Bảng Đơn hàng
CREATE TABLE DonHang (
    MaDH INT PRIMARY KEY IDENTITY(1,1),
    NgayDat DATETIME DEFAULT GETDATE(),
    TrangThai NVARCHAR(20) CHECK (TrangThai IN (N'Chờ xác nhận',N'Đang giao',N'Đã giao',N'Hủy')),
    PhuongThucTT NVARCHAR(20) CHECK (PhuongThucTT IN (N'COD',N'Thẻ',N'Ví điện tử')),
    TongTien DECIMAL(12,2) NOT NULL,
    MaKH INT,
    FOREIGN KEY (MaKH) REFERENCES KhachHang(MaKH)
);

-- Bảng Chi tiết đơn hàng
CREATE TABLE ChiTietDonHang (
    MaDH INT,
    MaSP INT,
    SoLuong INT CHECK (SoLuong > 0),
    DonGia DECIMAL(12,2) NOT NULL,
    PRIMARY KEY (MaDH, MaSP),
    FOREIGN KEY (MaDH) REFERENCES DonHang(MaDH),
    FOREIGN KEY (MaSP) REFERENCES SanPham(MaSP)
);

-- Bảng Nhân viên
CREATE TABLE NhanVien (
    MaNV INT PRIMARY KEY IDENTITY(1,1),
    HoTen NVARCHAR(100) NOT NULL,
    Email NVARCHAR(100) UNIQUE NOT NULL,
    SDT NVARCHAR(15),
    VaiTro NVARCHAR(20) CHECK (VaiTro IN (N'Quản lý',N'Giao hàng',N'Admin'))
);

-- Thêm dữ liệu Khách hàng
INSERT INTO KhachHang (HoTen, Email, SDT, MatKhau, DiaChiMacDinh)
VALUES 
(N'Nguyễn Văn A', 'vana@example.com', '0912345678', '123456', N'Hà Nội'),
(N'Trần Thị B', 'thib@example.com', '0987654321', 'abcdef', N'Hồ Chí Minh'),
(N'Lê Văn C', 'vanc@example.com', '0909090909', 'qwerty', N'Đà Nẵng');

-- Thêm dữ liệu Danh mục
INSERT INTO DanhMuc (TenDM)
VALUES 
(N'Đồ ăn nhanh'),
(N'Nước uống'),
(N'Đồ tráng miệng');

-- Thêm dữ liệu Sản phẩm
INSERT INTO SanPham (TenSP, MoTa, Gia, Anh, MaDM)
VALUES 
(N'Hamburger', N'Hamburger bò phô mai', 45000, 'hamburger.jpg', 1),
(N'Pizza phô mai', N'Pizza Ý nhiều phô mai', 120000, 'pizza.jpg', 1),
(N'Coca Cola', N'Nước ngọt có gas', 15000, 'coca.jpg', 2),
(N'Trà sữa trân châu', N'Trà sữa truyền thống', 35000, 'trasua.jpg', 2),
(N'Bánh Flan', N'Bánh flan caramel mềm mịn', 20000, 'flan.jpg', 3);

-- Thêm dữ liệu Giỏ hàng
INSERT INTO GioHang (MaKH)
VALUES (1), (2), (3);

-- Thêm dữ liệu Chi tiết giỏ hàng
INSERT INTO ChiTietGioHang (MaGH, MaSP, SoLuong)
VALUES 
(1, 1, 2),  -- KH1 mua 2 Hamburger
(1, 3, 1),  -- KH1 mua 1 Coca
(2, 2, 1),  -- KH2 mua 1 Pizza
(3, 5, 3);  -- KH3 mua 3 Bánh Flan

-- Thêm dữ liệu Đơn hàng
INSERT INTO DonHang (NgayDat, TrangThai, PhuongThucTT, TongTien, MaKH)
VALUES 
(GETDATE(), N'Chờ xác nhận', N'COD', 105000, 1),
(GETDATE(), N'Đang giao', N'Thẻ', 120000, 2),
(GETDATE(), N'Đã giao', N'Ví điện tử', 60000, 3);

-- Thêm dữ liệu Chi tiết đơn hàng
INSERT INTO ChiTietDonHang (MaDH, MaSP, SoLuong, DonGia)
VALUES 
(1, 1, 2, 45000),  -- 2 Hamburger
(1, 3, 1, 15000),  -- 1 Coca
(2, 2, 1, 120000), -- 1 Pizza
(3, 5, 3, 20000);  -- 3 Flan

-- Thêm dữ liệu Nhân viên
INSERT INTO NhanVien (HoTen, Email, SDT, VaiTro)
VALUES 
(N'Nguyễn Văn Quản', 'quanly@example.com', '0911222333', N'Quản lý'),
(N'Phạm Thị Giao', 'giaohang@example.com', '0922333444', N'Giao hàng'),
(N'Lê Văn Admin', 'admin@example.com', '0933444555', N'Admin');
