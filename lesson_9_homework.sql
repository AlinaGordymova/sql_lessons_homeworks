--task1  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem

select 
 if ((select GR.GRADE from GRADES as GR where St.MARKS between GR.MIN_MARK and GR.MAX_MARK)<8,"NULL", St.NAME),
      (select GR.GRADE from GRADES as GR where St.MARKS between GR.MIN_MARK and GR.MAX_MARK), St.MARKS
      from STUDENTS as St 
order by (select GR.GRADE from GRADES  as GR where St.MARKS between GR.MIN_MARK and GR.MAX_MARK) desc, St.NAME;

--task2  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/occupations/problem

with d as 
( select name, row_number() over ( order by name ) as  r from OCCUPATIONS 
where occupation = 'Doctor' ),
p as 
( select name,  row_number() over ( order by name )  as r from OCCUPATIONS 
where occupation = 'Professor' ),
s as 
( select name, row_number() over ( order by name ) as r from OCCUPATIONS 
where occupation = 'Singer' order by name  ),
a as 
( select name, row_number() over ( order by name ) as r from OCCUPATIONS 
where occupation = 'Actor'  order by name )

select d.name as doc, p.name as prof, s.name as sing, a.name as act  
from d 
full join p on ( d.r = p.r )
full join s on ( s.r = p.r )
full join a on ( a.r = p.r ) ;


--task3  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-9/problem

select distinct city
from station
where city not Rlike '^[aeiouAEIOU].*$';

-- Либо так 

select distinct city
from station
where city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%'; 

--task4  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-10/problem

select distinct city
from station
where city not like '%A' and city not like '%E' and city not like '%I' and city not like '%O' and city not like '%U'; 


--task5  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-11/problem

select distinct city
from station
where (city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%') or (city not like '%A' and city not like '%E' and city not like '%I' and city not like '%O' and city not like '%U'); 

--task6  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/weather-observation-station-12/problem

select distinct city 
from station 
where (city not like 'A%' and city not like 'E%' and city not like 'I%' and city not like 'O%' and city not like 'U%') and (city not like '%A' and city not like '%E' and city not like '%I' and city not like '%O' and city not like '%U'); 

--task7  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/salary-of-employees/problem

select name from employee where Salary > 2000 and months < 10 order by employee_id;

--task8  (lesson9)
-- oracle: https://www.hackerrank.com/challenges/the-report/problem
-- Такая же задача как task1