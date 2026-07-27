--В ноябре и декабре 2022 года была опробована альтернативная стратегия привлечения клиентов.

--Гипотеза: в ноябре и декабре 2022 года из-за более дорогой и таргетированной рекламы мы приобрели более “лояльных” игроков, которые больше времени посвящают нашей игре.

SELECT  case when reg_date BETWEEN '2022-11-01' AND '2022-12-31' then '11-12.2022' else 'Остальные' end as cog
       ,avg(end_session - start_session) as avg_session
FROM skygame.users u
  LEFT JOIN skygame.game_sessions gs 
         ON u.id_user = gs.id_user 
WHERE (end_session - start_session) > interval '5 minute'
  AND (end_session - start_session) is not null 
GROUP BY cog