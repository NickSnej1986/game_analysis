--Вычисляем DAU WAU MAU и Stickly Factor

SELECT *
FROM skygame.game_sessions

SELECT  date_trunc('day', start_session) as day
       ,count(distinct id_user) as DAU
FROM skygame.game_sessions
group by day
order by day

SELECT  date_trunc('week', start_session) as week
       ,count(distinct id_user) as WAU
FROM skygame.game_sessions
group by week
order by week

SELECT  date_trunc('month', start_session) as month
       ,count(distinct id_user) as MAU
FROM skygame.game_sessions
group by month
order by month
