# PayPal Transaction Analysis SQL Project

## Project Overview

**Project Title**: PayPal Transaction Analysis Project 
**Database**: `paypal`

This project analyzes a simulated PayPal transaction database consisting of five tables: Countries, Currencies, Users, Merchants, and Transactions.



The goal is to extract meaningful business insights related to:

* High-value transactions
* Top-performing markets
* Merchant performance
* Currency exposure
* Customer behavior



The analysis is performed using SQL, focusing on real-world financial analytics use cases such as risk monitoring, compliance, and business growth.

## Objectives

1. **Set up a retail sales database**: Create and populate a retail sales database with the provided sales data.
2. **Data Cleaning**: Identify and remove any records with missing or null values.
3. **Exploratory Data Analysis (EDA)**: Perform basic exploratory data analysis to understand the dataset.
4. **Business Analysis**: Use SQL to answer specific business questions and derive insights from the sales data.

## Project Structure

### 1\. Data Exploration \& Cleaning

**-- Check total records in each table**
```sql
SELECT COUNT(*) FROM Countries;
SELECT COUNT(*) FROM Users;
SELECT COUNT(*) FROM Merchants;
SELECT COUNT(*) FROM Transactions;
```


**-- Check for NULL values**
```sql

SELECT * FROM Users WHERE email IS NULL OR Name IS NULL;
SELECT * FROM Transactions WHERE Transaction_amount IS NULL;
```


**-- Check duplicate transactions**
```sql
SELECT Transaction_ID, COUNT(*)
FROM Transactions
GROUP BY Transaction_ID
HAVING COUNT(*) > 1;
```
**-- Check negative or invalid transaction amounts**
```sql
SELECT *
FROM Transactions
WHERE Transaction_amount <= 0;
```


**-- Check date range of transactions**
```sql
SELECT MIN(Transaction_date), MAX(Transaction_date)
FROM Transactions;
```


### 2\. Data Analysis \& Findings

**-- Top 5 Sending Countries**
```sql
SELECT  c.country_name,ROUND(SUM(t.transaction_amount),2) AS total_sent
FROM transactions t
JOIN users u 
ON t.sender_id =u.user_id
JOIN countries c 
ON u.country_id = c.country_id
WHERE YEAR(t.transaction_date) = 2023 AND EXTRACT(QUARTER FROM t.transaction_date) = 4
GROUP BY c.country_name
ORDER BY total_sent DESC
LIMIT 5;
```

**-- Top 5 Recieving Countries**
```sql
SELECT  c.country_name,ROUND(SUM(t.transaction_amount),2) AS total_received
FROM transactions t
JOIN users u 
ON t.recipient_id =u.user_id
JOIN countries c 
ON u.country_id = c.country_id
WHERE YEAR(t.transaction_date) = 2023 AND EXTRACT(QUARTER FROM t.transaction_date) = 4
GROUP BY c.country_name
ORDER BY total_received DESC
LIMIT 5;
```

**--High Value Transactions (> $10,000) In year 2023**
```sql
SELECT * FROM transactions;
SELECT  transaction_id,sender_id,recipient_id,transaction_amount,currency_code 
FROM transactions 
WHERE transaction_amount> 10000 AND YEAR(transaction_date) =2023;
```

