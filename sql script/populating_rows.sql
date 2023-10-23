-- populating visit table from csv (✅)
COPY visit(time_stamp, agent, merchant_phone_number, is_visit)
FROM '/tmp/Candidate Exercise - Raw Dataset.xlsx - GForm respond.csv'
DELIMITER ','
CSV HEADER;

-- populating merchant table from csv (✅)
COPY merchant(merchant_id, merchant_phone_number)
FROM '/tmp/Candidate Exercise - Raw Dataset.xlsx - Reseller Info.csv'
DELIMITER ','
CSV HEADER;

-- populating product table from csv (✅)
COPY product(actual_product, product_category, selling_price, is_active)
FROM '/tmp/Candidate Exercise - Raw Dataset.xlsx - Product Catalogue.csv'
DELIMITER ','
CSV HEADER;

-- populating sales table from csv (✅)
COPY sales(order_no, merchant_id, ordered_datetime, customer_name, customer_phone_number, skus, order_quantity, voucher_code, cancel_status)
FROM '/tmp/Candidate Exercise - Raw Dataset.xlsx - Sales.csv'
DELIMITER ','
CSV HEADER;

-- Populating Rows in voucher (✅)
INSERT INTO voucher
VALUES(DEFAULT, 'WELCOME_2023', 10.0, '2023-03-28', '2023-04-05');