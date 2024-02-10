create database Lab01;
USE Lab01;
CREATE TABLE Cungcap (
    MSNCC integer NOT NULL,
    MSMH integer NOT NULL,
    Giatien integer
);

CREATE TABLE Mathang (
    MSMH integer NOT NULL,
    TenMH varchar(30),
    Mausac varchar(10)
);

CREATE TABLE NCC (
    MSNCC integer NOT NULL,
    TenNCC varchar(30),
    DiaChi varchar(100)
);


INSERT INTO Cungcap VALUES (1, 1, 150);
INSERT INTO Cungcap VALUES (1, 2, 250);
INSERT INTO Cungcap VALUES (1, 3, 350);
INSERT INTO Cungcap VALUES (1, 4, 50);
INSERT INTO Cungcap VALUES (2, 1, 50);
INSERT INTO Cungcap VALUES (2, 2, 450);
INSERT INTO Cungcap VALUES (2, 3, 250);
INSERT INTO Cungcap VALUES (2, 4, 150);
INSERT INTO Cungcap VALUES (1, 5, 245);

INSERT INTO Mathang VALUES (1, 'Mat hang 1', 'do');
INSERT INTO Mathang VALUES (3, 'Mat hang 3', 'xanh');
INSERT INTO Mathang VALUES (4, 'Mat hang 4', 'do');
INSERT INTO Mathang VALUES (5, 'Mat hang 5', 'do');
INSERT INTO Mathang VALUES (2, 'Mat hang 2', 'tim');

INSERT INTO NCC VALUES (1, 'Cong ty A', 'Dia chi A');
INSERT INTO NCC VALUES (3, 'Cong ty C', 'Dia chi C');
INSERT INTO NCC VALUES (2, 'Dustin', 'Dia chi B');

ALTER TABLE Cungcap
    ADD CONSTRAINT pk_Cungcap PRIMARY KEY (MSNCC, MSMH);

ALTER TABLE Mathang
    ADD CONSTRAINT pk_Mathang PRIMARY KEY (MSMH);
	
ALTER TABLE NCC
    ADD CONSTRAINT pri_key_NCC PRIMARY KEY (MSNCC);

ALTER TABLE Cungcap
    ADD CONSTRAINT fk_Cungcap_Mathang FOREIGN KEY (MSMH) REFERENCES Mathang(MSMH);

ALTER TABLE Cungcap
    ADD CONSTRAINT pk_Cungcap_NCC FOREIGN KEY (MSNCC) REFERENCES NCC(MSNCC);
    
    
-- Câu 1 
-- a. Đưa ra tên của những hãng có cung ứng ít nhất 1 mặt hàng màu đỏ
select distinct TenNCC  from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'do';

-- Đưa ra mã số của các hãng có cung ứng ít nhất 1 mặt hàng màu đỏ hoặc 1 mặt hàng màu xanh
select distinct NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'do' or Mathang.Mausac = 'xanh';

-- c. Đưa ra mã số của hãng có cung ứng ít nhất 1 mặt hàng màu đỏ và 1 mặt hàng màu xanh
select distinct NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Mathang.MSMH
where Mathang.Mausac = 'do' and exists (
select distinct NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'xanh');


-- d. Đưa ra mã số của hãng cung ứng tất cả các mặt hàng màu đỏ

select NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'do'
group by NCC.MSNCC
having count(NCC.MSNCC) = (
select count(Mathang.MSMH) from Mathang
where Mathang.Mausac = 'do'
);


select NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'xanh'
group by NCC.MSNCC
having count(NCC.MSNCC) = (
select count(Mathang.MSMH) from Mathang
where Mathang.Mausac = 'xanh'
);

-- e. Đưa ra mã số của hãng cung ứng tất cả các mặt hàng màu đỏ và màu xanh
select bang_do.MSNCC from (
select NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'do'
group by NCC.MSNCC
having count(NCC.MSNCC) = (
select count(Mathang.MSMH) from Mathang
where Mathang.Mausac = 'do')
) bang_do
join (
select NCC.MSNCC from NCC
join Cungcap on Cungcap.MSNCC = NCC.MSNCC
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'xanh'
group by NCC.MSNCC
having count(NCC.MSNCC) = (
select count(Mathang.MSMH) from Mathang
where Mathang.Mausac = 'xanh')
) bang_xanh 
on bang_do.MSNCC = bang_xanh.MSNCC;

-- Đưa ra mã số của hãng cung ứng tất cả các mặt hàng màu đỏ hoặc tất cả các mặt hàng màu xanh
select distinct Cungcap.MSNCC from Cungcap
join Mathang on Mathang.MSMH = Cungcap.MSMH
where Mathang.Mausac = 'xanh' or Mathang.Mausac = 'do'
group by Cungcap.MSNCC, Mathang.Mausac 
having count(CASE WHEN Mathang.Mausac = 'do' then Mathang.MSMH end) = (select count(Mathang.MSMH) from Mathang where Mathang.Mausac = 'do')
or count(CASE WHEN Mathang.Mausac = 'xanh' then Mathang.MSMH end) = (select count(Mathang.MSMH) from Mathang where Mathang.Mausac = 'xanh');


-- g. Đưa ra cặp mã số của hãng cung ứng sao cho hãng cung ứng tương ứng với mã số thứ nhất cung cấp một mặt hàng nào đó với giá cao hơn so với giá mà hãng tương ứng với mã số thứ hai cung cấp cũng mặt hàng đó
select * from Cungcap
join Mathang on Cungcap.MSMH = Mathang.MSMH;



select distinct S1.MSNCC as 'MSNCC 1',S2.MSNCC as 'MSNCC 2'from (
select MSNCC,Cungcap.MSMH,Giatien from Cungcap
join Mathang on Cungcap.MSMH = Mathang.MSMH
) S1,(
select MSNCC,Cungcap.MSMH,Giatien from Cungcap
join Mathang on Cungcap.MSMH = Mathang.MSMH
) S2
where S1.MSMH = S2.MSMH and S1.MSNCC != S2.MSNCC and S1.Giatien > S2.Giatien;

-- h. Đưa ra mã số của mặt hàng được cung cấp bởi ít nhất hai hãng cung ứng
select Cungcap.MSMH,count(Cungcap.MSMH) from Mathang
join Cungcap on Cungcap.MSMH = Mathang.MSMH
group by Cungcap.MSMH
having count(Cungcap.MSMH) >= 2;

-- i. Đưa ra mã số của mặt hàng đắt nhất được cung cấp bởi hãng Dustin
select MSMH from Cungcap
join NCC on Cungcap.MSNCC = NCC.MSNCC
where Cungcap.Giatien = (SELECT MAX(Cungcap.Giatien) FROM Cungcap JOIN NCC ON Cungcap.MSNCC = NCC.MSNCC WHERE NCC.TenNCC = 'Dustin');

-- j. Đưa ra mã số của mặt hàng được cung ứng bởi tất cả các hãng mà giá tiền đều nhỏ hơn 200
select Cungcap.MSMH from Cungcap
where Cungcap.Giatien < 200
group by Cungcap.MSMH
having count(Cungcap.MSNCC) = (select count(distinct MSNCC)  from Cungcap where Cungcap.Giatien < 200)

