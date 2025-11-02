-- CREATE DATABASE
CREATE DATABASE retail_sales_database;

-- CREATE TABLE
CREATE TABLE retail_sales
(
	transactions_id INT PRIMARY KEY,
	sale_date DATE,
    sale_time TIME,	
    customer_id INT,	
    gender VARCHAR(8),	
    age INT,	
    category VARCHAR(15),	
    quantity INT,	
    price_per_unit FLOAT,	
    cogs FLOAT,	
    total_sale FLOAT
);

SELECT * 
FROM retail_sales;

-- Data Exploration & Cleaning

SELECT COUNT(*) 
FROM retail_sales;

SELECT COUNT(DISTINCT customer_id)
FROM retail_sales;

SELECT DISTINCT category
FROM retail_sales;


-- CHECKING IF THERE ANY NULLS
SELECT *
FROM retail_sales
WHERE 
	transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR 
    cogs IS NULL OR 
    total_sale IS NULL;

-- DELETING NULL VALUES
DELETE
FROM retail_sales
WHERE 
	transactions_id IS NULL OR
    sale_date IS NULL OR
    sale_time IS NULL OR
    customer_id IS NULL OR
    gender IS NULL OR
    age IS NULL OR
    category IS NULL OR
    quantity IS NULL OR
    price_per_unit IS NULL OR 
    cogs IS NULL OR 
    total_sale IS NULL;
    

    
    
-- 1. **Write a SQL query to retrieve all columns for sales made on '2022-11-05**

SELECT *
FROM retail_sales
WHERE sale_date = '2022-11-05';

-- 2. **Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 4 in the month of Nov-2022**
SELECT *
	FROM retail_sales
	WHERE category = 'clothing' 
    AND	DATE_FORMAT(sale_date,'%Y-%m') = '2022-11' 
	AND quantity>=4;
    
    
-- 3. **Write a SQL query to calculate the total sales (total_sale) for each category.**

SELECT category, 
SUM(total_sale) AS net_sale,
COUNT(*) AS total_orders
FROM retail_sales
GROUP BY category;

-- 4. **Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.**

SELECT ROUND(AVG(age),2) as avg_age
FROM retail_sales
WHERE category = 'beauty';

-- 5. **Write a SQL query to find all transactions where the total_sale is greater than 1000.**
SELECT *
FROM retail_sales
WHERE total_sale > 1000;

-- 6. **Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.**

SELECT gender, 
category,
count(*) as total_trans
FROM retail_sales
GROUP BY gender, category
ORDER BY gender;

-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**

SELECT sale_year,
sale_month,
avg_sale,
year_rank
FROM 
(
	SELECT
		YEAR(sale_date) AS sale_year,
		MONTH(sale_date) AS sale_month,
		ROUND(AVG(total_sale)) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS year_rank
		FROM retail_sales
        GROUP BY sale_year,sale_month
		ORDER BY sale_year,avg_sale DESC
) AS t1
WHERE year_rank=1;


-- 7. **Write a SQL query to calculate the average sale for each month. Find out best selling month in each year**
SELECT sale_year,
sale_month,
avg_sale
FROM
(
SELECT
		YEAR(sale_date) AS sale_year,
        MONTH(sale_date) AS sale_month,
        ROUND(AVG(total_sale)) AS avg_sale,
        RANK() OVER(PARTITION BY YEAR(sale_date) ORDER BY AVG(total_sale) DESC) AS rank_col       
FROM retail_sales
		 GROUP BY sale_year,sale_month
) AS t1
WHERE rank_col = 1;


-- 8. **Write a SQL query to find the top 5 customers based on the highest total sales **

SELECT 
	customer_id,
	SUM(total_sale) AS net_sale
FROM retail_sales
GROUP BY customer_id
ORDER BY net_sale DESC
LIMIT 5;


-- 9. **Write a SQL query to find the number of unique customers who purchased items from each category.**

SELECT category,
		COUNT(DISTINCT customer_id) AS customer_count
FROM retail_sales
GROUP BY category;

-- 10. **Write a SQL query to create each shift and number of orders (Example Morning <12, Afternoon Between 12 & 17, Evening >17)**

WITH hourly_sale
AS 
(	
	SELECT *,
	CASE 
		WHEN HOUR(sale_time)<12 THEN 'Morning'
        WHEN HOUR(sale_time) BETWEEN 12 AND 17 THEN 'Afternoon'
        ELSE 'Evening'
    END AS shifts
FROM retail_sales
)
SELECT shifts,
	COUNT(*) AS total_orders
from hourly_sale
GROUP BY shifts;

-- END OF PROJECT 
