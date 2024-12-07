
--************************************ SIMPLE QUERIES *******************************************--

--   1. List all the employees details

select * from EMPLOYEE

-- 2. List all the department details

select * from DEPARTMENT

-- 3. List all the Job details

select * from JOB

-- 4. List all the deatails of Locations

select * from LOCATION

-- 5. List out the First Name, Last Name, Salary, Commission for all Employees. 

select First_name,LAST_NAME,SALARY,COMM from EMPLOYEE

select * from employee_imp
/*
6. List out the Employee ID, Last Name, Department ID for all employees and
alias Employee ID as "ID of the Employee", Last Name as "Name of the
Employee", Department ID as "Dep_id". 
*/

SELECT EMPLOYEE_ID AS 'ID of the Employee',
LAST_NAME as 'Name of the Employee',
DEPARTMENT_ID as 'Dep_id'FROM EMPLOYEE

--7. List out the annual salary of the employees with their names only.

select LAST_NAME,(SALARY*12) as 'Annual Salary' from EMPLOYEE



-- ********************************** WHERE Condition: *************************************--
--1. List the details about "Smith". 

select * from EMPLOYEE
where LAST_NAME='SMITH'

--2. List out the employees who are working in department 20. 

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID=20

--3. List out the employees who are earning salaries between 3000 and4500. 

SELECT * FROM EMPLOYEE
WHERE SALARY BETWEEN 3000 AND 4500

--4. List out the employees who are working in department 10 or 20. 

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID IN (10,20)

--5. Find out the employees who are not working in department 10 or 30. 

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID NOT IN (10,30)

--6. List out the employees whose name starts with 'S'.

SELECT * FROM EMPLOYEE
WHERE LAST_NAME LIKE 'S%'

-- 7. List out the employees whose name starts with 'S' and ends with 'H'. 

SELECT * FROM EMPLOYEE
WHERE LAST_NAME LIKE 'S%H'

-- 8. List out the employees whose name length is 4 and start with 'S'. 

SELECT * FROM EMPLOYEE
WHERE LEN(LAST_NAME)=4 AND LAST_NAME LIKE 'S%'

-- 9. List out employees who are working in department 10 and draw salaries more than 3500. 

SELECT * FROM EMPLOYEE
WHERE DEPARTMENT_ID=10 AND SALARY>3500

--10. List out the employees who are not receiving commission.

SELECT * FROM EMPLOYEE
WHERE COMM IS NULL

--******************************** ORDER BY Clause: ************************************--
-- 1. List out the Employee ID and Last Name in ascending order based on the Employee ID. 

SELECT EMPLOYEE_ID,LAST_NAME FROM EMPLOYEE
ORDER BY EMPLOYEE_ID ASC

-- 2. List out the Employee ID and Name in descending order based onsalary.

SELECT EMPLOYEE_ID,LAST_NAME FROM  EMPLOYEE
ORDER BY SALARY DESC

--3. List out the employee details according to their Last Name in ascending-order. 

SELECT * FROM EMPLOYEE
ORDER BY LAST_NAME ASC

/*
4. List out the employee details according to their Last Name in ascending
order and then Department ID in descending order.
*/

select * from EMPLOYEE
order by LAST_NAME asc, DEPARTMENT_ID desc

-- **************************   GROUP BY and HAVING Clause:  *************************************
-- 1. How many employees are in different departments in the organization?

select department_id,count(*) as 'Number of Employee' from employee	
group by department_id

--2. List out the department wise maximum salary, minimum salary and average salary of the employees. 

select department_id,
max(salary) as Maximum_Salary,
min(salary) as Minimum_slary,
avg(salary) as Avg_Salary 
from employee
group by department_id

--3. List out the job wise maximum salary, minimum salary and average salary of the employees. 

select job_id,
max(salary) as 'maximum salary',
min(salary) as 'minimum salary',
avg(salary) as 'average salary'
from employee
group by job_id

-- 4. List out the number of employees who joined each month in ascendingorder.

select datename(month,hire_date) as Month
,count(*) as Employee_counts from employee
group by datename(month,hire_date)
order by Employee_counts

/*
5. List out the number of employees for each month and year in ascending order 
based on the year and month. 
*/

select YEAR(hire_date) as 'Year',
datename(month,hire_date) as 'month',
COUNT(EMPLOYEE_ID) as 'Employee_counts'
from EMPLOYEE
group by YEAR(hire_date),datename(month,hire_date)


--6. List out the Department ID having at least four employees. 

select department_id,COUNT(EMPLOYEE_ID) as employee_counts from EMPLOYEE
GROUp by department_id
having COUNT(EMPLOYEE_ID)>=4

-- 7. How many employees joined in the month of January?

