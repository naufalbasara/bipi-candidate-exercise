-- 1a
CREATE TABLE whole_sales AS 
SELECT 
	order_no, sales.merchant_id, DATE(sales.ordered_datetime) as ordered_date, sales.ordered_datetime::time as ordered_time,
	customer_name, customer_phone_number, skus, product_category, order_quantity, selling_price,
	sales.voucher_code, 
	deduction as voucher_deduction, 
	cancel_status,
	visits.is_visit as visit_day
FROM sales 
	INNER JOIN product ON sales.skus LIKE product.actual_product
	INNER JOIN merchant ON sales.merchant_id = merchant.merchant_id
	LEFT JOIN voucher ON sales.voucher_code LIKE voucher.voucher_code
	LEFT JOIN (
		SELECT DATE(time_stamp) as visit_date, merchant_phone_number, is_visit from visit
	) as visits ON merchant.merchant_phone_number = visits.merchant_phone_number and visits.visit_date = DATE(sales.ordered_datetime)

-- 2a
select sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
where cancel_status = 'F';

-- 2b number of unique customers
select count(distinct customer_name) as unique_customer, count(distinct customer_phone_number) as unique_customer_by_phone from whole_sales
where customer_name <> 'TEST';

-- 2c check data
-- check merchant/reseller compliant (merchant input TEST as customer, merchant phone number in customer section)
select merchant_id, count(customer_name) 
from whole_sales
where customer_name = 'TEST'
group by merchant_id order by merchant_id;

select distinct whole_sales.merchant_id
from whole_sales
inner join merchant on split_part(whole_sales.merchant_id, '+60',1) = merchant.merchant_id
where split_part(whole_sales.customer_phone_number, '+60',2) = merchant.merchant_phone_number

-- 2d total sales during visit day (merchant combined)
select sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
where cancel_status = 'F' and visit_day = true;

select count(distinct merchant.merchant_id) from merchant inner join visit on merchant.merchant_phone_number = visit.merchant_phone_number;

-- (merchant not combined)
select merchant_id, cancel_status, visit_day, sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
group by merchant_id, cancel_status, visit_day
having cancel_status = 'F' and visit_day = true;

-- 3 analyzing sales data
-- sales in each product category
select product_category, sum(order_quantity) as quantity, sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
where cancel_status = 'F'
group by product_category
order by total_sale desc;

-- sales in each product
select skus, sum(order_quantity) as quantity, sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
where cancel_status = 'F'
group by skus
order by total_sale desc
limit 10;

-- merchant that used a lot voucher
select merchant_id, count(voucher_code) as voucher_usage
from whole_sales
group by merchant_id
order by voucher_usage desc
limit 15;

-- total sales in each month
select EXTRACT('MONTH' from ordered_date) as month, sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
GROUP BY EXTRACT('MONTH' from ordered_date)
ORDER BY EXTRACT('MONTH' from ordered_date);

select EXTRACT('MONTH' from ordered_date) as month, count(voucher_code) as voucher_usage
from whole_sales
group by month
order by voucher_usage desc;

-- total sales in each month for every merchant
select merchant_id, EXTRACT('MONTH' from ordered_date), sum(selling_price - coalesce(voucher_deduction, 0)) as total_sale
from whole_sales
GROUP BY merchant_id, EXTRACT('MONTH' from ordered_date)
ORDER BY EXTRACT('MONTH' from ordered_date), merchant_id;

-- export tables to csv file
COPY whole_sales TO '/tmp/whole_sales.csv' DELIMITER ',' CSV HEADER;
