--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task1  (lesson7)
-- sqlite3: Сделать тестовый проект с БД (sqlite3, project name: task1_7). В таблицу table1 записать 1000 строк с случайными значениями (3 колонки, тип int) от 0 до 1000.
-- Далее построить гистаграмму распределения этих трех колонок



--Решение в колабе   Homework_lesson_7




--task2  (lesson7)
-- oracle: https://leetcode.com/problems/duplicate-emails/ 
create table Person (id int, email varchar(255))

Insert into Person (id, email) values ('1', 'a@b.com');
insert into Person (id, email) values ('2', 'c@d.com');
insert into Person (id, email) values ('3', 'a@b.com');
insert into Person (id, email) values ('4', 'f@c.com');
insert into Person (id, email) values ('5', 'c@d.com');
insert into Person (id, email) values ('6', 's@b.com');
insert into Person (id, email) values ('7', 't@b.com');

select * from Person

-- Первый вариант
select email
from Person
group by email
having count(email) > 1

--Второй вариант
select  email from
(
  select email, count(email) as  num
  from Person
  group by email
)  a
where num > 1



--task3  (lesson7)
-- oracle: https://leetcode.com/problems/employees-earning-more-than-their-managers/

Create table Employee (id int, name varchar(255), salary int, managerId int)
insert into Employee (id, name, salary, managerId) values ('1', 'Joe', '70000', '3');
insert into Employee (id, name, salary, managerId) values ('2', 'Henry', '80000', '4');
insert into Employee (id, name, salary, managerId) values ('3', 'Sam', '60000', '5');
insert into Employee (id, name, salary, managerId) values ('4', 'Max', '90000', '0');
insert into Employee (id, name, salary, managerId) values ('5', 'Pol', '100000', '0');

select * from Employee
-- Первый вариант

SELECT
     a.name as Employee
FROM Employee as a JOIN Employee as b
     ON a.ManagerId = b.Id
     AND a.Salary > b.Salary

--Второй вариант
select Name as Employee
FROM Employee   b
where b.ManagerId in (select Id from Employee)
and b.salary >
( 
    select bb.Salary from Employee bb where b.ManagerId = bb.Id
)



--task4  (lesson7)
-- oracle: https://leetcode.com/problems/rank-scores/
Create table  Scores (id int, score DECIMAL(3,2))
insert into Scores (id, score) values ('1', '3.5');
insert into Scores (id, score) values ('2', '3.65');
insert into Scores (id, score) values ('3', '4.0');
insert into Scores (id, score) values ('4', '3.85');
insert into Scores (id, score) values ('5', '4.0');
insert into Scores (id, score) values ('6', '3.65');
     

select score, rank
from (  select *,
	    dense_rank () over(order by score desc) as rank
	    from Scores 
	    ) a 
 


--task5  (lesson7)
-- oracle: https://leetcode.com/problems/combine-two-tables/ 
Create table  Person1 (personId int, firstName varchar(255), lastName varchar(255))
Create table  Address (addressId int, personId int, city varchar(255), state varchar(255))
insert into Person1 (personId, lastName, firstName) values ('1', 'Wang', 'Allen');
insert into Person1 (personId, lastName, firstName) values ('2', 'Alice', 'Bob');
insert into Person1 (personId, lastName, firstName) values ('3', 'Petrov', 'Oleg');
insert into Person1 (personId, lastName, firstName) values ('4', 'Ivanov', 'sergey');

insert into Address (addressId, personId, city, state) values ('1', '2', 'New York City', 'New York');
insert into Address (addressId, personId, city, state) values ('2', '4', 'Leetcode', 'California');
insert into Address (addressId, personId, city, state) values ('3', '3', 'San_Diego', 'California');

select * from Person1
select * from Address


select FirstName, LastName, City, State
from Person1 left join Address
on Person1.PersonId = Address.PersonId  