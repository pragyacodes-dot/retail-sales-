use da_intern;
select * from `sql - retail sales analysis_utf`;

-- data cleaning 
select count(*) from 
`sql - retail sales analysis_utf`;
 

select * from 
`sql - retail sales analysis_utf`
where ï»¿transactions_id is null;

select * from 
`sql - retail sales analysis_utf`
where sale_date is null;

select * from 
`sql - retail sales analysis_utf`
where sale_time is null;

SELECT * FROM `sql - retail sales analysis_utf`
WHERE 
    sale_date IS NULL
    OR 
    sale_time IS NULL
    OR
    gender IS NULL
    OR
    category IS NULL
    OR
    quantiy IS NULL
    OR
    cogs IS NULL
    OR
    total_sale IS NULL;
    
-- `checking duplicate values
    
select * from `sql - retail sales analysis_utf`;
    
with duplicate_cte as (
select*,
row_number() over( partition by ï»¿transactions_id,customer_id, gender, age) as row_num
from `sql - retail sales analysis_utf`)
select * from duplicate_cte 
where row_num >1;

-- Data exploration
-- How many sales we have?

select count(*) as totalsales 
from `sql - retail sales analysis_utf`;

-- How many uniuque customers we have ?

select distinct customer_id 
 from `sql - retail sales analysis_utf`;


select count(distinct customer_id) as total_customers
 from `sql - retail sales analysis_utf`;

-- what are different categories we have?

select distinct category 
 from `sql - retail sales analysis_utf`;

select distinct age
 from `sql - retail sales analysis_utf`; 
 
 -- Data Analysis & Business Key Problems & Answers

-- Q.1 Write a SQL query to retrieve all columns for sales made on '2022-11-05
select  * from `sql - retail sales analysis_utf`where 
sale_date = "2022-11-05";

-- Q.2 Write a SQL query to retrieve all transactions where the category is 'Clothing' and the quantity sold is more than 10 in the month of Nov-2022
select * from `sql - retail sales analysis_utf`
where category = "clothing"
and  format(sale_date, 'YYYY-MM') = '2022-11'
    AND
    quantiy >= 4;

-- Q.3 Write a SQL query to calculate the total sales (total_sale) for each category.
 select category, sum(total_sale) as sales 
 from `sql - retail sales analysis_utf`
 group by category;
 
-- Q.4 Write a SQL query to find the average age of customers who purchased items from the 'Beauty' category.
select category, avg(age) as average_age
 from `sql - retail sales analysis_utf`
where category= "beauty";
-- Q.5 Write a SQL query to find all transactions where the total_sale is greater than 1000.

select * from `sql - retail sales analysis_utf`
where total_sale > 1000;
-- Q.6 Write a SQL query to find the total number of transactions (transaction_id) made by each gender in each category.

select count(ï»¿transactions_id) as total_trans, gender , category
from  `sql - retail sales analysis_utf`
group by gender, category;

-- Q.7 Write a SQL query to calculate the average sale for each month. Find out best selling month in each year

SELECT 
       year,
       month,
    avg_sale
FROM 
(    
SELECT 
    EXTRACT(YEAR FROM sale_date) as year,
    EXTRACT(MONTH FROM sale_date) as month,
    AVG(total_sale) as avg_sale, 
    RANK() OVER(PARTITION BY EXTRACT(YEAR FROM sale_date) ORDER BY AVG(total_sale) DESC) as rankS
FROM `sql - retail sales analysis_utf`
GROUP BY 1, 2
) as t1
WHERE rankS = 1;

-- Q.8 Write a SQL query to find the top 5 customers based on the highest total sales 
select customer_id, sum(total_sale) as highestsale from `sql - retail sales analysis_utf`
group by customer_id
order by highestsale desc
limit 5;

-- Q.9 Write a SQL query to find the number of unique customers who purchased items from each category.
select count(distinct customer_id) as unique_customers , category from 
`sql - retail sales analysis_utf`
group by category;

-- Q.10 Write a SQL query to create each shift and number of orders (Example Morning <=12, Afternoon Between 12 & 17, Evening >17)
with hourly_sale
as
(
select *, 
case 
     when extract(hour FROM sale_time) < 12 then "morning" 
     when extract(hour FROM  sale_time) between 12 and 17 then "afternoon"
	 else "evening"
     end as shift 
from `sql - retail sales analysis_utf`
)
select shift,
count(*) as tota_orders 
from hourly_sale
group by shift; 