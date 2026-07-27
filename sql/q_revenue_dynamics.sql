--Рассчитаем динамику суммарных клиентских выплат по месяцам в разрезе по типам продукта.

SELECT *
       ,COALESCE(valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
FROM skygame.log_prices

SELECT date_trunc('month', dtime_pay) mm
      ,type
	  ,sum(cnt_buy*price) as revenue 
FROM skygame.monetary m
  JOIN skygame.item_list i 
    ON m.id_item_buy = i.id_item
  JOIN skygame.log_prices p 
    ON p.id_item = i.id_item
	AND dtime_pay::date >= valid_from 
	AND dtime_pay::date < COALESCE(valid_to, to_date('3000-01-01', 'YYYY-MM-DD'))
GROUP BY mm
        ,type
ORDER BY type 
        ,mm

