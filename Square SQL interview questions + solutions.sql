-- Below are a set of questions about the data.
-- Please answer them by writing queries using the following schema:

-- employees
-- +---------------+---------+
-- | id            | int     |
-- | first_name    | varchar |
-- | last_name     | varchar |
-- | salary        | int     |
-- | department_id | int     |
-- +---------------+---------+

-- departments
-- +---------------+---------+
-- | id            | int     |
-- | name          | varchar |
-- +---------------+---------+

-- projects
-- +---------------+---------+
-- | id            | int     |
-- | title         | varchar |
-- | start_date    | date    |
-- | end_date      | date    |
-- | budget        | int     |
-- +---------------+---------+

-- employees_projects
-- +---------------+---------+
-- | project_id    | int     |
-- | employee_id   | int     |
-- +---------------+---------+

-- Q1. How many employees are there?


SELECT COUNT(DISTINCT id)
FROM employees


-- Q2. How many employees are there in each department?


SELECT d.name, COUNT(DISTINCT e.id)
FROM employees e 
JOIN departments d 
ON e.department_id = d.id 
GROUP BY d.name 


-- Q3. How many unique first names do employees have?


SELECT COUNT(DISTINCT first_name)
FROM employees


-- Q4. What department pays the most in total salary?


SELECT d.name, SUM(salary)
FROM employees e 
JOIN departments d 
ON e.department_id = d.id 
GROUP BY d.name 
ORDER BY SUM(salary) DESC 
LIMIT 1


-- Q5. Which departments are involved in which projects?
-- Format should be department name, project title, employee id


SELECT d.name, p.title, e.id 
FROM projects p
JOIN employees_projects ep ON p.id = ep.project_id
JOIN employees e ON ep.employee_id = e.id 
JOIN departments d ON e.department_id = d.id 


-- Q6. Which department ended a project most recently?


SELECT d.name, p.title
FROM projects p
JOIN employees_projects ep ON p.id = ep.project_id
JOIN employees e ON ep.employee_id = e.id 
JOIN departments d ON e.department_id = d.id 
ORDER BY end_date DESC 
LIMIT 1


-- Q7. Which employees do not have a project?


SELECT e.id, e.first_name, e.last_name
FROM employees e 
LEFT JOIN employees_projects ep 
ON ep.employee_id = e.id 
WHERE ep.project_id IS NULL


