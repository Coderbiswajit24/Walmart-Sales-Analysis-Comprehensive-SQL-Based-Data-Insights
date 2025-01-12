-- Task 1:- Write a sql query to find unique cities 
-- Query:-
select 
    distinct city as unique_cities
from sales;	

-- Task 2:- Write a SQL QUERY to find how many unique product line this sales data have.
-- Query:-

select
     distinct product_line as unique_product_line
from sales;	 


--Task 3:-  Write a SQL query to find the most common payment method in this sales dataset
-- Query:-
select * from sales;

select
     payment,
	 count(invoice_id) as total_invoice_count
from sales
    group by payment
	     order by total_invoice_count desc
		      limit 1;

-- Task 4:-  Write a SQL query to find most selling product line from this sales dataset
-- Query:-
select
     product_line,
	 count(invoice_id) as product_line_count
from sales
    group by product_line
	    order by product_line_count desc;

-- Task 5:-  Write a SQL query to find total refenue by month from this sales dataset
-- Query:-
select
    extract(month from sales_date) as sales_month,
	round(sum(total),3) as total_revenue_per_month
from sales	
    group by extract(month from sales_date)
	     order by total_revenue_per_month desc;

-- Task 6:-  Write a SQL query to find out which product line makes maximum revenue
-- Query:-
select
    product_line,
	round(sum(total),2) as product_line_wise_revenue
from sales
    group by product_line
	     order by product_line_wise_revenue desc
		     limit 1;

-- Task 7:-  Write a SQL query to find which city makes largest revenue in this sales dataset
-- Query:- 
select
    city,
	round(sum(total),3) as city_wise_revenue
from sales
    group by city
	     order by city_wise_revenue desc
		     limit 1;

-- Task 8:- Write a SQL query to find what is the average rating of each product line
-- Query:- 
select
     product_line,
	 round(avg(rating)::numeric,1) as avg_rating_per_product_line
from sales
    group by product_line
	    order by avg_rating_per_product_line desc;

-- Task 9:- Write a SQL query to find most commom product line by gender in this sales dataset.
-- Query:- 
select -- outer query 
     t.gender as customer_gender,
	 t.product_line as most_common_product_line
from (select -- inner query
     gender,
	 product_line,
	 count(invoice_id) as total_number_of_invoice_count,
	 rank() over(partition by gender order by count(invoice_id) desc) as product_line_rank
from sales
    group by gender,product_line) as t
	    where t.product_line_rank = 1
		
-- Task 10:-  Write a SQL query to find which branch sold more products than average product sold
-- Query:- 
select
     branch as branch_name,
	 count(product_line) as total_number_product_line_sold
from sales
    group by branch
	    having count(product_line) > (select count(product_line)/count(distinct branch) as avg_number_product_line_sold from sales);

-- Task 11:-  Write a SQL query Fetch each product line and add a column to those product line showing "Good", "Bad". Good if its greater than average sales
-- Query:-
select
    t.product_line,
	case 
	    when t.total_number_of_product_line_sold > t.avg_number_of_product_line_sold then 'Good Sold'
		else 'Bad Sold'
	end as product_line_sold_status	
from (select
     product_line,
	 count(invoice_id) as total_number_of_product_line_sold,
	 (select count(product_line)/count(distinct product_line) as avg_number_of_product_line_sold from sales)
from sales
    group by product_line) as t
	    

-- Task 12:-   Write a SQL query to find the number of sales made in each time of the day per weekday 
-- Query:- 
select
     to_char(sales_date,'Day') as weekday,
	 sales_time,
	 count(invoice_id) as total_number_of_sales
from sales
    group by to_char(sales_date,'Day') , sales_time
	     order by weekday;

-- Task 13:-  Write a SQL query to find Which of the customer types brings the most revenue.
-- Query:- 
select
    customer_type,
	round(sum(total),3) as total_revenue
from sales
    group by customer_type
	     order by total_revenue desc
		     limit 1;

-- Task 14:- Write a SQL qyuery to find Which city has the largest tax percent/ VAT (Value Added Tax)	
-- Query:- 
select
     city as largest_tax_payment_city
from sales
    where tax_pct = (select max(tax_pct) from sales);


-- Task 15:-  Write a SQL query to find Which customer type pays the most in VAT/tax_pct.
-- Query:- 
select
    customer_type as maximum_tax_payment_customer_type
