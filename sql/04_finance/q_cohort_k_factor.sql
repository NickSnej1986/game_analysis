--Рассчитаем K-factor нашей игры.

--Определим, сколько пользователей нам принесет одна будущая среднестатистическая когорта.

WITH t1 as
(SELECT sum(coalesce(r.ref_reg, 0)) as sum_reg 
       ,count(DISTINCT u.id_user) as cnt_user 
	   ,sum(coalesce(r.ref_reg, 0)) / count(DISTINCT u.id_user) as k_factor
FROM skygame.users u 
  LEFT JOIN skygame.referral r
         ON u.id_user = r.id_user 
),
t2 as
(SELECT count(DISTINCT id_user) as cnt_user
       ,count(DISTINCT date_trunc('month', reg_date)) as cnt_month 
	   ,count(DISTINCT id_user) / count(DISTINCT date_trunc('month', reg_date)) avg_cog
FROM skygame.users
WHERE reg_date is not null
) 

SELECT  t1.sum_reg
       ,t1.cnt_user
	   ,t1.k_factor
	   ,t2.avg_cog
       ,t2.avg_cog * t1.k_factor as forecast_cogort
FROM t1
CROSS JOIN t2

