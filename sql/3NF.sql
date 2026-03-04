USE CollegeClubDB;

CREATE TABLE IF NOT EXISTS Student (
    StudentID    INT PRIMARY KEY,
    StudentName  VARCHAR(50) NOT NULL,
    Email        VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Club (
    ClubID       INT PRIMARY KEY AUTO_INCREMENT,
    ClubName     VARCHAR(50) NOT NULL UNIQUE,
    ClubRoom     VARCHAR(10),
    ClubMentor   VARCHAR(50)
);

CREATE TABLE IF NOT EXISTS Membership (
    StudentID    INT NOT NULL,
    ClubID       INT NOT NULL,
    JoinDate     DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID)   REFERENCES Club(ClubID)   ON DELETE CASCADE
);

INSERT IGNORE INTO Student (StudentID, StudentName, Email) VALUES
(1, 'Asha',   'asha@email.com'),
(2, 'Bikash', 'bikash@email.com'),
(3, 'Nisha',  'nisha@email.com'),
(4, 'Rohan',  'rohan@email.com'),
(5, 'Suman',  'suman@email.com'),
(6, 'Pooja',  'pooja@email.com'),
(7, 'Aman',   'aman@email.com');

INSERT IGNORE INTO Club (ClubName, ClubRoom, ClubMentor) VALUES
('Music Club',   'R101', 'Mr. Raman'),
('Sports Club',  'R202', 'Ms. Sita'),
('Drama Club',   'R303', 'Mr. Kiran'),
('Coding Club',  'Lab1', 'Mr. Anil');

INSERT IGNORE INTO Membership (StudentID, ClubID, JoinDate) VALUES
(1, 1, '2024-01-10'),  -- Asha → Music
(2, 2, '2024-01-12'),  -- Bikash → Sports
(1, 2, '2024-01-15'),  -- Asha → Sports
(3, 1, '2024-01-20'),  -- Nisha → Music
(4, 3, '2024-01-18'),  -- Rohan → Drama
(5, 1, '2024-01-22'),  -- Suman → Music
(2, 3, '2024-01-25'),  -- Bikash → Drama
(6, 2, '2024-01-27'),  -- Pooja → Sports
(3, 4, '2024-01-28'),  -- Nisha → Coding
(7, 4, '2024-01-30');  -- Aman → Coding