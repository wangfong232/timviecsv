--PROJECTv4 - SIMPLIFIED VERSION
DROP DATABASE IF EXISTS dbprojectv3
GO
CREATE DATABASE dbprojectv4
GO
USE dbprojectv4
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
	currentYear int,
	graduationYear int, 
	avatarPath nvarchar(500),
	dateOfBirth DATE,
	gender nvarchar(10) check (gender in ('FEMALE','MALE','OTHER')),
	city nvarchar(100),
	address nvarchar(max),
	bio nvarchar(500),
	updatedAt datetime not null default getdate(),
	constraint PK_sprofile foreign key (userID) references users(userID) ON DELETE CASCADE
);

-- ========== COMPANIES ==========

CREATE TABLE companies (
	companyID int identity(1,1) primary key,
	name nvarchar(255) not null,
	description nvarchar(max) null,
	industry nvarchar(100),
	size nvarchar(50),
	city nvarchar(100) not null,
	address nvarchar(max) not null,
	website nvarchar(200) null,
	logo nvarchar(255),
	createdAt datetime not null default getdate()
)
CREATE TABLE employers (
    companyID INT PRIMARY KEY,
    userID INT NOT NULL UNIQUE,
    position NVARCHAR(100) DEFAULT 'HR',
    CONSTRAINT FK_emp_company FOREIGN KEY (companyID) REFERENCES companies(companyID) ON DELETE CASCADE,
    CONSTRAINT FK_emp_user FOREIGN KEY (userID) REFERENCES users(userID) ON DELETE CASCADE
);