**--Top 10 Merchants**
```sql
SELECT 
	m.merchant_id,m.business_name business_name, 
	SUM(t.transaction_amount) AS total_received,
	AVG(t.transaction_amount) AS average_transaction
FROM transactions t 
JOIN merchants m 
ON t.recipient_id = m.merchant_id 
WHERE t.transaction_date BETWEEN '2023-11-01' AND '2024-04-30'
GROUP BY 1,2
ORDER BY total_received DESC 
LIMIT 10;
```
**--Currency Conversion Trends**
```sql
SELECT t.currency_code,SUM(t.transaction_amount) AS total_converted
FROM transactions t
WHERE t.transaction_date BETWEEN '2023-05-22' AND '2024-05-22'
GROUP BY t.currency_code
ORDER BY total_converted DESC
LIMIT 3;
```
**--Transaction Classification (2023)**
```sql
SELECT 
CASE 
    WHEN Transaction_amount > 10000 THEN 'High Value'
    ELSE 'Regular'
END AS category,
ROUND(SUM(Transaction_amount),2) AS total_amount
FROM Transactions
WHERE YEAR(Transaction_date) = 2023
GROUP BY category;
```
**--International vs Domestic Transactions**
```sql
SELECT 
	CASE
		WHEN u.country_id = u1.country_id THEN 'Domestic'
        ELSE 'International'
	END AS transaction_type,
    COUNT(*) AS transaction_count 
FROM transactions t 
JOIN users u
ON u.user_id = t.sender_id 
JOIN users u1 
ON u1.user_id = t.recipient_id
WHERE YEAR(transaction_date)=2024 AND EXTRACT(QUARTER FROM transaction_date) = 1
GROUP BY 1;
```
**--Transaction Classification (2023)**
```sql
SELECT 
CASE 
    WHEN Transaction_amount > 10000 THEN 'High Value'
    ELSE 'Regular'
END AS category,
ROUND(SUM(Transaction_amount),2) AS total_amount
FROM Transactions
WHERE YEAR(Transaction_date) = 2023
GROUP BY category;
```
**--High-Value Users**
```sql
SELECT 
	u.user_id,u.email,
	ROUND(AVG(t.transaction_amount),2) AS avg_amount
FROM users u 
JOIN transactions t
ON u.user_id = t.sender_id
WHERE t.transaction_date BETWEEN '2023-11-01' AND '2024-05-01'
GROUP BY u.user_id,u.email
HAVING avg_amount> 5000
ORDER BY u.user_id ASC; 
```
**--Monthly Transactions**
```sql
SELECT 
	YEAR(transaction_date)AS transaction_year,
    EXTRACT(MONTH FROM transaction_date) AS transaction_month,
    SUM(transaction_amount) AS total_amount
FROM transactions
WHERE YEAR(transaction_date) = 2023
GROUP BY 1,2
ORDER BY 1,2 ASC; 
```
**--Monthly Transactions**
```sql
SELECT 
	YEAR(transaction_date)AS transaction_year,
    EXTRACT(MONTH FROM transaction_date) AS transaction_month,
    SUM(transaction_amount) AS total_amount
FROM transactions
WHERE YEAR(transaction_date) = 2023
GROUP BY 1,2
ORDER BY 1,2 ASC; 
```
**--Loyal Customers**
```sql
SELECT u.user_id,u.email,u.name,
	ROUND(SUM(t.transaction_amount),2) AS total_amount
FROM users u 
JOIN transactions t 
ON u.user_id = t.sender_id
WHERE transaction_date BETWEEN '2023-05-22' AND '2024-05-22'
GROUP BY u.user_id,u.email,u.name
ORDER BY total_amount DESC
LIMIT 1;
```
**-- TO FIND THE MAX transaction_amt merchant**
```sql
SELECT MAX(total_amt)
FROM (
SELECT m.business_name as business_name,SUM(t.transaction_amount) AS total_amt 
FROM merchants m 
JOIN transactions t 
ON m.merchant_id = t.recipient_id 
WHERE transaction_date BETWEEN '2023-11-01' and '2024-04-30'
GROUP BY m.business_name) as dt;
```
**--Monthly Merchant Performancet**
```sql
SELECT m.Merchant_ID, m.Business_name,
YEAR(t.Transaction_date) AS year,
MONTH(t.Transaction_date) AS month,
ROUND(SUM(t.Transaction_amount),2) AS total_amount,
CASE 
    WHEN SUM(t.Transaction_amount) > 50000 
    THEN 'Exceeded $50,000'
    ELSE 'Did Not Exceed $50,000'
END AS performance_status
FROM Transactions t
JOIN Merchants m ON t.Recipient_ID = m.Merchant_ID
WHERE t.Transaction_date BETWEEN '2023-11-01' AND '2024-05-01'
GROUP BY m.Merchant_ID, m.Business_name, year, month;
```

```

## Findings

* **A small number of countries dominate global transaction volume**
* **High-value transactions contribute a significant portion of total revenue**
* **Few merchants generate majority of transaction volume (Pareto effect)**
* **International transactions form a crucial part of business operations**
* **A subset of users are high-value customers (ideal for targeting**



## Reports

* **Monthly financial performance report (2023)**
* **Merchant performance dashboard**
* **Transaction classification summary**
* **Customer segmentation insights**



## Conclusion

This project demonstrates the ability to:



* Work with relational databases
* Write advanced SQL queries
* Perform financial and business analysis
* Generate actionable insights



It reflects real-world scenarios in fintech companies like PayPal, helping in:



* Risk management
* Customer targeting
* Revenue optimization

