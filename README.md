# Zomato_Analysis
Zomato Data Exploration and Analysis with SQL (SQL SERVER).
Zomota is a largest food delivery company.The idea of analysing the Zomato_dataset is to get the overview of what actutally is happening in their business. Zomato Dataset consist of more than 9000 rows with columns such as Restaurants_id, Restaurants_name, City, Location, Cuisines and many more...
While Exploring Data with SQL, I was working on the following things...
In zomato_dataset, Country_name was not available. So, I have add country_name column and updated dataset based on the countrycode.
while updating country_name in the dataset, its complex to update single query, so I have used CTE(Common Table Expression) query to update at a time. I have cross checked itself with single queries.
I have split the data into multiple tables and create relationship between them to remove duplication and improve data integrity.
while inserting data into multiple tables, I have modify the data types and used joins, subqueries to insert data easily and fast.
After the data Exploration with SQL, I started working on Analysing the data with SQL where I found insights...
According to this zomato dataset, 90.67 % of data related to restaurants in India followed by Georgia, England.
Out of 15 countries, Only 2 Countries provides Online delivery Option to their customers, ie., India, United Arab Emirates.
As this dataset contains data most related to India so i worked on gaining insights on Indian Restaurants.
In India, New Delhi has total 5473 Restaurants in 254 places followed by gurgaon and Noida.
Connaught Place in New Delhi has the most listed restaurants (122) follwed by Rajouri Garden (99) and Shahdara (87).
Out of 122 restaurants in  Connaught place only 52 restaurants provides online delivery.
Later, I have catagorize the restaurant into poor, average, good, excellent based on star rating with CASE Statement.
Best modrately priced restaurants with average cost for two < 1000, rating > 4 and provides both table booking and online delivery options to their customer with indian cuisines is located in Kolkata,India named as 'India Restaurant'.
