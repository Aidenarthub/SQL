
--51. Who is the above programmer referred in 50?


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


--solution:
select * from Programmer
where PROF1 in ('FOXPRO','CPP','ORACLE') or PROF2 in ('FOXPRO','CPP','ORACLE')


--52. Who is the youngest programmer knowing dBase?

select top 1 * from Programmer
where PROF1='dbase' or prof2='dbase'
order by age asc

--53. Which female programmer earning more than 3000 does not know C, C++, Oracle or dBase?

select * from Programmer
where (GENDER='f' and salary >3000) and 
(PROF1 not in ('c','cpp','oracle','dBase') and PROF2 not in ('c','cpp','oracle','dBase'))

--54. Which institute has the most number of students?

select top 1 INSTITUTE,count(institute) no_of_students from Studies
group by INSTITUTE
order by no_of_students desc

--55. What is the costliest course?

select top 1 * from Studies
order by COURSE_FEE desc

--56. Which course has been done by the most number of students?

select top 1 with ties course,
(count(course)) as num_of_students from Studies
group by course
order by num_of_students desc

--57. Which institute conducts the costliest course?

select top 1 * from Studies
order by COURSE_FEE desc

--58. Display the name of the institute and the course which has below
--average course fee.

select INSTITUTE,course,COURSE_FEE from Studies
where COURSE_FEE<(select avg(COURSE_FEE) from Studies)

--59. Display the names of the courses whose fees are within 1000 (+ or -) of the average fee.

with average_fees as 
(select avg(course_fee) as avgfee from Studies)
select course,COURSE_FEE from Studies
cross join average_fees
where COURSE_FEE between (avgfee-1000) and (avgfee+1000)


--60. Which package has the highest development cost?

select top 1 with ties * from Software
order by DCOST desc

--61. Which course has below average number of students?
create view students_countbyCourse 
as select COURSE,count(course) as count_of_students from Studies group by COURSE

select course,count_of_students from students_countbyCourse
where count_of_students<(select avg(count_of_students) from students_countbyCourse)

--62. Which package has the lowest selling cost?

select top 1 with ties * from Software
order by SCOST asc

--63. Who developed the package that has sold the least number of copies?

select top 1 with ties * from Software
order by sold asc

--64. Which language has been used to develop the package which has the
--highest sales amount?

select TITLE,DEVELOPIN,(SCOST*SOLD) as total_sales from Software
where SCOST*sold=(select max(scost*sold) from Software)


--65. How many copies of the package that has the least difference between development and selling cost were sold?

select TITLE,DEVELOPIN,SOLD as Copies,(SCOST-DCOST) as Profit  from software
order by abs(SCOST-DCOST) asc

--66. Which is the costliest package developed in Pascal?

select top 1 with ties * from Software
where DEVELOPIN='pascal'
order by DCOST desc

--67. Which language was used to develop the most number of packages?

select top 1 with ties DEVELOPIN,COUNT(DEVELOPIN) as num_of_packages from Software
group by DEVELOPIN
order by num_of_packages desc

--68. Which programmer has developed the highest number of packages?

select top 1 with ties PNAME,COUNT(title) num_of_packages from Software
group by PNAME
order by num_of_packages desc

--69. Who is the author of the costliest package?

select top 1 with ties PNAME,TITLE,DEVELOPIN,DCOST from Software
order by DCOST desc

--70. Display the names of the packages which have sold less than the
--average number of copies.

select TITLE,SOLD as COPIES from Software
WHERE SOLD<(SELECT AVG(SOLD) FROM Software)
ORDER BY COPIES DESC

--71. Who are the authors of the packages which have recovered more than
--double the development cost?

SELECT PNAME,TITLE,DEVELOPIN,(SCOST*SOLD) AS TOTAL_SALES,DCOST FROM Software
WHERE (SCOST*SOLD)>(2*DCOST)

--72. Display the programmer names and the cheapest packages developed
--by them in each language.

