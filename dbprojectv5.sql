CREATE DATABASE dbprojectv5
GO
USE dbprojectv5
GO
 
-- ========== ROLES & USERS ==========
CREATE TABLE roles (
    roleID INT IDENTITY(1,1) PRIMARY KEY,
    roleName NVARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE users (
    userID INT IDENTITY(1,1) PRIMARY KEY,
    email NVARCHAR(255) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    fullName NVARCHAR(100) NOT NULL,
    phone NVARCHAR(20) NOT NULL,
    roleID INT NOT NULL,                        
    isActive BIT NOT NULL DEFAULT 1,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME NULL,
    CONSTRAINT FK_users_role FOREIGN KEY (roleID) REFERENCES roles(roleID)
);

-- ========== STUDENT PROFILE ==========
CREATE TABLE studentProfile (
	userID int primary key ,
	university nvarchar(200),
    currentYear nvarchar(100)	,	--nam 3 / da tot nghiep ....
	avatarPath nvarchar(500),
	dateOfBirth DATE,
	gender nvarchar(10) check (gender in ('FEMALE','MALE','OTHER')),
	city nvarchar(100),
	address nvarchar(max),
	bio nvarchar(500),
	updatedAt datetime not null default getdate(),
	constraint PK_sprofile foreign key (userID) references users(userID) ON DELETE CASCADE
);


CREATE TABLE employers (
    employerID INT IDENTITY(1,1) PRIMARY KEY,
    userID INT NOT NULL UNIQUE,
    -- Company Info
    companyName NVARCHAR(255) NOT NULL,
    industry NVARCHAR(100),
    city NVARCHAR(100),
    address NVARCHAR(max),
    website NVARCHAR(200),
    logo NVARCHAR(255),
    -- Status
    status NVARCHAR(20) DEFAULT 'PENDING' CHECK (status IN ('PENDING','APPROVED','REJECTED')),
    createdAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_emp_user FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);


--PARTTIME/ WEEKEND
CREATE TABLE jobTypes (
    typeID INT IDENTITY(1,1) PRIMARY KEY,
    typeCode NVARCHAR(30) NOT NULL UNIQUE
);

--==========JOBS=================
CREATE TABLE jobs (
    jobID INT IDENTITY(1,1) PRIMARY KEY,
    employerID INT NOT NULL, 
    title NVARCHAR(200) NOT NULL,
    description NVARCHAR(max) NOT NULL,
    requirements NVARCHAR(max),
    benefits NVARCHAR(max),
    city NVARCHAR(100),
    address NVARCHAR(255),
    shift_info NVARCHAR(150),
    work_format NVARCHAR(10) NOT NULL DEFAULT 'ONSITE' CHECK (work_format IN ('ONSITE','REMOTE','HYBRID')),
    pay_type NVARCHAR(12) DEFAULT 'HOURLY' CHECK (pay_type IN ('HOURLY','DAILY','MONTH')),
    pay_rate DECIMAL(12,2),
    numberOfPositions INT DEFAULT 1,
    applicationCount INT DEFAULT 0,
    contactEmail NVARCHAR(255),
    contactPhone NVARCHAR(20),
    deadline DATETIME,
    typeID INT NOT NULL,
    status NVARCHAR(20) DEFAULT 'ACTIVE' CHECK (status IN ('ACTIVE', 'CLOSED')),
    views_count INT NOT NULL DEFAULT 0,
    createdAt DATETIME DEFAULT GETDATE(),
    updatedAt DATETIME NULL,
    CONSTRAINT FK_jobs_employer FOREIGN KEY (employerID) REFERENCES employers(employerID),
    CONSTRAINT FK_jobs_type FOREIGN KEY (typeID) REFERENCES jobTypes(typeID)
);

--PENDING / APPROVED/ REJECT 
CREATE TABLE applicationStatuses (
    statusID INT IDENTITY(1,1) PRIMARY KEY,
    statusCode NVARCHAR(30) NOT NULL UNIQUE
);

--===========APPLICATIONS==============
CREATE TABLE applications(
	applicationID int identity(1,1) primary key,
	jobID int not null,
	studentID int not null,
	statusID int not null,				--ACCEPT/REJECT
	coverLetter nvarchar(max),			
	appliedAt datetime default getdate(),
	reviewedAt datetime ,				--thoi gain xem xet
	reviewedBy int,						--nguoi xem xet (employerID)
	reviewNote nvarchar(max),			--ghi chu cua nha tuyen dung
	CONSTRAINT UQ_app unique(jobID,studentID),
	constraint FK_app_student Foreign key (studentID) references users(userID),
	constraint FK_app_job foreign key (jobID) references jobs(jobID) on delete cascade,
	constraint FK_app_status foreign key (statusID) references applicationStatuses(statusID),-- PENDING, APPROVED, REJECTED, WITHDRAWN 
	CONSTRAINT FK_app_reviewer FOREIGN KEY (reviewedBy) REFERENCES users(userID)
);




--=========OPERATIONS===========
CREATE TABLE notifications (
	notificationID BIGINT identity(1,1) primary key,
	userID int not null,
	type nvarchar(40) not null,
	title nvarchar(200) not null,
	content nvarchar(max),
	isRead BIT default 0,
	createdAt datetime not null default getdate(),
	constraint FK_noti_user foreign key (userID) references users(userID) on delete cascade
);

CREATE TABLE systemLog (
    logID INT PRIMARY KEY IDENTITY(1,1),
    userID INT,
    action NVARCHAR(100) NOT NULL,
    description NVARCHAR(500),
    createdAt DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (userID) REFERENCES users(userID)
);



-- ========== ADDITIONAL FEATURES ==========
CREATE TABLE savedJobs (
	userID int not null,
	jobID int not null,
	savedAt datetime default getDate(),
	constraint PK_savedJobs primary key (userID,jobID),
	constraint FK_savedjob_user foreign key (userID) references users(userID) on delete cascade,
	constraint FK_savedjob_job foreign key (jobID) references jobs(jobID) on delete cascade
);









--===========================DATA===================
--ROLES
INSERT INTO roles(roleName) VALUES
('ADMIN'),('STUDENT'),('EMPLOYER');


--users
INSERT INTO users(email,password,fullName,phone,roleID) VALUES
--admin (roleID=1)
('tranquangphong232@gmail.com','admin123',N'Trần Quang Phong','0999999999',1),

-- Students roleID =2 
('student1@fpt.edu.vn', '123456', N'Trần Văn An', '0912345678',2),
('student2@fpt.edu.vn', '123456', N'Lê Thị Bình', '0923456789',2),
('student3@fpt.edu.vn', '123456', N'Phạm Minh Cường', '0934567890',2),
('student4@fpt.edu.vn', '123456', N'Hoàng Thu Dung', '0945678901',2),
('student5@fpt.edu.vn', '123456', N'Ngô Văn Em', '0956789012',2),

-- Employers (roleID=3)
('hr@thecoffeehouse.vn', '123456', N'Nguyễn Thị HR', '0967890123',3),
('recruit@highlands.vn', '123456', N'Trần Văn Tuyển', '0978901234',3),
('hiring@cgv.vn', '123456', N'Lê Thị Tuyển Dụng', '0989012345',3),
('hr@lotteria.vn', '123456', N'Phạm Văn Nhân Sự', '0990123456',3),
('contact@circlek.vn', '123456', N'Hoàng Thị Liên Hệ', '0901234568',3),
('hr@thealley.vn', '123456', N'Trương Thị Duyên', '0911234569',3),
('recruit@winmart.vn', '123456', N'Lý Văn Minh', '0912234570',3),
('hiring@trungnguyencoffee.vn', '123456', N'Võ Thị Hương', '0913234571',3),
('hr@gongcha.vn', '123456', N'Đỗ Văn Kiên', '0914234572',3),
('recruit@pizzacompany.vn', '123456', N'Ngô Thị Liên', '0915234573',3),
('hr@phuclongcoffee.vn', '123456', N'Bùi Văn Toàn', '0916234574',3),
('hiring@familymart.vn', '123456', N'Hà Thị Tuyết', '0917234575',3),
('recruit@ministop.vn', '123456', N'Tạ Văn Hùng', '0918234576',3),
('hr@shopeeexpress.vn', '123456', N'Vũ Thị Loan', '0919234577',3),
('hiring@kfc.vn', '123456', N'Trịnh Văn Hải', '0920234578',3);


--================
INSERT INTO employers (userID, companyName, industry, city, address, website, status) VALUES
(7, N'The Coffee House', N'F&B', N'Hà Nội', N'Số 5 Trần Thái Tông', 'thecoffeehouse.vn', 'APPROVED'),
(8, N'Highlands Coffee', N'F&B', N'Hà Nội', N'Hoà Lạc', 'highlands.vn', 'APPROVED'),
(9, N'CGV Cinemas', N'Entertainment', N'Hà Nội', N'Vincom Metropolis', 'cgv.vn', 'APPROVED'),
(10, N'Lotteria', N'F&B', N'Hà Nội', N'246 Phố Huế', 'lotteria.vn', 'APPROVED'),
(11, N'Circle K', N'Retail', N'Hà Nội', N'Số 1 Nguyễn Trãi', 'circlek.vn', 'APPROVED'),
(12, N'The Alley', N'F&B', N'Hà Nội', N'Vincom Nguyễn Chí Thanh', 'thealley.vn', 'APPROVED'),
(13, N'WinMart+', N'Retail', N'Hà Nội', N'65 Cầu Giấy', 'winmart.vn', 'APPROVED'),
(14, N'Trung Nguyên Coffee', N'F&B', N'Hà Nội', N'123 Cầu Giấy', 'trungnguyencoffee.vn', 'APPROVED'),
(15, N'Gong Cha', N'F&B', N'Hà Nội', N'Royal City', 'gongcha.vn', 'APPROVED'),
(21, N'KFC', N'F&B', N'Hà Nội', N'120 Kim Mã', 'kfc.vn', 'APPROVED');

--========4. Student Profile 
INSERT INTO studentProfile(userID,university,currentYear,dateOfBirth,gender,city,address,bio) VALUES
(2,'FPT UNIVERSITY', '3',  '2005-05-15','MALE', N'Hà Nội', N'Hòa Lạc, Thạch Thất', N'Sinh viên năm 3 chuyên ngành Software Engineering, tìm part-time linh hoạt'),
(3, N'FPT University', '2', '2004-08-20', 'FEMALE', N'Hà Nội', N'Trần Duy Hưng, Cầu Giấy', N'Năm 2 SE, muốn tích lũy kinh nghiệm làm việc'),
(4, N'FPT University', '2', '2004-03-25', 'FEMALE', N'Hà Nội', N'Thanh Xuân', N'AI student, thích làm việc cuối tuần'),
(5, N'FPT University', '4', '2002-12-10', 'MALE', N'Hà Nội', N'Mỹ Đình, Nam Từ Liêm', N'Sắp tốt nghiệp, tìm việc full-time hoặc part-time'),
(6, N'FPT University', '1', '2005-07-30', 'MALE', N'Hà Nội', N'Hà Đông', N'Sinh viên năm 1, muốn kiếm thêm thu nhập');



-- ========== 8. APPLICATION STATUSES ==========
INSERT INTO applicationStatuses (statusCode) VALUES
('PENDING'),
('APPROVED'),
('REJECTED'),
('WITHDRAWN');

-- ========== 9. JOB TYPES ==========
INSERT INTO jobTypes (typeCode) VALUES
('PARTTIME'),
('WEEKEND'),
('FLEXIBLE');

-- ==========SEED. JOBS  NEW==========
INSERT INTO jobs (employerID, title, description, requirements, benefits, 
    city, address, shift_info, work_format, pay_type, pay_rate, numberOfPositions, 
    contactEmail, contactPhone, deadline, typeID, status)
VALUES
(1, N'Nhân viên pha chế part-time',
N'Tuyển nhân viên pha chế làm việc theo ca, phục vụ khách hàng tại cửa hàng',
N'- Sinh viên năm 2 trở lên\n- Giao tiếp tốt, vui vẻ\n- Yêu thích cà phê',
N'- Lương 25k/giờ\n- Được đào tạo kỹ năng pha chế\n- Free đồ uống',
N'Hà Nội', N'Số 5 Trần Thái Tông, Cầu Giấy',
N'Ca sáng: 7h-11h, Ca chiều: 14h-18h',
'ONSITE', 'HOURLY', 25000, 3, 'tuyen.dung@thecoffeehouse.vn', '0967890123', '2025-11-30', 1, 'ACTIVE'),

(2, N'Nhân viên phục vụ cuối tuần',
N'Tuyển nhân viên phục vụ làm việc cuối tuần',
N'- Sinh viên đang học\n- Nhiệt tình, năng động',
N'- Lương 30k/giờ\n- Thưởng doanh thu\n- Free đồ uống',
N'Hà Nội', N'Hoà Lạc, Thạch Thất',
N'Thứ 7-CN: 8h-20h',
'ONSITE', 'HOURLY', 30000, 5, 'recruit@highlands.vn', '0978901234', '2025-12-15', 2, 'ACTIVE'),

(3, N'Nhân viên bán vé và bắp nước',
N'CGV Metropolis tuyển nhân viên bán vé, bắp nước',
N'- Sinh viên\n- Cao từ 1m55 trở lên\n- Giao tiếp tốt',
N'- Lương 35k/giờ\n- Được xem phim miễn phí\n- Cơ hội thăng tiến',
N'Hà Nội', N'Vincom Metropolis, 29 Liễu Giai',
N'Ca chiều: 14h-18h, Ca tối: 18h-23h',
'ONSITE', 'HOURLY', 35000, 4, 'hiring@cgv.vn', '0989012345', '2025-11-20', 1, 'ACTIVE'),

(4, N'Nhân viên phục vụ thức ăn nhanh',
N'Lotteria tuyển nhân viên phục vụ, thu ngân',
N'- Sinh viên từ 18 tuổi\n- Nhanh nhẹn, chịu được áp lực',
N'- Lương 28k/giờ + thưởng KPI\n- Được ăn ca\n- Đào tạo bán hàng',
N'Hà Nội', N'246 Phố Huế, Hai Bà Trưng',
N'Giờ cao điểm: 11h-13h30, 17h-20h',
'ONSITE', 'HOURLY', 28000, 6, 'hr@lotteria.vn', '0990123456', '2025-12-31', 3, 'ACTIVE'),

(5, N'Nhân viên cửa hàng ca tối',
N'Circle K tuyển nhân viên làm ca tối',
N'- Không yêu cầu kinh nghiệm\n- Chịu được ca đêm\n- Trung thực, cẩn thận',
N'- Lương 40k/giờ\n- Phụ cấp ca đêm\n- Discount 20% sản phẩm',
N'Hà Nội', N'Số 1 Nguyễn Trãi, Thanh Xuân',
N'Ca tối: 16h-00h',
'ONSITE', 'HOURLY', 40000, 2, 'contact@circlek.vn', '0901234568', '2025-10-31', 1, 'ACTIVE'),

(6, N'Nhân viên pha chế trà sữa',
N'The Alley tuyển nhân viên pha chế trà sữa',
N'- Sinh viên từ 18 tuổi\n- Học tập nhanh, chịu khó',
N'- Lương 27k/giờ\n- Thưởng KPI, tip hàng ngày\n- Free đồ uống',
N'Hà Nội', N'Vincom Nguyễn Chí Thanh',
N'Ca sáng: 8h-12h, Ca tối: 17h-21h',
'ONSITE', 'HOURLY', 27000, 4, 'hr@thealley.vn', '0911234569', '2025-11-25', 3, 'ACTIVE'),

(7, N'Nhân viên bán hàng WinMart+',
N'WinMart+ tuyển nhân viên bán hàng',
N'- Nam/Nữ sinh viên\n- Nhanh nhẹn, trách nhiệm',
N'- Lương 35k/giờ\n- Phụ cấp ca tối\n- Discount 20%',
N'Hà Nội', N'65 Cầu Giấy, Đống Đa',
N'Ca sáng: 7h-15h, Ca tối: 15h-23h',
'ONSITE', 'HOURLY', 35000, 5, 'recruit@winmart.vn', '0912234570', '2025-12-05', 1, 'ACTIVE'),

(8,  N'Nhân viên phục vụ Trung Nguyên',
N'Trung Nguyên tuyển nhân viên phục vụ',
N'- Sinh viên năm 2 trở lên\n- Giao tiếp tốt, tươi cười',
N'- Lương 26k/giờ\n- Hoa hồng bán hàng\n- Học barista',
N'Hà Nội', N'123 Cầu Giấy',
N'Ca linh hoạt',
'ONSITE', 'HOURLY', 26000, 3, 'hiring@trungnguyencoffee.vn', '0913234571', '2025-11-20', 3, 'ACTIVE'),

(9, N'Nhân viên Gong Cha',
N'Gong Cha tuyển nhân viên pha chế',
N'- Sinh viên đang học\n- Cẩn thận, chuyên cần',
N'- Lương 28k/giờ\n- Hoa hồng doanh số\n- Free đồ uống',
N'Hà Nội', N'Royal City, Nguyễn Trãi',
N'Ca chiều: 14h-18h, Ca tối: 18h-22h',
'ONSITE', 'HOURLY', 28000, 3, 'hr@gongcha.vn', '0914234572', '2025-12-10', 2, 'ACTIVE'),

(10, N'Nhân viên KFC',
N'KFC tuyển nhân viên phục vụ',
N'- Sinh viên từ 18 tuổi\n- Giao tiếp tốt, vui vẻ',
N'- Lương 30k/giờ\n- Được ăn ca miễn phí\n- Thưởng KPI',
N'Hà Nội', N'120 Kim Mã, Ba Đình',
N'Ca trưa: 10h-14h, Ca tối: 17h-21h',
'ONSITE', 'HOURLY', 30000, 4, 'hiring@kfc.vn', '0920234578', '2025-12-05', 1, 'ACTIVE');


-- ========== 17. APPLICATIONS ==========
INSERT INTO applications (jobID, studentID, statusID, coverLetter, appliedAt) VALUES
(1, 2, 2, N'Em rất yêu thích cà phê và có kinh nghiệm làm barista 3 tháng tại TCH chi nhánh khác. Em mong muốn được làm việc tại chi nhánh này vì gần nơi ở.', '2025-10-01 10:30:00'),
(1, 3, 1, N'Em là sinh viên năm 2, muốn tìm công việc part-time để tích lũy kinh nghiệm. Em có thể làm việc linh hoạt theo ca.', '2025-10-02 14:20:00'),

(2, 4, 2, N'Em có kinh nghiệm làm việc tại Highlands Coffee 1 năm, hiểu rõ quy trình phục vụ. Em có thể làm cả thứ 7 và chủ nhật.', '2025-09-28 09:15:00'),
(2, 5, 1, N'Em đang tìm việc làm cuối tuần. Em là người nhiệt tình và học hỏi nhanh.', '2025-10-01 16:45:00'),

(3, 3, 3, N'Em xin ứng tuyển vị trí nhân viên bán vé tại CGV. Em yêu thích điện ảnh và muốn làm việc trong môi trường này.', '2025-09-25 11:00:00'),
(3, 6, 1, N'Em là sinh viên năm 1, muốn kiếm thêm thu nhập. Em có thể làm ca tối và cuối tuần.', '2025-10-02 20:30:00'),

(4, 2, 1, N'Em quan tâm đến vị trí này vì giờ làm việc phù hợp với lịch học. Em là người nhanh nhẹn, thích môi trường năng động.', '2025-10-01 08:00:00'),

(5, 4, 2, N'Em đang tìm công việc ca tối để có thể học buổi sáng. Em là người cẩn thận, trung thực, phù hợp với công việc bán hàng tại cửa hàng tiện lợi.', '2025-09-30 15:20:00'),
(5, 6, 1, N'Em muốn thử làm việc ca tối tại Circle K. Em sẵn sàng học hỏi và chịu khó.', '2025-10-02 19:00:00');



-- ========== 18. SAVED JOBS ==========
INSERT INTO savedJobs (userID, jobID, savedAt) VALUES
(2, 2, '2025-09-30 10:00:00'),
(2, 4, '2025-10-01 08:30:00'),
(3, 1, '2025-10-01 12:00:00'),
(3, 5, '2025-10-02 09:00:00'),
(4, 6, '2025-10-01 14:00:00'),
(5, 2, '2025-09-29 16:00:00'),
(5, 3, '2025-09-30 11:00:00'),
(6, 1, '2025-10-02 08:00:00'),
(6, 4, '2025-10-02 20:00:00');



-- ========== 21. UPDATE JOB VIEWS & APPLICATION COUNT ==========
UPDATE jobs SET views_count = 125, applicationCount = 2 WHERE jobID = 1;
UPDATE jobs SET views_count = 98, applicationCount = 2 WHERE jobID = 2;
UPDATE jobs SET views_count = 156, applicationCount = 2 WHERE jobID = 3;
UPDATE jobs SET views_count = 87, applicationCount = 1 WHERE jobID = 4;
UPDATE jobs SET views_count = 142, applicationCount = 2 WHERE jobID = 5;
UPDATE jobs SET views_count = 65, applicationCount = 0 WHERE jobID = 6;
UPDATE jobs SET views_count = 43, applicationCount = 0 WHERE jobID = 7;



-- ========== 22. NOTIFICATIONS ==========
INSERT INTO notifications (userID, type, title, content, isRead, createdAt) VALUES
-- Student notifications
(2, 'APPLICATION', N'Đơn ứng tuyển được chấp nhận', N'Chúc mừng! Đơn ứng tuyển của bạn tại The Coffee House đã được chấp nhận. Vui lòng liên hệ 0967890123 để sắp xếp lịch làm việc.', 1, '2025-10-02 10:00:00'),
(4, 'APPLICATION', N'Đơn ứng tuyển được duyệt', N'Highlands Coffee đã chấp nhận đơn ứng tuyển của bạn. HR sẽ liên hệ trong 24h tới.', 0, '2025-10-02 15:00:00'),
(3, 'APPLICATION', N'Đơn ứng tuyển bị từ chối', N'Rất tiếc, đơn ứng tuyển của bạn tại CGV Cinemas không phù hợp lần này. Chúc bạn tìm được công việc phù hợp!', 1, '2025-09-30 09:00:00'),
(2, 'SYSTEM', N'Có công việc mới phù hợp với bạn', N'Highlands Coffee vừa đăng việc làm cuối tuần - Phù hợp với hồ sơ của bạn!', 0, '2025-10-03 08:00:00'),

-- Employer notifications
(7, 'APPLICATION', N'Có đơn ứng tuyển mới', N'Trần Văn An vừa ứng tuyển vào vị trí Nhân viên pha chế part-time. Vui lòng xem xét!', 0, '2025-10-01 10:35:00'),
(8, 'APPLICATION', N'2 đơn ứng tuyển mới', N'Có 2 sinh viên ứng tuyển vào vị trí Nhân viên phục vụ cuối tuần.', 0, '2025-10-01 17:00:00'),
(7, 'SYSTEM', N'Tin tuyển dụng sắp hết hạn', N'Tin "Nhân viên pha chế part-time" sẽ hết hạn vào 30/11/2025. Gia hạn ngay!', 0, '2025-10-03 09:00:00');

-- ========== 23. SYSTEM LOGS ==========
INSERT INTO systemLog (userID, action, description, createdAt) VALUES
(1, 'LOGIN', 'Admin đăng nhập hệ thống', '2025-10-03 08:00:00'),
(2, 'APPLY_JOB', 'Student ứng tuyển job ID: 1', '2025-10-01 10:30:00'),
(7, 'CREATE_JOB', 'Employer tạo tin tuyển dụng mới', '2025-09-25 14:00:00'),
(2, 'UPDATE_PROFILE', 'Student cập nhật profile', '2025-10-02 16:00:00'),
(7, 'APPROVE_APPLICATION', 'Employer duyệt đơn ứng tuyển ID: 1', '2025-10-02 10:00:00');


-- Reset identity về số cuối cùng hợp lệ
DBCC CHECKIDENT('jobs', RESEED,0); -- Hoặc số ID cuối cùng hợp lệ
delete from jobs 

GO 
CREATE OR ALTER TRIGGER TR_jobs_only_approved_employer
ON jobs
INSTEAD OF INSERT
AS
BEGIN
  SET NOCOUNT ON;

  -- Nếu có bất kỳ employer chưa APPROVED -> chặn tất cả
  IF EXISTS (
    SELECT 1
    FROM inserted i
    LEFT JOIN employers e ON i.employerID = e.employerID
    WHERE e.status IS NULL OR e.status <> 'APPROVED'
  )
  BEGIN
    RAISERROR (N'Employer chưa được duyệt. Vui lòng liên hệ admin để được xác nhận.', 16, 1);
    RETURN;
  END;

  -- Chèn, để DB tự áp dụng DEFAULT cho các cột có default (applicationCount, views_count, createdAt, status)
  INSERT INTO jobs (
    employerID, title, description, requirements, benefits,
    city, address, shift_info, work_format, pay_type, pay_rate,
    numberOfPositions, contactEmail, contactPhone, deadline, typeID
    -- status, applicationCount, views_count, createdAt, updatedAt: để DB tự handle
  )
  SELECT
    i.employerID, i.title, i.description, i.requirements, i.benefits,
    i.city, i.address, i.shift_info, i.work_format, i.pay_type, i.pay_rate,
    COALESCE(i.numberOfPositions, 1), i.contactEmail, i.contactPhone, i.deadline, i.typeID
  FROM inserted i;
END;
GO
