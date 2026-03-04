# Database Normalization

Normalization is the process of organizing a database to reduce data redundancy and improve data integrity. It involves decomposing a large, flat table into smaller, well-structured tables by applying a series of rules called Normal Forms.

---

## The Problem — Unnormalized Table

Before normalization, all data was stored in one flat table:

| StudentID | StudentName | Email | ClubName | ClubRoom | ClubMentor | JoinDate |
|---|---|---|---|---|---|---|
| 1 | Asha | asha@email.com | Music Club | R101 | Mr. Raman | 2024-01-10 |
| 2 | Bikash | bikash@email.com | Sports Club | R202 | Ms. Sita | 2024-01-12 |
| 1 | Asha | asha@email.com | Sports Club | R202 | Ms. Sita | 2024-01-15 |
| 3 | Nisha | nisha@email.com | Music Club | R101 | Mr. Raman | 2024-01-20 |
| 4 | Rohan | rohan@email.com | Drama Club | R303 | Mr. Kiran | 2024-01-18 |
| 5 | Suman | suman@email.com | Music Club | R101 | Mr. Raman | 2024-01-22 |
| 2 | Bikash | bikash@email.com | Drama Club | R303 | Mr. Kiran | 2024-01-25 |
| 6 | Pooja | pooja@email.com | Sports Club | R202 | Ms. Sita | 2024-01-27 |
| 3 | Nisha | nisha@email.com | Coding Club | Lab1 | Mr. Anil | 2024-01-28 |
| 7 | Aman | aman@email.com | Coding Club | Lab1 | Mr. Anil | 2024-01-30 |

**Problems with this table:**
- Asha's name and email are stored twice (rows 1 and 3)
- Music Club's room and mentor are repeated in rows 1, 4, and 6
- You cannot add a new club without a student already enrolled in it
- Deleting the only student in a club would erase all information about that club
- Changing a club mentor requires updating every row for that club

---

## First Normal Form (1NF)

### Rule
Every column must contain **atomic (indivisible) values**, there must be no repeating groups, and each row must be uniquely identifiable.

### Applied to this project
The original table already stores one value per cell (no comma-separated lists or arrays). To satisfy 1NF formally, we define a **composite primary key** since no single column can uniquely identify a row on its own.

**Primary Key:** `(StudentID, ClubName)`

```sql
CREATE TABLE ClubMembership_1NF (
    StudentID   INT         NOT NULL,
    StudentName VARCHAR(50),
    Email       VARCHAR(100),
    ClubName    VARCHAR(50) NOT NULL,
    ClubRoom    VARCHAR(10),
    ClubMentor  VARCHAR(50),
    JoinDate    DATE,
    PRIMARY KEY (StudentID, ClubName)
);
```

### What 1NF solves
- Each row is uniquely identifiable via the composite key
- No multi-valued or nested fields exist

### What 1NF does NOT solve
- Student details (StudentName, Email) are still repeated for every club a student joins
- Club details (ClubRoom, ClubMentor) are still repeated for every student in that club
- Data anomalies still exist

---

## Second Normal Form (2NF)

### Rule
The table must already be in 1NF, and **every non-key attribute must depend on the entire primary key** — not just part of it. This eliminates partial dependencies.

### Partial dependencies identified
In the 1NF table, the composite key is `(StudentID, ClubName)`:

| Attribute | Depends on |
|---|---|
| StudentName | StudentID only — partial dependency ✗ |
| Email | StudentID only — partial dependency ✗ |
| ClubRoom | ClubName only — partial dependency ✗ |
| ClubMentor | ClubName only — partial dependency ✗ |
| JoinDate | (StudentID, ClubName) — full dependency ✓ |

### Applied to this project
We split the table into three separate tables, each with its own primary key:

**Student table** — attributes that depend only on StudentID
```sql
CREATE TABLE Student (
    StudentID   INT         PRIMARY KEY,
    StudentName VARCHAR(50) NOT NULL,
    Email       VARCHAR(100) UNIQUE NOT NULL
);
```

**Club table** — attributes that depend only on ClubName (now ClubID)
```sql
CREATE TABLE Club (
    ClubID     INT         PRIMARY KEY AUTO_INCREMENT,
    ClubName   VARCHAR(50) NOT NULL UNIQUE,
    ClubRoom   VARCHAR(10),
    ClubMentor VARCHAR(50)
);
```

**Membership table** — stores only the relationship and JoinDate
```sql
CREATE TABLE Membership (
    StudentID INT  NOT NULL,
    ClubID    INT  NOT NULL,
    JoinDate  DATE NOT NULL,
    PRIMARY KEY (StudentID, ClubID),
    FOREIGN KEY (StudentID) REFERENCES Student(StudentID) ON DELETE CASCADE,
    FOREIGN KEY (ClubID)    REFERENCES Club(ClubID)       ON DELETE CASCADE
);
```

### What 2NF solves
- Student information is stored exactly once per student
- Club information is stored exactly once per club
- Updating a club mentor now requires changing only one row in the Club table
- A student can be added without joining any club
- A club can be deleted from Membership without losing its details

---

## Third Normal Form (3NF)

### Rule
The table must already be in 2NF, and **every non-key attribute must depend directly on the primary key** — not on another non-key attribute. This eliminates transitive dependencies.

### Transitive dependency check
A transitive dependency exists when: `Non-key A → Non-key B → Primary Key`

Checking each table after 2NF:

**Student table** (`StudentID` → StudentName, Email)
- StudentName depends directly on StudentID ✓
- Email depends directly on StudentID ✓
- No transitive dependencies

**Club table** (`ClubID` → ClubName, ClubRoom, ClubMentor)
- ClubName depends directly on ClubID ✓
- ClubRoom depends directly on ClubID ✓
- ClubMentor depends directly on ClubID ✓
- No transitive dependencies

**Membership table** (`StudentID, ClubID` → JoinDate)
- JoinDate depends on the full composite key ✓
- No transitive dependencies

### Applied to this project
No further splitting is required. The 2NF schema is already in 3NF. We add stricter constraints to enforce data integrity:

```sql
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
```

### What 3NF solves
- Every fact is stored in exactly one place
- No attribute depends on anything other than the primary key
- The schema is clean, consistent, and free of all update, insert, and deletion anomalies

---

## Summary

| Normal Form | Rule | What it removes |
|---|---|---|
| 1NF | Atomic values, unique rows | Repeating groups, multi-valued fields |
| 2NF | No partial dependencies | Attributes depending on part of a composite key |
| 3NF | No transitive dependencies | Attributes depending on other non-key attributes |

### Final Schema (3NF)

```
Student ──< Membership >── Club
(StudentID)  (StudentID)   (ClubID)
             (ClubID)
             (JoinDate)
```

A student can join many clubs. A club can have many students. The Membership table manages this many-to-many relationship cleanly, with no redundant data anywhere in the schema.