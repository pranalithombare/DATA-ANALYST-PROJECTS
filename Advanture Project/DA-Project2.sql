create database DAP2;
USE DAP2;

CREATE TABLE Salespeople (
    snum INT NOT NULL,
    sname VARCHAR(50),
    city VARCHAR(20),
    comm FLOAT
);

INSERT INTO Salespeople (snum, sname, city, comm)
VALUES (1001, 'Peel', 'London', 0.12),
(1002, 'Serres', 'San Jose', 0.13),
(1003, 'Axelrod', 'New york', 0.10),
(1004, 'Motika', 'London', 0.11),
(1007, 'Rafkin', 'Barcelona', 0.15);
 
CREATE TABLE Cust (
    cnum INT NOT NULL,
    cname VARCHAR(50),
    city VARCHAR(20),
	rating INT,
    snum INT NOT NULL
);

INSERT INTO Cust (cnum, cname, city, rating, snum)
VALUES (2001, 'Hoffman', 'London', 100, 1001),
(2002, 'Giovanne', 'Rome', 200, 1003),
(2003, 'Liu', 'San Jose', 300, 1002),
(2004, 'Grass', 'Berlin', 100, 1002),
(2006, 'Clemens', 'London', 300, 1007),
(2007, 'Pereira', 'Rome', 100, 1004),
(2008, 'James', 'London', 200, 1007);

CREATE TABLE Orders (
    onum INT NOT NULL,
    amt float,
    odate DATE,
    cnum INT NOT NULL,
    snum INT NOT NULL
);

INSERT INTO Orders (onum, amt, odate, cnum, snum)
VALUES (3001, 18.69, '1994-10-03', 2008, 1007),
(3002, 1900.10, '1994-10-03', 2007, 1004),
(3003, 767.19, '1994-10-03', 2001, 1001),
(3005, 5160.45, '1994-10-03', 2003, 1002),
(3006, 1098.16, '1994-10-04', 2008, 1007),
(3007, 75.75, '1994-10-05', 2004, 1002),
(3008, 4723.0, '1994-10-05', 2006, 1001),
(3009, 1713.23, '1994-10-04', 2002, 1003),
(3010, 1309.95, '1994-10-06', 2004, 1002),
(3011, 9891.88, '1994-10-06', 2006, 1001);


# Q 4.	Write a query to match the salespeople to the customers according to the city they are living.
SELECT 
    salespeople.snum, sname, cnum, cname, salespeople.city
FROM
    salespeople
        INNER JOIN
    cust ON salespeople.snum = cust.snum
WHERE
    salespeople.city = cust.city;
    
# Q5 Write a query to select the names of customers and the salespersons who are providing service to them.

SELECT 
    cust.cname, salespeople.sname
FROM
    cust
        LEFT JOIN
    salespeople ON cust.snum = salespeople.snum;
    
# Q6.	Write a query to find out all orders by customers not located in the same cities as that of their salespeople

SELECT * FROM orders WHERE cnum NOT IN (
SELECT 
    cnum FROM
    salespeople
        INNER JOIN
    cust ON salespeople.snum = cust.snum
WHERE
    salespeople.city = cust.city);
    
# Q7.	Write a query that lists each order number followed by name of customer who made that order

SELECT 
    onum, cname
FROM
    orders
        LEFT JOIN
    cust ON orders.cnum = cust.cnum;

#Q 8.	Write a query that finds all pairs of customers having the same rating

SELECT 
    *
FROM
    CUST
WHERE
    rating IN (SELECT 
            rating
        FROM
            cust
        GROUP BY rating
        HAVING COUNT(rating) > 1)
ORDER BY rating;

#Q 9.	Write a query to find out all pairs of customers served by a single salesperson

SELECT 
    *
FROM
    CUST
WHERE
    snum IN (SELECT 
            snum
        FROM
            cust
        GROUP BY snum
        HAVING COUNT(snum) > 1);

#Q 10.	Write a query that produces all pairs of salespeople who are living in same city

SELECT 
    *
FROM
    salespeople
WHERE
    city IN (SELECT 
            city
        FROM
            salespeople
        HAVING COUNT(city) > 1);


#Q 11.	Write a Query to find all orders credited to the same salesperson who services Customer 2008

SELECT 
    *
FROM
    orders
WHERE
    snum = (SELECT 
            snum
        FROM
            cust
        WHERE
            cnum = 2008);

#Q12.	Write a Query to find out all orders that are greater than the average for Oct 4th

SELECT 
    *
FROM
    orders
WHERE
    amt > (SELECT 
            ROUND(AVG(amt), 2)
        FROM
            orders
        WHERE
            odate = '1994-10-04');

#Q 13.	Write a Query to find all orders attributed to salespeople in London.
 
SELECT 
    *
FROM
    orders
WHERE
    snum IN (SELECT 
            snum
        FROM
            salespeople
        WHERE
            salespeople.city = 'London');
            
#Q 14.	Write a query to find all the customers whose cnum is 1000 above the snum of Serres. 

SELECT 
    *
FROM
    cust
WHERE
    cnum > 1000 + (SELECT 
            snum
        FROM
            salespeople
        WHERE
            sname = 'Serres');
            
#Q 15.	Write a query to count customers with ratings above San Jose’s average rating.

SELECT 
    *
FROM
    cust
WHERE
    rating > (SELECT 
            AVG(rating)
        FROM
            cust
        WHERE
            city = 'San Jose');
            
#Q 16.	Write a query to show each salesperson with multiple customers.

SELECT 
    *
FROM
   Salespeople
WHERE
    snum IN (SELECT 
            snum
        FROM
            cust
        GROUP BY snum
        HAVING COUNT(snum) > 1);
