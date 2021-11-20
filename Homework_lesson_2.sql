--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing


---- Задание 1: Вывести name, class по кораблям, выпущенным после 1920

select ships.name, classes.class
from classes 
join ships 
on classes.class = ships.class 
where launched > 1920 

--или так

select ships.name, ships.class
from ships
where launched > 1920 


--  Задание 2: Вывести name, class по кораблям, выпущенным после 1920, но не позднее 1942
select ships.name, classes.class
from classes 
join ships 
on classes.class = ships.class 
where (launched > 1920 and launched <=1942)

--или просто из одной талицы


select ships.name, ships.class
from ships
where (launched > 1920 and launched <=1942)


--  Задание 3: Какое количество кораблей в каждом классе. Вывести количество и class
select classes.class, count (*)
from classes 
join ships 
on classes.class = ships.class
group by classes.class

-- либо так
select ships.class, count (*)
from ships
group by ships.class

 -- Задание 4: Для классов кораблей, калибр орудий которых не менее 16, укажите класс и страну. (таблица classes)
select classes.class, country
from classes
where bore >= 16


-- Задание 5: Укажите корабли, потопленные в сражениях в Северной Атлантике (таблица Outcomes, North Atlantic). Вывод: ship.
select outcomes.ship 
from outcomes 
where (result = 'sunk' and battle = 'North Atlantic')

-- ��� ���
select outcomes.ship 
from outcomes
join battles 
on outcomes.battle = battles.name
where (result = 'sunk' and battles.name = 'North Atlantic')


-- Задание 6: Вывести название (ship) последнего потопленного корабля

select outcomes.ship, date
from outcomes 
join battles 
on outcomes.battle = battles.name 
where battles.date = (
    select max (battles.date)
    from outcomes 
    join battles
    on outcomes.battle = battles.name
    where result = 'sunk')
    
                

--  Задание 7: Вывести название корабля (ship) и класс (class) последнего потопленного корабля
    
select outcomes.ship, ships.class 
from outcomes
join ships 
on outcomes.ship = ships.name
where outcomes.result = 'sunk'
and outcomes.ship in
(
  
  select outcomes.ship
  from outcomes
  join battles 
  on outcomes.battle = battles.name
  where battles.date = (
    select max (battles.date)
    from outcomes 
    join battles
    on outcomes.battle = battles.name
    where result = 'sunk')
) 
  
-- Задание 8: Вывести все потопленные корабли, у которых калибр орудий не менее 16, и которые потоплены. Вывод: ship, class

select classes.class, ships.name 
from classes 
join ships
on ships.class = classes.class
where classes.bore >=16
and ships.name in
(
      select ships.name
      from ships
      join outcomes
      on outcomes.ship = ships.name
      where outcomes.result = 'sunk'
)

-- Задание 9: Вывести все классы кораблей, выпущенные США (таблица classes, country = 'USA'). Вывод: class

select classes.class
from classes 
where country = 'USA'


-- Задание 10: Вывести все корабли, выпущенные США (таблица classes & ships, country = 'USA'). Вывод: name, class

select ships.name, classes.class
from classes 
join ships 
on classes.class = ships.class
where country = 'USA'


-- Задание 20: Найдите средний размер hd PC каждого из тех производителей, которые выпускают и принтеры. Вывести: maker, средний размер HD.


select maker, avg(pc.hd)
from product
join pc 
on product.model = pc.model 
and product.maker in 
(  
   select product.maker
   from product 
   join printer 
   on product.model = printer.model
)
group by maker