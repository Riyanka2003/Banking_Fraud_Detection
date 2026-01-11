-- Database Setup
CREATE DATABASE IF NOT EXISTS Banking_Fraud_DB;
USE Banking_Fraud_DB;

-- Table Structure
CREATE TABLE IF NOT EXISTS Transactions (
    Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
    Customer_ID INT,
    Transaction_Date DATETIME,
    Amount DECIMAL(10, 2),
    Merchant_Name VARCHAR(100),
    Category VARCHAR(50),
    Is_Flagged INT DEFAULT 0 -- 0 = Safe, 1 = Suspicious
);