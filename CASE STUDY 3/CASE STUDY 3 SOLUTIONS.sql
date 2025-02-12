

/*
Dataset:

The 3 key datasets for this case study are:

a. Continent: The Continent table has two attributes i.e., region_id and
region_name, where region_name consists of different continents such as
Asia, Europe, Africa etc., assigned with the unique region id.

b. Customers: The Customers table has four attributes named customer_id,
region_id, start_date and end_date which consists of 3500 records.

c. Transaction: Finally, the Transaction table contains around 5850 records
and has four attributes named customer_id, txn_date, txn_type and
txn_amount.

*/

SELECT * FROM CONTINENT

SELECT COUNT(distict customer_id) FROM Customers

SELECT * FROM Transactions;



--1. Display the count of customers in each region who have done the transaction in the year 2020.

SELECT ct.region_name,count(distinct c.customer_id) as Count_of_Customers FROM Transactions as T
inner join Customers as c
on T.customer_id=c.customer_id
inner join Continent as ct
on c.region_id=ct.region_id
where Year(T.txn_date)=2020
GROUP by ct.region_name

--2. Display the maximum and minimum transaction amount of each transaction type.

SELECT txn_type,MIN(txn_amount) AS MIN_TXN, MAX(txn_amount) AS MAX_TXN FROM Transactions
GROUP BY txn_type

/*
3. Display the customer id, region name and transaction amount where
transaction type is deposit and transaction amount > 2000.
*/

SELECT C.customer_id,CT.region_name,TS.txn_amount FROM Customers AS C
INNER JOIN Transactions AS TS
ON C.customer_id=TS.customer_id
INNER JOIN Continent AS CT
ON C.region_id=CT.region_id
WHERE TS.txn_type='deposit' and TS.txn_amount>2000

--4. Find duplicate records in the Customer table.

SELECT customer_id, region_id, start_date,end_date, COUNT(*) AS duplicate_count
FROM Customers
GROUP BY customer_id, region_id, start_date,end_date
HAVING COUNT(*) > 1;


/*
5. Display the customer id, region name, transaction type and transaction
amount for the minimum transaction amount in deposit.
*/

select c.customer_id,ct.region_name,ts.txn_type,ts.txn_amount from Customers as c
inner join Continent as ct
on c.region_id=ct.region_id
inner join Transactions as ts
on c.customer_id=ts.customer_id
where ts.txn_type='deposit' and ts.txn_amount=
(select MIN(txn_amount) from Transactions
where txn_type='deposit')

/*
6. Create a stored procedure to display details of customers in the
Transaction table where the transaction date is greater than Jun 2020.
*/

CREATE PROCEDURE CUSTOMER_DET
(@TXN_MONTH INT,
@TXN_YEAR INT)
AS
BEGIN
    SELECT * FROM Transactions
    WHERE txn_date > DATEFROMPARTS(@TXN_YEAR, @TXN_MONTH, 30)
END;


EXECUTE CUSTOMER_DET 6,2020


-- 7. Create a stored procedure to insert a record in the Continent table.

SELECT * FROM Continent

CREATE PROCEDURE NEW_CONTINENT
(@REGION_ID INT,
@REGION_NAME VARCHAR(20)
)
AS
BEGIN
SET NOCOUNT ON;-- Prevents "X rows affected" messages

IF NOT EXISTS( SELECT 1 FROM Continent WHERE region_id=1)
BEGIN
INSERT INTO Continent(region_id,region_name) VALUES(@REGION_ID,@REGION_NAME)

PRINT('NEW RECORD INSERTED SUCCESSFULLY')
END
ELSE
BEGIN
PRINT('ERROR: REGION ID ALREADY EXISTS!')
END
END

/*
8. Create a stored procedure to display the details of transactions that
happened on a specific day.
*/

CREATE PROCEDURE TRANSACTIONS_ON
(@TXN_DATE DATE)
AS
BEGIN
SET NOCOUNT ON;

--CHECK WEATHER DATE IS EXISTS
IF EXISTS(SELECT 1 FROM Transactions WHERE txn_date=@TXN_DATE)
BEGIN
SELECT * FROM Transactions WHERE txn_date=@TXN_DATE
END
ELSE
BEGIN
RAISERROR('NO RECORDS FOUND ON THIS DAY', 16, 1);
END
END

--9. Create a user defined function to add 10% of the transaction amount in a table.

