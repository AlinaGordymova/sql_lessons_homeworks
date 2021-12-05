--схема БД: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--task6 (lesson5)
-- Компьютерная фирма: Сделать график со средней ценой по всем товарам по каждому производителю (X: maker, Y: avg_price) на базе view all_products_050521
create table   all_products__0505211 as 
select maker, avg(price) as avgprice
from all_products_050521
group by maker 
 
-- График в колаб файл Home_work_colab_5

--task11 (lesson5)
-- Компьютерная фирма: Построить график с со средней и максимальной ценами на базе products_with_lowest_price (X: maker, Y1: max_price, Y2: avg)price
create table products_with_lowest_price1 as
select maker, avg(price) as avgprice, max(price) as maxprice
from products_with_lowest_price
group by maker 
 
-- График в колаб файл Home_work_colab_5


--task1 (lesson5)
-- Компьютерная фирма: Сделать view (pages_all_products), в которой будет постраничная разбивка всех продуктов (не более двух продуктов на одной странице). Вывод: все данные из laptop, номер страницы, список всех страниц

sample:
1 1
2 1
1 2
2 2
1 3
2 3


create view razbivka_on_page as
select *, row_number(*) over(partition by page_num order by code) as place_of_pages
from  
( SELECT *, 
     CASE WHEN counts % 2 = 0 THEN counts/2 ELSE counts/2 + 1 END AS col_vo_pages, 
     CASE WHEN code % 2 = 0 THEN code/2 ELSE code/2 + 1 END AS page_num 
      
FROM (
   SELECT  *, 
             COUNT(*) OVER() AS counts
      FROM Laptop
    ) a
)b 


--Проверка
select *
from razbivka_on_page




--task2 (lesson5)
-- Компьютерная фирма: Сделать view (distribution_by_type), в рамках которого будет процентное соотношение всех товаров по типу устройства. Вывод: производитель, тип, процент (%)



-- Отдельно  посчитала полное колличество строк по всем моделям, получила 19 и потом высчитала проценты округленные до целого. Так не получилось.
select  count(model)
from product 


create view distribution_by_type as
select *, counts*100/19 as value, '%' as persent
from  
		(select distinct type,  count(model) over (partition by type) as counts
		from product
     )  a 

--Проверка
   
select *
from distribution_by_type
  


--task3 (lesson5)
-- Компьютерная фирма: Сделать на базе предыдущенр view график - круговую диаграмму. Пример https://plotly.com/python/histograms/



--task4 (lesson5)
-- Корабли: Сделать копию таблицы ships (ships_two_words), но название корабля должно состоять из двух слов
   
create table ships_two_words as
select *
from ships 
where name like '% %' 

--Проверка

select *
from ships_two_words

--task5 (lesson5)
-- Корабли: Вывести список кораблей, у которых class отсутствует (IS NULL) и название начинается с буквы "S"

select name, ships.class
from ships 
where class is null and name like 'S%'
 union 
select ship, ships.class
from outcomes 
left join ships
on ships.name = outcomes.ship
where class is  null and ship like 'S%'



--task6 (lesson5)
-- Компьютерная фирма: Вывести все принтеры производителя = 'A' со стоимостью выше средней по принтерам производителя = 'C' и три самых дорогих (через оконные функции). Вывести model
-- Заменила в задаче производителя 'C' на производителя 'D', так как в принципе производитель 'C' не производит принтеры. Так же условие про три самых дорогих не проверяется, 
--так как принтер без этого условия выводится всего лишь один при проверки первого условия по цене выше средней производителя 'D'
--
select *
from ( 
       select *, row_number(*) over( order by price desc) as total
        from ( 
				select product.model, price
				from product
				join printer 
				on product.model = printer.model
				where maker = 'A'
				and price > (select avg(price) from product
											join printer 
											on product.model = printer.model where maker = 'D')
          ) a
) b
where total < 4