SELECT PNAME,DEVELOPIN,MIN(DCOST) AS DCOST FROM Software
GROUP BY PNAME,DEVELOPIN
ORDER BY DCOST

--73. Display the language used by each programmer to develop the highest
--selling and lowest selling package.

WITH PackageSales AS (
    SELECT PNAME, DEVELOPIN, SOLD,
           ROW_NUMBER() OVER (PARTITION BY PNAME ORDER BY SOLD DESC) AS RankHighest,
           ROW_NUMBER() OVER (PARTITION BY PNAME ORDER BY SOLD ASC) AS RankLowest
    FROM Software
)
SELECT PNAME, 
       MAX(CASE WHEN RankHighest = 1 THEN DEVELOPIN END) AS LanguageForHighestSelling,
       MAX(CASE WHEN RankLowest = 1 THEN DEVELOPIN END) AS LanguageForLowestSelling
FROM PackageSales
GROUP BY PNAME;


--74. Who is the youngest male programmer born in 1965?

SELECT TOP 1 WITH TIES * FROM Programmer
WHERE YEAR(DOB)=1965 AND GENDER='M'
ORDER BY DOB DESC

--75. Who is the oldest female programmer who joined in 1992?

SELECT TOP 1 WITH TIES * FROM Programmer
WHERE YEAR(DOJ)=1992 AND GENDER='F'
ORDER BY DOB ASC

--76. In which year was the most number of programmers born?

SELECT TOP 1 WITH TIES YEAR(DOB) AS YEAR,COUNT(PNAME) AS NUM_OF_PROGRAMMERS FROM Programmer
GROUP BY YEAR(DOB)
ORDER BY NUM_OF_PROGRAMMERS DESC

--77. In which month did the most number of programmers join?

SELECT TOP 1 WITH TIES DATENAME(MM,DOJ) AS MONTH,COUNT(PNAME) AS PROGRAMMER_COUNT FROM Programmer
GROUP BY DATENAME(MM,DOJ)
ORDER BY PROGRAMMER_COUNT DESC

--78. In which language are most of the programmer’s proficient?

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

-- alternative method
-- CREATING VIEW
CREATE VIEW TOTAL_PROGRAMES AS
SELECT PROF1 AS PROF,COUNT(PROF1) AS NUM_OF_PROGRAMMERS FROM Programmer
GROUP BY PROF1
UNION ALL
SELECT PROF2 AS PROF,COUNT(PROF2) AS NUM_OF_PROGRAMMERS FROM Programmer
GROUP BY PROF2

--TACKLING THE SOLUTION
SELECT PROF,SUM(NUM_OF_PROGRAMMERS) AS COUNT_PROGRAMMERS FROM TOTAL_PROGRAMES
GROUP BY PROF
ORDER BY COUNT_PROGRAMMERS DESC


--79. Who are the male programmers earning below the average salary of
--female programmers?

select * from Programmer
where GENDER='m' and SALARY<( Select AVG(SALARY) from Programmer where GENDER='F')

--80. Who are the female programmers earning more than the highest paid Males?

select * from Programmer where gender='f' and 
salary>(select max(salary) from programmer where gender='m')

--81. Which language has been stated as the proficiency by most of the programmers?

select top 1 with ties prof,sum(count_language) as counts from
(select prof1 as prof,count(prof1) as count_language from programmer
group by prof1
union all
select prof2 as prof,count(prof2) as count_language from programmer
group by prof2
) as combined
group by prof
order by counts desc

--82. Display the details of those who are drawing the same salary.
with salary_count as
(select salary,count(salary) as count from programmer
group by salary)

select p.pname,p.salary,p.age from programmer as p
inner join salary_count as s
on p.salary=s.salary
where s.count >1

--83. Display the details of the software developed by the male programmers
--earning more than 3000.

select s.pname,p.salary,s.title,s.developin,s.scost,s.dcost,s.sold from software as s
inner join programmer as p
on s.pname=p.pname
where p.salary>3000 and p.gender='m'