-- ========== LOOKUPS ==========
CREATE TABLE jobStatuses (
    statusID INT IDENTITY(1,1) PRIMARY KEY,
    statusCode NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE applicationStatuses (
    statusID INT IDENTITY(1,1) PRIMARY KEY,
    statusCode NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE jobTypes (
    typeID INT IDENTITY(1,1) PRIMARY KEY,
    typeCode NVARCHAR(30) NOT NULL UNIQUE
);

CREATE TABLE categories (
    categoryID INT IDENTITY(1,1) PRIMARY KEY,
    categoryName NVARCHAR(150) NOT NULL UNIQUE
);

CREATE TABLE tags (
    tagID INT IDENTITY(1,1) PRIMARY KEY,
    tagName NVARCHAR(100) NOT NULL UNIQUE
);



--==========JOBS=================
CREATE TABLE jobs(
	jobID int identity(1,1) primary key,
	companyID int not null,
	createdBy int not null,
	title nvarchar(200) not null,
	description nvarchar(max) not null,
	requirements nvarchar(max),
	benefits nvarchar(max),
	city nvarchar(100) ,
	address nvarchar(255),
	
	shift_info nvarchar(150) ,				--thong tin ca : ca sang 7h
	hours_per_week_min int check(hours_per_week_min BETWEEN 1 AND 40),	--so gio lam toi thieu 1 tuan
	hours_per_week_max int check (hours_per_week_max BETWEEN 1 AND 40) ,	--so gio lam toi da 1 tuan
	is_evening_shift BIT NOT NULL DEFAULT(0),
	is_weekend_shift BIT NOT NULL DEFAULT(0),
	work_format nvarchar(10) not null default('ONSITE') check (work_format in('ONSITE','REMOTE','HYBRID')),
	
	pay_type NVARCHAR(12) NOT NULL DEFAULT 'HOURLY' CHECK(pay_type IN('HOURLY','DAILY','SHIFT','NEGOTIABLE')),
    pay_rate DECIMAL(12,2),
    salary_min DECIMAL(12,2) CHECK(salary_min >= 0),
    salary_max DECIMAL(12,2) ,
	
	numberOfPositions int default 1,			--so luong can tuyen
	applicationCount int default 0,				--so don ung tuyen
	contactEmail nvarchar(255),
	contactPhone nvarchar(20),
	deadline DATETIME,

	statusID int not null,						--PENDING / APPROVED / CLOSED
	typeID int not null,						--FLEXIBLE / WEEKEND / PARTTIME
	views_count int not null default(0),
	createdAt datetime default getdate(),
	updatedAt datetime ,
	constraint FK_jobs_company foreign key (companyID) references companies(companyID),
	constraint FK_jobs_creator foreign key (createdBy) references users(userID),
	constraint FK_jobs_status foreign key (statusID) references jobStatuses(statusID),
	constraint FK_jobs_type foreign key (typeID) references jobTypes(typeID),

	-->>check min<=max (cho phep 1 trong 2 null)
	constraint CK_jobs_hours_range 
		check(hours_per_week_min is null or hours_per_week_max is null or hours_per_week_min <= hours_per_week_max),

	-->> check paytype : negotiable thi pay rate phai null
	constraint CK_jobs_pay_rule
		check ((pay_type = 'NEGOTIABLE' AND pay_rate IS NULL)
			OR
			(pay_type<>'NEGOTIABLE' AND (pay_rate IS NULL OR pay_rate >=0))
		),
	
	-->> check salary
	constraint CK_jobs_salary
		check(salary_max >= 0 AND (salary_max >= salary_min))
);


CREATE TABLE jobCategories (
	jobID int not null,
	categoryID int not null,
	CONSTRAINT PK_jobCategories PRIMARY KEY(jobID, categoryID),
	CONSTRAINT FK_jobcat_job FOREIGN KEY (jobID) references jobs(jobID) ON DELETE CASCADE,
	CONSTRAINT FK_jobcat_cat FOREIGN KEY (categoryID) references categories(categoryID) 
);

CREATE TABLE jobTags (
	jobID int not null,
	tagID int not null,
	CONSTRAINT PK_jobTags PRIMARY KEY(jobID, tagID),
	CONSTRAINT FK_jobtag_job FOREIGN KEY (jobID) references jobs(jobID) ON DELETE CASCADE,
	CONSTRAINT FK_jobtag_tag FOREIGN KEY (tagID) references tags(tagID) 
); 







--===========APPLICATIONS==============
CREATE TABLE applications(
	applicationID int identity(1,1) primary key,
	jobID int not null,
	studentID int not null,
	statusID int not null,
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

CREATE TABLE SystemLog (
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

--companyReviews 
/*CREATE TABLE companyReviews (
    reviewID INT IDENTITY(1,1) PRIMARY KEY,
    companyID INT NOT NULL,
    studentID INT NOT NULL,
    rating INT CHECK(rating BETWEEN 1 AND 5),
    title NVARCHAR(200),
    content NVARCHAR(MAX),
    isVerified BIT DEFAULT 0,
    createdAt DATETIME DEFAULT GETDATE(),
    CONSTRAINT FK_review_company FOREIGN KEY (companyID) REFERENCES companies(companyID) ON DELETE CASCADE,
    CONSTRAINT FK_review_student FOREIGN KEY (studentID) REFERENCES users(userID)
);*/



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
('contact@circlek.vn', '123456', N'Hoàng Thị Liên Hệ', '0901234568',3);



--========4. Student Profile 
INSERT INTO studentProfile(userID,university,currentYear,graduationYear,dateOfBirth,gender,city,address,bio) VALUES
(2,'FPT UNIVERSITY', 3, 2027, '2005-05-15','MALE', N'Hà Nội', N'Hòa Lạc, Thạch Thất', N'Sinh viên năm 3 chuyên ngành Software Engineering, tìm part-time linh hoạt'),
(3, N'FPT University', 2, 2027, '2004-08-20', 'FEMALE', N'Hà Nội', N'Trần Duy Hưng, Cầu Giấy', N'Năm 2 SE, muốn tích lũy kinh nghiệm làm việc'),
(4, N'FPT University', 2, 2027, '2004-03-25', 'FEMALE', N'Hà Nội', N'Thanh Xuân', N'AI student, thích làm việc cuối tuần'),
(5, N'FPT University', 4, 2025, '2002-12-10', 'MALE', N'Hà Nội', N'Mỹ Đình, Nam Từ Liêm', N'Sắp tốt nghiệp, tìm việc full-time hoặc part-time'),
(6, N'FPT University', 1, 2028, '2005-07-30', 'MALE', N'Hà Nội', N'Hà Đông', N'Sinh viên năm 1, muốn kiếm thêm thu nhập');



--=========5. COMPANIES=============
INSERT INTO companies(name,description,industry,size,city,address,website,logo) VALUES
(N'The Coffee House', N'Chuỗi cà phê hàng đầu Việt Nam với không gian trẻ trung, hiện đại', N'F&B - Coffee', '200-500', N'Hà Nội', N'Số 5 Trần Thái Tông, Cầu Giấy', 'https://thecoffeehouse.com', 'tch_logo.png'),
(N'Highlands Coffee', N'Thương hiệu cà phê nổi tiếng với nhiều chi nhánh toàn quốc', N'F&B - Coffee', '500+', N'Hà Nội', N'Trường đại học FPT Hà Nội, Thạch Thất, Hoà Lạc', 'https://highlandscoffee.com.vn', 'highlands_logo.png'),
(N'CGV Cinemas', N'Hệ thống rạp chiếu phim hiện đại nhất Việt Nam', N'Entertainment', '500+', N'Hà Nội', N'Vincom Metropolis, 29 Liễu Giai', 'https://cgv.vn', 'cgv_logo.png'),
(N'Lotteria', N'Chuỗi nhà hàng thức ăn nhanh phong cách Hàn Quốc', N'F&B - Fast Food', '200-500', N'Hà Nội', N'246 Phố Huế, Hai Bà Trưng', 'https://lotteria.vn', 'lotteria_logo.png'),
(N'Circle K', N'Chuỗi cửa hàng tiện lợi 24/7 phục vụ nhu cầu sinh hoạt hàng ngày', N'Retail', '500+', N'Hà Nội', N'Số 1 Nguyễn Trãi, Thanh Xuân', 'https://circlek.vn', 'circlek_logo.png');


-- ========== 6. EMPLOYERS ==========
INSERT INTO employers (companyID, userID) VALUES
(1, 7),  -- The Coffee House
(2, 8),  -- Highlands Coffee
(3, 9),  -- CGV Cinemas
(4, 10), -- Lotteria
(5, 11); -- Circle K


-- ========== 7. JOB STATUSES ==========
INSERT INTO jobStatuses (statusCode) VALUES
('PENDING'),
('APPROVED'),
('CLOSED');

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


-- ========== 10. CATEGORIES ==========
INSERT INTO categories (categoryName) VALUES
(N'Phục vụ bàn'),
(N'Pha chế'),
(N'Thu ngân'),
(N'Bán hàng'),
(N'Marketing'),
(N'Kho vận'),
(N'Giao hàng'),
(N'Nhân viên văn phòng'),
(N'Dạy kèm'),
(N'IT Support');


-- ========== 11. TAGS ==========
INSERT INTO tags (tagName) VALUES
(N'Linh hoạt'),
(N'Cuối tuần'),
(N'Ca tối'),
(N'Gần trường'),
(N'Lương cao'),
(N'Môi trường trẻ'),
(N'Có đào tạo'),
(N'Remote');


-- ========== 14. JOBS ==========
INSERT INTO jobs (companyID, createdBy, title, description, requirements, benefits, city, address, 
    shift_info, hours_per_week_min, hours_per_week_max, is_evening_shift, is_weekend_shift, 
    work_format, pay_type, pay_rate, salary_min, salary_max, 
    numberOfPositions, contactEmail, contactPhone, deadline, statusID, typeID) 
VALUES
-- The Coffee House
(1, 7, N'Nhân viên pha chế part-time', 
N'Tuyển nhân viên pha chế làm việc theo ca, phục vụ khách hàng tại cửa hàng',
N'- Sinh viên năm 2 trở lên\n- Giao tiếp tốt, vui vẻ\n- Yêu thích cà phê\n- Có thể làm ca tối và cuối tuần',
N'- Lương cạnh tranh + tip\n- Được đào tạo kỹ năng pha chế\n- Môi trường trẻ trung\n- Được uống free đồ uống',
N'Hà Nội', N'Số 5 Trần Thái Tông, Cầu Giấy',
N'Ca sáng: 7h-11h, Ca chiều: 14h-18h, Ca tối: 18h-22h', 
12, 20, 1, 1, 'ONSITE', 'HOURLY', 25000, NULL, NULL,
3, 'tuyen.dung@thecoffeehouse.vn', '0967890123', '2025-11-30', 2, 1),

-- Highlands Coffee
(2, 8, N'Nhân viên phục vụ cuối tuần',
N'Tuyển nhân viên phục vụ làm việc cuối tuần tại cửa hàng Highlands Coffee Vincom',
N'- Sinh viên đang học\n- Nhiệt tình, năng động\n- Có kinh nghiệm là lợi thế',
N'- Lương 30k/giờ\n- Thưởng doanh thu\n- Free đồ ăn, uống\n- Discount 30% cho nhân viên',
N'Hà Nội', N'Trường đại học FPT Hà Nội, Thạch Thất, Hoà Lạc',
N'Thứ 7-CN: 8h-20h (làm cả ngày hoặc nửa ngày)', 
8, 16, 0, 1, 'ONSITE', 'HOURLY', 30000, NULL, NULL,
5, 'recruit@highlands.vn', '0978901234', '2025-12-15', 2, 2),

-- CGV Cinemas
(3, 9, N'Nhân viên bán vé và bắp nước',
N'CGV Metropolis tuyển nhân viên bán vé, bắp nước làm ca tối và cuối tuần',
N'- Sinh viên, học sinh\n- Cao từ 1m55 trở lên\n- Ngoại hình khá, giao tiếp tốt\n- Sử dụng máy tính cơ bản',
N'- Lương: 4-5 triệu/tháng (tùy giờ làm)\n- Được xem phim miễn phí\n- Môi trường hiện đại, chuyên nghiệp\n- Có cơ hội thăng tiến',
N'Hà Nội', N'Vincom Metropolis, 29 Liễu Giai',
N'Ca chiều: 14h-18h, Ca tối: 18h-23h', 
16, 24, 1, 1, 'ONSITE', 'SHIFT', 35000, 4000000, 5000000,
4, 'hiring@cgv.vn', '0989012345', '2025-11-20', 2, 1),

-- Lotteria
(4, 10, N'Nhân viên phục vụ thức ăn nhanh',
N'Lotteria Phố Huế cần tuyển nhân viên phục vụ, thu ngân làm part-time',
N'- Sinh viên từ 18 tuổi trở lên\n- Nhanh nhẹn, chịu được áp lực\n- Có thể làm giờ cao điểm',
N'- Lương 28k/giờ + thưởng KPI\n- Được ăn ca\n- Đào tạo kỹ năng bán hàng\n- Tăng ca được tính thêm',
N'Hà Nội', N'246 Phố Huế, Hai Bà Trưng',
N'Giờ cao điểm: 11h-13h30, 17h-20h', 
10, 20, 1, 1, 'ONSITE', 'HOURLY', 28000, NULL, NULL,
6, 'hr@lotteria.vn', '0990123456', '2025-12-31', 2, 3),

-- Circle K
(5, 11, N'Nhân viên cửa hàng ca tối',
N'Circle K tuyển nhân viên làm ca tối, công việc bán hàng và sắp xếp kệ',
N'- Ưu tiên nam\n- Không yêu cầu kinh nghiệm\n- Chịu được ca đêm\n- Trung thực, cẩn thận',
N'- Lương: 5-6 triệu/tháng\n- Phụ cấp ca đêm\n- Được đào tạo bài bản\n- Discount 20% sản phẩm',
N'Hà Nội', N'Số 1 Nguyễn Trãi, Thanh Xuân',
N'Ca tối: 16h-00h, Ca đêm: 23h-7h', 
20, 32, 1, 0, 'ONSITE', 'SHIFT', 40000, 5000000, 6000000,
2, 'contact@circlek.vn', '0901234568', '2025-10-31', 2, 1),

-- More jobs...
(1, 7, N'Nhân viên thu ngân - The Coffee House',
N'Tuyển thu ngân làm việc linh hoạt, xử lý thanh toán và chăm sóc khách hàng',
N'- Am hiểu tiền tệ, tính toán nhanh\n- Trung thực, cẩn thận\n- Biết sử dụng máy POS',
N'- Lương 30k/giờ\n- Thưởng theo doanh thu\n- Môi trường thân thiện',
N'Hà Nội', N'Times City, Hai Bà Trưng',
N'Ca linh hoạt theo sắp xếp', 
8, 16, 1, 1, 'ONSITE', 'HOURLY', 30000, NULL, NULL,
2, 'tuyen.dung@thecoffeehouse.vn', '0967890123', '2025-11-30', 2, 3),

(2, 8, N'Nhân viên kho - Highlands Coffee',
N'Tuyển nhân viên kho kiêm giao hàng nội bộ giữa các chi nhánh',
N'- Nam, khỏe mạnh\n- Có xe máy, biết đường HN\n- Chăm chỉ, trách nhiệm',
N'- Lương 6 triệu/tháng\n- Hỗ trợ xăng xe\n- Nghỉ chủ nhật',
N'Hà Nội', N'Kho Highlands - Long Biên',
N'Thứ 2-7: 8h-17h', 
40, 40, 0, 0, 'ONSITE', 'SHIFT', NULL, 6000000, 6000000,
1, 'recruit@highlands.vn', '0978901234', '2025-10-25', 2, 1);



-- ========== 15. JOB CATEGORIES ==========
INSERT INTO jobCategories (jobID, categoryID) VALUES
(1, 2), -- Pha chế
(2, 1), -- Phục vụ bàn
(3, 3), (3, 4), -- Thu ngân, Bán hàng
(4, 1), (4, 3), -- Phục vụ, Thu ngân
(5, 4), -- Bán hàng
(6, 3), -- Thu ngân
(7, 6); -- Kho vận



-- ========== 16. JOB TAGS ==========
INSERT INTO jobTags (jobID, tagID) VALUES
(1, 1), (1, 3), (1, 6), (1, 7), -- Linh hoạt, Ca tối, Môi trường trẻ, Có đào tạo
(2, 2), (2, 5), (2, 6), -- Cuối tuần, Lương cao, Môi trường trẻ
(3, 1), (3, 3), (3, 5), -- Linh hoạt, Ca tối, Lương cao
(4, 1), (4, 3), (4, 7), -- Linh hoạt, Ca tối, Có đào tạo
(5, 3), (5, 5), (5, 7), -- Ca tối, Lương cao, Có đào tạo
(6, 1), (6, 6), -- Linh hoạt, Môi trường trẻ
(7, 7); -- Có đào tạo


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
INSERT INTO SystemLog (userID, action, description, createdAt) VALUES
(1, 'LOGIN', 'Admin đăng nhập hệ thống', '2025-10-03 08:00:00'),
(2, 'APPLY_JOB', 'Student ứng tuyển job ID: 1', '2025-10-01 10:30:00'),
(7, 'CREATE_JOB', 'Employer tạo tin tuyển dụng mới', '2025-09-25 14:00:00'),
(2, 'UPDATE_PROFILE', 'Student cập nhật profile', '2025-10-02 16:00:00'),
(7, 'APPROVE_APPLICATION', 'Employer duyệt đơn ứng tuyển ID: 1', '2025-10-02 10:00:00');





-- ===== THỐNG KÊ =====
DECLARE 
  @Users        INT,
  @Students     INT,
  @Companies    INT,
  @Jobs         INT,
  @Applications INT,
  @Reviews      INT = 0;  -- mặc định 0 nếu không có bảng

SELECT @Users        = COUNT(*) FROM dbo.users;
SELECT @Students     = COUNT(*) FROM dbo.studentProfile;
SELECT @Companies    = COUNT(*) FROM dbo.companies;
SELECT @Jobs         = COUNT(*) FROM dbo.jobs;
SELECT @Applications = COUNT(*) FROM dbo.applications;

-- Nếu có bảng companyReviews thì mới đếm
IF OBJECT_ID('dbo.companyReviews', 'U') IS NOT NULL
  SELECT @Reviews = COUNT(*) FROM dbo.companyReviews;

PRINT N'✅ ĐÃ INSERT DATA THÀNH CÔNG!';
PRINT N'';
PRINT N'📊 THỐNG KÊ:';
PRINT N'- Users: '         + CAST(@Users        AS NVARCHAR(20));
PRINT N'- Students: '      + CAST(@Students     AS NVARCHAR(20));
PRINT N'- Companies: '     + CAST(@Companies    AS NVARCHAR(20));
PRINT N'- Jobs: '          + CAST(@Jobs         AS NVARCHAR(20));
PRINT N'- Applications: '  + CAST(@Applications AS NVARCHAR(20));
PRINT N'- Reviews: '       + CAST(@Reviews      AS NVARCHAR(20));
PRINT N'';
PRINT N'🔐 THÔNG TIN ĐĂNG NHẬP:';
PRINT N'Admin:    admin@system.com / 123456';
PRINT N'Student:  student1@fpt.edu.vn / 123456';
PRINT N'Employer: hr@thecoffeehouse.vn / 123456';






SELECT * FROM users 
-- Xóa records test sai
--DELETE FROM users WHERE email LIKE 'student13@fpt.edu.vn' OR fullName IS NULL;

-- Reset identity về số cuối cùng hợp lệ
--DBCC CHECKIDENT('users', RESEED, 11); -- Hoặc số ID cuối cùng hợp lệ


select j.*, c.name as companyName, c.logo as companyLogo, js.statusCode, jt.typeCode from jobs j 
                    join jobStatuses js 
                    on j.statusID = js.statusID
                    join jobTypes jt on jt.typeID = j.typeID
                    join companies c on c.companyID = j.companyID
                    where js.statusCode = 'APPROVED' AND j.deadline >= GETDATE()
                    ORDER BY j.createdAt DESC