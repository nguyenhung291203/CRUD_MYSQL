create database Lab03;

USE Lab03;

create table Nhanvien(
	MaNV char(10) NOT NULL,
	Hoten varchar(50) NOT NULL,
	Ngaysinh date NOT NULL,
	MaP char(3) NOT NULL,
	CONSTRAINT pk_Nhanvien PRIMARY KEY(MaNV)
);

create table Phong(
	MaP char(3) NOT NULL,
	TenP varchar(50) NOT NULL,
	Diadiem varchar(100) NOT NULL,
	SoDT varchar(20) NOT NULL,
	CONSTRAINT pk_Phong PRIMARY KEY(MaP)
);

ALTER TABLE Nhanvien
ADD CONSTRAINT fk1_Nhanvien FOREIGN KEY(MaP) REFERENCES Phong(MaP);

create table Duan(
	MaDA char(6) NOT NULL,
	TenDA varchar(50) NOT NULL,
	Ngansach float NOT NULL,
	CONSTRAINT pk_Duan PRIMARY KEY(MaDA)
);

create table Thamgia(
	MaNV char(10) NOT NULL,
	MaDA char(6) NOT NULL,
	Sogio int NOT NULL,
	CONSTRAINT pk_Thamgia PRIMARY KEY(MaNV, MaDA),
	CONSTRAINT fk1_Thamgia FOREIGN KEY(MaNV) REFERENCES Nhanvien(MaNV),
	CONSTRAINT fk2_Thamgia FOREIGN KEY(MaDA) REFERENCES Duan(MaDA)
);

insert into Phong
values('P01', 'Phong Mo Hinh', 'Tang 5', '0987777777');
insert into Phong
values('P02', 'Phong Giao Dien', 'Tang 4', '0941111111');
insert into Phong
values('P03', 'Phong Kiem Thu', 'Tang 3', '0901234567');
insert into Phong
values('P04', 'Phong Thiet Ke', 'Tang 2', '0986663331');
insert into Phong
values('P05', 'NCKH', 'Tang 1', '0915671112');


insert into Nhanvien
values ('NV001', 'Teo', '1996-08-12', 'P01');
insert into Nhanvien
values ('NV002', 'Ty', '1997-07-12', 'P02');
insert into Nhanvien
values ('NV003', 'Binh', '1993-06-12', 'P03');
insert into Nhanvien
values ('NV004', 'Giai', '1994-01-12', 'P04');
insert into Nhanvien
values ('NV005', 'An', '1995-02-12', 'P05');
insert into Nhanvien
values ('NV006', 'Nga', '1995-03-12', 'P01');
insert into Nhanvien
values ('NV007', 'Lan', '1995-04-12', 'P02');
insert into Nhanvien
values ('NV008', 'Trong', '1997-05-22', 'P04');
insert into Nhanvien
values ('NV009', 'Phu', '1991-06-12', 'P01');
insert into Nhanvien
values ('NV010', 'Toan', '1994-03-21', 'P01');
insert into Nhanvien
values ('NV011', 'Ty', '1992-12-24', 'P05');

insert into Duan
values('DA0001', 'Quan ly dao tao', 20000000);
insert into Duan
values('DA0002', 'Thu thap du lieu', 80000);
insert into Duan
values('DA0003', 'Thu gom rac thai', 60000);
insert into Duan
values('DA0004', 'Dao tao tu xa', 3000000);
insert into Duan
values('DA0005', 'Mua ban but bi', 600000);

insert into Thamgia
values('NV001', 'DA0001', 50);
insert into Thamgia
values('NV009', 'DA0001', 14);
insert into Thamgia
values('NV006', 'DA0001', 14);
insert into Thamgia
values('NV001', 'DA0004', 20);
insert into Thamgia
values('NV005', 'DA0004', 3);
insert into Thamgia
values('NV009', 'DA0004', 7);
insert into Thamgia
values('NV002', 'DA0005', 10);
insert into Thamgia
values('NV007', 'DA0005', 10);
insert into Thamgia
values('NV008', 'DA0003', 20);




-- a. Đưa ra tên của các dự án có ngân sách nằm trong khoảng từ 50,000 đến 100,000
select * from Duan
where Ngansach between 50000 and 100000;


-- b. Đưa ra họ tên của các nhân viên có tham gia làm dự án “Quản lý đào tạo”
select Hoten from Nhanvien
join Thamgia on Nhanvien.MaNV = Thamgia.MaNV
join Duan on Thamgia.MaDA = Duan.MaDA
where TenDA = 'Quan ly dao tao';


-- c. Đưa ra mã số của các nhân viên tham gia cả hai dự án “Quản lý đào taọ” và “Đào tạo từ xa”
select T1.MaNV from (
select Thamgia.MaNV from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
where TenDA = 'Quan ly dao tao'
) T1
join (
select Thamgia.MaNV from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
where TenDA = 'Dao tao tu xa'
) T2 on T1.MaNV = T2.MaNV;


-- d. Đưa ra mã số của các nhân viên tham gia dự án “Quản lý đào tạo” nhưng không tham gia dự án “Đào tạo từ xa”
select Thamgia.MaNV from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
where TenDA = 'Quan ly dao tao' and Thamgia.MaNV not in (
select Thamgia.MaNV from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
where TenDA = 'Dao tao tu xa'
);

-- e. Đưa ra mã số của phòng không có nhân viên nào tham gia dự án
select MaP from Phong 
where MaP not in (
select distinct Phong.MaP from Nhanvien
join Phong on Nhanvien.MaP = Phong.MaP
join Thamgia on Thamgia.MaNV = Nhanvien.MaNV
);

-- f. Dự án nào có tất cả các nhân viên của phòng ‘NCKH’ tham gia?
select MaDA from Nhanvien
join Phong on Nhanvien.MaP = Phong.MaP and TenP = 'NCKH'
join Thamgia on Nhanvien.MaNV = Thamgia.MaNV
group by MaDA
having count(MaDA)=(
select count(Nhanvien.MaNV) from Nhanvien
join Phong on Nhanvien.MaP = Phong.MaP and TenP = 'NCKH'
join Thamgia on Thamgia.MaNV = Nhanvien.MaNV
group by Nhanvien.MaNV
);

-- g. Ngân sách trung bình của các dự án mà nhân viên có mã số NV001 tham gia là bao nhiêu?
select avg(Ngansach) from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA where Thamgia.MaNV = 'NV001';


-- h. Có bao nhiêu nhân viên tham gia dự án Quản lý đào tạo?
select count(*) from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA and Duan.TenDA = 'Quan ly dao tao';



-- i. Hãy đưa ra tên của các dự án mà số nhân viên tham gia dự án đó < 10
select TenDA,count(MaNV) from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
group by TenDA
having count(MaNV)<10;


-- j. Dự án nào có số nhân viên tham gia lớn nhất
select TenDA,count(MaNV) from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
group by TenDA
having count(TenDA) = (
select count(MaNV) from Thamgia
join Duan on Thamgia.MaDA = Duan.MaDA
group by TenDA
order by count(MaNV) desc
limit 1
);