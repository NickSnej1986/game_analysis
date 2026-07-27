--Рейтинг по вылатам

WITH LTR as
(SELECT id_user 
      ,sum(cnt_buy * price) as revenue
FROM skygame.monetary m
  JOIN skygame.log_prices lp 
    ON m.id_item_buy = lp.id_item
	AND dtime_pay >= valid_from AND dtime_pay <= COALESCE(valid_to, '3000-01-01')
GROUP BY m.id_user
),
LT_mm as
(SELECT u.id_user 
      ,ceil(EXTRACT('days' from max(start_session) - min(reg_date)) / 30) as lt_mm
FROM skygame.game_sessions gs 
  JOIN skygame.users u 
    ON gs.id_user = u.id_user 
GROUP BY u.id_user  
)

SELECT LTR.id_user 
      ,revenue / LT_mm as LTR_mm
	  ,LT_mm
FROM LTR
  JOIN LT_mm
    ON LTR.id_user = LT_mm.id_user
ORDER BY LTR_mm desc
limit 100
