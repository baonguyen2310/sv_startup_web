-- 3 hình thức thu:
-- 1 - free + quảng cáo
-- 2 - premium có thời hạn
-- 3 - gold, ruby

CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL,
    Password VARCHAR(255) NOT NULL,
    Role TEXT NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15),
    BirthDate DATE,  -- Ngày sinh của người dùng
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    PremiumPackageID INT,
    ChildName VARCHAR(50),  -- Tên của trẻ (nếu áp dụng)
    ChildBirthDate DATE,  -- Ngày sinh của trẻ (nếu áp dụng)
    GoldBalance INT DEFAULT 0,
    RubyBalance INT DEFAULT 0,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (PremiumPackageID) REFERENCES PremiumPackages(PackageID)
);

CREATE TABLE Games (
    GameID INT AUTO_INCREMENT PRIMARY KEY,
    GameName VARCHAR(255) NOT NULL,
    Description TEXT,
    Status ENUM('Active', 'Inactive', 'Beta', 'Archived') DEFAULT 'Active', -- tiện cho việc hiển thị sau này
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE Levels (
    LevelID INT AUTO_INCREMENT PRIMARY KEY,
    GameID INT NOT NULL,  -- Trường GameID để xác định trò chơi mà cấp độ thuộc về
    LevelName VARCHAR(255) NOT NULL,
    Description TEXT,
    RequireScore INT,
    LimitTime INT,
    GoldReward INT,
    Status ENUM('Active', 'Inactive', 'Beta', 'Archived') DEFAULT 'Active', -- tiện cho việc hiển thị sau này
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (GameID) REFERENCES Games (GameID)  -- Liên kết với bảng Games
);

CREATE TABLE LevelContent (
    ContentID INT AUTO_INCREMENT PRIMARY KEY,
    LevelID INT NOT NULL,  -- Trường LevelID để xác định màn chơi
    ContentName VARCHAR(255),  -- Tên của nội dung
    ContentType ENUM('Text', 'Image', 'Audio', 'Video', 'Other') NOT NULL,  -- Loại nội dung (văn bản, hình ảnh, âm thanh, video, và loại khác)
    Content TEXT,  -- Dữ liệu nội dung (văn bản hoặc đường dẫn tới tệp đa phương tiện)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (LevelID) REFERENCES GameLevels (LevelID)  -- Liên kết với bảng GameLevels
);


CREATE TABLE UnlockMethodLevel (
    UnlockMethodLevelID INT AUTO_INCREMENT PRIMARY KEY,
    LevelID INT NOT NULL,
    Method VARCHAR(255) NOT NULL,  -- Ví dụ: Gold, Ruby, Both, In-App Purchase, ...
    Amount INT NOT NULL,  -- Số lượng cần (ví dụ: số tiền Gold hoặc Ruby cần)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (LevelID) REFERENCES Levels (LevelID)
);

CREATE TABLE UserLevelUnlocked (
    UserLevelUnlockedID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- Trường UserID để xác định người dùng
    LevelID INT NOT NULL,  -- Trường LevelID để xác định cấp độ
    Unlocked BOOLEAN DEFAULT false,  -- Trường Unlocked để xác định xem cấp độ đã được mở hay chưa
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),  -- Liên kết với bảng Users
    FOREIGN KEY (LevelID) REFERENCES Levels (LevelID)  -- Liên kết với bảng Levels
);

