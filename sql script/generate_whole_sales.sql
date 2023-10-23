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