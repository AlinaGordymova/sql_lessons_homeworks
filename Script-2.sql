--����� ��: https://docs.google.com/document/d/1NVORWgdwlKepKq_b8SPRaSpraltxoMg2SIusTEN6mEQ/edit?usp=sharing
--colab/jupyter: https://colab.research.google.com/drive/1j4XdGIU__NYPVpv74vQa9HUOAkxsgUez?usp=sharing

--������� 1: ������� name, class �� ��������, ���������� ����� 1920
select ships.name, classes.class
from classes 
join ships 
on classes.class = ships.class 
where launched > 1920 


-- ������� 2: ������� name, class �� ��������, ���������� ����� 1920, �� �� ������� 1942
select ships.name, classes.class
from classes 
join ships 
on classes.class = ships.class 
where (launched > 1920 and launched <=1942)

-- ������� 3: ����� ���������� �������� � ������ ������. ������� ���������� � class
select classes.class, count (*)
from classes 
join ships 
on classes.class = ships.class
group by classes.class


-- ������� 4: ��� ������� ��������, ������ ������ ������� �� ����� 16, ������� ����� � ������. (������� classes)
select classes.class, country
from classes
where bore >= 16


-- ������� 5: ������� �������, ����������� � ��������� � �������� ��������� (������� Outcomes, North Atlantic). �����: ship.
select outcomes.ship 
from outcomes 
where (result = 'sunk' and battle = 'North Atlantic')


-- ������� 6: ������� �������� (ship) ���������� ������������ �������

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
    
                

-- ������� 7: ������� �������� ������� (ship) � ����� (class) ���������� ������������ �������
    
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
  
--
-- ������� 8: ������� ��� ����������� �������, � ������� ������ ������ �� ����� 16, � ������� ���������. �����: ship, class

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



-- ������� 20: ������� ������� ������ hd PC ������� �� ��� ��������������, ������� ��������� � ��������. �������: maker, ������� ������ HD.
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


