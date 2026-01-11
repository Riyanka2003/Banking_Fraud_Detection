import mysql.connector
import random
from datetime import datetime, timedelta

# --- CONFIGURATION ---
DB_CONFIG = {
    'host': 'localhost',
    'user': 'root', 
    'password': '@Finance_955',  # <--- UPDATE THIS!
}

def create_database():
    conn = mysql.connector.connect(**DB_CONFIG)
    cursor = conn.cursor()
    
    # 1. Create Database
    cursor.execute("CREATE DATABASE IF NOT EXISTS Banking_Fraud_DB")
    cursor.execute("USE Banking_Fraud_DB")
    
    # 2. Create Table
    cursor.execute("""
    CREATE TABLE IF NOT EXISTS Transactions (
        Transaction_ID INT AUTO_INCREMENT PRIMARY KEY,
        Customer_ID INT,
        Transaction_Date DATETIME,
        Amount DECIMAL(10, 2),
        Merchant_Name VARCHAR(100),
        Category VARCHAR(50),
        Is_Flagged INT DEFAULT 0
    )
    """)
    print("Database and Table created successfully.")
    conn.close()

def generate_transactions():
    conn = mysql.connector.connect(database='Banking_Fraud_DB', **DB_CONFIG)
    cursor = conn.cursor()
    
    print("Generating 5,000 transactions (this might take 10 seconds)...")
    
    merchants = ['Amazon', 'Walmart', 'Uber', 'Starbucks', 'Apple Store', 'Target', 'Gas Station', 'Unknown Vendor']
    categories = ['Retail', 'Groceries', 'Transport', 'Dining', 'Electronics', 'Shopping', 'Fuel', 'Online']
    
    data = []
    start_date = datetime(2024, 1, 1)
    
    for _ in range(5000):
        cust_id = random.randint(1001, 1100) # 100 Customers
        days_offset = random.randint(0, 30)
        
        # 95% Normal transactions
        if random.random() < 0.95:
            date = start_date + timedelta(days=days_offset, hours=random.randint(8, 22), minutes=random.randint(0, 59))
            amount = round(random.uniform(5.0, 300.0), 2)
            merchant = random.choice(merchants)
            category = categories[merchants.index(merchant)]
        
        # 5% Suspicious Patterns (The "Needles" in the haystack)
        else:
            # Pattern 1: Late Night High Value (e.g., $4,000 at 3 AM)
            date = start_date + timedelta(days=days_offset, hours=random.randint(0, 4), minutes=random.randint(0, 59))
            amount = round(random.uniform(1000.0, 5000.0), 2)
            merchant = "Unknown Vendor"
            category = "Online"

        data.append((cust_id, date, amount, merchant, category))
    
    # Bulk Insert
    sql = "INSERT INTO Transactions (Customer_ID, Transaction_Date, Amount, Merchant_Name, Category) VALUES (%s, %s, %s, %s, %s)"
    cursor.executemany(sql, data)
    conn.commit()
    
    print("Success! 5,000 transactions loaded.")
    conn.close()

if __name__ == "__main__":
    create_database()
    generate_transactions()