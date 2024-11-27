SELECT *

FROM walmart_db.Walmart;


-- Business Problems
-- Q.1 Find different payment method and number of transactions, number of qty sold

SELECT payment_method, COUNT(payment_method) as number_of_transactions, SUM(quantity) as number_of_qty_sold
FROM walmart_db.Walmart
GROUP BY payment_method
ORDER BY number_of_transactions DESC;

-- Q.2 Identify the highest-rated category in each branch, displaying the branch, category
-- AVG RATING

SELECT Branch, category, AVG(rating), RANK() OVER(PARTITION BY Branch ORDER BY AVG(rating) DESC) as Ranked
FROM walmart_db.Walmart
GROUP BY 1,2;

-- Q3. Identify the busiest day for each branch based on the number of transactions
SELECT 
*
FROM(
SELECT Branch,DAYNAME(STR_TO_DATE(date, '%d/%m/%y')) AS day_name, COUNT(*) as number_of_transactions,
RANK()OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) AS ranked
FROM Walmart_db.Walmart
GROUP BY 1,2
ORDER BY 1,3 DESC
)subquery

WHERE ranked =1 ;


-- Q4. Calculate the total quantity of items sold per payment method. List payment_method and total_quantity

SELECT payment_method, SUM(quantity) as total_quantity

FROM walmart_db.Walmart

GROUP BY payment_method;

-- Q5. Determine the average, minimum, and maximum rating of products for each city.
-- List the city, average_rating, min_rating, and max_rating

SELECT 
*
FROM(
SELECT City, category, MAX(rating) as max_rating, AVG(rating) as average_rating, MIN(rating) as min_rating
FROM walmart_db.Walmart
GROUP BY 1, 2) subquery

WHERE City = 'Irving';

-- Q6. Calculate the total profit for each category by considering total profit as
-- (unit_price * quantity * profit_margin) List category and total_profit, order from highest to lowest profit.

SELECT category, SUM((total*profit_margin)) as total_profit
FROM walmart_db.Walmart
GROUP BY category
ORDER BY total_profit DESC;

-- Q7. Determine the most common payment method per branch

SELECT Branch,payment_method,COUNT(*) as total_transaction,
RANK() OVER (PARTITION BY Branch ORDER BY COUNT(*) DESC) as ranked
FROM walmart_db.Walmart
GROUP BY 1,2;

-- Q8. Categorize sales into 3 group Morning, Afternoon , Evening
-- Find out which of the shift and number of invoices

WITH CTE AS(
SELECT Branch,COUNT(*) as number_of_invoices, CASE 
WHEN HOUR(time) < 12 THEN 'Morning'
WHEN HOUR(time) BETWEEN 12 AND 17 THEN 'Afternoon'
ELSE 'Evening'
END AS day_time,
RANK()OVER(PARTITION BY Branch ORDER BY COUNT(*) DESC) as ranked
FROM walmart_db.Walmart
GROUP BY 1,3)

SELECT *
FROM CTE
WHERE ranked =1;

-- Q9 Identify 5 branch with highest decrease ratio in
-- revenue compare to last year(current year 2023 and last year 2022)
-- rdr == last_year revenue - current_ revenue/ last year revenue *100

WITH revenue_2022 AS(
SELECT Branch,SUM(total) as revenue_2022
FROM walmart_db.Walmart
WHERE YEAR(STR_TO_DATE (date, "%d/%m/%y")) = 2022
GROUP BY 1
),

revenue_2023 AS(
SELECT Branch,SUM(total) as revenue_2023
FROM walmart_db.Walmart
WHERE YEAR(STR_TO_DATE (date, "%d/%m/%y")) = 2023
GROUP BY 1
)

SELECT lyr.Branch, lyr.revenue_2022,cyr.revenue_2023,
ROUND((revenue_2022-revenue_2023)/revenue_2022 * 100,2) as decrease_ratio_rate

FROM revenue_2022 lyr JOIN revenue_2023 cyr
ON lyr.Branch = cyr.Branch
WHERE revenue_2022 > revenue_2023
ORDER BY decrease_ratio_rate DESC;





