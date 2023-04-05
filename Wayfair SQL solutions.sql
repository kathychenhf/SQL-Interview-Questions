
# SQL Questions by Wayfair
# SQL online IDE: https://sqliteonline.com/

CREATE TABLE table1(
   emp_id     INTEGER  NOT NULL PRIMARY KEY 
  ,emp_name   VARCHAR(15) NOT NULL
  ,department VARCHAR(25) NOT NULL
  ,salary     INTEGER  NOT NULL
  ,hire_date  DATE  NOT NULL
);
INSERT INTO table1(emp_id,emp_name,department,salary,hire_date) VALUES (1,'Alice','HR',60000,'2019-01-01');
INSERT INTO table1(emp_id,emp_name,department,salary,hire_date) VALUES (2,'Bob','IT',80000,'2017-06-15');
INSERT INTO table1(emp_id,emp_name,department,salary,hire_date) VALUES (3,'Charlie','Finance',70000,'2018-03-20');
INSERT INTO table1(emp_id,emp_name,department,salary,hire_date) VALUES (4,'David','IT',90000,'2016-11-10');
INSERT INTO table1(emp_id,emp_name,department,salary,hire_date) VALUES (5,'Emily','HR',55000,'2020-08-05');


# Question 1
# Write a sql query to calculate the variation rate of the average salary of the employees who joined in 2016 versus the ones who joined in 2020. 

# Suppose the variation rate formula = (2020 avg salary - 2016 avg salary) / (2016 avg salary)

WITH temp AS (
  SELECT date_part('year', hire_date) AS year, AVG(salary) AS avg_salary
  FROM table1
  WHERE date_part('year', hire_date) in (2016,2020)
  GROUP BY date_part('year', hire_date)
)

SELECT 
	ROUND(
	(SUM(CASE WHEN year = 2020 THEN avg_salary ELSE 0 END) - SUM(CASE WHEN year = 2016 THEN avg_salary ELSE 0 END)) * 100
    /
    SUM(CASE WHEN year = 2016 THEN avg_salary ELSE 0 END)
    ,2) AS "variation_rate (%)"
FROM temp;



# Question 2
# Calculate the percentage share of the total company salary for each department and rank the departments based on their share for each year.

SELECT 
	department, 
    date_part('year', hire_date) AS year,
	sum(salary) AS sum_salary,
    ROUND(SUM(salary) * 100 / SUM(SUM(salary)) OVER (),2) AS "pct_share (%)"
FROM table1
GROUP BY 1,2
ORDER BY 4 DESC;


