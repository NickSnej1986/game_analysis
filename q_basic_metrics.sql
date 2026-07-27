--Исследуем выборку пользователей в таблице

select * 
from skygame.users

--Сколько всего пользователей в нашей базе?

select count(*) as cnt_all
      ,count(id_user) as cnt_reg
	  ,count(distinct id_user) as cnt_user
from skygame.users

--Есть ли пользователи, которые регистрировались больше одного раза?

select id_user
from skygame.users
group by id_user
having count(*) > 1

--Исследуем время регистрации полльзователей
--Какое минимальное и максимальное время регистрации есть в нашей витрине

select min(reg_date) as min_date
      ,max(reg_date) as max_date
	  ,sum(case when reg_date is null then 1 else 0 end) as cnt_null
from skygame.users

--Исследуем динамику пользовательской базы

select date_trunc('month', reg_date) as mm
      ,count(*) as cnt_users
from skygame.users
group by mm 
order by mm