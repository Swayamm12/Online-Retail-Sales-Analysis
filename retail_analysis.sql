--Total revenue (overall) 
select sum(revenue) as total_revenue
from  retail;

--Total orders
select count(distinct(invoiceno)) as total_orders
from retail;

--Total quantity sold
select sum(quantity) as total_quantity_sold
from retail;

--Average order value
select round(sum(revenue)/count(distinct(invoiceno)), 2) as avg_order_value
from retail;

--Top 10 products by revenue/ highest revenue generating product
select description, round(sum(revenue), 2) as total_revenue
from retail
group by description
order by total_revenue desc
limit 10;

--Top 10 product by quantity sold
select description, round(sum(quantity), 2) as total_quantity_sold
from retail
group by description
order by total_quantity_sold desc
limit 10;

--Least selling product
select description, round(sum(quantity), 2) as total_quantity_sold
from retail
group by description
order by total_quantity_sold;

--Top 10 customers by spending
select customerid, round(sum(revenue), 2) as total_spending
from retail
group by customerid
order by total_spending desc
limit 10;

--Number of unique customer
select  count(distinct(customerid)) as unique_customers
from retail;

--Customers who buy frequently
select customerid, count(distinct(invoiceno)) as total_orders
from retail
group by customerid
order by total_orders desc
limit 10;

--Which country generates highest revenue? / Top 5 country by sales
select country, round(sum(revenue), 2) as total_revenue
from retail
group by country
order by total_revenue desc;

--Which country has most orders
select country, count(distinct(invoiceno)) as total_orders
from retail
group by country
order by total_orders desc;

--Monthly sales trend / Best sales month
select extract(month from invoicedate) as month, 
       round(sum(revenue), 2) as total_revenue
from retail
group by month
order by month;

--Daily/weekly purchase pattern
select extract (dow from invoicedate) as day_num,
       to_char(invoicedate, 'Day') as day_name,
       round(sum(revenue), 2) as total_revenue
from retail
group by day_num, day_name
order by day_num;

--peak hours of sales
select extract(hour from invoicedate) as hour,
       round(sum(revenue), 2) as total_revenue
from retail
group by hour
order by total_revenue desc;

--Products that are often bought together
select a.description as product_1, 
       b.description as product_2,
	   count(*) as times_bought_together
from retail a
join retail b
     on a.invoiceno = b.invoiceno
	 and a.description<b.description

group by product_1, product_2
order by times_bought_together desc;

--Revenue distribution across customers by cust count and percentage
SELECT
    customer_segment,
    COUNT(*) AS customer_count,
    ROUND(
        COUNT(*) * 100.0 /
        SUM(COUNT(*)) OVER (),
        2
    ) AS percentage_of_customers
FROM (
    SELECT customerid,
           CASE
               WHEN SUM(revenue) >= 10000 THEN 'High Value'
               WHEN SUM(revenue) >= 1000 THEN 'Medium Value'
               ELSE 'Low Value'
           END AS customer_segment
    FROM retail
    GROUP BY customerid
) t
GROUP BY customer_segment;
       


