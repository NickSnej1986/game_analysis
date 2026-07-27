--Найдем количество битых строк и их долю

SELECT  sum(case when end_session is null then 1 else 0 end) as sum_null
       ,sum(case when end_session is null then 1.0 else 0.0 end) / count (*) * 100 as share_null
FROM skygame.game_sessions

--Посчитаем долю битых записей для всех типов девайсов

SELECT  dev_type 
       ,sum(case when t1.end_session is null AND t2.dev_type = 'ios' then 1.0 else 0.0 end) / count(case when t2.dev_type = 'ios' then 1.0 else 0.0 end) *100 as ios_share
       ,sum(case when t1.end_session is null AND t2.dev_type = 'android' then 1.0 else 0.0 end) / count(case when t2.dev_type = 'android' then 1.0 else 0.0 end) *100 as android_share
FROM skygame.game_sessions t1
         JOIN skygame.users t2
	       ON t1.id_user = t2.id_user 
group by dev_type

--Посчитаем распределение проблемных заказов по ios и android

SELECT  sum(case when t1.end_session is null AND t2.dev_type = 'ios' then 1.0 else 0.0 end) / sum(case when t1.end_session is null then 1.0 else 0.0 end) *100 as ios_share_null
       ,sum(case when t1.end_session is null AND t2.dev_type = 'android' then 1.0 else 0.0 end) / sum(case when t1.end_session is null then 1.0 else 0.0 end)*100 as android_share_null
FROM skygame.game_sessions t1
         JOIN skygame.users t2
	       ON t1.id_user = t2.id_user 
where t1.end_session is null

--Соединим три запроса в один запрос

WITH base_data AS 
(SELECT t1.end_session
       ,t2.dev_type
FROM skygame.game_sessions t1
  JOIN skygame.users t2 
    ON t1.id_user = t2.id_user)
	,aggregates AS
(SELECT
      SUM(CASE WHEN end_session IS NULL THEN 1 ELSE 0 END) AS sum_null
	,(SUM(CASE WHEN end_session IS NULL THEN 1.0 ELSE 0.0 END) / COUNT(*) * 100) AS share_null
	,(SUM(CASE WHEN end_session IS NULL AND dev_type = 'ios' THEN 1.0 ELSE 0.0 END)
      / SUM(CASE WHEN dev_type = 'ios' THEN 1.0 ELSE 0.0 END) * 100) AS ios_share
	,(SUM(CASE WHEN end_session IS NULL AND dev_type = 'android' THEN 1.0 ELSE 0.0 END)
      / SUM(CASE WHEN dev_type = 'android' THEN 1.0 ELSE 0.0 END) * 100) AS android_share
	,(SUM(CASE WHEN end_session IS NULL AND dev_type = 'ios' THEN 1.0 ELSE 0.0 END)
      / SUM(CASE WHEN end_session IS NULL THEN 1.0 ELSE 0.0 END) * 100) AS ios_share_null
	,(SUM(CASE WHEN end_session IS NULL AND dev_type = 'android' THEN 1.0 ELSE 0.0 END)
      / SUM(CASE WHEN end_session IS NULL THEN 1.0 ELSE 0.0 END) * 100) AS android_share_null
FROM base_data)
SELECT * FROM aggregates;

