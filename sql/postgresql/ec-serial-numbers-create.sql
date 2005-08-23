--
-- Ecommerce Serial Number Tracking Package
--
-- @author Joe Cooper (joe@virtualmin.com)
-- @author Timo Hentschel (timo@timohentschel.de)
-- @creation-date 2005-08-18
--




create table ec_serial_numbers (
	serial_id		integer constraint ec_serial_numbers_serial_id_pk primary key,
	license_key		varchar(100),
	start_date		date,
	end_date		date,
	owner_id		integer references users(user_id),
	software_id		integer references ec_products(product_id)
);

