# 🕵️‍♀️ Credit Card Fraud Detection System

**A forensic SQL analysis project that automates the detection of financial anomalies using rule-based logic.**

## 📌 Project Overview
This project simulates a banking environment to identify fraudulent transaction patterns. Unlike black-box machine learning models, this system uses **transparent SQL logic** to flag suspicious activity based on "Time-of-Day" and "Merchant Context" anomalies.

**Key Scenarios Detected:**
* **The "Cinderella" Attack:** High-value transactions occurring between 12:00 AM - 5:00 AM.
* **Contextual Anomalies:** Logically impossible charges (e.g., $300 at a Gas Station).

## 🛠️ Tech Stack
* **Python:** Generated a synthetic dataset of 5,000 realistic transactions with hidden fraud patterns.
* **MySQL:** Data storage and forensic analysis.
* **SQL Logic:** Used `CASE WHEN`, `Window Functions`, and `Views` to build an automated risk classifier.

## Evidence Board

![Evidence Board](./Evidence report.png)

## 🧠 Fraud Detection Logic (Flowchart)
*How the system decides if a transaction is safe or suspicious:*

```mermaid
graph TD;
    A[New Transaction] --> B{Is amount > $100?};
    B -- No --> D[Label: Normal];
    B -- Yes --> C{Time between 00:00 - 05:00?};
    C -- Yes --> E[Label: CRITICAL RISK];
    C -- No --> F{Merchant = 'Gas Station'?};
    F -- Yes --> G[Label: WARNING (Context)];
    F -- No --> D;
    
    style E fill:#ff9999,stroke:#333,stroke-width:2px

    style G fill:#ffcc00,stroke:#333,stroke-width:2px
    style D fill:#99ff99,stroke:#333,stroke-width:2px
