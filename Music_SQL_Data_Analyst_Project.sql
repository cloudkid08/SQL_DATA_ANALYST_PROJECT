/* Q1: Who is the senior most employee based on job title? */

select first_name,last_name,title 
from employee
order by levels desc
limit 1

/* Q2: Which countries have the most Invoices? */

select count(invoice_id) as total_invoices,billing_country 
from  invoice
group by 2
order by 1 desc

/* Q3: What are top 3 values of total invoice? */

select total 
from invoice
order by 1 desc
limit 3

/* Q4: Which city has the best customers? We would like to throw a promotional Music Festival in the city we made the most money. 
Write a query that returns one city that has the highest sum of invoice totals. 
Return both the city name & sum of all invoice totals */

select billing_city,sum(total) invoice_total 
from invoice
group by 1
order by 2 desc
limit 1


/* Q5: Who is the best customer? 
The customer who has spent the most money will be declared the best customer. 
Write a query that returns the person who has spent the most money.*/

select c.first_name,c.last_name,sum(i.total) as total_invoice 
from customer c
join invoice i
on c.customer_id = i.customer_id
group by 1,2
order by 3 desc
limit 1



/* Q6: Write query to return the email, first name, last name, & Genre of all Rock Music listeners. 
Return your list ordered alphabetically by email starting with A. */

select distinct c.first_name,c.last_name,c.email
from customer c
join invoice i
on i.customer_id = c.customer_id
join invoice_line il
on il.invoice_id = i.invoice_id
join track t
on t.track_id = il.track_id
join genre g
on g.genre_id = t.genre_id
where g.name like 'Rock'
order by 3



/* Q7: Let's invite the artists who have written the most rock music in our dataset. 
Write a query that returns the Artist name and total track count of the top 10 rock bands. */

select a.name as artist_name,count(g.name) as track_count
from artist a
join album al
on a.artist_id = al.artist_id
join track t
on t.album_id = al.album_id
join genre g
on g.genre_id = t.genre_id
where g.name like 'Rock'
group by 1
order by 2 desc
limit 10


/* Q8: Return all the track names that have a song length longer than the average song length. 
Return the Name and Milliseconds for each track. 
Order by the song length with the longest songs listed first. */

select name, milliseconds 
from track
where milliseconds > (select round(avg(milliseconds),2) from track)
order by 2 desc

/* Q9: Find how much amount spent by each customer on artists? 
Write a query to return customer name, artist name and total spent */


with customer_artist as (
select distinct first_name,last_name,a.name,sum(il.unit_price*il.quantity) as total_spent
from customer c
join invoice i
on c.customer_id = i.customer_id
join invoice_line il
on il.invoice_id = i.invoice_id
join track t
on t.track_id = il.track_id
join album al
on al.album_id = t.album_id
join artist a
on a.artist_id = al.artist_id
group by 1,2,3
order by 4 desc)

select * from customer_artist




/* Q10: We want to find out the most popular music Genre for each country. 
We determine the most popular genre as the genre 
with the highest amount of purchases. 
Write a query that returns each country along with the top Genre. For countries where 
the maximum number of purchases is shared return all Genres. */



with max_purchases_country_wise as 
(	
select c.country, g.name as genre_name, count(il.quantity) as total_purchase,
dense_rank() over(partition by c.country order by count(il.quantity ) desc) as rnk
from customer c
join invoice i 
on c.customer_id = i.customer_id
join invoice_line as il
on il.invoice_id = i.invoice_id
join track t
on t.track_id = il.track_id
join genre g
on g.genre_id = t.genre_id
group by 1,2
order by 3 desc
)
select * from max_purchases_country_wise
where rnk=1




/* Q11: Write a query that determines the customer that has spent the most on music for each country. 
Write a query that returns the country along with the top customer and how much they spent. 
For countries where the top amount spent is shared, provide all customers who spent this amount. */

with customer_country as  (
select c.first_name,c.last_name,c.country,sum(i.total) as total,
dense_rank() over(partition by c.country order by sum(i.total) desc ) as rnk
from customer c
join invoice i
on i.customer_id = c.customer_id
group by 1,2,3
order by 4 desc
)
select * from customer_country
where rnk =1







