/* 
=== SQL/HiveQL ===
You have a table with following information - 
Table name: mail_activity
Table schema: 
{
    date            STRING
    , user_id       STRING
    , event_name    STRING
    , email_id      STRING
    , time_stamp    STRING
}   
Sample data:
+---------------+-----------+---------------+---------------+---------------+
|date           |user_id    |event_name     |email_id       |timestamp      |
+---------------+-----------+---------------+---------------+---------------+
|2018-01-01     |foo        |launch_mail    |NULL           |1514764800     |
|2018-01-01     |foo        |read_mail      |123            |1514764805     |
|2018-01-01     |foo        |read_mail      |456            |1514764811     |
|2018-01-01     |foo        |star_mail      |456            |1514764900     |
|2018-01-01     |foo        |unstar_mail    |456            |1514764903     |
|2018-01-01     |foo        |star_mail      |456            |1514765000     |
|2018-01-01     |bar        |launch_mail    |NULL           |1514765300     |
|2018-01-02     |foo        |launch_mail    |NULL           |1514851200     |
|2018-01-02     |bar        |launch_mail    |NULL           |1514853472     |
....
+---------------+-----------+---------------+---------------+---------------+
*/  


/*
Q1. 
What metrics can you get from this table?
*/

/* 
Q2. 
Write a query to calculate DAU (Daily Active User)? DAU is defined as users who have hit "launch_mail" event.
Desired output: 
+---------------+-----------+
|date           |DAU        |
+---------------+-----------+
|2018-01-01     |35,000,000 |
|2018-01-02     |37,000,000 |
|2018-01-03     |34,000,000 |
...
+---------------+-----------+
*/


SELECT date, count(distinct user_id) AS DAU
FROM Sample
WHERE event_name = 'launch_mail'
GROUP BY date

/*
Q3. 
Can you get the distribution of the number of emails read on "2018-01-01"? 
(where x-axis being number of read emails and y-axis being number of users)
Desired output: 
+-------------------+-----------+
|read_email_count   |user_count |
+-------------------+-----------+
|0                  |25,000,000 |
|1                  |15,000,000 |
|2                  |10,000,000 |
|3                  | 8,000,000 |
.....
+-------------------+-----------+
*/

SELECT 0 AS read_email_count, count(distinct user_id) AS user_count
FROM (
  SELECT user_id
  FROM Sample
  WHERE date = ' 2018-01-01' -- AND event_name in ('launch_mail', 'read_mail')
  GROUP BY user_id
  HAVING count(distinct event_name) = 1
) t2


UNION

SELECT read_email_count, count(distinct user_id) AS user_count
FROM (
  SELECT user_id, count(distinct email_id) AS read_email_count
  FROM Sample
  WHERE date = '2018-01-01' AND event_name = 'read_email'
  GROUP BY user_id
) t2
GROUP BY read_email_count

--2018-01-01, mike, launch_mail, NULL
--2018-01-01, mike, read_mail, 123

--2018-01-01, mike, launch_mail, NULL
--2018-01-01, mike, star_mail, 123



SELECT 
  coalesce(read_email_count,0) AS read_email_count, 
  count(distinct user_id) AS user_count
FROM (
  SELECT distinct user_id
  FROM Sample
  WHERE date = '2018-01-01' AND event_name = 'launch_mail'
) dau
LEFT JOIN (
  SELECT user_id, count(distinct email_id) AS read_email_count
  FROM Sample
  WHERE date = '2018-01-01' AND event_name = 'read_email'
  GROUP BY user_id
) s
ON dau.user_id = s.user_id 
GROUP BY read_email_count
ORDER BY 1


