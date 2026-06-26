# Practice Assignment 3

The solution for the Ass03 is a query in ass03.sql script.

### Structure

First queries in the script are for creating tables. Then the user can execute the script to fill up the 
database. Next queries are functions and procedures - calculate_order_total calculates sum of quantity*price and returns
0 if the sum is NULL, create_order does exactly that, add_product_to_order is the same with required
checks, and triggers to update order_total and log the orders. The final queries are for testing the 
triggers and other procedures/functions.