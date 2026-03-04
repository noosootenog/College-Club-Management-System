# College Club Management System

A MySQL database project demonstrating relational database design and normalization for managing student club memberships at a college. The project walks through the full normalization process from an unnormalized flat table through 1NF, 2NF, and 3NF, with SQL scripts and a Docker setup ready to run.

---

## Project Structure

```
College-Club-Management-System/
├── Docker/
│   └── docker-compose.yml       # MySQL 8.0 container config
├── Diagram/
│   └── Er_Diagram.png           # Entity Relationship diagram
├── sql/
│   ├── init.sql                 # Main file — runs everything (use this)
│   ├── database_setup.sql       # Creates the database
│   ├── 1NF.sql                  # Step 1: First Normal Form
│   ├── 2NF.sql                  # Step 2: Second Normal Form
│   ├── 3NF.sql                  # Step 3: Third Normal Form
│   ├── insert_data.sql          # Task 4: insert + select queries
│   └── join_queries.sql         # Task 5: JOIN query
├── Normalization.md             # Normalization notes
└── README.md
```

---

## Database Schema

The final normalized schema (3NF) consists of three tables:

**Student**
| Column | Type | Notes |
|---|---|---|
| StudentID | INT | Primary Key |
| StudentName | VARCHAR(50) | NOT NULL |
| Email | VARCHAR(100) | UNIQUE, NOT NULL |

**Club**
| Column | Type | Notes |
|---|---|---|
| ClubID | INT | Primary Key, AUTO_INCREMENT |
| ClubName | VARCHAR(50) | UNIQUE, NOT NULL |
| ClubRoom | VARCHAR(10) | |
| ClubMentor | VARCHAR(50) | |

**Membership** (junction table)
| Column | Type | Notes |
|---|---|---|
| StudentID | INT | FK → Student |
| ClubID | INT | FK → Club |
| JoinDate | DATE | NOT NULL |

A student can join many clubs, and a club can have many students (many-to-many via Membership).

---

## Getting Started

### Requirements

- [Docker](https://www.docker.com/)
- [Docker Compose](https://docs.docker.com/compose/)

### Run with Docker

The `docker-compose.yml` automatically loads `init.sql` on first startup.

```bash
# Clone the repo
git clone https://github.com/noosootenog/College-Club-Management-System.git
cd College-Club-Management-System

# Start the MySQL container
docker-compose -f Docker/docker-compose.yml up -d
```

The database `CollegeClubDB` will be created and seeded automatically.

### Connect to the database

```bash
docker exec -it mysql mysql -uroot -proot CollegeClubDB
```

### Stop the container

```bash
docker-compose -f Docker/docker-compose.yml down
```

To also remove the stored data volume:

```bash
docker-compose -f Docker/docker-compose.yml down -v
```

---

## Running SQL Scripts Manually

If you prefer to run scripts individually rather than using Docker auto-init:

```bash
# Copy and run init.sql inside the running container
docker cp sql/init.sql mysql:/init.sql
docker exec -i mysql mysql -uroot -proot < sql/init.sql
```

Or run a specific script:

```bash
docker exec -i mysql mysql -uroot -proot CollegeClubDB < sql/join_queries.sql
```

---

## Sample Data

The database is seeded with 7 students, 4 clubs, and 10 memberships:

| StudentID | Name | Clubs |
|---|---|---|
| 1 | Asha | Music Club, Sports Club |
| 2 | Bikash | Sports Club, Drama Club |
| 3 | Nisha | Music Club, Coding Club |
| 4 | Rohan | Drama Club |
| 5 | Suman | Music Club |
| 6 | Pooja | Sports Club |
| 7 | Aman | Coding Club |

---

## Normalization Summary

The project starts from one unnormalized table (`ClubMembership_1NF`) and progressively normalizes it:

- **1NF** — Atomic values, composite primary key `(StudentID, ClubName)`
- **2NF** — Removes partial dependencies; splits into `Student`, `Club`, and `Membership` tables
- **3NF** — Removes transitive dependencies; all non-key attributes depend only on the primary key

See [`Normalization.md`](Normalization.md) for a detailed explanation.


## License

This project is licensed under the terms in the [LICENSE](LICENSE) file.