# College Club Membership Management System

This project demonstrates database design and normalization for managing student club memberships in a college environment. It includes normalization steps from 1NF to 3NF, SQL scripts, and Docker container setup for a MySQL database.

## Repository Contents

- **docker-compose.yml** - Runs the MySQL database using Docker
- **sql/** - SQL scripts for schema creation, sample data, and queries
- **diagrams/** - ER Diagram showing the relationship between entities
- **docs/** - Normalization explanation

## How to Run

### Requirements:
- Docker
- Docker Compose

### Steps:

1. Clone the repository:
   ```bash
   git clone https://github.com/noosootenog/College-Club-Management-System.git
   cd College-Club-Management-System

### 1. Start MySQL 8.0 Container
```bash
docker run -d -p 3306:3306 -e MYSQL_ROOT_PASSWORD=root --name mysql mysql:8.0 
docker exec -it mysql mysql -uroot -p

