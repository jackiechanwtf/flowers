create table product(
prod_id int auto_increment not null PRIMARY KEY,
prod_name varchar(60) null,
prod_measure varchar(60) null,
prod_price float null,
prod_category int null
);
create table users(
user_id int auto_increment not null primary key,
login varchar(60) null,
password varchar(60) null,
user_role varchar(60) null
);
create table sell_report(
date_of_sell date null,
prod_id int,
foreign key(prod_id) references product(prod_id),
amount float null,
selling_price float null
);
create table report(
year int null,
month int null,
prod_id int,
foreign key(prod_id) references product(prod_id),
sum_price float null,
value float null
);
create table user_order(
order_id int primary key auto_increment,
user_id int,
foreign key(user_id) references users(user_id),
state varchar(1)
);
create table order_product(
order_id int,
foreign key(order_id) references user_order(order_id),
prod_id int,
foreign key(prod_id) references product(prod_id),
amount float null
);