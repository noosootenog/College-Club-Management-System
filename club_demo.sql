-- club_demo.sql - Full script for College Club Management Database
-- Creates normalized tables, loads sample data, and includes required queries

CREATE DATABASE IF NOT EXISTS college;
USE college;

-- Student Table (student details only)
CREATE TABLE IF NOT EXISTS Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL
);

-- Club Table (club details only)
CREATE TABLE IF NOT EXISTS Club (
    ClubID INT PRIMARY KEY AUTO_INCREMENT,
    ClubName VARCHAR(50) NOT NULL UNIQUE,
    ClubRoom VARCHAR(20),
    ClubMentor VARCHAR(50)
);

--Membership Table (junction for many-to-many)
CREATE TABLE IF NOT EXISTS Membership (
    StudentID INT NOT NULL,
    ClubID INT NOT NULL,
    JoinDate DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID) ON DELETE CASCADE
);

-- Insert unique clubs (from your original table)
INSERT IGNORE INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club', 'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club', 'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');

-- Insert unique students
INSERT IGNORE INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha', 'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha', 'nisha@email.com'),
(4, 'Rohan', 'rohan@email.com'),
(5, 'Suman', 'suman@email.com'),
(6, 'Pooja', 'pooja@email.com'),
(7, 'Aman', 'aman@email.com');

-- Insert memberships (matching your original data - dates adjusted to YYYY-MM-DD)
INSERT IGNORE INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-10-01'),   -- Asha → Music
(2, 2, '2024-12-01'),   -- Bikash → Sports
(1, 2, '2024-01-15'),   -- Asha → Sports
(3, 1, '2024-01-20'),   -- Nisha → Music
(4, 3, '2024-01-18'),   -- Rohan → Drama
(5, 1, '2024-01-22'),   -- Suman → Music
(2, 3, '2024-01-25'),   -- Bikash → Drama
(6, 2, '2024-01-27'),   -- Pooja → Sports
(3, 4, '2024-01-28'),   -- Nisha → Coding
(7, 4, '2024-01-30');   -- Aman → Coding

-- Task 4: Insert examples
INSERT INTO Student (StudentID, StudentName, Email) 
VALUES (8, 'New Student', 'new@email.com')
ON DUPLICATE KEY UPDATE StudentName = 'New Student', Email = 'new@email.com';

INSERT INTO Club (ClubName, ClubRoom, ClubMentor) 
VALUES ('Art Club', 'R404', 'Ms. Priya')
ON DUPLICATE KEY UPDATE ClubRoom = 'R404', ClubMentor = 'Ms. Priya';

-- Display all students
SELECT * FROM Student;

-- Display all clubs
SELECT * FROM Club;

-- Task 5: JOIN query - Student Name, Club Name, Join Date
SELECT 
    s.StudentName,
    c.ClubName,
    m.JoinDate
FROM Student s
JOIN Membership m ON s.StudentID = m.StudentID
JOIN Club c ON m.ClubID = c.ClubID
ORDER BY s.StudentName, m.JoinDate;