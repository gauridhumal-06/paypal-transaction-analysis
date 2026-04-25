CREATE DATABASE paypal;
USE paypal;
SHOW TABLES;

DESC countries;
DESC merchants;
DESC users;

DESC currencies;
DESC transactions;


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

-- QUESTION 2 
SELECT * FROM transactions;
SELECT  transaction_id,sender_id,recipient_id,transaction_amount,currency_code 
FROM transactions 
WHERE transaction_amount> 10000 AND YEAR(transaction_date) =2023;

-- Q3
SELECT * FROM merchants;
SELECT * FROM transactions;
select * from countries;
SELECT * FROM users;


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


-- Q5
SELECT t.currency_code,SUM(t.transaction_amount) AS total_converted
FROM transactions t
WHERE t.transaction_date BETWEEN '2023-05-22' AND '2024-05-22'
GROUP BY t.currency_code
ORDER BY total_converted DESC
LIMIT 3;


-- Q6
SELECT 
	CASE 
		WHEN transaction_amount > 10000 THEN 'High Value'
        ELSE 'Regular'
	END AS transaction_category,
    SUM(transaction_amount) AS total_amount 
FROM transactions 
WHERE YEAR(transaction_date)= 2023
GROUP BY transaction_category;

-- Q7
SELECT * FROM merchants;
SELECT * FROM transactions;
select * from countries;
SELECT * FROM users;

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
		



-- Transaction Behaviour


SELECT * FROM transactions;
SELECT * FROM users;

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


-- Monthly Transactions 
SELECT * FROM transactions;
SELECT 
	YEAR(transaction_date)AS transaction_year,
    EXTRACT(MONTH FROM transaction_date) AS transaction_month,
    SUM(transaction_amount) AS total_amount
FROM transactions
WHERE YEAR(transaction_date) = 2023
GROUP BY 1,2
ORDER BY 1,2 ASC; 

-- Loyal Customers/CUSTOMER
SELECT u.user_id,u.email,u.name,
	ROUND(SUM(t.transaction_amount),2) AS total_amount
FROM users u 
JOIN transactions t 
ON u.user_id = t.sender_id
WHERE transaction_date BETWEEN '2023-05-22' AND '2024-05-22'
GROUP BY u.user_id,u.email,u.name
ORDER BY total_amount DESC
LIMIT 1;

-- Currency with the highest transaction amount 
SELECT currency_code,
       SUM(transaction_amount) AS total_amount
FROM transactions 
WHERE transaction_date BETWEEN DATE_SUB('2024-05-22', INTERVAL 1 YEAR) AND '2024-05-22'
GROUP BY currency_code 
ORDER BY total_amount DESC
LIMIT 1;

-- top performing merchant (the one with the highest transaction_amount recieved)
SELECT * FROM transactions;
SELECT * FROM merchants;

SELECT m.business_name,SUM(t.transaction_amount) AS total_amt 
FROM merchants m 
JOIN transactions t 
ON m.merchant_id = t.recipient_id 
WHERE transaction_date BETWEEN '2023-11-01' and '2024-04-30'
GROUP BY m.business_name
ORDER BY total_amt DESC;

-- TO FIND THE MAX transaction_amt merchant
SELECT MAX(total_amt)
FROM (
SELECT m.business_name as business_name,SUM(t.transaction_amount) AS total_amt 
FROM merchants m 
JOIN transactions t 
ON m.merchant_id = t.recipient_id 
WHERE transaction_date BETWEEN '2023-11-01' and '2024-04-30'
GROUP BY m.business_name) as dt;


-- Count of transaction 
SELECT * FROM transactions;
SELECT * FROM users;

SELECT 
	CASE 
		WHEN u.country_id = u1.country_id THEN 
			CASE 
				WHEN transaction_amount> 10000 THEN 'High Value Domestic'
				ELSE 'Regular Domestic'
			END
		WHEN u.country_id <> u1.country_id THEN 
			CASE
				WHEN transaction_amount> 10000 THEN 'High Value International'
                ELSE 'Regular International'
			END
	END AS transaction_category,
COUNT(*) AS transaction_count
FROM transactions t 
JOIN users u 
ON t.sender_id =u.user_id
JOIN users u1 
ON t.recipient_id = u1.user_id
WHERE YEAR(transaction_date) = 2023
GROUP BY transaction_category;





-- GROUP Wise Transaction
WITH cte as
(SELECT t.transaction_amount,YEAR(t.transaction_date)AS transaction_year,MONTH(t.transaction_date) AS transaction_month,
	CASE 
		WHEN t.transaction_amount > 10000 THEN 'High Value'
        ELSE 'Regular'
	END AS value_category,
    CASE 
		WHEN u.country_id = u1.country_id THEN 'Domestic'
        ELSE 'International'
	END AS location_category
FROM transactions t 
JOIN users u 
ON t.sender_id = u.user_id 
JOIN users u1 
ON t.recipient_id = u1.user_id
WHERE YEAR(t.transaction_date)= 2023 )
SELECT cte.transaction_year,cte.transaction_month,cte.value_category,cte.location_category,
	SUM(transaction_amount) as total_amount,
    ROUND(AVG(transaction_amount),2) AS average_amount 
FROM cte
GROUP BY 1,2,3,4
ORDER BY 1,2,3,4;
-- Or do it with subquery 

-- Average_Amount
SELECT * FROM merchants;

SELECT m.merchant_id,m.business_name,
	ROUND(SUM(t.transaction_amount),2) AS total_received,
    CASE 
		WHEN ROUND(SUM(t.transaction_amount),2)> 50000 THEN 'Excellent'
        WHEN ROUND(SUM(t.transaction_amount),2) > 20000 AND ROUND(SUM(t.transaction_amount),2)<= 50000 THEN 'Good'
        WHEN ROUND(SUM(t.transaction_amount),2) > 10000 AND ROUND(SUM(t.transaction_amount),2)<= 20000 THEN 'Average'
        ELSE 'Below Average'
	END AS performance_score,
    ROUND(AVG(t.transaction_amount),2) AS average_transaction 
FROM transactions t 
JOIN merchants m 
ON t.recipient_id = m.merchant_id
WHERE t.transaction_date BETWEEN '2023-11-01' AND '2024-04-30' 
GROUP BY 1,2
ORDER BY 
    CASE 
        WHEN performance_score='Excellent' THEN 1 
        WHEN performance_score='Good' THEN 2
        WHEN performance_score='Average' THEN 3 
        WHEN performance_score='Below Average' THEN 4 
    END,
total_received DESC;
























































