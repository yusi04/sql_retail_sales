# Retail Sales Analysis SQL Project

## Project Overview

**Project Title**: Retail Sales Analysis  
**Level**: Beginner  
**Database**: `p1_retail_db`

This project highlights a full-cycle SQL approach to retail data management, covering everything from rigorous cleaning to in-depth data interpretation. Leveraging database integration and Exploratory Data Analysis (EDA), the goal is to convert raw transactional records into actionable business intelligence that solves critical operational problems.

## Project Milestones

1. **Database Architecture**: Construct and initialize a dedicated repository for transactional records using the supplied retail information.
2. **Quality Assurance**: Execute data scrubbing to detect and eliminate incomplete entries or null points, ensuring dataset integrity.
3. **Exploratory Data Analysis (EDA)**: Conduct an initial deep dive into the data to map out its fundamental characteristics and distributions.
4. **Business Analysis**: Leverage advanced querying to extract actionable answers for commercial inquiries and reveal meaningful patterns in consumer behavior.

### 1. Database Setup

- **Database Creation**: The project begins with the establishment of a new database schema titled p1_retail_db.
- **Table Creation**: A core table identified as retail_sales is generated to organize the transaction data. This table is structured to capture comprehensive details, including unique transaction identifiers, temporal data (date and time), and demographic info (customer ID, gender, age). Furthermore, it tracks product-specific metrics such as category, volume sold, unit pricing, cost of goods sold (COGS), and the aggregate sale value.

```sql
CREATE DATABASE p1_retail_db;

CREATE TABLE retail_sales
(
    transactions_id INT PRIMARY KEY,
    sale_date DATE,	
    sale_time TIME,
    customer_id INT,	
    gender VARCHAR(10),
    age INT,
    category VARCHAR(35),
    quantity INT,
    price_per_unit FLOAT,
```

### 2. Data Exploration & Cleaning

- **Record Count**: Calculate the total number of entries to determine the overall scale of the dataset.
- **Customer Count**: Quantify the distinct number of individual consumers represented in the records.
- **Category Count**: Extract a comprehensive list of all unique merchandise categories available.
- **Null Value Check**: Perform a rigorous check for null values across all fields and purge any incomplete records to ensure the highest level of data integrity for subsequent analysis.

```sql
SELECT COUNT(*) FROM retail_sales;
SELECT COUNT(DISTINCT customer_id) FROM retail_sales;
SELECT DISTINCT category FROM retail_sales;

SELECT * FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;

DELETE FROM retail_sales
WHERE 
    sale_date IS NULL OR sale_time IS NULL OR customer_id IS NULL OR 
    gender IS NULL OR age IS NULL OR category IS NULL OR 
    quantity IS NULL OR price_per_unit IS NULL OR cogs IS NULL;
```

### 3. Data Analysis

The following SQL queries were developed to answer specific business questions:

1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**:
```sql
SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';
```

2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**:
```sql
SELECT 
  *
FROM retail_sales
WHERE 
    category = 'Clothing'
    AND 
    TO_CHAR(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantity >= 4
```

3. **Write a SQL query to calculate the total sales (total_sale) for each category.**:
```sql
SELECT 
    category,
    SUM(total_sale) as net_sale,
    COUNT(*) as total_orders
FROM retail_sales
GROUP BY 1
```

4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**:
```sql
SELECT
    ROUND(AVG(age), 2) as avg_age
FROM retail_sales
WHERE category = 'Beauty'
```

5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**:
```sql
SELECT * FROM retail_sales
WHERE total_sale > 1000
```

6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**:
```sql
SELECT 
    category,
    gender,
    COUNT(*) as total_trans
FROM retail_sales
GROUP 
    BY 
    category,
    gender
ORDER BY 1
```

7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**:
```sql
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
```

8. **Write a SQL query to find the top 5 customers based on the highest total sales **:
```sql
SELECT 
    customer_id,
    SUM(total_sale) as total_sales
FROM retail_sales
GROUP BY 1
ORDER BY 2 DESC
LIMIT 5
```

9. **Write a SQL query to find the number of unique customers who purchased items from each category.**:
```sql
SELECT 
    category,    
    COUNT(DISTINCT customer_id) as cnt_unique_cs
FROM retail_sales
GROUP BY category
```

10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**:
```sql
WITH hourly_sale
AS
(
SELECT *,
    CASE
        WHEN EXTRACT(HOUR FROM sale_time) < 12 THEN 'Morning'
        WHEN EXTRACT(HOUR FROM sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END as shift
FROM retail_sales
)
SELECT 
    shift,
    COUNT(*) as total_orders    
FROM hourly_sale
GROUP BY shift
```

## Key Discovery

- **Customer Demographics**: The data reveals a diverse age range among the shopper base, with revenue streams flowing from multiple sectors, notably the Apparel and Cosmetics departments.
- **High-Value Transactions**: A significant number of orders exceeded the 1,000 threshold, highlighting a segment of high-ticket retail activity.
- **Sales Trends**: Seasonal fluctuations were observed through month-to-month evaluations, allowing for the pinpointing of high-performance periods.
- **Customer Insights**: The study successfully isolated the highest-contributing patrons and determined which merchandise groups dominate market demand.

## Analytical Deliverables

- **Executive Sales Overview**: A comprehensive documentation of aggregate revenue metrics, consumer age/gender distributions, and the commercial viability of various product lines.
- **Dynamic Trend Monitoring**: A deep dive into transactional momentum, highlighting performance variations across different months and specific time-of-day shifts.
- **Client Intelligence Dossier**: Summarized findings focusing on high-value patrons and the reach of unique customer engagement within each merchandise classification.



















    cogs FLOAT,
    total_sale FLOAT
);
