--Определим, надо ли нам наше маркетинговое воздействие распределять на все когорты поровну? Возможно, какие-то когорты более “щедрые” на покупку игровых предметов.

--Рассчитаем среднюю выручку на одного человека на один месяц для каждой когорты.

SELECT  *
      ,extract ('day' from ((select max (dtime_pay) from skygame.monetary) - mm )/30) as interv
      ,avg_rev/( extract ('day' from ((select max (dtime_pay) from skygame.monetary) - mm )/30)) avg_rev_per_month
FROM
(SELECT date_trunc('month', reg_date) mm
       ,sum(cnt_buy*price) as revenue 
	   ,count(distinct m.id_user) as cnt_user
	   ,sum(cnt_buy*price) / count(distinct m.id_user) as avg_rev
FROM skygame.monetary m
  JOIN skygame.log_prices p 
    ON m.id_item_buy = p.id_item
	AND dtime_pay::date >= valid_from 
	AND dtime_pay::date < COALESCE(valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
  JOIN skygame.users u
    ON m.id_user = u.id_user
WHERE reg_date < (SELECT max(dtime_pay) - interval '1 month' 
                  FROM skygame.monetary)
GROUP BY mm
ORDER BY mm
) t