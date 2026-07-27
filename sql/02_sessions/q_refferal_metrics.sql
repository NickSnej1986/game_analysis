--Определим общее количество разосланных приглашений, а также количество пользователей, которые эти приглашения рассылали.

select count(*) as cnt 
      ,count(DISTINCT id_user) as cnt_user
from skygame.referral

--Какая доля приглашенных друзей установила игру? (поле ref_reg)

select count(*) as cnt 
      ,count(DISTINCT id_user) as cnt_user
	  ,sum(ref_reg) / count(*) as share_ref
from skygame.referral 

--Выведим топ-50 пользователей, у которых больше всего приглашений.

select id_user
       ,count(*) as cnt
from skygame.referral
group by id_user
order by cnt desc
limit 50

--Определим тех пользователей, которые сделали больше 5 приглашений и у которых минимум половина приглашенных зарегистрировались.

select id_user
      ,count(*) as cnt_ref 
	  ,sum(ref_reg) / count(*) as share_ref
from skygame.referral 
group by id_user
having count(*) > 5
  and sum(ref_reg) / count(*) >= 0.5

--Есть ли пользователи, у которых больше (строго) 6 приглашений, но нет ни одного зарегистрированного друга?

select id_user
      ,count(*) as cnt_ref 
	  ,sum(ref_reg) / count(*) as share_ref
from skygame.referral 
group by id_user
having count(*) > 6
  and sum(ref_reg) / count(*) = 0