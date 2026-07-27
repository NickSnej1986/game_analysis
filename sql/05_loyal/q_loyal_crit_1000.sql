--Расчет динамики лояльного пользователя по критерию "оплатил больше 1000"

WITH crit_1000 as
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
GROUP BY bin_month
ORDER BY bin_month