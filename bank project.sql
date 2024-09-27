CREATE TABLE customers (
    customer_id SERIAL PRIMARY KEY,
    customer_name VARCHAR(50),
    account_number BIGINT,
    account_type VARCHAR(20),
    gender VARCHAR(10),
    act_open_date DATE,
    products VARCHAR(50),
    state_of_residence VARCHAR(50)
);


CREATE TABLE transactions (
    transaction_id SERIAL PRIMARY KEY,
    customer_id INT,
    transaction_date DATE,
    transaction_type VARCHAR(20),
    transaction_amount DECIMAL(15, 2),
    channels VARCHAR(20),
    currency VARCHAR(10)
);


SELECT * 
FROM customer;

SELECT *
FROM transactions


--sum transaction type

SELECT transaction_type, SUM(transaction_amount) AS Value
FROM transactions
GROUP BY transaction_type;

-- MIN AND MAX.
SELECT MIN(transaction_date) AS MIN_date, MAX(transaction_date) AS MAX_date
FROM transactions;

--Total transaction by month and year
SELECT TO_CHAR(transaction_date, 'Mon-YYYY') AS Date, 
       SUM(transaction_amount) AS Value
FROM transactions
GROUP BY TO_CHAR(transaction_date, 'Mon-YYYY')
ORDER BY Value DESC;

--daily report
--count of customer that transacted on 2023-08-29
SElECT COUNT(customer_id) AS customer_count, transaction_date
FROM transactions
WHERE transaction_date = '29-Aug-2023'
GROUP BY transaction_date;

--debit transaction 
SELECT transaction_type, SUM(transaction_amount) AS Value
FROM transactions
WHERE transaction_date = '29-Aug-2023'	
GROUP BY transaction_type;

--transactions that happen in 2023 
SELECT TO_CHAR(transaction_date, 'Mon-YYYY') AS Date, 
       SUM(transaction_amount) AS Value
FROM transactions
WHERE EXTRACT(YEAR FROM transaction_date) = 2023
GROUP BY TO_CHAR(transaction_date, 'Mon-YYYY')
ORDER BY Value DESC;

--net profits
SELECT
    SUM(CASE WHEN transaction_type = 'credit' THEN transaction_amount ELSE 0 END) AS total_credit,
    SUM(CASE WHEN transaction_type = 'debit' THEN transaction_amount ELSE 0 END) AS total_debit
FROM transactions
WHERE transaction_date = '2023-08-29';


-- Top 3 Customers in a month
SELECT A.customer_id, B.customer_name,
    SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END) AS Credit_Amt,
    SUM(CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) AS Debit_Amt,
    SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END 
        - CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) AS Net_Value
FROM transactions A
JOIN customer B
    ON A.customer_id = B.customer_id
WHERE A.transaction_date >= '2023-Aug-01' 
    AND A.transaction_date <= '2023-Aug-30'
GROUP BY A.customer_id, B.customer_name
ORDER BY Net_Value DESC
LIMIT 3;

-- Top 5 Customers in the month with negative influence
SELECT A.customer_id, B.customer_name,
    SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END) AS Credit_Amt,
    SUM(CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) AS Debit_Amt,
    SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END
        - CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) AS Net_Value
FROM transactions A
JOIN customer B
    ON A.customer_id = B.customer_id
GROUP BY A.customer_id, B.customer_name
HAVING SUM(CASE WHEN A.transaction_type = 'Credit' THEN A.transaction_amount ELSE 0 END
        - CASE WHEN A.transaction_type = 'Debit' THEN A.transaction_amount ELSE 0 END) < 0
ORDER BY Net_Value ASC
LIMIT 5;