CREATE TABLE merchant (
	id SERIAL PRIMARY KEY,
	merchant_id varchar(50) unique,
	merchant_phone_number varchar(50) unique
);

CREATE TABLE product (
	id SERIAL PRIMARY KEY,
	actual_product varchar unique,
	product_category varchar,
	selling_price float,
	is_active bool
);

CREATE TABLE voucher (
	id SERIAL PRIMARY KEY,
	voucher_code varchar(50) UNIQUE,
	deduction float,
	start_date date,
	end_date date
);

CREATE TABLE visit (
	id SERIAL PRIMARY KEY,
	time_stamp timestamp,
	agent varchar,
	merchant_phone_number varchar REFERENCES merchant(merchant_phone_number),
	is_visit bool
);

CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	order_no bigint not null, -- long in java
	merchant_id varchar REFERENCES merchant(merchant_id),
	ordered_datetime timestamp,
	customer_name varchar,
	customer_phone_number varchar,
	skus varchar,
	order_quantity integer,
	voucher_code varchar, -- regex or %like% keyword to find voucher if there is a typo
	cancel_status varchar
);