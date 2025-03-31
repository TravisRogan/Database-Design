-- DML STATEMENTS

SELECT *
FROM NFLPlaybyPlay2015Load npl ;

-- GAME

INSERT INTO GAME 
(Game_Date, Season)
SELECT DISTINCT npl.Game_Date, npl.Season FROM NFLPlaybyPlay2015Load npl;

-- TEAM

INSERT INTO TEAM
(TEAM_NAME)
SELECT DISTINCT npl.posteam FROM NFLPlaybyPlay2015Load npl;


-- Play Type

INSERT INTO PLAYTYPE
(Play_Type)
SELECT DISTINCT npl.PlayType FROM NFLPlaybyPlay2015Load npl;


-- Player

INSERT INTO PLAYER (Player_Name)
SELECT DISTINCT Passer FROM NFLPlaybyPlay2015Load WHERE Passer IS NOT NULL
UNION
SELECT DISTINCT PelizedPlayer FROM NFLPlaybyPlay2015Load WHERE PelizedPlayer IS NOT NULL
UNION
SELECT DISTINCT Receiver FROM NFLPlaybyPlay2015Load WHERE Receiver IS NOT NULL
UNION
SELECT DISTINCT Rusher FROM NFLPlaybyPlay2015Load WHERE Rusher IS NOT NULL
UNION
SELECT DISTINCT Tackler1 FROM NFLPlaybyPlay2015Load WHERE Tackler1 IS NOT NULL
UNION
SELECT DISTINCT Tackler2 FROM NFLPlaybyPlay2015Load WHERE Tackler2 IS NOT NULL;

-- Drive

INSERT INTO DRIVE (Game_ID, Game_Quarter, Drive_Number, PosTeam_ID, DefTeam_ID)
SELECT DISTINCT
    g.Game_ID, 
    npl.qtr, 
    npl.Drive,
    npl.posteam_ID,
    npl.Def_Team_ID
FROM NFLPlaybyPlay2015Load npl
JOIN GAME g on g.Game_Date = npl.Game_Date;


-- Play

INSERT INTO PLAY (Drive_ID, Play_Type_ID, Down, Play_Time, Start_Yard_Line, Yards_Gain, First_Down, Score_Result)
SELECT 
    npl.Drive_ID,
    npl.Play_Type_ID,
    npl.Down,
    npl.`time`,
    npl.yrdln,
    npl.Yards_Gained,
    npl.FirstDown,
    CASE 
        WHEN npl.Touchdown = 1 THEN 'Touchdown' 
        WHEN npl.FieldGoalResult = 1 THEN 'Field_Goal'  
        ELSE NULL  
    END AS Score_Result
FROM NFLPlaybyPlay2015Load npl;

-- Penalites

INSERT INTO PENALTIES (Team_ID, Penalty_Type, Player_ID, Penalty_Yards, Play_ID)
SELECT
	t.Team_ID,
	npl.PeltyType,
	p.Player_ID,
	npl.PenaltyYards,
	p2.Play_ID
FROM NFLPlaybyPlay2015Load npl 
JOIN TEAM t on npl.PelizedTeam  = t.Team_Name 
JOIN PLAYER p on p.Player_Name = npl.PelizedPlayer 
LEFT JOIN PLAY p2 on p2.DOWN = npl.down
AND p2.Start_Yard_Line = npl.yrdln
AND p2.Play_Type_ID = npl.Play_Type_ID
AND p2.Drive_ID = npl.Drive_ID
WHERE npl.PelizedTeam IS NOT NULL
AND npl.PelizedPlayer IS NOT NULL

-- Passer

INSERT INTO PASSER (Play_ID, Player_ID)
SELECT 
    pl.Play_ID,
    p.Player_ID
FROM NFLPlaybyPlay2015Load npl
JOIN PLAY pl ON pl.Drive_ID = npl.Drive_ID
    AND pl.Play_Type_ID = npl.Play_Type_ID
    AND pl.Start_Yard_Line = npl.yrdln
    AND pl.Down = npl.down
    AND pl.First_Down = npl.FirstDown
LEFT JOIN PLAYER p ON p.Player_Name = npl.Passer
WHERE npl.PlayType = 'Pass';

-- Rusher

INSERT INTO RUSHER (Play_ID, Player_ID)
SELECT 
    pl.Play_ID,
    p.Player_ID
FROM NFLPlaybyPlay2015Load npl
JOIN PLAY pl ON pl.Drive_ID = npl.Drive_ID
    AND pl.Play_Type_ID = npl.Play_Type_ID
    AND pl.Start_Yard_Line = npl.yrdln
    AND pl.Down = npl.down
    AND pl.First_Down = npl.FirstDown
LEFT JOIN PLAYER p ON p.Player_Name = npl.Rusher
WHERE npl.PlayType = 'RUN';

-- Reciever

INSERT INTO RECEIVER (Play_ID, Player_ID)
SELECT 
    pl.Play_ID,
    p.Player_ID
FROM NFLPlaybyPlay2015Load npl
JOIN PLAY pl ON pl.Drive_ID = npl.Drive_ID
    AND pl.Play_Type_ID = npl.Play_Type_ID
    AND pl.Start_Yard_Line = npl.yrdln
    AND pl.Down = npl.down
    AND pl.First_Down = npl.FirstDown
LEFT JOIN PLAYER p ON p.Player_Name = npl.Receiver 
WHERE npl.PlayType = 'Pass';

-- Tackler UNION

INSERT INTO TACKLER (Play_ID, Player_ID)
SELECT 
    pl.Play_ID,
    p.Player_ID
FROM NFLPlaybyPlay2015Load npl
JOIN PLAY pl ON pl.Drive_ID = npl.Drive_ID
    AND pl.Play_Type_ID = npl.Play_Type_ID
    AND pl.Start_Yard_Line = npl.yrdln
    AND pl.Down = npl.down
    AND pl.First_Down = npl.FirstDown
LEFT JOIN PLAYER p ON p.Player_Name = npl.Tackler1
WHERE npl.Tackler1 IS NOT NULL
UNION
SELECT 
    pl.Play_ID,
    p.Player_ID
FROM NFLPlaybyPlay2015Load npl
JOIN PLAY pl ON pl.Drive_ID = npl.Drive_ID
    AND pl.Play_Type_ID = npl.Play_Type_ID
    AND pl.Start_Yard_Line = npl.yrdln
    AND pl.Down = npl.down
    AND pl.First_Down = npl.FirstDown
LEFT JOIN PLAYER p ON p.Player_Name = npl.Tackler2
WHERE npl.Tackler2 IS NOT NULL;