--84. Display the details of the packages developed in Pascal by the female
--programmers.

select s.pname,p.gender,s.title,s.developin,s.scost,s.dcost,s.sold 
from software as s inner join programmer as p
on s.pname=p.pname
where s.developin='pascal' and p.gender='f'

--85. Display the details of the programmers who joined before 1990.

select * from programmer
where year(doj)<1990

--86. Display the details of the software developed in C by the female
--programmers at Pragathi.

select s.pname,p.gender,s.title,s.developin,s.scost,s.dcost,s.sold,st.institute from 
software as s inner join programmer as p
on s.pname=p.pname
inner join studies as st
on s.pname=st.pname
where s.developin='c' and p.gender='f' and st.institute='pragathi'


--87. Display the number of packages, number of copies sold and sales value
--of each programmer institute wise.

select st.institute,s.pname,count(s.title) as number_of_packages,
sum(s.sold) as num_of_copies,sum(s.scost*s.sold) as total_sales
from software as s inner join studies as st
on s.pname=st.pname
group by st.institute,s.pname

--88. Display the details of the software developed in dBase by male
--programmers who belong to the institute in which the most number of
--programmers studied.

;with intitute_wise_students_count as
(select top 1 institute,count(pname) as counts from studies 
group by institute
order by counts desc)

select s.pname,p.gender,s.title,s.developin,s.scost,s.dcost,s.sold,st.institute
from software as s inner join programmer as p
on s.pname=p.pname
inner join studies as st
on s.pname=st.pname
where s.developin='dbase'
and p.gender='m' and st.institute in (select institute from intitute_wise_students_count)

--89. Display the details of the software developed by the male programmers
--born before 1965 and female programmers born after 1975.


select s.pname,p.gender,p.dob,s.title,s.developin,s.scost,s.dcost,s.sold
from software as s inner join programmer as p
on s.pname=p.pname
where (p.gender='m' and year(p.dob)<1965) or (p.gender='f' and year(p.dob)>1975)
--Note: we have one employee who born before 1965 but he not develped any packages

--90. Display the details of the software that has been developed in the
--language which is neither the first nor the second proficiency of the
--programmers.
; with prof_with_ranks as(
select prof,DENSE_RANK()over(order by counts desc) as ranks from
(select prof,SUM(count_of_language) as counts from
(
select prof1 as prof,COUNT(prof1) as count_of_language from Programmer
group by PROF1
union all
select prof2 as prof,COUNT(prof2) as count_of_language from Programmer
group by PROF2
)as combined 
group by prof
) as ss)

select * from Software as s
inner join prof_with_ranks as pr
on s.DEVELOPIN=pr.prof
where pr.ranks>2

--91. Display the details of the software developed by the male students at
--Sabhari.

select s.PNAME,st.INSTITUTE,p.GENDER,s.DEVELOPIN,s.TITLE,s.DCOST,s.SCOST,s.SOLD from 
Software as s
inner join Programmer as p
on s.PNAME=p.PNAME
inner join Studies as st
on s.PNAME=st.PNAME
where p.GENDER='m' and st.INSTITUTE='Sabhari'

--92. Display the names of the programmers who have not developed any
--packages.

select * from Programmer
where PNAME not in (select pname from Software)

--93. What is the total cost of the software developed by the programmers of
--Apple?

select st.INSTITUTE,SUM(s.dcost) as 'Development Cost' from 
Software as s inner join Studies as st
on s.PNAME=st.PNAME
where st.INSTITUTE='Apple'
group by st.INSTITUTE


--94. Who are the programmers who joined on the same day?

select * from programmer
where doj in 
(select doj from
(select DOJ,COUNT(doj) as counts from Programmer
group by DOJ
having COUNT(doj)>1) as ss)

--95. Who are the programmers who have the same Prof2?

select * from Programmer
where PROF2 in (select PROF2 from
(select PROF2,COUNT(prof2) as counts 
from Programmer
group by prof2
having COUNT(prof2)>2) as aa))