-- Các gói premium sẽ luôn mở được tất cả màn chơi trong thời hạn của gói
CREATE TABLE PremiumPackages (
    PremiumPackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageName VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Currency VARCHAR(20) NOT NULL,  -- Loại tiền tệ (ví dụ: USD)
    DurationInDays INT NOT NULL,  -- Thời hạn của gói premium trong ngày
    IsActive BOOLEAN DEFAULT true,  -- Trạng thái hoạt động
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

-- Các gói mua vàng và ruby
CREATE TABLE PurchasePackages (
    PackageID INT AUTO_INCREMENT PRIMARY KEY,
    PackageName VARCHAR(255) NOT NULL,
    Description TEXT,
    Price DECIMAL(10, 2) NOT NULL,
    Currency VARCHAR(20) NOT NULL,  -- Loại tiền tệ (ví dụ: USD)
    IsActive BOOLEAN DEFAULT true,  -- Trạng thái hoạt động
    GoldAmount INT NOT NULL,  -- Số lượng vàng trong gói
    RubyAmount INT NOT NULL,  -- Số lượng ruby trong gói
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE PurchasePremiumTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- ID của người dùng thực hiện giao dịch
    PremiumPackageID INT NOT NULL,  -- ID của gói premium được mua
    Amount DECIMAL(10, 2) NOT NULL,  -- Số tiền được thanh toán
    Currency VARCHAR(20) NOT NULL,  -- Loại tiền tệ (ví dụ: USD)
    PaymentMethod VARCHAR(50),  -- Phương thức thanh toán (ví dụ: Visa, MasterCard, PayPal)
    TransactionStatus ENUM('Pending', 'Completed', 'Failed') NOT NULL,  -- Trạng thái giao dịch
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE PurchasePackageTransactions (
    TransactionID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- ID của người dùng thực hiện giao dịch
    PackageID INT NOT NULL,  -- ID của gói vàng/ruby được mua
    Amount DECIMAL(10, 2) NOT NULL,  -- Số tiền được thanh toán
    Currency VARCHAR(20) NOT NULL,  -- Loại tiền tệ (ví dụ: USD)
    PaymentMethod VARCHAR(50),  -- Phương thức thanh toán (ví dụ: Visa, MasterCard, PayPal)
    TransactionStatus ENUM('Pending', 'Completed', 'Failed') NOT NULL,  -- Trạng thái giao dịch
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- BẢNG NÀY DÙNG ĐỂ HIỂN THỊ TRONG GAME
CREATE TABLE PlayerLevelArchieve (
    PlayerLevelArchieveID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- Trường UserID để xác định người chơi
    LevelID INT NOT NULL,  -- Trường LevelID để xác định cấp độ
    IsCompleted BOOLEAN DEFAULT false,  -- Trường IsCompleted để xác định xem người chơi đã hoàn thành màn đó hay chưa
    BestScore INT,  -- Trường Score để lưu trữ điểm số hoặc tiến độ cụ thể (nếu có)
    BestTime INT,
    HasReceivedReward BOOLEAN DEFAULT false,  -- Trường HasReceivedReward để xác định xem người chơi đã nhận thưởng từ màn này chưa
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),  -- Liên kết với bảng Users
    FOREIGN KEY (LevelID) REFERENCES Levels (LevelID)  -- Liên kết với bảng Levels
);

-- BẢNG NÀY DÙNG ĐỂ THU THẬP DỮ LIỆU CHO HỌC SÂU
CREATE TABLE PlayerLevelHistory (
    PlayerLevelArchieveID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- Trường UserID để xác định người chơi
    LevelID INT NOT NULL,  -- Trường LevelID để xác định cấp độ
    StartTime TIMESTAMP NOT NULL,  -- Thời gian bắt đầu lần chơi
    EndTime TIMESTAMP NOT NULL,  -- Thời gian kết thúc lần chơi
    Score INT,  -- Điểm số của người chơi trong lần chơi
    PlayResult ENUM('Win', 'Lose', 'Draw', 'Incomplete'),  -- Kết quả của lần chơi
    AdditionalInfo TEXT,  -- Thông tin bổ sung (ví dụ: hành động của người chơi, thao tác, v.v.)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),  -- Liên kết với bảng Users
    FOREIGN KEY (LevelID) REFERENCES Levels (LevelID)  -- Liên kết với bảng Levels
);

-- THU THẬP DỮ LIỆU CHO HỌC SÂU DỰA VÀO CÂU HỎI KHẢO SÁT TÌNH TRẠNG CỦA TRẺ
CREATE TABLE SurveyQuestions (
    QuestionID INT AUTO_INCREMENT PRIMARY KEY,
    QuestionText TEXT NOT NULL,  -- Văn bản câu hỏi
    SurveyType ENUM('SingleChoice', 'MultipleChoice', 'TextAnswer') NOT NULL,  -- Loại câu hỏi (lựa chọn một, lựa chọn nhiều, hoặc trả lời bằng văn bản)
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
);

CREATE TABLE SurveyAnswers (
    AnswerID INT AUTO_INCREMENT PRIMARY KEY,
    QuestionID INT NOT NULL,  -- Trường QuestionID để xác định câu hỏi mà câu trả lời liên quan đến
    AnswerText TEXT NOT NULL,  -- Văn bản câu trả lời
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (QuestionID) REFERENCES SurveyQuestions (QuestionID)
);

CREATE TABLE ChildSurveys (
    SurveyID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- Trường UserID để xác định người dùng (phụ huynh)
    SurveyDate DATE NOT NULL,  -- Ngày phiếu khảo sát
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),  -- Liên kết với bảng Users (phụ huynh)
    FOREIGN KEY (ChildID) REFERENCES Children (ChildID)  -- Liên kết với bảng Children (trẻ)
);

