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