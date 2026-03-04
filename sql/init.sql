-- College Club Membership Management System
-- Drop this file into your Docker MySQL container
-- Compatible with: docker-compose.yml (MySQL 8.0, CollegeClubDB)

CREATE DATABASE IF NOT EXISTS CollegeClubDB;
USE CollegeClubDB;


-- TASK 2 STEP 1: 1NF Table (unnormalized, single table)


DROP TABLE IF EXISTS ClubMembership_1NF;
CREATE TABLE ClubMembership_1NF (
    StudentID   INT          NOT NULL,
    StudentName VARCHAR(50),
    Email       VARCHAR(100),
    ClubName    VARCHAR(50)  NOT NULL,
    ClubRoom    VARCHAR(10),
    ClubMentor  VARCHAR(50),
    JoinDate    DATE,
    PRIMARY KEY (StudentID, ClubName)  -- composite key, no single PK possible
);

INSERT INTO ClubMembership_1NF VALUES
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


-- TASK 2 STEP 2 & 3: 2NF / 3NF Normalized Tables


DROP TABLE IF EXISTS Membership;
DROP TABLE IF EXISTS Student;
DROP TABLE IF EXISTS Club;

CREATE TABLE Student (
    StudentID   INT          PRIMARY KEY,
    StudentName VARCHAR(50)  NOT NULL,
    Email       VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE Club (
    ClubID     INT         PRIMARY KEY AUTO_INCREMENT,
    ClubName   VARCHAR(50) NOT NULL UNIQUE,
    ClubRoom   VARCHAR(10),
    ClubMentor VARCHAR(50)
);

CREATE TABLE Membership (
    StudentID INT  NOT NULL,
    ClubID    INT  NOT NULL,
    JoinDate  DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID)    REFERENCES Club(ClubID)       ON DELETE CASCADE
);


-- Seed Data


INSERT INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha',   'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha',  'nisha@email.com'),
(4, 'Rohan',  'rohan@email.com'),
(5, 'Suman',  'suman@email.com'),
(6, 'Pooja',  'pooja@email.com'),
(7, 'Aman',   'aman@email.com');

INSERT INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club',  'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club',  'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');

-- ClubID: 1=Music, 2=Sports, 3=Drama, 4=Coding
INSERT INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-01-10'),  -- Asha    → Music
(2, 2, '2024-01-12'),  -- Bikash  → Sports
(1, 2, '2024-01-15'),  -- Asha    → Sports
(3, 1, '2024-01-20'),  -- Nisha   → Music
(4, 3, '2024-01-18'),  -- Rohan   → Drama
(5, 1, '2024-01-22'),  -- Suman   → Music
(2, 3, '2024-01-25'),  -- Bikash  → Drama
(6, 2, '2024-01-27'),  -- Pooja   → Sports
(3, 4, '2024-01-28'),  -- Nisha   → Coding
(7, 4, '2024-01-30');  -- Aman    → Coding


-- TASK 4: Basic SQL Operations


-- 1. Insert a new student
INSERT INTO Student (StudentID, StudentName, Email)
VALUES (8, 'Srijana Thapa', 'srijana.thapa@email.com');

-- 2. Insert a new club
INSERT INTO Club (ClubName, ClubRoom, ClubMentor)
VALUES ('Debate Club', 'D105', 'Ms. Anjali Gurung');

-- 3. Display all students
SELECT StudentID, StudentName, Email
FROM Student
ORDER BY StudentID;

-- 4. Display all clubs
SELECT ClubID, ClubName, ClubRoom, ClubMentor
FROM Club
ORDER BY ClubID;


-- TASK 5: JOIN Query — Student Name, Club Name, Join Date


SELECT
    s.StudentName,
    c.ClubName,
    m.JoinDate
FROM Membership m
JOIN Student s ON m.StudentID = s.StudentID
JOIN Club    c ON m.ClubID    = c.ClubID
ORDER BY s.StudentName, m.JoinDate;


-- Verification counts

SELECT 'Students'   AS TableName, COUNT(*) AS RowCount FROM Student
UNION ALL
SELECT 'Clubs',      COUNT(*) FROM Club
UNION ALL
SELECT 'Memberships',COUNT(*) FROM Membership;