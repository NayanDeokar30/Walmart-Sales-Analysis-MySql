create database if not exists walmartsales;
drop table if exists sales;
create table sales(
	invoice_id varchar(30) not null,
    branch varchar(5) not null,
    city varchar(30) not null,
    customer_type varchar(30) not null,
    gender varchar(10) not null,
    product_line varchar(100) not null,
    unit_price decimal(10,2) not null,
    quantity int not null,
    VAT float(6,4) not null,
    total decimal(12,4) not null,
    date datetime not null,
    time time not null,
    payment_method varchar(15) not null,
    cogs decimal(10,2) not null,
    gross_margin_percentage float(11,9),
    gross_income decimal(12,4) not null,
    rating float(2,1) 
);

-- ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------ Feature Engineering -------------------------------------------------------------------------------------------------
-- time_of_day

select 
	time, 
	(case
		when time between "00:00:00" and "12:00:00" then "Morning"
		when time between "12:01:00" and "16:00:00" then "Afternoon"
		else "Evening" 
	end
	) as time_of_day
from sales;

alter table sales add column time_of_day varchar(20);

update sales
set time_of_day = (
	case
			when time between "00:00:00" and "12:00:00" then "Morning"
			when time between "12:01:00" and "16:00:00" then "Afternoon"
			else "Evening" 
	end
);

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- day_name

select date,
	dayname(date) as day_name
from sales;

alter table sales add column day_name varchar(14);

update sales
set day_name = dayname(date);


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- month_name

select date,
	monthname(date) as month_name
from sales;

alter table sales add column month_name varchar(14);

update sales
set month_name = monthname(date);


-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------- Generic ---------------------------------------------------------------------------------------------
-- how many unique cities does the data have
select distinct city from sales;

-- in which city is each branch
select distinct branch from sales;
select distinct city,branch from sales;

-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ---------------------------------------------------------------------- Product ---------------------------------------------------------------------------------------------
-- how many unique product lines does the data have
select distinct product_line from sales;
select count(distinct product_line) from sales;


-- what is the most common payment method
select payment_method, 
	   count(payment_method) as count 
from sales group by(payment_method) order by count desc;


-- what is the most selling product line 
select product_line,
	   count(product_line) as count
from sales group by(product_line) order by count desc;


-- what is the total revenue by month
select month_name as month,
	   sum(total) as total_revenue
from sales group by(month_name) order by total_revenue desc;


-- what month has the largest cogs
select month_name as month,
	   sum(cogs) as cogs
from sales group by(month_name) order by cogs desc;


-- which product line has the largest revenue
select product_line,
	   sum(total) as revenue
from sales group by(product_line) order by revenue desc;


-- what is the city with the largest revenue
select branch,
	   city,
       sum(total) as largest_revenue
from sales group by city, branch order by largest_revenue desc;


-- what product line has the largest VAT
select product_line,
	   avg(VAT) as largest_VAT
from sales group by product_line order by largest_VAT desc;


-- Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales








-- Which branch sold more products than average product sold?
select branch,
	   sum(quantity) as qty
from sales group by branch 
having sum(quantity) > (select avg(quantity) from sales);


-- What is the most common product line by gender?
select gender,
	   product_line,
       count(gender) as total_cnt
from sales group by gender, product_line order by total_cnt desc;


-- What is the average rating of each product line?
select product_line,
	   round(avg(rating), 2) as avg_rating                                         -- to round of avg value upto 2 decimal places
from sales group by product_line order by avg_rating desc;



-- ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ------------------------------------------------------------------ Sales ---------------------------------------------------------------------------------------------------

-- Number of sales made in each time of the day per weekday
select time_of_day,
	   count(*) as total_sales
from sales  where day_name = "Monday" group by time_of_day order by total_sales desc;


-- Which of the customer types brings the most revenue?
select customer_type,
	   sum(total) as total_rev
from sales group by customer_type order by total_rev desc;


-- Which city has the largest tax percent/ VAT (Value Added Tax)?
select city,
	   avg(VAT) as VAT
from sales group by city order by VAT desc limit 1;


-- Which customer type pays the most in VAT?
select customer_type,
	   sum(VAT) as total_vat
from sales group by customer_type order by total_vat desc ;