CREATE FUNCTION ADD_10PCT_AMOUNT
()
RETURNS TABLE
AS 
RETURN
(SELECT customer_id,txn_type,txn_amount,txn_amount*1.1 AS '10_PCT__ADDED_AMOUNT' FROM Transactions)

SELECT * FROM dbo.ADD_10PCT_AMOUNT()

-- 10. Create a user defined function to find the total transaction amount for a given transaction type.

CREATE FUNCTION TRANSACTION_AMOUNT
(@TRANSACTION_TYPE VARCHAR(50))
RETURNS INT
AS
BEGIN
RETURN (SELECT SUM(txn_amount) FROM Transactions WHERE txn_type=@TRANSACTION_TYPE)
END

-- USING THE FUNCTION

SELECT  dbo.TRANSACTION_AMOUNT('withdrawal') as 'Transaction Amount'


/*
11. Create a table value function which comprises the columns customer_id,
region_id ,txn_date , txn_type , txn_amount which will retrieve data from
the above table.
*/

create function comprised_table()
returns table
as
return( select c.customer_id,ct.region_id,ts.txn_date,ts.txn_type,ts.txn_amount
from Customers as c
inner join Continent as ct
on c.region_id=ct.region_id
inner join Transactions as ts
on c.customer_id=ts.customer_id)


--execution
select * from comprised_table()

--12. Create a TRY...CATCH block to print a region id and region name in a single column.

BEGIN TRY
	SELECT CAST(region_id AS nvarchar)+' - '+ region_name AS REGION_INFO FROM Continent
END TRY
BEGIN CATCH
	PRINT 'Error occurred: ' + Error_message();
END CATCH

--13. Create a TRY...CATCH block to insert a value in the Continent table.

begin try
	insert into Continent(region_id,region_name) values (6,'Pak')
	print 'Inserted Successfully'
end try
begin catch
	print 'Error Occurred: '+ Error_message()
end catch

--14. Create a trigger to prevent deleting a table in a database.

CREATE TRIGGER DONOT_DELETE ON DATABASE
AFTER DROP_TABLE
AS
BEGIN
PRINT 'YOU DONT HAVE ANY PERSION TO DROP A TABLE'
ROLLBACK
END

--15. Create a trigger to audit the data in a table.

CREATE TABLE AUDIT_CUSTOMER
(EMPLOYEE_COUNT INT)

SELECT COUNT(*) FROM Customers -- 3500 RECORDS AS PER 11-02-2025

INSERT INTO AUDIT_CUSTOMER VALUES(3500)

SELECT * FROM AUDIT_CUSTOMER

-- TRIGGER FOR INSERT

CREATE TRIGGER NEW_CUSTOMER_INSERT ON CUSTOMERS
AFTER INSERT
AS
BEGIN
UPDATE AUDIT_CUSTOMER
SET EMPLOYEE_COUNT=EMPLOYEE_COUNT+1
END


-- TRIGGER FOR DELETE

CREATE TRIGGER CUSTOMER_DELETION ON CUSTOMERS
AFTER DELETE
AS
BEGIN
UPDATE AUDIT_CUSTOMER
SET EMPLOYEE_COUNT=EMPLOYEE_COUNT-1
END

--16. Create a trigger to prevent login of the same user id in multiple pages.

--17. Display top n customers on the basis of transaction type.
DECLARE @N INT = 5;  -- Set the number of top customers
DECLARE @TransactionType VARCHAR(50) = 'purchase';  -- Set transaction type

SELECT TOP (@N) customer_id, SUM(txn_amount) AS TotalSpent
FROM Transactions
WHERE txn_type = @TransactionType
GROUP BY customer_id
ORDER BY TotalSpent DESC;

/*
18. Create a pivot table to display the total purchase, withdrawal and
deposit for all the customers.
*/



-- step 3 : final selection

select customer_id,ISNULL([Purchase], 0) AS Total_Purchase, 
       ISNULL([Withdrawal], 0) AS Total_Withdrawal, 
       ISNULL([Deposit], 0) AS Total_Deposit
	   from
-- step 1 : selecting columns to be used
(
select customer_id,txn_type,txn_amount from Transactions
)
as P1

--step 2 : pivoting 

pivot( sum(txn_amount) for txn_type in ([deposit],[withdrawal],[purchase])
) as P2
























