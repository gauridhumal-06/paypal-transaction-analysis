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

**SELECT COUNT(*) FROM Users;**

**SELECT COUNT(*) FROM Merchants;**

**SELECT COUNT(*) FROM Transactions;**
```


**-- Check for NULL values**
```sql

**SELECT * FROM Users WHERE Email IS NULL OR Name IS NULL;**

**SELECT * FROM Transactions WHERE Transaction\_amount IS NULL;**
```


**-- Check duplicate transactions**
```sql
**SELECT Transaction\_ID, COUNT(*)**

**FROM Transactions**

**GROUP BY Transaction\_ID**

**HAVING COUNT(\*) > 1;**
```
**-- Check negative or invalid transaction amounts**
```sql
**SELECT \***

**FROM Transactions**

**WHERE Transaction\_amount <= 0;**
```


**-- Check date range of transactions**
```sql
**SELECT MIN(Transaction\_date), MAX(Transaction\_date)**

**FROM Transactions;**
```


### 2\. Data Analysis \& Findings



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

