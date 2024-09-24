
/*
Tables:
STUDIES, SOFTWARE and PROGRAMMER
*/

select * from studies

select * from software

select * from programmer


--1. Find out the selling cost average for packages developed in Pascal.

select DEVELOPIN,AVG(SCOST) from Software
where DEVELOPIN='PASCAL'
group by DEVELOPIN

--2. Display the names and ages of all programmers.

select pname,(year(getdate())-year(dob)) as age from Programmer


--3. Display the names of those who have done the DAP Course.

select * from Studies
where COURSE='DAP'

--4. Display the names and date of birth of all programmers born in January.

select Programmer.PNAME,Programmer.DOB from Programmer
where month(DOB)=1

--5. What is the highest number of copies sold by a package?

select title,sum(sold) as num_copies from Software
group by title
order by sum(sold) desc

--6. Display lowest course fee.

select distinct(COURSE),course_fee from Studies
order by course_fee asc

--7. How many programmers have done the PGDCA Course?

select COURSE,COUNT(COURSE) AS COUNT from Studies
where COURSE='PGDCA'
GROUP BY COURSE

--8. How much revenue has been earned through sales of packages developed in C?

SELECT Software.DEVELOPIN,sum(scost * sold) as revenue FROM Software
where DEVELOPIN='c'
group by DEVELOPIN


--9. Display the details of the software developed by Ramesh.

select * from Software
where pname='ramesh'

--10. How many programmers studied at Sabhari

select * from Studies
where INSTITUTE='sabhari'

--11. Display details of packages whose sales crossed the 2000 mark.

select TITLE,DEVELOPIN,(scost*sold)-(DCOST) as sales from Software
where (scost*sold)-(DCOST)>2000

--12. Display the details of packages for which development costs have been recovered.

select TITLE,DEVELOPIN,(SCOST*SOLD)-DCOST AS PROFIT from Software
WHERE (SCOST*SOLD)-DCOST>0

--LOSSED PRODUCTS
select TITLE,DEVELOPIN,(SCOST*SOLD)-DCOST AS LOSS from Software
WHERE (SCOST*SOLD)-DCOST<0

--13. What is the cost of the costliest software development in Basic?

SELECT TITLE,DEVELOPIN,DCOST FROM Software
WHERE DEVELOPIN='BASIC'
ORDER BY DCOST DESC

--14. How many packages have been developed in dBase?

SELECT DEVELOPIN,COUNT(*) AS COUNT FROM Software
WHERE DEVELOPIN='DBASE'
GROUP BY DEVELOPIN

--15. How many programmers studied in Pragathi?

SELECT * FROM STUDIES
WHERE INSTITUTE='PRAGATHI'

--16. How many programmers paid 5,000 to 10,000 for their course?

select count(*) as course_fee from Studies
where COURSE_FEE between 5000 and 10000

--17. What is the average course fee?

select avg(COURSE_FEE) as avg_course_fee from Studies 

--18. Display the details of the programmers knowing C.

select * from Programmer
where PROF1='C' or PROF2 ='c'

--19. How many programmers know either COBOL or Pascal?

select * from Programmer
where PROF1='COBOL'  or PROF1='Pascal'or PROF2='Pascal' or PROF2='COBOL'



--20. How many programmers don’t know Pascal and C?

select count(*) as counts from Programmer
where PROF1 not in ('Pascal','C') and PROF2 not in ('Pascal','C')

--21. How old is the oldest male programmer?

select dense_rank() over (order by datediff(yy,dob,getdate()) desc) as age_rank,
pname,datediff(yy,dob,getdate()) as age,
datediff(YY,doj,getdate()) as workexp 
from Programmer
order by datediff(YY,dob,getdate()) desc

--Juliana is oldest programer


--22. What is the average age of female programmers?

ALTER TABLE Programmer 
ADD age AS DATEDIFF(YY, dob, GETDATE());

select avg(age) as female_avg_age from Programmer
where GENDER='f'


--23. Calculate the experience in years for each programmer and display with
--their names in descending order.

select pname,DATEDIFF(yy,doj,getdate()) as experience from Programmer
order by pname desc

select pname,DATEDIFF(yy,doj,getdate()) as experience from Programmer
order by DATEDIFF(yy,doj,getdate()) desc

--24. Who are the programmers who celebrate their birthdays during the
--current month?

select pname,dob from Programmer
where month(dob)=month(getdate())

--25. How many female programmers are there?

select count(*) female_programers from Programmer
where GENDER='f'

-- 26. What are the languages studied by male programmers?

select PNAME,PROF1,PROF2 from Programmer
where gender='M'

-- alternative

select distinct(PROF1) from Programmer
where GENDER='m'
union
select distinct(prof2) from Programmer
where GENDER='m'

--27. What is the average salary

select avg(salary) as average_salary from Programmer

--28. How many people draw a salary between 2000 to 4000?

select count(*) as count_of_people_salary_2000_to_4000 from Programmer
where salary between 2000 and 4000

--29. Display the details of those who don’t know Clipper, COBOL or Pascal.

select * from programmer
where prof1 not in ('Clipper','COBOL','Pascal')
and prof2 not in ('Clipper','COBOL','Pascal')

--30. Display the cost of packages developed by each programmer.

select pname,sum(dcost) total_development_cost from software
group by pname
order by sum(dcost) asc

--31. Display the sales value of the packages developed by each programmer.

select Pname,sum(scost*sold) Sales_by_Developer from Software
group by PNAME
order by sum(SCOST*SOLD) desc

--32. Display the number of packages sold by each programmer.

select PNAME,count(*) as Software_count from Software
group by PNAME
order by count(*) desc

--33. Display the sales cost of the packages developed by each programmer language wise.

