---схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task13 (lesson3)
--Компьютерная фирма: Вывести список всех продуктов и производителя с указанием типа продукта (pc, printer, laptop). Вывести: model, maker, type  

select  distinct model, maker,type 
from product


--task14 (lesson3)
--Компьютерная фирма: При выводе всех значений из таблицы printer дополнительно вывести для тех, у кого цена вышей средней PC - "1", у остальных - "0"  
select *,
case
   when price > (select avg(price) from printer) then 1
   else 0
end flag
from printer 

--Проверка средняя цена = 296

select avg(price)
from printer

--task15 (lesson3)
--Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) 


--Только из таблицы Ships
select * 
from ships
where class is null

--Из outcomes и ships. Без  "Бисмарк" с классом, но в таблице classes
select name, ships.class
from ships 
where class is null
 union 
select ship, ships.class
from outcomes 
left join ships
on ships.name = outcomes.ship
where class is  null


--task16 (lesson3)
--Корабли: Укажите сражения, которые произошли в годы, не совпадающие ни с одним из годов спуска кораблей на воду. 

with q1 as 
(
	select name, extract(year from date) as year 
	from battles
) 
select *
from q1
where year not in (select launched from ships)



--task17 (lesson3)
--Корабли: Найдите сражения, в которых участвовали корабли класса Kongo из таблицы Ships. 
 
--Через объединение 
select distinct battle
from outcomes 
join ships 
on outcomes.ship = ships.name
where class = 'Kongo'

-- через IN
select distinct battle
from outcomes 
where ship in 
 (select name 
  from ships 
  where class = 'Kongo')


--task1  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_300) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше > 300. Во view три колонки: model, price, flag 

create view  all_products_flag__300 as
select  model, price, 
case 
    when price > 300 then 1
    else 0
end flag
from (
select model, price
from pc 
union all
select model,price
from printer 
union all
select model, price
from laptop 
) a 


--Проверка
select *
from all_products_flag__300



--task2  (lesson4)
-- Компьютерная фирма: Сделать view (название all_products_flag_avg_price) для всех товаров (pc, printer, laptop) с флагом, если стоимость больше cредней . Во view три колонки: model, price, flag 
create view all_products_flag_avg_price as
select  model, price, 
case 
    when price > (select avg(price) from
									    (select model, price
										from pc 
										union
										select model,price
										from printer 
										union
										select model, price
										from laptop 
										)d 
					)	
    then 1
           
    else 0
end flag
from (
select model, price
from pc 
union
select model,price
from printer 
union
select model, price
from laptop 
) a 

--Проверка
select *
from all_products_flag_avg_price


-- Проверка средняя цена по всем товарам = 659

select avg(price) from
									    
                       (select model, price
						from pc 
						union
						select model,price
						from printer 
						union
						select model, price
						from laptop 
						)d 




--task3  (lesson4)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model 
						
select product.model
from product
join printer 
on product.model = printer.model
where maker = 'A'
and price > (select avg(price) from product
							join printer 
							on product.model = printer.model where (maker = 'D' or maker = 'C'))
							


--task4 (lesson4)
-- Компьютерная фирма: Вывести все товары производителя = 'A' со стоимостью выше средней по принтерам производителя = 'D' и 'C'. Вывести model 
							
select model
from ( select product.model, price
       from product
       join pc 
       on product.model = pc.model
       where maker = 'A'
       union all
       select product.model, price
       from product 
       join printer
       on product.model = printer.model
       where maker = 'A'
       union all
       select product.model, price
       from product
       join laptop
       on product.model = laptop.model 
       where maker = 'A'
      ) a 
where price > ( select avg(price) from product
							       join printer 
							       on product.model = printer.model where (maker = 'D' or maker = 'C')
           	)	
			         	
--Проверка Средняя стоимость принтера производителей D и С равна 335
select avg(price) 
from printer 
join product 
on printer.model = product.model
where maker = 'C' or maker = 'D'
							      
     
 
     
							

