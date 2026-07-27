--Определим суммарное количество игровых сессий за всё время.

select count(*) as cnt_all
      ,sum(case when end_session - start_session > interval '5 minute' then 1 else 0 end) as cnt_signif
from skygame.game_sessions

--Определим суммарное количество игровых сессий дольше 5 минут.
--Определим ответы на пункты 1 и 2 в один запрос.

--Построим распределение по месяцам:
--суммарного количества игровых сессий,
--суммарного количества сессий дольше 5 минут,
--доли сессий дольше 5 минут среди всех сессий.
--В дальнейшем анализе отсеем все сессии меньше 5 минут.

select date_trunc('month', start_session) as mm
      ,count(*) as cnt_all
      ,sum(case when end_session - start_session > interval '5 minute' then 1.0 else 0.0 end) as cnt_signif
	  ,sum(case when end_session - start_session > interval '5 minute' then 1.0 else 0.0 end) / count(*) as share_signif
from skygame.game_sessions
group by mm 
order by mm

--Построим динамику средней длительности одной игровой сессии по месяцам.

select date_trunc('month', start_session) as mm
      ,avg(extract(epoch from end_session - start_session)) / (60*60) as avg_len
from skygame.game_sessions
where end_session - start_session > interval '5 minute'
group by mm 
order by mm

--Построим динамику доли «длинных» сессий среди всех сессий. В качестве границы длины можно взять, например, 1 час.

select date_trunc('month', start_session) as mm
      ,sum(case when end_session - start_session > interval '1 hour' then 1.0 else 0.0 end ) / count(*) as share_long
from skygame.game_sessions
where end_session - start_session > interval '5 minute'
group by mm 
order by mm