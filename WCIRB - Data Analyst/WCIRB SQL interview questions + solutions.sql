-- 1. You're given 3 tables with schema.

-- Table: Customers
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | customer_id | int     |
-- | name        | varchar |
-- +-------------+---------+
-- customer_id is the primary key for this table.
-- This table contains information about the customers.

-- Table: Orders 
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | order_id    | int     |
-- | order_date  | date    |
-- | customer_id | int     |
-- | product_id  | int     |
-- +-------------+---------+
-- order_id is the primary key for this table.
-- This table contains information about the orders made by customer_id.
-- No customer will order the same product more than once in a single day.

-- Table: Products 
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | product_id   | int     |
-- | product_name | varchar |
-- | price        | int     |
-- +--------------+---------+
-- product_id is the primary key for this table.
-- This table contains information about the prodcuts.


-- Write an SQL query or R/Python code to find the most frequently ordered product(s) for each customer. 
-- The result table should have the product_id, product_name for each customer_id who ordered at least one order. Return the result table in any order.
-- Query result format: | customer_id | product_id | product_name |

SELECT o.customer_id, o.product_id, p.product_name
FROM (
	SELECT customer_id, product_id, DENSE_RANK() OVER(PARTITON BY customer_id ORDER BY order_date DESC) AS rnk
	FROM Orders 
) o
JOIN Products p 
ON o.product_id = p.product_id 
WHERE rnk = 1


-- 2. You're given 1 table with schema.

-- Table: Stocks
-- +---------------+---------+
-- | Column Name   | Type    |
-- +---------------+---------+
-- | stock_name    | varchar |
-- | operation     | enum    |
-- | operation_day | int     |
-- | price         | int     |
-- +---------------+---------+
-- (stock_name, operation_day) is the primary key for this table.
-- This operation column is an ENUM of type ('Sell', 'Buy')

-- Each row of this table indicates that the stock which has stock_name had an operation on the day operation_day with the price.
-- It is guaranteed that each 'Sell' operation for a stock has a corresponding 'Buy' operation in a previous day.

-- Write an SQL query or R/Python code to report the Capital gain/loss for eacxh stock.
-- The capital gain/loss is total gain or loss after buying and selling the stock one or many times. Return the result table in any order.
-- Query result format: | stock_name | capital_gain_loss |

SELECT stock_name, SUM(CASE WHEN operation = 'Sell' THEN price ELSE (-1)*price END) AS capital_gain_loss
FROM Stocks 
GROUP BY stock_name


-- 3. You're given 1 table with schema.

-- Table: Employee
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | id          | int     |
-- | company     | varchar |
-- | salary      | int     |
-- +-------------+---------+

-- Write an SQL query or R/Python code to find the median salary for each company. Bonus points if you can solve it without using any built-in SQL functions.
-- Query result format: | id | company | salary |


SELECT id, company, salary
FROM (
	SELECT *,
		ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id ASC) AS rnk_asc,
		ROW_NUMBER() OVER(PARTITION BY company ORDER BY salary, id DESC) AS rnk_desc
	FROM Employee
) temp
WHERE rnk_asc BETWEEN (rnk_desc-1) AND (rnk_desc+1)
ORDER BY 2,3,1


-- 4. Write a function in Python/R that replaces all missing values of a vector with median of that vector.

median_impute <- function(x){
	ifelse(is.na(x), median(x, na.rm = T), x)
}


