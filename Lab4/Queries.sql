
/* QUERIES */

SET SQL_MODE=(SELECT REPLACE(@@sql_mode,'ONLY_FULL_GROUP_BY',''));

/*4)Display the total number of customers based on gender who have placed orders of worth at least Rs.3000*/
SELECT CUS_GENDER AS 'GENDER',COUNT(*) AS 'NUMBER OF CUSTOMERS'
FROM customer
INNER JOIN orders
WHERE customer.CUS_ID=orders.CUS_ID
      AND ORD_AMOUNT >=3000
GROUP BY CUS_GENDER;

/*5)Display all the orders along with product name ordered by a customer having Customer_Id=2*/
SELECT ORD_ID AS 'ORDERS',PRO_NAME AS 'PRODUCT NAME'
FROM customer
JOIN orders
USING (CUS_ID)
JOIN supplier_pricing
USING(PRICING_ID)
JOIN product
USING(PRO_ID)
WHERE CUS_ID=2;

/*6)Display the Supplier details who can supply more than one product*/
SELECT SUPP_NAME,SUPP_CITY,SUPP_PHONE
FROM supplier
JOIN supplier_pricing
USING ( supp_id )
JOIN product
USING ( pro_id )
GROUP BY supp_id
HAVING COUNT( supp_id ) >1;

/*7)Find the least expensive product from each category and print the table with category id, name, product name 
    and price of the product*/
SELECT CAT_ID,CAT_NAME,PRO_NAME,MIN(SUPP_PRICE) AS 'PRICE OF PRODUCT'
FROM category
JOIN product
USING (CAT_ID)
JOIN supplier_pricing
USING ( pro_id )
GROUP BY CAT_NAME
ORDER BY CAT_ID;

/* 8)Display the Id and Name of the Product ordered after “2021-10-05”*/
SELECT PRO_ID,PRO_NAME
FROM product
JOIN supplier_pricing
USING ( PRO_ID )
JOIN orders
USING (PRICING_ID)
WHERE ORD_DATE > "2021-10-05";

/* 9) Display customer name and gender whose names start or end with character 'A'*/
SELECT CUS_NAME,CUS_GENDER
FROM customer
WHERE CUS_NAME LIKE '%A'
      OR CUS_NAME LIKE'A%';

/* 10)Create a stored procedure to display supplier id, name, Rating(Average rating of all the products sold by every customer) and
Type_of_Service. For Type_of_Service, If rating =5, print “Excellent Service”,If rating >4 print “Good Service”, If rating >2 print “Average
Service” else print “Poor Service”. Note that there should be one rating per supplier.*/

DELIMITER &&  
	CREATE PROCEDURE supplierValues()
	BEGIN
	SELECT SUPP_ID,SUPP_NAME, AVG(RAT_RATSTARS ) AS RATING,
Case
when AVG( RAT_RATSTARS )=5 then 'Excellent Service'
when AVG( RAT_RATSTARS )>4 then 'Good Service'
when AVG( RAT_RATSTARS )>3 then 'Average Service'
else 'Poor Service'
end as 'Type_of_Service'
FROM supplier
JOIN supplier_pricing
USING ( SUPP_ID )
JOIN orders
USING ( PRICING_ID )
JOIN rating
USING ( ORD_ID )
GROUP BY SUPP_NAME;
	END &&  
	DELIMITER ;
    
call supplierValues();
    




