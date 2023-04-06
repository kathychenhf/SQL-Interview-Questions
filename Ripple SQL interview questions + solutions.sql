-- fact_ticks

-- | exchange | base | counter | price    | order_closetime     | order_size |
-- | ----------------------------------------------------------------------- |
-- | coinbase | btc  | usd     | 34047.24 | 2020-11-09 15:45:21 | 0.5        |
-- | coinbase | eth  | usd     | 1397.36  | 2020-11-11 11:12:01 | 42         |


-- Q1. Calculate the daily open, high, low, close, volume for each trading pair (base/counter) on each exchange.
-- | date | exchange | base | counter | open | high | low | close | volume |


SELECT 
	DATE_TRUNC('day', order_closetime) AS date, 
	exchange, 
	base, 
	counter,
	FIRST_VALUE(price) OVER(PARTITION BY date, exchange, base, counter ORDER BY order_closetime) AS open,
	MAX(price) AS high,
	MIN(price) AS low,
	FIRST_VALUE(price) OVER(PARTITION BY date, exchange, base, counter ORDER BY order_closetime DESC) AS close,
	SUM(order_size) AS volume
FROM fact_ticks
GROUP BY 1,2,3,4


-- Q2. Output the top 5 largest trades for XRP/USD in 2020


SELECT *
FROM fact_ticks
WHERE base = 'XRP' AND counter = 'USD' AND DATE_PART('year', order_closetime) = 2020
ORER BY order_size DESC
LIMIT 5