select DEVELOPIN,sum(SCOST*SOLD) as Total_Revenue from software
group by DEVELOPIN
order by Total_Revenue desc

--34. Display each language name with the average development cost,
--average selling cost and average price per copy.

select DEVELOPIN,
avg(DCOST) as AVG_DCOST,
sum(SCOST*SOLD)/sum(sold) as AVG_SCOST,
avg(SCOST) AS AVG_PRICE_PER_COPY
from Software
GROUP BY DEVELOPIN

--alternative

select DEVELOPIN,
avg(DCOST) as AVG_DCOST,
avg(SCOST*SOLD) as AVG_SCOST,
avg(SCOST) AS AVG_PRICE_PER_COPY
from Software
GROUP BY DEVELOPIN

--35. Display each programmer’s name and the costliest and cheapest
--packages developed by him or her.

select PNAME,iif(max(dcost),max(dcost),min(dcost)) from Software
group by PNAME

WITH CostliestPackages AS (
    SELECT pname, TITLE, DCOST,
           ROW_NUMBER() OVER (PARTITION BY pname ORDER BY DCOST DESC) AS rank_max
    FROM Software
),
CheapestPackages AS (
    SELECT pname, TITLE, DCOST,
           ROW_NUMBER() OVER (PARTITION BY pname ORDER BY DCOST ASC) AS rank_min
    FROM Software
)
SELECT C.pname,
       C.title AS COSTLIEST_PACKAGE,
       H.title AS CHEAPEST_PACKAGE
FROM CostliestPackages C
JOIN CheapestPackages H ON C.pname = H.pname
WHERE C.rank_max = 1 AND H.rank_min = 1;


--36. Display each institute’s name with the number of courses and the average cost per course.

select INSTITUTE,count(course) as NUMBER_OF_COURSE,avg(course_fee) AS AVERAGE_COURSE from Studies
group by INSTITUTE

--37. Display each institute’s name with the number of students.

SELECT INSTITUTE,COUNT(PNAME) AS NUMBER_OF_STUDENTS FROM Studies
GROUP BY INSTITUTE

--38. Display names of male and female programmers along with their gender.

SELECT PNAME,IIF(GENDER='M','Male','Female') as gender FROM Programmer

--39. Display the name of programmers and their packages.

select p.PNAME,s.TITLE as Packages from Programmer as p
inner join Software as s
on p.PNAME=s.PNAME

--40. Display the number of packages in each language except C and C++.

select DEVELOPIN,count(title) as NO_OF_PACKAGES from Software
WHERE DEVELOPIN NOT IN ('CPP','C')
GROUP BY DEVELOPIN


--41. Display the number of packages in each language for which development cost is less than 1000.

SELECT DEVELOPIN,COUNT(TITLE) AS NO_OF_PACKAGES FROM SOFTWARE
WHERE DCOST<1000
GROUP BY DEVELOPIN

--42. Display the average difference between SCOST and DCOST for each package.

SELECT TITLE,AVG(DCOST-SCOST) FROM SOFTWARE
GROUP BY TITLE

--43. Display the total SCOST, DCOST and the amount to be recovered for 
--each programmer whose cost has not yet been recovered.

SELECT 
PNAME,TITLE,
SCOST*SOLD AS TOTAL_SELLING_COST,
DCOST,
((SCOST*SOLD)-DCOST) AS RECOVERED_MONEY 
FROM Software
WHERE ((SCOST*SOLD)-DCOST)<0

--44. Display the highest, lowest and average salaries for those earning more than 2000.

SELECT MAX(SALARY) AS HIGHEST_SALARY,
MIN(SALARY) AS LOWEST_SALARY,
AVG(SALARY) AS AVERAGE_SALARY FROM Programmer
WHERE SALARY>2000

--45. Who is the highest paid C programmer

SELECT TOP 1 PNAME,SALARY FROM Programmer
WHERE PROF1='C' OR PROF2='C'
ORDER BY SALARY DESC

--46. Who is the highest paid female COBOL programmer?

SELECT PNAME,SALARY FROM Programmer
WHERE GENDER='F' AND (PROF1='COBOL' OR PROF2='COBOL')
ORDER BY SALARY DESC

--47. Display the names of the highest paid programmers for each language.

WITH MaxSalaries AS (
    SELECT S.DEVELOPIN, MAX(P.SALARY) AS HIGHEST_SALARY
    FROM Programmer AS P
    INNER JOIN Software AS S
    ON P.PNAME = S.PNAME
    GROUP BY S.DEVELOPIN
)
SELECT P.PNAME, S.DEVELOPIN, P.SALARY AS HIGHEST_SALARY
FROM Programmer AS P
INNER JOIN Software AS S
ON P.PNAME = S.PNAME
INNER JOIN MaxSalaries MS
ON S.DEVELOPIN = MS.DEVELOPIN AND P.SALARY = MS.HIGHEST_SALARY;


--48. Who is the least experienced programmer?

select TOP 1 PNAME,DATEDIFF(yy,DOJ,getdate()) as EXPIRIENCE from Programmer
ORDER BY EXPIRIENCE

--49. Who is the most experienced male programmer knowing PASCAL?

SELECT * FROM Programmer

--50. Which language is known by only one programmer?

select * from Programmer
where PROF1 in ('FOXPRO','CPP','ORACLE') or PROF2 in ('FOXPRO','CPP','ORACLE')



select prof,sum(no_of_programmers) as total_programmers
from (
--count for prof1
select prof1 as prof, count(prof1) as no_of_programmers
from Programmer
group by PROF1

union all

--count for prof2
select prof2 as prof, count(prof2) as no_of_programmers
from programmer
group by prof2
) as combined
group by prof
having sum(no_of_programmers)=1




