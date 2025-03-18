SELECT * FROM sales_data;

--Total Sales

SELECT SUM(sales) AS total_sales
FROM sales_data;

--Total Orders

SELECT COUNT(DISTINCT order_id) AS total_orders
FROM sales_data;

--Average Order Value 

SELECT SUM(sales) / COUNT(DISTINCT order_id) AS average_order_value
FROM sales_data;


--Total Sales by Region

SELECT region, SUM(sales) AS total_sales
FROM sales_data
GROUP BY region
ORDER BY total_sales DESC;


--Total Sales by Product Category

SELECT category, SUM(sales) AS total_sales
FROM sales_data
GROUP BY category
ORDER BY total_sales DESC;


--Top 5 Best-Selling Products

SELECT product_name, SUM(sales) AS total_sales
FROM sales_data
GROUP BY product_name
ORDER BY total_sales DESC
LIMIT 5;

--Total Revenue by Category & Region

SELECT category, region, SUM(sales) AS total_sales
FROM sales_data
GROUP BY category, region
ORDER BY total_sales DESC;

--Sales Performance

SELECT product_name, 
       SUM(sales) AS total_sales,
       CASE 
           WHEN SUM(sales) >= 10000 THEN 'High Sales'
           WHEN SUM(sales) BETWEEN 5000 AND 9999 THEN 'Medium Sales'
           ELSE 'Low Sales'
       END AS sales_category
FROM sales_data
GROUP BY product_name
ORDER BY total_sales DESC;


--Most Profitable Region

SELECT region, SUM(profit) AS total_profit
FROM sales_data
GROUP BY region
ORDER BY total_profit DESC;

--Discount Impact on Sales

SELECT discount,
       COUNT(order_id) AS total_orders,
       SUM(sales) AS total_sales,
       SUM(profit) AS total_profit
FROM sales_data
GROUP BY discount
ORDER BY discount DESC;

--Monthly Sales Trends

SELECT DATE_TRUNC('month', order_date) AS sales_month,
       SUM(sales) AS total_sales
FROM sales_data
GROUP BY sales_month
ORDER BY sales_month;


