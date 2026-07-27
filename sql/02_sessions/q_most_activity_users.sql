--Ищем самых вовлеченных игроков

SELECT  t1.id_user
       ,sum(EXTRACT(epoch FROM(end_session - start_session)) / 60) as session_minutes
FROM skygame.game_sessions t1
      LEFT JOIN skygame.users t2
	    ON t1.id_user = t2.id_user
where end_session is NOT NULL
  AND reg_date >= '2022-01-01'
  AND reg_date <= '2022-12-31'
group by t1.id_user
order by session_minutes desc
limit 25