CREATE TABLE SurveyResponses (
    ResponseID INT AUTO_INCREMENT PRIMARY KEY,
    SurveyID INT NOT NULL,  -- Trường SurveyID để xác định phiếu khảo sát
    QuestionID INT NOT NULL,  -- Trường QuestionID để xác định câu hỏi
    AnswerID INT,  -- Trường AnswerID để xác định câu trả lời (nếu có)
    TextAnswer TEXT,  -- Trường TextAnswer để lưu câu trả lời bằng văn bản
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (SurveyID) REFERENCES ChildSurveys (SurveyID),  -- Liên kết với bảng ChildSurveys
    FOREIGN KEY (QuestionID) REFERENCES SurveyQuestions (QuestionID),
    FOREIGN KEY (AnswerID) REFERENCES SurveyAnswers (AnswerID)
);


-- BẢNG LỘ TRÌNH ĐỀ XUẤT ĐƯỢC CẬP NHẬT THEO SỰ THAY ĐỔI CỦA BẢNG LỊCH SỬ CHƠI
-- CÓ THỂ GHI CHỒNG
CREATE TABLE ProposedPlaySchedule (
    ScheduleID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- Trường UserID để xác định người chơi (trẻ)
    ProposedDate DATE NOT NULL,  -- Ngày đề xuất chơi
    LevelID INT NOT NULL,  -- Trường LevelID để xác định cấp độ hoặc màn chơi
    RecommendedPlayTime INT,  -- Thời gian đề xuất để chơi màn chơi (đơn vị thời gian tùy chọn, ví dụ: phút)
    RecommendedScore INT,  -- Số điểm cần đạt được
    Description TEXT,  -- Mô tả hoặc ghi chú (tùy chọn),
    IsCompleted BOOLEAN DEFAULT false,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UpdatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users (UserID),  -- Liên kết với bảng Users
    FOREIGN KEY (LevelID) REFERENCES Levels (LevelID)  -- Liên kết với bảng Levels
);

CREATE TABLE Notifications (
    NotificationID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT NOT NULL,  -- ID của người dùng nhận thông báo
    Title VARCHAR(255) NOT NULL,  -- Tiêu đề thông báo
    Message TEXT NOT NULL,  -- Nội dung thông báo
    IsRead BOOLEAN DEFAULT false,  -- Trạng thái đã đọc hoặc chưa đọc
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


-- CÒN CÁC TÍNH NĂNG BỔ SUNG SAU:
-- KẾT BẠN, NHẮN TIN VÀ CHƠI ONLINE

-- QUẢNG CÁO KHÔNG CẦN TẠO BẢNG, CHỈ CẦN CẬP NHẬT SỐ VÀNG SAU KHI XEM QUẢNG CÁO BẰNG API
-- TUY NHIÊN, CẦN GIỚI HẠN SỐ LẦN XEM QUẢNG CÁO, KIỂM TRA TÍNH TOÀN VẸN CỦA DỮ LIỆU
-- SAU NÀY CÓ THỂ THÊM BẢNG LỊCH SỬ XEM QUẢNG CÁO

