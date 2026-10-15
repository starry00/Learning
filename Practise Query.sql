DROP TABLE IF EXISTS orders_raw;
 
CREATE TABLE orders_raw (
  order_id   INT,
  category   NVARCHAR(50),
  qty        INT,     -- TEXT!
  unit_price FLOAT,     -- TEXT! (may decimals)
  status     NVARCHAR(50),   -- D = Delivered, S = Shipped, C = Cancelled, R = Returned
  order_date DATE      -- YYYY-MM-DD
);
 
INSERT INTO orders_raw VALUES
  (1,  'Electronics', '2', '1500.50', 'D', '2026-01-03'),
  (2,  'Electronics', '1', '3200.00', 'D', '2026-01-15'),
  (3,  'Fashion',     '3', '450.00',  'D', '2026-01-20'),
  (4,  'Fashion',     '2', '799.99',  'C', '2026-02-02'),
  (5,  'Home',        '4', '250.00',  'D', '2026-02-10'),
  (6,  'Home',        '1', '1200.00', 'R', '2026-02-14'),
  (7,  'Electronics', '1', '899.00',  'S', '2026-02-20'),
  (8,  'Fashion',     '5', '300.00',  'D', '2026-03-01'),
  (9,  'Home',        '2', '640.00',  'D', '2026-03-05'),
  (10, 'Electronics', '3', '120.75',  'D', '2026-03-12'),
  (11, 'Fashion',     '1', '2100.00', 'S', '2026-03-18'),
  (12, 'Home',        '6', '85.50',   'D', '2026-03-25');
 
-- Quick check: dapat 12 rows
SELECT * FROM orders_raw;

--Ipakita: order_id, line_total, status_label, value_flag
-- Tanong: Ilang order ang 'Big'? Ilan ang 'Medium'? Ilan ang 'Small'?

WITH total_sum AS (
SELECT order_id,
category,
sum(qty * unit_price) AS line_total,
CASE status
	WHEN 'D' THEN 'Delivered'
	WHEN 'C' THEN 'Cancelled'
	WHEN 'R' THEN 'Returned'
	WHEN 'S' THEN 'Shipped'
END AS status_label
FROM orders_raw
GROUP BY order_id, category, status),

total_count AS (
Select order_id,
line_total,
CASE 
 WHEN line_total >= 3000 THEN 'Big'
 WHEN line_total >= 1000 THEN 'Medium'
ELSE 'Small'
END AS value_flag
FROM total_sum
)
SELECT 
value_flag,
count(value_flag) AS total_count_flagvalue
FROM total_count
GROUP BY value_flag;

--Revenue report kada category, 
--pero Delivered at Shipped lang ang bibilangin (hindi Cancelled o Returned).

WITH clean AS (
