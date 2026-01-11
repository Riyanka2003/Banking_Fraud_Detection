USE Banking_Fraud_DB;

-- View the first 10 transactions to understand the columns
SELECT * FROM Transactions 
LIMIT 10;

-- Investigation 1: Find high-value transactions happening between Midnight and 5 AM
SELECT 
    Transaction_ID,
    Customer_ID,
    Transaction_Date,
    Amount,
    Merchant_Name
FROM Transactions
WHERE 
    HOUR(Transaction_Date) BETWEEN 0 AND 5 -- 0 = Midnight, 5 = 5 AM
    AND Amount > 100 -- Ignore small purchases, look for the big hits
ORDER BY Amount DESC;

-- Find out which customers lost the most money to this fraud
SELECT 
    Customer_ID,
    COUNT(Transaction_ID) AS Number_of_Fraud_Transactions,
    SUM(Amount) AS Total_Money_Lost
FROM Transactions
WHERE Merchant_Name = 'Unknown Vendor'
GROUP BY Customer_ID
ORDER BY Total_Money_Lost DESC;

-- "The Automator": Flag all suspicious transactions automatically
SET SQL_SAFE_UPDATES = 0; -- Disable safety mode to allow bulk updates

UPDATE Transactions
SET Is_Flagged = 1
WHERE 
    Merchant_Name = 'Unknown Vendor' 
    AND HOUR(Transaction_Date) BETWEEN 0 AND 5;

-- Verify it worked
SELECT * FROM Transactions 
WHERE Is_Flagged = 1;

-- Investigation 4: Contextual Anomalies (Gas Station > $100)
SELECT 
    Transaction_ID,
    Customer_ID,
    Transaction_Date,
    Amount,
    Merchant_Name
FROM Transactions
WHERE 
    Merchant_Name = 'Gas Station'
    AND Amount > 100 -- Logic Check: High amount for this category
ORDER BY Amount DESC;

-- Create a Master View that labels every transaction
CREATE OR REPLACE VIEW v_Fraud_Report AS
SELECT 
    Transaction_ID,
    Customer_ID,
    Transaction_Date,
    Amount,
    Merchant_Name,
    -- Here is the "Brain" of our detection system:
    CASE
        -- Rule 1: The Midnight Attackers
        WHEN HOUR(Transaction_Date) BETWEEN 0 AND 5 AND Amount > 100 THEN 'Critical: Late Night Suspicious'
        
        -- Rule 2: The Gas Station Anomalies
        WHEN Merchant_Name = 'Gas Station' AND Amount > 100 THEN 'Warning: High Value Gas'
        
        -- Default: Everything else is likely fine
        ELSE 'Normal'
    END AS Risk_Score
FROM Transactions;

-- Now, let's look at our final report
SELECT * FROM v_Fraud_Report
WHERE Risk_Score != 'Normal'
ORDER BY Transaction_Date DESC;