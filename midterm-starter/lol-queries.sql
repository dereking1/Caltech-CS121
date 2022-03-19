-- [Problem 1]
SELECT (SELECT COUNT(*) FROM final_blows
    WHERE time_of_blow < '00:20:00')/
   (SELECT COUNT(*) FROM final_blows)
   AS percent_within_20m;

-- [Problem 2]
SELECT champion, COUNT(*) AS win_count FROM
    played NATURAL JOIN teams WHERE
    team = team_name AND won = 1
    GROUP BY champion ORDER BY win_count DESC;

-- [Problem 3]
SELECT gamehash, team, game_length FROM
    matches NATURAL JOIN teams WHERE
    side = 'red' AND won = 1
    ORDER BY game_length;

-- [Problem 4]
WITH blue AS (SELECT gamehash, team FROM
         teams WHERE side='blue' AND won = 1),
     red AS (SELECT gamehash, team FROM
         teams WHERE side='red' AND won = 0)
SELECT gamehash, blue.team, red.team, COUNT(*) AS blue_total_final_blows 
     FROM blue NATURAL JOIN red NATURAL JOIN played 
     NATURAL JOIN final_blows
     WHERE killing_player = player_name
     AND team_name = blue.team
     GROUP BY gamehash, blue.team, red.team
     ORDER BY blue_total_final_blows DESC;

-- [Problem 5]
SELECT gamehash, team_name, COUNT(*) AS blows_within_15m,
    season, year FROM 
    matches NATURAL JOIN final_blows NATURAL JOIN played
    WHERE killing_player = player_name AND time_of_blow < '00:15:00'
    GROUP BY gamehash, team_name HAVING COUNT(killing_player) >= 20
    ORDER BY blows_within_15m ASC;

-- [Problem 6]
SELECT gamehash, killing_player AS killer, champion, COUNT(*) AS solo_blows
    FROM played NATURAL JOIN final_blows 
    WHERE player_name = killing_player AND
    (gamehash, time_of_blow, killed_player) NOT IN
    (SELECT gamehash, time_of_blow, killed_player FROM assists)
    GROUP BY gamehash, killer, champion 
    ORDER BY solo_blows DESC, gamehash ASC;

-- [Problem 7]
WITH support_assists AS (SELECT gamehash, COUNT(*) AS num_assists FROM 
        played NATURAL JOIN final_blows NATURAL JOIN assists
        WHERE role = 'Support' AND assisting_player = player_name
        AND (ypos > xpos) AND time_of_blow < TIME'00:15:00'
        GROUP BY gamehash),
	support_kills AS (SELECT gamehash, COUNT(*) AS num_kills FROM 
        final_blows NATURAL JOIN played
        WHERE role = 'Support' AND killing_player = player_name
        AND (ypos > xpos) AND time_of_blow < TIME'00:15:00'
        GROUP BY gamehash)
SELECT gamehash, (num_assists + num_kills) / 2 AS avg_top_participations
    FROM support_kills NATURAL JOIN support_assists;

-- [Problem 8]
DROP VIEW champion_stats;
CREATE VIEW champion_stats AS 
    WITH champion_chosen AS
            (SELECT champion, COUNT(*) AS num_chosen
            FROM played GROUP BY champion),
	     champion_kills AS
             (SELECT champion, COUNT(killed_player) AS num_kills
             FROM played NATURAL JOIN final_blows
             WHERE killing_player = player_name GROUP BY champion)
	SELECT champion, num_chosen, num_kills
        FROM champion_chosen NATURAL JOIN champion_kills ORDER BY champion;

-- [Problem 9]
DROP VIEW nalcs_gold_rates;
CREATE VIEW nalcs_gold_rates AS
    SELECT player_name, year, SUM(gold) / SUM(game_length) AS gold_per_min
        FROM played NATURAL JOIN matches
        WHERE league = 'NALCS'
        GROUP BY player_name, year
        ORDER BY year DESC, gold_per_min ASC;

-- [Problem 10]
SELECT year, player_name, gold_per_min FROM nalcs_gold_rates
    NATURAL JOIN (SELECT year, MAX(gold_per_min) AS max_gold_per_min
	FROM nalcs_gold_rates GROUP BY year) AS max_golds
    WHERE gold_per_min = max_gold_per_min
    ORDER BY year;

-- [Problem 11]
DELETE FROM matches 
    WHERE gamehash IN (SELECT gamehash FROM
	(SELECT * FROM matches NATURAL JOIN teams
    WHERE year = 2017 AND league = 'WC' AND team = 'SKT')
    AS skt_matches);
