create database Lab04;
USE Lab04;

CREATE TABLE sinhvien(
	mssv char(8) not null,
	hoten varchar(30) not null,
	ngaysinh date ,
	quequan varchar(30)
	);

CREATE TABLE monhoc(
	msmh char(8) not null,
	tenmh varchar(20) not null,
	tengv varchar(30) not null
	);

CREATE TABLE dangky(
	msmh char(8) not null,
	mssv char(8) not null,
	diem float not null
	);

ALTER TABLE sinhvien ADD CONSTRAINT pk_sv PRIMARY KEY (mssv);

ALTER TABLE monhoc ADD CONSTRAINT pk_mh PRIMARY KEY (msmh);

ALTER TABLE dangky ADD CONSTRAINT pk_dk PRIMARY KEY (msmh, mssv);

ALTER TABLE dangky ADD CONSTRAINT fk_2sv FOREIGN KEY (mssv) REFERENCES sinhvien(mssv);

ALTER TABLE dangky ADD CONSTRAINT fk_2mh FOREIGN KEY (msmh) REFERENCES monhoc(msmh);

ALTER TABLE dangky ADD CONSTRAINT ck_diem CHECK (diem>=0 and diem <= 10);

-- Thông thường các rằng buộc nên tạo trước khi insert dữ liệu vào để đảm bảo dữ liệu ko bị insert sai

INSERT INTO sinhvien VALUES ('20142014', 'Le Van Long', date '1996-01-10', 'nam dinh');
INSERT INTO sinhvien VALUES ('20142017', 'Tran Tuan Minh', date '1996-04-06', 'ha tay');
INSERT INTO sinhvien VALUES ('20142012', 'Nguyen Van Minh', date '1995-09-10', 'bac giang');
INSERT INTO sinhvien VALUES ('20142015', 'Tran Van Tuan', date '1996-01-03', 'ca mau');
INSERT INTO sinhvien VALUES ('20152016', 'Nguyen Anh Quan', date '1997-04-10', 'quang ninh');
INSERT INTO sinhvien VALUES ('20042325', 'Nguyen Thuy Linh', date '1990-02-07', 'da nang');

INSERT INTO monhoc VALUES ('m1', 'csdl', 'Le Quan');
INSERT INTO monhoc VALUES ('m2', 'csdl', 'Nguyen Thi Oanh');
INSERT INTO monhoc VALUES ('m3', 'giaitich', 'Nguyen Duy Thanh');
INSERT INTO monhoc VALUES ('m4', 'vldc', 'Cao Ba Quat');
INSERT INTO monhoc VALUES ('m5', 'ctdlgt', 'Nguyen Duc Nghia');
INSERT INTO monhoc VALUES ('m6', 'oop', 'Trinh Thanh Trung');
INSERT INTO monhoc VALUES ('m7', 'ktlt', 'Vu Duc Vuong');
INSERT INTO monhoc VALUES ('m8', 'cnpm', 'Vu Thi Huong Giang');

INSERT INTO dangky VALUES ('m1', '20142012', 8);
INSERT INTO dangky VALUES ('m1', '20142014', 9);
INSERT INTO dangky VALUES ('m1', '20142015', 8);
INSERT INTO dangky VALUES ('m2', '20142017', 5);
INSERT INTO dangky VALUES ('m2', '20142012', 4);
INSERT INTO dangky VALUES ('m2', '20142014', 10);
INSERT INTO dangky VALUES ('m2', '20042325', 6);
INSERT INTO dangky VALUES ('m3', '20042325', 8);
INSERT INTO dangky VALUES ('m3', '20142015', 3);
INSERT INTO dangky VALUES ('m4', '20142012', 7);
INSERT INTO dangky VALUES ('m4', '20142017', 9);
INSERT INTO dangky VALUES ('m5', '20042325', 8);
INSERT INTO dangky VALUES ('m5', '20152016', 10);
INSERT INTO dangky VALUES ('m6', '20142012', 10);
INSERT INTO dangky VALUES ('m7', '20142014', 6);
INSERT INTO dangky VALUES ('m7', '20142012', 2);





-- a. Đưa ra tên của các môn học
select distinct tenmh from monhoc;


-- b. Đưa ra MS, Họtên, Ngày sinh của các sinh viên ở Hà nội
select mssv,hoten,ngaysinh from sinhvien
where quequan = 'ha noi';


-- c. Đưa ra mã số của các sinh viên đăng ký học môn học có mã số M1 hoặc M2
select distinct mssv from dangky
where msmh = 'M1' or msmh = 'M2';


-- d. Đưa ra tên của môn học mà sinh viên có mã số 20042325 học
select tenmh from dangky
join monhoc on dangky.msmh = monhoc.msmh and mssv = '20042325';


-- e. Đưa ra tên của các sinh viên đăng ký học ít nhất một môn do giảng viên Lê Quân dạy
select hoten from dangky
join monhoc on dangky.msmh = monhoc.msmh and tengv='Le Quan'
join sinhvien on sinhvien.mssv = dangky.mssv;


-- f. Đưa ra tên các môn mà sinh viên Nguyễn Văn A học và điểm tương ứng của các môn đó cho sinh viên này
select tenmh,diem from dangky
join sinhvien on sinhvien.mssv = dangky.mssv and hoten='Nguyen Thuy Linh'
join monhoc on monhoc.msmh=dangky.msmh;



-- g. Đưa ra mã số của các sinh viên học tất cả các môn mà giảng viên Lê Quân có dạy
select mssv from dangky
join monhoc on monhoc.msmh = dangky.msmh and tengv = 'Le Quan';


-- h. Đưa ra tên của các môn học không được sinh viên nào đăng ký học
select tenmh from monhoc
where msmh not in (select distinct msmh from dangky);


-- i. Những sinh viên nào có đăng ký học từ 5 môn trở lên
select mssv,count(mssv) from dangky
group by mssv
having count(mssv)>=5;



-- j. Điểm trung bình của sinh viên Nguyễn Văn A là bao nhiêu?
select avg(diem) from dangky
join sinhvien on sinhvien.mssv = dangky.mssv and hoten = 'Nguyen Thuy Linh';



-- k. Sinh viên nào đạt điểm cao nhất cho môn CSDL?



select sinhvien.mssv,hoten,ngaysinh,quequan from dangky
join monhoc on monhoc.msmh = dangky.msmh and monhoc.tenmh = 'csdl'
join sinhvien on sinhvien.mssv = dangky.mssv and diem = (
select max(diem) from dangky
join monhoc on monhoc.msmh = dangky.msmh and monhoc.tenmh = 'csdl'
)
