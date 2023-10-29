#create database by exploding csv file
create database zomato;
use zomato;
select * from zomato_dataset;
# 1.add column name country in the dataset
alter table zomato_dataset add country_name varchar(55);
#1.add data in the new column
set sql_safe_updates = 0;
update zomato_dataset set country_name = 'India' where countrycode = 1;
update zomato_dataset set country_name = 'Australia' where countrycode = 14;
update zomato_dataset set country_name = 'Brazil' where countrycode = 30;
update zomato_dataset set country_name = 'Canada' where countrycode = 37;
update zomato_dataset set country_name = 'Indonesia' where countrycode = 94 ;
update zomato_dataset set country_name = 'NewZealand' where countrycode = 148 ;
# 2. update multiple records using one query by using cte
update zomato_dataset
set country_name= case countrycode 
when 162 then 'philippines'
when 166 then 'qatar'
else country_name
end;

# update multiple records
update zomato_dataset
set country_name = case countrycode
when 184 then 'singapore'
when 189 then 'South Africa'
when 191 then 'Srilanka'
when 208 then 'Turkey'
when 214 then 'United Arab Emirates'
when 215 then 'England'
when 216 then 'Georgia'
else country_name
end;

select countrycode, country_name from zomato_dataset where country_name = 'England';
select * from zomato_dataset;

#3.create different tables from the large table for better understanding
create table hotel (
RestaurantID int Primary key,
RestaurantName varchar(50),
Cuisines varchar(50));

create table bookings(
booking_id integer auto_increment primary key,
hotel_id int,
RestauratnName varchar (50),
Has_Table_booking varchar(10),
Has_Online_delivery varchar(10),
Is_delivery_now varchar(10),
foreign key(hotel_id) references hotel(RestaurantID)
);

create table Payment (
payment_id int auto_increment primary key,
cuisines varchar(50),
Average_cost_for_two int,
booking_id int,
hotel_id int,
foreign key(hotel_id) references hotel(RestaurantID),
foreign key(booking_id) references bookings(booking_id) );

create table address (
address_id int auto_increment primary key,
hotel_id int,
countrycode int,
city varchar(50),
address varchar (100),
locality varchar(50),
localityverbose varchar(50),
country_name varchar(20),
foreign key(hotel_id) references hotel(RestaurantID) );

create table star_rating(
hotel_id int,
address_id int,
Restaurantname varchar (50),
votes int,
rating int,
price_range int,
foreign key(hotel_id) references hotel(RestaurantID),
foreign key(address_id) references address(address_id));

#4. insert data into new tables

insert into hotel (RestaurantId,RestaurantName, cuisines) select Restaurantid, restaurantname, cuisines from zomato_dataset;
# data too long for column cuisines
alter table hotel modify column cuisines varchar(100);
ALTER TABLE hotel MODIFY COLUMN RestaurantName VARCHAR(100);
insert into hotel (RestaurantId,RestaurantName, cuisines) select Restaurantid, restaurantname, cuisines from zomato_dataset;
select * from hotel;

# insert data into bookings

# data too long for restaurant name
ALTER TABLE bookings MODIFY COLUMN RestauratnName VARCHAR(100);
insert into bookings (hotel_id,RestauratnName, has_table_booking, has_online_delivery, Is_delivery_now) select 
restaurantid,restaurantname, has_table_booking,
has_online_delivery, Is_delivering_now from zomato_dataset;

select * from bookings;

# insert data into payment
alter table payment add currency varchar(100);
insert into payment (cuisines, average_cost_for_two, booking_id, hotel_id, currency) 
select zd.Cuisines, zd.Average_Cost_for_two, b.booking_id, b.hotel_id, zd.Currency from zomato_dataset zd join bookings b 
on zd.RestaurantID = b.hotel_id;
ALTER TABLE payment MODIFY COLUMN cuisines VARCHAR(100);

select * from payment;

# insert data into address
select * from address;
insert into address (hotel_id, countrycode, city, address, locality, localityverbose, country_name) 
select restaurantid , countrycode, city, address, locality, localityverbose, country_name from zomato_dataset;
ALTER TABLE address MODIFY COLUMN localityverbose VARCHAR(100);
ALTER TABLE address MODIFY COLUMN address VARCHAR(200);
ALTER TABLE address MODIFY COLUMN locality VARCHAR(100);
select * from address;

#insert data to the star rating
select * from star_rating;
insert into star_rating (hotel_id, address_id, restaurantname, votes, rating, price_range)
select a.hotel_id, a.address_id, zd.restaurantname, zd.votes, zd.rating, zd.price_range from zomato_dataset zd
 inner join address a on zd.restaurantid = a.hotel_id;

ALTER TABLE star_rating MODIFY COLUMN Restaurantname VARCHAR(100);
select * from star_rating;

# followed rules of atomacity

# count of restaurants in the dataset
select count(country_name) as total_no_of_restaurants, country_name from address 
group by country_name order by count(country_name) desc;

# india has highest restaurants followed by georgia, england
# avg percentage of india 
select(((select count(country_name) from address where country_name='india')/
(select count(country_name) from address)) * 100) as indian_percentage;

# write a query how many countries are provided online delivery
select country_name, count(country_name) as total_no_of_hotels, Has_Online_delivery from bookings b inner join address a 
on a.hotel_id = b.hotel_id  where Has_Online_delivery = 'yes' group by country_name;

# which country has highest listed restaurants in india
select  distinct city,count(city)as total_number_of_restaurants, count(distinct(locality)) as total_places from address
 where country_name = 'india' group by city order by count(city) desc ;
 
 # in which locality has highest number of restaurants
select locality ,count(locality), city from address where city = 'new delhi' group by locality order by count(locality) desc;

# how many restaurants have online delivery in connaught place
select locality,Has_Online_delivery, count(*) as total_no_of_restaurants from bookings b inner join address a on
 b.hotel_id = a.hotel_id where locality = 'connaught place' group by Has_Online_delivery;

# categorize the restaurant into poor <= 2 , average = 2- 3 , good = 3-4 , expensive >5
select * from star_rating;
select restaurantname, rating,
case
when rating <= 2 then 'poor'
when rating >= 2.5 and rating <=3 then 'average'
when  rating >= 3.5 and rating <= 4 then 'good'
when rating >=4.1 then 'excellent'
end as hotel_rating
from star_rating;

# write a  query where average cost of two was 1000 - 1500, rating 4-5 , price range = 3-4 provides 
# both table booking and online delivery for indian customers
select p.Average_cost_for_two, sr.rating, b.Has_Online_delivery,b.Has_Table_booking, a.city, h.restaurantname
from payment p inner join star_rating sr on p.hotel_id= sr.hotel_id inner join bookings b on sr.hotel_id = b.hotel_id
inner join address a on b.hotel_id = a.hotel_id inner join hotel h on a.hotel_id = h.RestaurantID
where country_name = 'india' and p.Average_cost_for_two <1000 and sr.rating > 4
and b.Has_Online_delivery = 'yes' and b.Has_Table_booking = 'yes';