--task5 (lesson4)
-- Компьютерная фирма: Какая средняя цена среди уникальных продуктов производителя = 'A' (printer & laptop & pc) 

select avg(price)
from
(
     select price, maker
	   from pc 
	   join product 
	   on pc.model = product.model 
   union  
   		select price, maker
   		from laptop 
   		join product 
   		on laptop.model = product.model 
   union 
         select price, maker
         from printer 
         join product 
         on product.model = printer.model
) a
where maker = 'A'




--task6 (lesson4)
-- Компьютерная фирма: Сделать view с количеством товаров (название count_products_by_makers) по каждому производителю. Во view: maker, count 

create view count_products__by__makers as
select count(*) as counts, maker
from ( 
      select  pc.model, maker
	   from pc 
	   join product 
	   on pc.model = product.model 
   union  all
   		select laptop.model, maker
   		from laptop 
   		join product 
   		on laptop.model = product.model 
   union all
         select  printer.model, maker
         from printer 
         join product 
         on product.model = printer.model
     ) a
group by maker


--Проверка
select *
from count_products__by__makers


--task7 (lesson4)
-- По предыдущему view (count_products_by_makers) сделать график в colab (X: maker, y: count) 
-- Сделала в колаб


--task8 (lesson4)
-- Компьютерная фирма: Сделать копию таблицы printer (название printer_updated) и удалить из нее все принтеры производителя 'D' 

create table printer_updated as
select *
from printer 
where model in (select model from product where maker != 'D')

--Проверка
select *
from printer_updated


--task9 (lesson4)
-- Компьютерная фирма: Сделать на базе таблицы (printer_updated) view с дополнительной колонкой производителя (название printer_updated_with_makers) 
create view printer_updated_with_makers as
select code, printer_updated.model, color, printer_updated.type, price, maker 
from printer_updated
join product 
on printer_updated.model = product.model
 
--Проверка
select *
from printer_updated_with_makers



--task10 (lesson4)
-- Корабли: Сделать view c количеством потопленных кораблей и классом корабля (название sunk_ships_by_classes). Во view: count, class (если значения класса нет/IS NULL, то заменить на 0) 


create table count1__class as
select count(*) as counts, class as clas
from outcomes 
left join ships
on outcomes.ship = ships.name  
where result = 'sunk'
group by class

update  count1__class
set clas = '0' where clas is null

create view sunk1_ships__by__classes as
select *
from count1__class



-- Проверка
select *
from sunk1_ships__by__classes

--task11 (lesson4)
-- Корабли: По предыдущему view (sunk_ships_by_classes) сделать график в colab (X: class, Y: count)

--Сделала в колаб, но странно выводит по оси Х


--task12 (lesson4)
-- Корабли: Сделать копию таблицы classes (название classes_with_flag) и добавить в нее flag: если количество орудий больше или равно 9 - то 1, иначе 0 

create table classes_with_flag as
select *,
case
when numguns >= 9 then 1
else 0
end flag
from classes

--Проверка

select *
from classes_with_flag

--task13 (lesson4)
-- Корабли: Сделать график в colab по таблице classes с количеством классов по странам (X: country, Y: count)  

create table classes_copy as
select count (*) as counts, country
from classes
group by country

--Проверка
select *
from classes_copy

--График построила в колаб

--task14 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название начинается с буквы "O" или "M". 

select count(*)
from ships 
where name like 'O%' or name like 'M%'

--Проверка
select *
from ships

--task15 (lesson4)
-- Корабли: Вернуть количество кораблей, у которых название состоит из двух слов. 

select count (*)
from ships 
where name like '% %'

--task16 (lesson4)
-- Корабли: Построить график с количеством запущенных на воду кораблей и годом запуска (X: year, Y: count)
 
create table ships1_copy_year as
select count(*) as counts, launched as year
from ships
group by launched
order by year

--Проверка
select * 
from ships1_copy_year

--График построен в колаб