select COUNT(EMPLOYEE_ID) from EMPLOYEE
where DATENAME(MONTH,HIRE_DATE)='January'

-- 8. How many employees joined in the month of January or September?

select COUNT(EMPLOYEE_ID) from EMPLOYEE
where DATENAME(MONTH,HIRE_DATE) in ('January','September')

-- 9. How many employees joined in 1985?

select COUNT(EMPLOYEE_ID) as 'Employee counts' from EMPLOYEE
where YEAR(hire_date)=1985

-- 10. How many employees joined each month in 1985?

select datename(month,hire_date) as 'Month',
COUNT(EMPLOYEE_ID) as 'Employee_counts' from EMPLOYEE
where year(hire_date)=1985
group by datename(month,hire_date)


-- 11. How many employees joined in March 1985?

select COUNT(EMPLOYEE_ID) from EMPLOYEE
where YEAR(hire_date)=1985 and MONTH(hire_date)=3

--12. Which is the Department ID having greater than or equal to 3 employees joining in April 1985.

select DEPARTMENT_ID,COUNT(EMPLOYEE_ID) as 'Emp_counts' from EMPLOYEE
where YEAR(hire_date)=1985 and MONTH(hire_date)=4
group by DEPARTMENT_ID
having count(employee_id)>=3


--******************************** Joins:  ***************************************

--1. List out employees with their department names.

select e.EMPLOYEE_ID,e.FIRST_NAME,e.LAST_NAME,d.Name as 'Department Name'
from EMPLOYEE as e inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id


--2. Display employees with their designations. 

select e.EMPLOYEE_ID,e.FIRST_NAME,e.LAST_NAME,j.Designation
from EMPLOYEE as e inner join JOB as j
on e.JOB_ID=j.Job_ID


--3. Display the employees with their department names and regional groups.

select e.EMPLOYEE_ID,e.FIRST_NAME,e.LAST_NAME,d.Name as 'Departement Name',l.City
from 
EMPLOYEE as e inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.DEPARTMENT_ID
inner join LOCATION as l
on d.Location_ID=l.Location_ID

/*
4. How many employees are working in different departments? Display with
department names.
*/

select d.Name as 'Department Name',COUNT(e.employee_id) as 'Emp counts' 
from EMPLOYEE as e inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
group by d.Name

--5. How many employees are working in the sales department?

select d.Name as 'Department Name',COUNT(e.employee_id) as 'Emp counts' 
from EMPLOYEE as e inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
where d.Name='Sales'
group by d.Name

/*
6. Which is the department having greater than or equal to 5
employees? Display the department names in ascending
order. 
*/

select d.Name as 'Department Name',COUNT(e.employee_id) as 'Emp counts' 
from EMPLOYEE as e inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
group by d.Name
having COUNT(e.employee_id)>=5
order by [Department Name] asc

--7. How many jobs are there in the organization? Display with designations. 

select j.Designation,count(e.EMPLOYEE_ID) as 'Employee Count' from 
EMPLOYEE as e inner join JOB as j
on e.job_id=j.job_id
group by j.Designation

--8. How many employees are working in "New York"?

select l.City,COUNT(e.EMPLOYEE_ID) as 'Emp_Counts' from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join LOCATION as l
on d.Location_Id=l.Location_ID
where l.City='New York'
group by l.City

/*
9. Display the employee details with salary grades. Use conditional statement to
create a grade column. 
*/

select EMPLOYEE_ID,FIRST_NAME,LAST_NAME,SALARY,
case when SALARY>2500 then 'A'
when SALARY>2000 then 'B'
when SALARY>1000 then 'C'
else 'D'
end as Salary_Grade
from EMPLOYEE


/*
10. List out the number of employees grade wise. Use conditional statement to
create a grade column. 
*/

select
case when SALARY>2500 then 'A'
when SALARY>2000 then 'B'
when SALARY>1000 then 'C'
else 'D'
end as Salary_Grade,
COUNT(employee_id) as 'Employee Counts'
from EMPLOYEE
where SALARY between 2000 and 5000
group by case when SALARY>2500 then 'A'
when SALARY>2000 then 'B'
when SALARY>1000 then 'C'
else 'D'
end
/*
11.Display the employee salary grades and the number of employees
between 2000 to 5000 range of salary. 
*/

select
case when SALARY>2500 then 'A'
when SALARY>2000 then 'B'
when SALARY>1000 then 'C'
else 'D'
end as Salary_Grade,
COUNT(employee_id) as 'Employee Counts'
from EMPLOYEE
group by case when SALARY>2500 then 'A'
when SALARY>2000 then 'B'
when SALARY>1000 then 'C'
else 'D'
end

--12. Display all employees in sales or operation departments.

