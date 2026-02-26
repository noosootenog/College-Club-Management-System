# College Club Management System

Normalized MySQL database for managing college student club memberships (Music Club, Sports Club, etc.).  
Demonstrates normalization from unnormalized table → 1NF → 2NF → 3NF, with many-to-many relationship via a Membership table.

## ER Diagram

![ER Diagram](ER_Diagram.png)

*(If image doesn't display yet — upload it soon via "Add file → Upload files")*

**Relationships**  
- One **Student** can join many **Clubs**  
- One **Club** can have many **Students**  
- Junction table: **Membership** (StudentID + ClubID as composite PK, plus JoinDate)

## Database Schema (3NF)

- **Student** (StudentID PK, StudentName, Email)  
- **Club** (ClubID PK, ClubName, ClubRoom, ClubMentor)  
- **Membership** (StudentID FK, ClubID FK, JoinDate)

## Docker + MySQL Setup

### Prerequisites
- Docker installed and running on your machine

### 1. Start MySQL 8.0 Container
```bash
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --name mysql mysql:8.0 
docker exec -it mysql mysql -uroot -p

