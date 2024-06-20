create database bikestore;
use bikestore;
show tables;

-- lets check all the tables--

select * from brands;
select * from categories;
select * from customers;
select * from order_items;
select * from orders;
select * from products;
select * from staffs;
select * from stocks;
select * from stores;


-- DATA ANALYSIS--

--  Which store has the highest sale--

with total_revenue as
(select oi.order_id,oi.product_id,oi.quantity,oi.list_price,oi.discount,s.store_id,s.store_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join stores s 
on o.store_id=s.store_id)

select store_name,sum(total_sales) as revenue, 
(sum(total_sales)/(select sum(total_sales) from total_revenue))*100 as percentage
from total_revenue
group by store_name
order by revenue desc;

-- Most Valuable Customer --

with total_spent as
(select oi.order_id,c.customer_id,oi.quantity,oi.list_price,oi.discount,c.first_name,c.last_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join customers c
on o.customer_id=c.customer_id)

select customer_id,first_name,last_name,sum(total_sales) as spent
from total_spent
group by customer_id,first_name,last_name
order by spent desc
limit 10;

-- Year wise most revenue

with total_spent as
(select oi.order_id,oi.product_id,o.order_date,oi.quantity,oi.list_price,oi.discount,years,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join (select order_id,SUBSTRING(order_date,7, 4) AS years from orders) as yearstable
on oi.order_id=yearstable.order_id
)

select years,sum(total_sales) as salesperyear
from total_spent
group by years
order by salesperyear desc;

-- Month wise most revenue

with total_spent as
(select oi.order_id,oi.product_id,o.order_date,oi.quantity,oi.list_price,oi.discount,months,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join (select order_id,SUBSTRING(order_date,4, 2) AS months from orders) as monthstable
on oi.order_id=monthstable.order_id
)

select months,sum(total_sales) as salesperyear
from total_spent
group by months
order by salesperyear desc;

-- Most selled product on 2016

with selled_product as
(select oi.order_id,o.order_date,oi.quantity,oi.list_price,oi.discount,p.product_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join products p
on oi.product_id=p.product_id)

select product_name,sum(quantity) as quantitysold,sum(total_sales) as salesperproduct
from selled_product
where order_date like "%-2016"
group by product_name
order by salesperproduct desc
limit 10;

-- Most selled product on 2017

with selled_product as
(select oi.order_id,o.order_date,oi.quantity,oi.list_price,oi.discount,p.product_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join products p
on oi.product_id=p.product_id)

select product_name,sum(quantity) as quantitysold,sum(total_sales) as salesperproduct
from selled_product
where order_date like "%-2017"
group by product_name
order by salesperproduct desc
limit 10;

-- Most selled product on 2018

with selled_product as
(select oi.order_id,o.order_date,oi.quantity,oi.list_price,oi.discount,p.product_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
left join orders o
on oi.order_id=o.order_id
left join products p
on oi.product_id=p.product_id)

select product_name,sum(quantity) as quantitysold,sum(total_sales) as salesperproduct
from selled_product
where order_date like "%-2018"
group by product_name
order by salesperproduct desc
limit 10;


-- Best Staff Seller

with selled_product as
(select oi.order_id,s.staff_id,oi.quantity,oi.list_price,oi.discount,s.first_name,s.last_name,
((oi.quantity*oi.list_price)*(1-oi.discount)) total_sales from order_items oi
 join orders o
on oi.order_id=o.order_id
 join staffs s
on o.staff_id=s.staff_id)

select staff_id,first_name,last_name,sum(total_sales) as salesperstaff
from selled_product
group by staff_id,first_name,last_name
order by salesperstaff desc;




