--Анализируем гипотезы о комбинациях различных критериев лояльности пользователей, и как эти критерии влияют на динамику и базу

--Критерии:
--1. Оплатил более 1000 р
--2. Пригласил в игру более 3 пользователей и минимум 1 зарегистрировался

WITH crit_invite as
(SELECT id_user
      ,count(*) as cnt
	  ,sum(ref_reg) as sum_reg
FROM skygame.referral
GROUP BY id_user
HAVING count(*) >= 3
   AND sum(ref_reg) >= 1
),
crit_1000 as
(SELECT id_user 
      ,sum(cnt_buy * price)
FROM skygame.monetary m
  JOIN skygame.log_prices lp 
    ON m.id_item_buy = lp.id_item
	AND dtime_pay >= valid_from AND dtime_pay <= COALESCE(valid_to, '3000-01-01')
GROUP BY id_user
HAVING sum(cnt_buy * price) > 1000
) 

SELECT date_trunc('Month', start_session) as bin_month 
      ,count(DISTINCT id_user) as cnt_user
FROM skygame.game_sessions
WHERE id_user in (SELECT id_user 
                  FROM crit_1000)
  AND id_user in (SELECT id_user 
                  FROM crit_invite)
GROUP BY bin_month
ORDER BY bin_month

----------------------------------------

WITH crit_invite as
(SELECT id_user
      ,count(*) as cnt
	  ,sum(ref_reg) as sum_reg
FROM skygame.referral
GROUP BY id_user
HAVING count(*) >= 3
   AND sum(ref_reg) >= 1
),
crit_1000 as
(SELECT id_user 
      ,sum(cnt_buy * price)
FROM skygame.monetary m
  JOIN skygame.log_prices lp 
    ON m.id_item_buy = lp.id_item
	AND dtime_pay >= valid_from AND dtime_pay <= COALESCE(valid_to, '3000-01-01')
GROUP BY id_user
HAVING sum(cnt_buy * price) > 1000
) 

SELECT date_trunc('Month', start_session) as bin_month 
      ,count(DISTINCT id_user) as cnt_user
FROM skygame.game_sessions
WHERE id_user in (SELECT id_user 
                  FROM crit_1000)
  OR id_user in (SELECT id_user 
                  FROM crit_invite)
GROUP BY bin_month
ORDER BY bin_month

--------------------------------------

WITH crit_invite as
(SELECT id_user
      ,count(*) as cnt
	  ,sum(ref_reg) as sum_reg
FROM skygame.referral
GROUP BY id_user
HAVING count(*) >= 3
   AND sum(ref_reg) >= 1
),
crit_1000 as
(SELECT id_user 
      ,sum(cnt_buy * price)
FROM skygame.monetary m
  JOIN skygame.log_prices lp 
    ON m.id_item_buy = lp.id_item
	AND dtime_pay >= valid_from AND dtime_pay <= COALESCE(valid_to, '3000-01-01')
GROUP BY id_user
HAVING sum(cnt_buy * price) > 1000
) 

SELECT date_trunc('Month', start_session) as bin_month 
      ,count(DISTINCT id_user) as cnt_user
FROM skygame.game_sessions
WHERE id_user in (SELECT id_user 
                  FROM crit_1000)
  AND id_user not in (SELECT id_user 
                  FROM crit_invite)
GROUP BY bin_month
ORDER BY bin_month