from sales
    where tax_pct = (select max(tax_pct) from sales);
	
	 
-- Task 16:-  Write a SQL query to find How many unique customer types does the data have
-- Query:- 
select 
    distinct customer_type as unique_customer_type
from sales;	

-- Task 17:-  Write a SQL query to find How many unique payment methods does the data have
-- Query:- 
select
     distinct payment as unique_payment_method
from sales ;	 

-- Task 18:-  Write a SQL query to find What is the most common customer type
-- Query:- 
select
     customer_type as most_common_customer_type,
	 count(invoice_id) as customer_type_wise_count
from sales
     group by customer_type
	      order by customer_type_wise_count desc
		       limit 1;

-- Task 19:-   Write a SQL query to find Which day of the week has the best average ratings per branch	
-- Query:- 
select
     t.branch_name,
	 t.weekday,
	 t.average_rating as best_avgerage_rating
from (select
     branch as branch_name,
	 to_char(sales_date,'Day') as weekday,
	 round(avg(rating)::numeric,1) as average_rating,
	 rank() over(partition by branch order by round(avg(rating)::numeric,1) desc ) as average_rating_rank
from sales
     group by branch,to_char(sales_date,'Day')) as t
	      where t.average_rating_rank = 1;
              
-- Task 20:-  Write a SQL query to find Which time of the day do customers give most ratings per branch
-- Query:- 
select
     t.branch_name,
	 t.weekday,
	 t.sales_time,
	 t.count_of_rating as most_rating_count
from (select
    branch as branch_name,
	to_char(sales_date,'Day') as weekday,
	sales_time,
	count(rating) as count_of_rating,
	rank() over(partition by branch order by count(rating) desc) as rating_rank
from sales
    group by branch,to_char(sales_date,'Day'),sales_time ) as t
	     where t.rating_rank = 1

-- Task 21:-  Write a SQL query to find What is the gender of most of the customers
-- Query:- 
select
    gender,
	count(invoice_id) as total_count
from sales
    group by gender
	     order by total_count desc
		      limit 1;

-- Task 22:-  Write a SQL query What is the gender distribution per branch
-- Query:- 
select
    branch,
	gender,
	count(invoice_id) as gender_count,
	concat(round(count(invoice_id)*100/sum(count(invoice_id)) over(partition by branch),2),'%') as gender_distribution
from sales
    group by branch,gender
	     order by branch,gender;

-- Task 23:-  Write a SQL query find Which day fo the week has the best avg ratings
-- Query:- 
select
     to_char(sales_date,'Day') as weekday,
	 round(avg(rating)::numeric,2) as best_avg_rating
from sales
    group by to_char(sales_date,'Day')
	     order by best_avg_rating desc;
		     -- limit 1;
    
-- Task 24: - Write a sql query to find branch wise total sales
-- Query:- 
select
     branch,
	 sum(total) as total_revenue
from sales
    group by branch
	     order by total_revenue desc;


-- Task 25:-  Write a sql query to find customer type distribution by city
-- Query:- 
select
     city,
	 customer_type,
	 concat(round(count(invoice_id)* 100/sum(count(invoice_id)) over(partition by city),2),'%') as customer_type_distribution
from sales
   group by city,customer_type
       order by city asc ,customer_type asc;

-- Task 26:-  Write a sql query to find average quantity sale by each product line
-- Query:- 
select
    product_line,
	round(avg(quantity)::numeric,0) as average_quantity_sold_per_product_line
from sales
    group by product_line;


-- Task 27:-  Write a  SQL query to find average customer satisfaction rating by payment method
-- Query:- 
select
    payment as payment_method,
	round(avg(rating)::numeric,2) as avg_satisfaction_rating
from sales
    group by payment;

-- Task 28:-  Write a SQL query to find monthly trends of total gros margin percentage and customer satisfaction rating per city.
-- Query:- 
select
     city,
	 to_char(sales_date,'Month') as selling_months,
	 round(sum(gross_margin_pct)::numeric , 2) as total_gross_margin_pct,
	 round(avg(rating)::numeric , 2) as avg_satisfaction_rating
from sales
    group by city,to_char(sales_date,'Month')
	     order by city asc, selling_months asc;
	 