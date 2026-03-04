-- 1. Create the database

USE CollegeClubDB;


-- Step 1: Unnormalized table (close to 1NF)

CREATE TABLE ClubMembership_1NF (
    StudentID    INT          NOT NULL,
    StudentName  VARCHAR(50),
    Email        VARCHAR(100),
    ClubName     VARCHAR(50)  NOT NULL,
    ClubRoom     VARCHAR(10),
    ClubMentor   VARCHAR(50),
    JoinDate     DATE,
    PRIMARY KEY (StudentID, ClubName)
);

-- Insert original data (fixed typo: ADIING → INSERT, dates in YYYY-MM-DD)
INSERT INTO ClubMembership_1NF (StudentID, StudentName, Email, ClubName, ClubRoom, ClubMentor, JoinDate) VALUES
(1, 'Asha',   'asha@email.com',   'Music Club',  'R101', 'Mr. Raman', '2024-01-10'),
(2, 'Bikash', 'bikash@email.com', 'Sports Club', 'R202', 'Ms. Sita',  '2024-01-12'),
(1, 'Asha',   'asha@email.com',   'Sports Club', 'R202', 'Ms. Sita',  '2024-01-15'),
(3, 'Nisha',  'nisha@email.com',  'Music Club',  'R101', 'Mr. Raman', '2024-01-20'),
(4, 'Rohan',  'rohan@email.com',  'Drama Club',  'R303', 'Mr. Kiran', '2024-01-18'),
(5, 'Suman',  'suman@email.com',  'Music Club',  'R101', 'Mr. Raman', '2024-01-22'),
(2, 'Bikash', 'bikash@email.com', 'Drama Club',  'R303', 'Mr. Kiran', '2024-01-25'),
(6, 'Pooja',  'pooja@email.com',  'Sports Club', 'R202', 'Ms. Sita',  '2024-01-27'),
(3, 'Nisha',  'nisha@email.com',  'Coding Club', 'Lab1', 'Mr. Anil',  '2024-01-28'),
(7, 'Aman',   'aman@email.com',   'Coding Club', 'Lab1', 'Mr. Anil',  '2024-01-30');

-- Step 2: Normalize to 2NF / 3NF (final schema)


-- Student table (depends only on StudentID)
CREATE TABLE Student (
    StudentID   INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Email       VARCHAR(100) UNIQUE NOT NULL
);

-- Club table (depends only on ClubID)
CREATE TABLE Club (
    ClubID      INT PRIMARY KEY AUTO_INCREMENT,
    ClubName    VARCHAR(50) NOT NULL UNIQUE,
    ClubRoom    VARCHAR(10),
    ClubMentor  VARCHAR(50)
);

-- Membership table (junction table for many-to-many)
CREATE TABLE Membership (
    StudentID   INT NOT NULL,
    ClubID      INT NOT NULL,
    JoinDate    DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID)   REFERENCES Club(ClubID)   ON DELETE CASCADE
);

-- Populate Student table (unique students)
INSERT IGNORE INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha',   'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha',  'nisha@email.com'),
(4, 'Rohan',  'rohan@email.com'),
(5, 'Suman',  'suman@email.com'),
(6, 'Pooja',  'pooja@email.com'),
(7, 'Aman',   'aman@email.com');

-- Populate Club table (unique clubs)
INSERT IGNORE INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club',  'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club',  'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');

-- Populate Membership table (using ClubID from above)
-- ClubID 1 = Music, 2 = Sports, 3 = Drama, 4 = Coding
INSERT IGNORE INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-01-10'),   -- Asha → Music
(2, 2, '2024-01-12'),   -- Bikash → Sports
(1, 2, '2024-01-15'),   -- Asha → Sports
(3, 1, '2024-01-20'),   -- Nisha → Music
(4, 3, '2024-01-18'),   -- Rohan → Drama
(5, 1, '2024-01-22'),   -- Suman → Music
(2, 3, '2024-01-25'),   -- Bikash → Drama
(6, 2, '2024-01-27'),   -- Pooja → Sports
(3, 4, '2024-01-28'),   -- Nisha → Coding
(7, 4, '2024-01-30');   -- Aman → Coding

-- =============================================
-- Optional: Verify the data
-- =============================================
SELECT 'Students' AS TableName, COUNT(*) AS RowCount FROM Student
UNION ALL
SELECT 'Clubs',     COUNT(*) FROM Club
UNION ALL
SELECT 'Memberships', COUNT(*) FROM Membership;

-- Example JOIN query (shows student names with clubs)
SELECT 
    s.StudentID,
    s.StudentName,
    c.ClubName,
    m.JoinDate
FROM Student s
JOIN Membership m ON s.StudentID = m.StudentID
JOIN Club c ON m.ClubID = c.ClubID
ORDER BY s.StudentName, m.JoinDate;