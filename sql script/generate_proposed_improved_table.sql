CREATE TABLE merchant (
	id SERIAL PRIMARY KEY,
	merchant_name varchar(50),
	merchant_phone_number varchar(50),
	location_id serial REFERENCES location(id),
	created_at timestamp
);

CREATE TABLE customer (
	id SERIAL PRIMARY KEY,
	name varchar(50),
	phone_number varchar(50),
	location_id SERIAL REFERENCES location(id),
	created_at timestamp
);

CREATE TABLE location (
	id SERIAL PRIMARY KEY,
	city varchar(50),
	state varchar(50),
	country varchar,
	full_address varchar
);

CREATE TABLE product (
	id SERIAL PRIMARY KEY,
	product_title varchar,
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
	merchant_id SERIAL REFERENCES merchant(id),
	is_visit bool
);

CREATE TABLE sales (
	id SERIAL PRIMARY KEY,
	order_no bigint unique not null,
	merchant_id SERIAL REFERENCES merchant(id),
	ordered_datetime timestamp,
	customer_id SERIAL REFERENCES customer(id),
	product_id SERIAL REFERENCES product(id),
	order_quantity integer,
	voucher_id SERIAL REFERENCES voucher(id),
	cancel_status bool
);