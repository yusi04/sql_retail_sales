-- SQL Retail Analysys
CREATE DATABASE sql_project_p2;


-- Create Table
DROP TABLE IF EXISTS retail_sales;
CREATE TABLE retail_sales (
							transactions_id INT PRIMARY KEY,
							sale_date DATE,
							sale_time TIME,
							customer_id INT, 
							gender VARCHAR(15),
							age INT,
							category VARCHAR(15),
							quantity INT,
							price_per_unit FLOAT,
							cogs FLOAT,
							total_sale FLOAT
);

SELECT * FROM retail_sales;
LIMIT 10

SELECT 
	COUNT(*)
FROM retail_sales


-- Data Cleaning
SELECT * FROM retail_sales
WHERE transactions_id IS NULL

SELECT * FROM retail_sales
WHERE sale_date IS NULL

SELECT * FROM retail_sales
WHERE sale_time IS NULL

SELECT * FROM retail_salesWHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL;

-- 
DELETE FROM retail_sales
WHERE 
	transactions_id IS NULL
	OR
	sale_date IS NULL
	OR
	sale_time IS NULL
	OR
	gender IS NULL
	OR
	age IS NULL
	OR
	category IS NULL
	OR
	quantity IS NULL
	OR
	price_per_unit IS NULL
	OR
	cogs IS NULL
	OR
	total_sale IS NULL; 


-- Data Exploration

-- How many sales we have?
SELECT COUNT(*) as total_sale FROM retail_sales

-- How many unique customers we have?
SELECT COUNT(DISTINCT customer_id) as total_sale FROM retail_sales


SELECT COUNT(DISTINCT category) as total_sale FROM retail_sales


SELECT DISTINCT category FROM retail_sales


-- Data Analysys & Business Key Problems & Answers

-- 1. Retrieving all columns for sales made on 2022-11-05
SELECT * 
FROM retail_sales
WHERE sale_date = '2022-11-05'

-- 2. Retrieving all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
SELECT *
FROM retail_sales
WHERE  
	category = 'Clothing'
	AND
	TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
	AND
	quantity >= 4

-- 3. Calculating the total sales for each category
SELECT 
	category,
	SUM(total_sale) as net_sale,
	COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1

-- 4. Finding the average of customers who purcahsed items from 'Beauty' category
SELECT
	ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'

-- 5. Finding all transactions where the total_sale is greater than 1000
SELECT * FROM retail_sales
WHERE total_sale > 1000

-- 6. Finding the total number of transactions mase by each gender in each category
SELECT
	category,
	gender,
	COUNT(*) as total_trans
FROM retail_sales
GROUP BY
	category,
	gender
ORDER BY 1

-- 7. Calculating the average sale for each month to find out which the best selling month in each year
SELECT
		year,
		month,
		avg_sale
FROM
(
	SELECT
		EXTRACT(YEAR FROM sale_date) as year,
		EXTRACT(MONTH FROM sale_date) as month,
		AVG(total_sale) as avg_sale,
		RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rank
	FROM retail_sales
	GROUP BY 1, 2
) as t1
WHERE rank = 1
ORDER BY 1, 3 DESC

-- 8. Finding the 5 top customers based on the highest total sales
SELECT
	customer_id,
	SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 1, 2 DESC
LIMIT 5

-- 9. Finding the number of uniqur customers who purchsed items from each category
SELECT
	category,
	COUNT(DISTINCT customer_id) as cnt_unique_cust
FROM retail_sales
GROUP BY category

-- 10. Creating shift and number or oerders
WITH hourly_sale
AS
(
SELECT *,
	CASE
		WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
		WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afernoon'
		ELSE 'Evening'
	END as shift
FROM retail_sales
)
SELECT
	shift,
	COUNT(*) as total_orders
FROM hourly_sale
GROUP BY shift

-- Done