--96. Display the total sales value of the software institute wise.

select INSTITUTE,SUM(SCOST*SOLD) as Total_sales 
from Software inner join Studies
on Software.PNAME=Studies.PNAME
group by INSTITUTE
order by Total_sales desc

--97. In which institute does the person who developed the costliest package
--study?

select Software.PNAME,Studies.INSTITUTE from Software inner join Studies
on Software.PNAME=Studies.PNAME
where SCOST=(select MAX(SCOST) from Software)

--98. Which language listed in Prof1, Prof2 has not been used to develop any
--package?

select prof1 from Programmer
where PROF1 not in (select DEVELOPIN from Software)
union
select prof2 from Programmer
where PROF2 not in (select developin from Software)


--99. How much does the person who developed the highest selling package
--earn and what course did he/she undergo?

select p.PNAME,p.SALARY,s.TITLE,st.COURSE,st.INSTITUTE,s.DCOST from Programmer as p
inner join Software as s
on p.PNAME=s.PNAME
inner join Studies as st
on p.PNAME=st.PNAME
where s.DCOST=(select MAX(dcost) from Software)

--100. What is the average salary for those whose software sales is more than
--50,000?

select AVG(salary) avg_salary from Programmer inner join Software
on Programmer.PNAME=Software.PNAME
where SCOST*SOLD>500000

--101. How many packages were developed by students who studied in
--institutes that charge the lowest course fee?

select st.INSTITUTE,COUNT(*) total_DPackages from Software as s
inner join Studies as st
on s.PNAME=st.PNAME
where st.COURSE_FEE=(select MIN(course_fee) from Studies)
group by st.INSTITUTE

--102. How many packages were developed by the person who developed the
--cheapest package? Where did he/she study?

select s.PNAME,st.INSTITUTE,COUNT(s.TITLE) as num_of_packages from Software as s
inner join Studies as st
on s.PNAME=st.PNAME
where s.PNAME in(
select pname from Software where DCOST=(select MIN(dcost) from Software))
group by s.PNAME,st.INSTITUTE


--103. How many packages were developed by female programmers earning
--more than the highest paid male programmer?

select distinct(COUNT(*)) as number_of_female_employees 
from Software as s inner join Programmer as p
on s.PNAME=p.PNAME
where p.GENDER='f' and p.SALARY>(select MAX(salary) from Programmer where GENDER='m')

--104. How many packages are developed by the most experienced
--programmers from BDPS?


select COUNT(*) as 'number of packages' from 
Software as s inner join Programmer as p
on s.PNAME=p.PNAME
inner join Studies as st
on s.PNAME=st.PNAME
where st.INSTITUTE='BDPS' and 
p.DOJ=(select MIN(doj) from Programmer as p
inner join Studies as st
on p.PNAME=st.PNAME
where st.INSTITUTE='bdps')

--105. List the programmers (from the software table) and the institutes they
--studied at.

select distinct(s.PNAME),st.INSTITUTE from Software as s
inner join Studies as st
on s.PNAME=st.PNAME

--106. List each PROF with the number of programmers having that PROF
--and the number of the packages in that PROF.
; with table_prof as(
select prof,SUM(count_prof) as counts from
(select prof1 as prof,COUNT(prof1) as count_prof from Programmer
group by PROF1
union all
select prof2 as prof,COUNT(prof2) as count_prof from Programmer
group by PROF2
) as combined
group by prof)

select s.DEVELOPIN,tp.counts as Number_of_employees,COUNT(s.developin) as number_of_packages 
from Software as s
inner join table_prof as tp
on s.DEVELOPIN=tp.prof
group by s.DEVELOPIN,tp.counts


--107. List the programmer names (from the programmer table) and the
--number of packages each has developed

select p.PNAME,COUNT(s.TITLE) as number_of_packages from Programmer as p
inner join Software as s
on p.PNAME=s.PNAME
group by p.PNAME


