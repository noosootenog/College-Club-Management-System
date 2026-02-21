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
