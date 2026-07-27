-- LMAU, LDAU, LWAU

WITH crit_invite as
(SELECT id_user
      ,count(*) as cnt
	  ,sum(ref_reg) as sum_reg
FROM skygame.referral
GROUP BY id_user
HAVING count(*) >= 3
   AND sum(ref_reg) >= 1
)

SELECT date_trunc('Month', start_session) as bin_month 
      ,count(DISTINCT id_user) as cnt_user
FROM skygame.game_sessions
WHERE id_user in (SELECT id_user 
                  FROM crit_invite)
GROUP BY bin_month
ORDER BY bin_month