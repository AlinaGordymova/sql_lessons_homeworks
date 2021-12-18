--task1  (lesson8)
-- oracle: https://leetcode.com/problems/department-top-three-salaries/
SELECT
    d.name as "Department", a.name as "Employee", a.Salary
FROM
    Employee a
        JOIN
    Department d ON a.DepartmentId = d.Id
WHERE
    3 > (SELECT
            COUNT(DISTINCT b.Salary)
        FROM
            Employee b
        WHERE
            b.Salary > a.Salary
                AND a.DepartmentId = b.DepartmentId
                
        )  order by d.name


--task2  (lesson8)

select member_name, status, sum(amount*unit_price) as costs
from FamilyMembers
join Payments
on FamilyMembers.member_id= Payments.family_member
WHERE  Payments. date BETWEEN  '2005-01-01' and '2006-01-01'
group by member_name, status


--task3  (lesson8)

select name
from Passenger
group by name
having count(name) >= 2

--task4  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38

select count(first_name) as count
from Student
where first_name = 'Anna'

--task5  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/35

SELECT COUNT(DISTINCT classroom) AS count
FROM Schedule  
WHERE Schedule.date LIKE '2019-09-02%'


--task6  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/38
--Дублирует задание 4

select count(*) as count 
from Student
where first_name = 'Anna'

--task7  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/32

SELECT FLOOR(AVG(TIMESTAMPDIFF(YEAR,
        birthday,
        NOW()))) AS age
FROM FamilyMembers


--task8  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/27
SELECT good_type_name,
        SUM(unit_price * amount) AS costs
FROM Payments, Goods, GoodTypes
WHERE good_id=good
    AND good_type_id=type
    AND YEAR(date)=2005
GROUP BY good_type_name

--task9  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/37

select min (TIMESTAMPDIFF(YEAR,
        birthday,
        NOW())) AS YEAR
From Student

--Либо так

SELECT TIMESTAMPDIFF(YEAR,
        birthday,
        NOW()) AS year
FROM Student
ORDER BY birthday  desc limit 1  

--task10  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/44

SELECT MAX(TIMESTAMPDIFF(YEAR,
        Student.birthday,
        NOW())) AS max_year
FROM Student
INNER JOIN Student_in_class
    ON Student_in_class.student=Student.id
INNER JOIN Class
    ON Student_in_class.class=Class.id
WHERE Class.name LIKE '10%'


--task11 (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/20

SELECT status, member_name,SUM(unit_price * amount) AS costs
FROM FamilyMembers, Goods, Payments, GoodTypes
WHERE member_id=family_member
    AND good_id=good
    AND good_type_id=type
    AND good_type_name='entertainment'
GROUP BY status, member_name


--task12  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/55

delete
FROM Company
WHERE id IN
    (SELECT company
    FROM
        (SELECT company,
        COUNT(*) AS count
        FROM Trip
        GROUP BY company
        HAVING count =
            (SELECT COUNT(*) AS a
            FROM Trip
            GROUP BY company LIMIT 1 )
         ) AS b
    )


--task13  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/45

SELECT Schedule.classroom
FROM Schedule
GROUP BY classroom
HAVING COUNT(*)=
    (SELECT MAX(count)
    FROM
        (SELECT COUNT(*) AS count
        FROM Schedule
        GROUP BY classroom) AS a)

--task14  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/43

select last_name
from Teacher, Schedule, Subject
where Teacher.id = Schedule.teacher  and Subject.id = Schedule.subject
and Subject.name= 'Physical Culture'
order by last_name

--Либо так 

SELECT last_name
FROM Teacher
INNER JOIN Schedule
    ON Schedule.teacher=Teacher.id
INNER JOIN Subject
    ON Schedule.subject=Subject.id
WHERE Subject.name='Physical Culture'
ORDER BY last_name

--task15  (lesson8)
-- https://sql-academy.org/ru/trainer/tasks/63

SELECT CONCAT(last_name,".",
        SUBSTRING(first_name,
        1,
        1),
        ".",
        SUBSTRING(middle_name,
        1,
        1),
        ".") AS name
FROM Student
ORDER BY name
