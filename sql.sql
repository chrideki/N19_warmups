-- Get a list of the 3 long-standing customers for each country

WITH standing_by_country AS(
SELECT
    customer_id,
    country,
    order_date,
    RANK() OVER(PARTITION BY country ORDER BY order_date) AS rank
FROM customers
JOIN orders USING(customer_id)
) 
SELECT *
FROM standing_by_country
WHERE rank <= 3;

-- Modify the previous query to get the 3 newest customers in each each country.

WITH first_order AS(
SELECT
    customer_id,
    country,
    MIN(order_date) as date_first_order
FROM customers
JOIN orders USING(customer_id)
GROUP BY customer_id, country
), 
standing_by_country AS(
SELECT
    *,
    RANK() OVER(PARTITION BY country ORDER BY date_first_order DESC) AS rank
FROM first_order
) 
SELECT *
FROM standing_by_country
WHERE rank <= 3;

-- Get the 3 most frequently ordered products in each city
-- FOR SIMPLICITY, we're interpreting "most frequent" as 
-- "highest number of total units ordered within a country"
-- hint: do something with the quanity column

WITH quantity_per_product AS(
SELECT
    ship_city,
    product_id,
    SUM(quantity) OVER(PARTITION BY product_id) as total_quantity
FROM orders
JOIN order_details USING(order_id)
),
rank_quantity_by_city AS(
    SELECT
    *,
    RANK() OVER(PARTITION BY ship_city ORDER BY total_quantity DESC) as rank
    FROM quantity_per_product   
    )
    SELECT
        *
    FROM rank_quantity_by_city
    WHERE rank <= 3;



