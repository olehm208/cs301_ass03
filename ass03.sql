create table customers (
    customer_id serial primary key,
    full_name varchar(100) not null,
    email varchar(100) unique not null,
    balance numeric(10,2) default 0
);

create table products (
    product_id serial primary key,
    product_name varchar(100) not null,
    price numeric(10,2) not null,
    stock_quantity int not null
);

create table orders (
    order_id serial primary key,
    customer_id int references customers(customer_id),
    order_date timestamp default current_timestamp,
    total_amount numeric(10,2) default 0
);

create table order_items (
    order_item_id serial primary key,
    order_id int references orders(order_id),
    product_id int references products(product_id),
    quantity int not null,
    price numeric(10,2) not null
);

create table order_log (
    log_id serial primary key,
    order_id int,
    customer_id int,
    action varchar(50),
    log_date timestamp default current_timestamp
);

create or replace function calculate_order_total(p_order_id int)
returns int as $$
	select 
		coalesce(sum(quantity*price),0)
	from order_items item
	where item.order_id = p_order_id
$$ language sql;

create or replace procedure create_order(p_customer_id int)
language plpgsql
as $$
begin
	if exists(select 1 
				from customers c 
				where c.customer_id = p_customer_id) then
		insert into orders(customer_id, total_amount, order_date)
		values (p_customer_id, 0, current_timestamp)
	else
		-- Пан Володимир, я знаю, що тут будуть питання :-)
		raise notice 'Customer with ID % doesn`t exist. Aborting.', p_customer_id
	end if;
end;
$$;
end

create or replace procedure add_product_to_order(
    p_order_id int,
    p_product_id int,
    p_quantity int
)
language plpgsql
as $$
begin
	update products
	set stock_quantity = stock_quantity - p_quantity
	where product_id = p_product_id
	and p_quantity > 0
	and stock_quantity >= p_quantity;
	-- перевіряє чи минулий запит взагалі пройшов
	if found then
		insert into order_items (order_id, product_id, quantity, price)
		select p_order_id, p_product_id, p_quantity, price
		from products
		where product_id = p_product_id;
	end if;
end;
$$;
end

create or replace function trigger_update_order_total()
returns trigger as $$
begin
	update orders
	set total_amount = calculate_order_total(coalesce(NEW.order_id, OLD.order_id))
	where order_id  = coalesce(NEW.order_id, OLD.order_id);

	return null;
end;
$$ language plpgsql;

create trigger trg_update_order_total
after insert or delete or update on order_items
for each row
execute function trigger_update_order_total();
