--С 1 января 2023 года мы увеличили стоимость одного кристалла.

--Построим динамику среднего количества приобретаемых кристаллов на одну покупку.

SELECT date_trunc('month', dtime_pay) mm
      ,avg(cnt_buy) as avg_cb
	  ,sum(cnt_buy*price) as revenue 
FROM skygame.monetary m
  JOIN skygame.item_list i 
    ON m.id_item_buy = i.id_item
  JOIN skygame.log_prices p 
    ON p.id_item = i.id_item
	AND dtime_pay::date >= valid_from 
	AND dtime_pay::date < COALESCE(valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
WHERE name_item = 'Crystal'
GROUP BY mm
ORDER BY mm