select e.EMPLOYEE_ID,e.LAST_NAME,e.SALARY,d.Name as 'DeptName' from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
where d.Name in ('Sales','Operations')

-- ***************************  SET Operators: **********************************

--1. List out the distinct jobs in sales and accounting departments. 

select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Sales')
union
select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Accounting')

--2. List out all the jobs in sales and accounting departments. 

select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Sales')
union all
select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Accounting')

--3. List out the common jobs in research and accounting departments in ascending order.

select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Research')
intersect
select j.Designation from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
inner join JOB as j
on e.JOB_ID=j.Job_ID
where d.Name in ('Accounting')
order by j.Designation asc

-- ****************************************  Subqueries: ***************************************
--1. Display the employees list who got the maximum salary.

select LAST_NAME,SALARY from EMPLOYEE
where SALARY=(select MAX(SALARY) from EMPLOYEE)

--2. Display the employees who are working in the sales department. 

select e.EMPLOYEE_ID,e.LAST_NAME,e.SALARY,d.Name as 'DeptName' from EMPLOYEE as e
inner join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
where d.Name ='Sales';

--3. Display the employees who are working as 'Clerk'. 

select 
	e.EMPLOYEE_ID,
	e.FIRST_NAME,
	e.LAST_NAME,
	e.SALARY,
	d.Name as 'DeptName',
	j.Designation 
from  
	EMPLOYEE as e
inner join 
	DEPARTMENT as d
on 
	e.DEPARTMENT_ID=d.Department_Id
inner join 
	JOB as j
on 
	e.JOB_ID=j.Job_ID
where
	j.Designation='Clerk'

--4. Display the list of employees who are living in "New York". 

select 
	e.EMPLOYEE_ID,
	e.FIRST_NAME,
	e.LAST_NAME,
	e.SALARY,
	d.Name as 'DeptName',
	l.City
from
	EMPLOYEE as e
inner join
	DEPARTMENT as d
on
	e.DEPARTMENT_ID=d.Department_Id
inner join
	LOCATION as l
on
	d.Location_Id=l.Location_ID	
where
	l.City='New York';

--5. Find out the number of employees working in the sales department. 

select
	d.Name as 'DeptName',
	COUNT(e.EMPLOYEE_ID) as 'Employee count'
from 
	EMPLOYEE as e
inner join
	DEPARTMENT as d
on
	e.DEPARTMENT_ID=d.Department_Id
where
	d.Name='Sales'
group by
	d.Name

--6. Update the salaries of employees who are working as clerks on the basis of 10%. 

update EMPLOYEE
set SALARY=SALARY*1.1
where JOB_ID in (select JOB_ID from JOB where JOB.Designation='Clerk')

--7. Delete the employees who are working in the accounting department. 

delete 
from EMPLOYEE
where DEPARTMENT_ID in 
(select DEPARTMENT_ID from DEPARTMENT
where DEPARTMENT.Name='Accounting')

--8. Display the second highest salary drawing employee details. 


WITH RankedSalaries AS (
    SELECT 
        EMPLOYEE_ID, 
        LAST_NAME, 
        SALARY, 
        ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS Rank
    FROM EMPLOYEE
)
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM RankedSalaries
WHERE Rank = 2;

--9. Display the nth highest salary drawing employee details. 

WITH RankedSalaries AS (
    SELECT 
        EMPLOYEE_ID, 
        LAST_NAME, 
        SALARY, 
        ROW_NUMBER() OVER (ORDER BY SALARY DESC) AS Rank
    FROM EMPLOYEE
)
SELECT EMPLOYEE_ID, LAST_NAME, SALARY
FROM RankedSalaries
WHERE Rank = LEN(EMPLOYEE_ID);

--10. List out the employees who earn more than every employee in department 30. 

select * from EMPLOYEE
where SALARY>(select max(SALARY) from EMPLOYEE where DEPARTMENT_ID=30)

/*
11. List out the employees who earn more than the lowest salary in department.
Find out whose department has no employees. 
*/

select * from EMPLOYEE
where SALARY>(select MIN(salary) from EMPLOYEE)

--12. Find out which department has no employees. 

select d.Name as 'DeptName',COUNT(e.EMPLOYEE_ID) as 'EmpCount' from EMPLOYEE as e
full outer join DEPARTMENT as d
on e.DEPARTMENT_ID=d.Department_Id
group by d.Name


/*
13. Find out the employees who earn greater than the average salary for
their department.
*/

SELECT * 
FROM EMPLOYEE e
WHERE e.SALARY > (
    SELECT AVG(salary) 
    FROM EMPLOYEE 
    WHERE DEPARTMENT_ID = e.DEPARTMENT_ID
);














