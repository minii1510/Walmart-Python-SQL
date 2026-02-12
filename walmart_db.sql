create database walmart_db;
use walmart_db;

-- Count total recods
select count(*) from walmart;

-- Count payment methods and no of transactions by payment method
select  payment_method ,count(*) as total_count
from walmart
group by payment_method
order by payment_method desc;

-- Count distinct branches
select count(distinct branch) as total_count
from walmart;

-- Find the minimum qty sold
select min(quantity) as lowerst_qty 
from walmart;

-- Find the minimum qty sold
select max(quantity) as highest_qty 
from walmart;

-- Business Problems
-- Q1.Find different payment method and number of transaction , numbers of qty sold
select  payment_method ,count(*) as number_of_transaction,
sum(quantity) as number_of_qty
from walmart
group by payment_method
order by number_of_transaction desc;

-- Q2.Identify the highest_rated Category in each branch , display the branch , category and avg rating.
select * from
(select branch , category , avg(rating) as avg_rating,
rank() over(partition by branch order by  avg(rating) desc) as rnk 
from walmart
group by branch,category
order by branch , avg_rating )t
where rnk =1;

-- Q3. 	dentify the business day for each branch based on the number of transactions. 
select * from
(select branch,
dayname(date) as day_name,
count(*) as no_transaction, 
rank()over(partition by branch order by count(*) desc) as rnk
from walmart
group by branch , day_name) as t
where rnk = 1;

-- Q4. Calculate the total quantity of items sold per payment method . 
select  payment_method,
sum(quantity) as totol_qty
from walmart
group by payment_method;

-- Q5. Determine the average , minimun , maximun rating of categories for each city . 
select city ,category ,
min(rating) as min_rating ,
max(rating) as max_rating ,
avg(rating) as avg_rating 
from walmart
group by city , category;

-- Q6. Calculate the total profit for each category
select category ,
sum(unit_price * quantity * profit_margin) as total_profit
from walmart
group by category
order by total_profit desc;

-- Q7. Determine the most comman payment method for each branch
with cte as(
select branch , payment_method,
count(*) as total_trans , 
rank() over(partition by branch order by count(*) desc) as rnk
from walmart 
group by branch , payment_method)
select branch , payment_method as preferred_payment_method
from cte
where rnk = 1;

-- Q8. Categorize sales into Morning , Afternoon And Evening Shifts
select branch , 
case 
     when hour(time(time)) <12 Then 'Morning'
     when hour(time(time)) between 12 and 17 then 'Afternoon'
     else 'Evening'
     end as Shifts,
     count(*) as num_invoices
from walmart 
group by branch , shifts
order by branch , num_invoices desc ;

-- Q9. Identify the 5 branches with the highest revenue decrease ratio from last year to current year (e.g. 2022, 2023)
with revenue_2022 as (
select branch , 
sum(total) as revenue
from walmart 
where year(date) = 2022
group by branch
),
revenue_2023 as(
select branch ,
sum(total) as revenue 
from walmart
where year(date) = 2023
group by branch
)
select  r2022.branch ,
r2022.revenue as last_year_revenue , 
r2023.revenue as current_year_revenue,
round(((r2022.revenue - r2023.revenue)/ r2022.revenue ) * 100 , 2) as revenue_decrease_ratio
from revenue_2022 as r2022
join revenue_2023 as r2023
on r2022.branch = r2023.branch
where r2022.revenue > r2023.revenue
order by revenue_decrease_ratio desc
limit 5 ;










