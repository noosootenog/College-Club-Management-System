USE CollegeClubDB;
CREATE TABLE Student (
    StudentID INT PRIMARY KEY,
    StudentName VARCHAR(50),
    Email VARCHAR(100)
);
INSERT INTO Student VALUES
(1, 'Asha', 'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha', 'nisha@email.com'),
(4, 'Rohan', 'rohan@email.com'),
(5, 'Suman', 'suman@email.com'),
(6, 'Pooja', 'pooja@email.com'),
(7, 'Aman', 'aman@email.com');


CREATE TABLE Club (
    ClubID INT PRIMARY KEY AUTO_INCREMENT,
    ClubName VARCHAR(50),
    ClubRoom VARCHAR(10),
    ClubMentor VARCHAR(50)
);
INSERT INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club', 'R101', 'Mr. Raman'),
('Sports Club', 'R202', 'Ms. Sita'),
('Drama Club', 'R303', 'Mr. Kiran'),
('Coding Club', 'Lab1', 'Mr. Anil');


CREATE TABLE Membership (
    StudentID INT,
    ClubID INT,
    JoinDate DATE,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID),
    FOREIGN KEY (ClubID) REFERENCES Club(ClubID)
);
INSERT INTO Membership VALUES
(1, 1, '2024-01-10'),
(2, 2, '2024-01-12'),
(1, 2, '2024-01-15'),
(3, 1, '2024-01-20'),
(4, 3, '2024-01-18'),
(5, 1, '2024-01-22'),
(2, 3, '2024-01-25'),
(6, 2, '2024-01-27'),
(3, 4, '2024-01-28'),
(7, 4, '2024-01-30');

