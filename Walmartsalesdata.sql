#Creating the database
CREATE DATABASE IF NOT EXISTS salesdatawalmart;
use salesdatawalmart;
----------------------------------------------------------------------------------------------------------------------------------------------------
drop table walmartsalesdata;
#creating the table sales inside salesdatawalmart
CREATE TABLE IF NOT EXISTS sales(
invoice_id varchar(30) not null primary key,
branch varchar(5) not null,
city varchar (30) not null,
customer_type VARCHAR(30) not null,
gender VARCHAR(10) not null,
product_line varchar(100) not null,
unit_price decimal(10,2) not null,
quantity int not null,
VAT float (6,4) not null,
total decimal (10,2) not null,
date date not null,
time time not null,
payment_method decimal(10,2) not null,
cogs decimal(10,2) not null,
gross_margin_percentage float(11,9) not null,
gross_income decimal(12,4) not null,
rating float(2,1) not null
);

select * from sales;

#Analysis
#Appproach 1. Data Wrangaling, 2. Feature Engineering 3.EDA 


-- Feature Engineering
-- Time_of_day

select * from sales;

select time, 
(case when `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
when `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
end) AS time_of_day
FROM sales;

ALTER table sales ADD Column time_of_day Varchar(50);

select * from sales;

UPDATE sales #using update and set, so that we can add the column time_of_day to sales table 
SET time_of_day = (case when `time` BETWEEN "00:00:00" AND "12:00:00" THEN "Morning"
when `time` BETWEEN "12:01:00" AND "16:00:00" THEN "Afternoon"
ELSE "Evening"
end); # this case is used, to seprate the different time into a specific time period.

-- Adding day_name column

select date, DAYNAME(date) from sales;

Alter table sales Add column day_name varchar(50);

UPDATE sales 
set day_name = (DAYNAME(date));

-- Adding day_name column
select date, MONTHNAME(date) from sales;
alter table sales add column month_name varchar(50);
update sales 
set month_name = (MONTHNAME(date));
----------------------------------------------------------------------------------------------------

-- EDA Exploratory data analysis
# 1. How many unique cities does the data have?
select distinct city
from sales; 
#Answer 3 different citis

#2. In which city each branch is located 
select distinct city , branch from sales;
# 3 cities 3 branches A= Yangon, B= mandalay, c= Naypjitaw

-- Product analysis
#1. How many unique product lines does the data have?
select count( distinct product_line) from sales;
#2. What is the most common payment method?
select payment_method,
count(payment_method) as cnt from sales
Group by payment_method order by cnt desc;

#3. What is the most selling product line?
select product_line,
count(product_line) as cnt from sales
Group by product_line order by cnt desc;

#4.What is the total revenue by month?
select distinct month_name from sales;
select month_name,
sum(total) as Total_revenue
from sales
group by month_name order by Total_revenue;
-- 5 What month had the largest COGS?
select Cogs,
sum(cogs)as cogs
from sales
group by cogs order by cogs desc;
-- 6 What product line had the largest revenue?
select product_line,
sum(total) as total_revenue
from sales
group by product_line order by total_revenue;
-- 7 What is the city with the largest revenue?
select city,
sum(total) as total_revenue from sales
group by city order by total_revenue;
-- 8 What product line had the largest VAT?
select product_line,
sum(VAT) as value_tax
from sales
group by product_line order by value_tax desc;
-- 9 Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
select product_line, case 
when AVG(quantity)>6 Then "Good" 
ELSE "Bad"
end as remoark from sales 
group by product_line;
-- 10 Which branch sold more products than average product sold?
select branch,
sum(quantity) as qty
from sales
group by branch 
having sum(quantity)> (select avg(quantity) from sales);
-- 11 What is the most common product line by gender?
select gender, product_line,
count(gender) as total_count
from sales
group by gender,product_line order by total_count desc;
-- 12 What is the average rating of each product line?
select 
round(avg(rating),2) as avg_rating, product_line
from sales
group by product_line
order by avg_rating desc;

-- Sales Analysis
# Number of sales made in each time of the day per weekday
use salesdatawalmart;
select time_of_day,
count(*) as total_sales
from sales
where day_name = "Monday"
group by time_of_day order by total_sales desc;

select time_of_day,
count(*) as total_sales
from sales
where day_name = "Tuesday"
group by time_of_day order by total_sales desc;

select time_of_day,
count(*) as total_sales
from sales
where day_name = "Wednesday"
group by time_of_day order by total_sales desc;

select time_of_day,
count(*) as total_sales
from sales
where day_name = "Thrusday"
group by time_of_day order by total_sales desc;

select time_of_day,
count(*) as total_sales
from sales
where day_name = "Friday"
group by time_of_day order by total_sales desc; # evening experiences most sales, the stores are filled during evening hours

# Which of the customer types brings the most revenue?
select customer_type,
sum(total) as total_revenue
from sales
group by customer_type order by total_revenue;

# Which city has the largest tax/VAT percent?
select city,
avg(VAT) as value_tax
from sales
group by city order by value_tax desc;

# Which customer type pays the most in vat 
select customer_type,
avg(VAT) as value_tax
from sales
group by customer_type order by value_tax desc;

-- customer analysis 
# How many unique customer types does the data have?
select distinct (customer_type) from sales;

# How many unquie payment methods does that data have?
select distinct (payment_method) from sales;

# what is the common customer type
select 
customer_type,
count(*) as total_count
from sales
group by customer_type order by total_count; 

#Which customer type buys the most?
select customer_type, 
count(*) as total_count 
from sales
group by customer_type order by total_count;

# What is the gender of most of the customers?
select gender,
count(*) as gender_count
from sales
group by gender order by gender_count;

# What is the gender distribution per branch?
select gender,
count(*) as gender_count
from sales
where branch ="C"
group by gender order by gender_count desc;

# Which time of the day do customers give most ratings?
select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day order by avg_rating desc;

#  Which time of the day do customers give most ratings per branch?
select time_of_day,
avg(rating) as avg_rating
from sales
group by time_of_day order by avg_rating ;

select time_of_day,
avg(rating) as avg_rating
from sales
where branch = "C"
group by time_of_day order by avg_rating ;

# Which day fo the week has the best avg ratings?
select day_name,
avg(rating) as avg_rating
from sales
group by day_name order by avg_rating desc;

# Which day of the week has the best average ratings per branch?
select day_name,
avg(rating) as avg_rating
from sales
where branch ="A"
group by day_name order by avg_rating;

#Revenue And Profit Calculations
--- total gross
SELECT
	city,
    ROUND(AVG(tax_pct), 2) AS avg_tax_pct
FROM sales
GROUP BY city 
ORDER BY avg_tax_pct DESC;

-- Which customer type pays the most in VAT?
SELECT
	customer_type,
	AVG(VAT) AS total_tax
FROM sales
GROUP BY customer_type
ORDER BY total_tax;
