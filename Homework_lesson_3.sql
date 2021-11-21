----схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing


task1
--Корабли: Для каждого класса определите число кораблей этого класса, потопленных в сражениях. Вывести: класс и число потопленных кораблей.

SELECT union1.class, SUM(union1.sunks1) Sunks 
FROM (

SELECT classes.class, COUNT(outcomes.ship) sunks1 
FROM Outcomes   JOIN 
Ships  ON outcomes.ship = ships.name  JOIN 
Classes  ON ships.class = classes.class
WHERE outcomes.result = 'sunk'
GROUP BY classes.class
UNION

SELECT classes.class, COUNT(outcomes.ship)
FROM Outcomes   JOIN 
Classes  ON outcomes.ship = classes.class
WHERE outcomes.result = 'sunk'

GROUP BY classes.class
UNION

SELECT classes.class, 0 
FROM Classes 
) union1
GROUP BY union1.class;

--либо учитываем только корабли из таблицы ships
select ships.class, count(*)
from ships 
join outcomes 
on ships.name = outcomes.ship 
where outcomes.result = 'sunk'
group by ships.class


--task2
---Корабли: Для каждого класса определите год, когда был спущен на воду первый корабль этого класса. Если год спуска на воду головного корабля неизвестен, определите минимальный год спуска на воду кораблей этого класса. Вывести: класс, год.

SELECT class, launched AS year
FROM Ships
WHERE name = class
union

SELECT class, MIN(launched)
FROM Ships
WHERE class NOT IN (SELECT class 
 FROM Ships 
 WHERE name = class
 )
GROUP BY class
union

SELECT class, NULL
FROM classes
WHERE class NOT IN(SELECT class 
 FROM ships
 ) ;


--task3
--Корабли: Для классов, имеющих потери в виде потопленных кораблей и не менее 3 кораблей в базе данных, вывести имя класса и число потопленных кораблей.

SELECT class, COUNT(result) AS number_sunk 
FROM (SELECT class, result, name 
 FROM Ships LEFT JOIN 
 Outcomes ON outcomes.ship=ships.name AND 
 class IS NOT NULL AND 
 result = 'sunk'
 ) a
GROUP BY class 
HAVING COUNT(class) > 2 AND 
 COUNT(result) > 0;


--task4
--Корабли: Найдите названия кораблей, имеющих наибольшее число орудий среди всех кораблей такого же водоизмещения (учесть корабли из таблицы Outcomes).


SELECT name
FROM (SELECT outcomes.ship AS name, numGuns, displacement
 FROM Outcomes  INNER JOIN 
 Classes  ON outcomes.ship = classes.class AND 
 outcomes.ship NOT IN (SELECT name 
 FROM Ships
 ) 
 UNION
 SELECT ships.name AS name, numGuns, displacement 
 FROM Ships  INNER JOIN 
 Classes  ON ships.class = classes.class 
 ) OS INNER JOIN 
 (SELECT MAX(numGuns) AS MaxNumGuns, displacement
 FROM Outcomes  INNER JOIN 
 Classes  ON outcomes.ship = classes.class AND 
 outcomes.ship NOT IN (SELECT name 
 FROM Ships
 ) 
 GROUP BY displacement
 UNION
 SELECT MAX(numGuns) AS MaxNumGuns, displacement
 FROM Ships  INNER JOIN 
 Classes  ON ships.class = classes.class
 GROUP BY displacement
 ) GD ON OS.numGuns = GD.MaxNumGuns AND 
 OS.displacement = GD.displacement;


--task5
--Компьютерная фирма: Найдите производителей принтеров, которые производят ПК с наименьшим объемом RAM и с самым быстрым процессором среди всех ПК, имеющих наименьший объем RAM. Вывести: Maker

SELECT DISTINCT maker
FROM Product 
WHERE type = 'Printer' AND 
      maker IN(SELECT maker 
               FROM Product 
               WHERE model IN(SELECT model 
                              FROM PC
                              WHERE speed = (SELECT MAX(speed)
                                             FROM (SELECT speed 
                                                   FROM PC 
                                                   WHERE ram=(SELECT MIN(ram)
                                                              FROM PC
                                                              )
                                                   ) as mk
                                             )
                              )
               );
