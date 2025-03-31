-- Queries


-- 1. In the first 100 plays, who had the most receptions?
Select 
p.Player_Name,
COUNT(Receiver_ID) as Receptions
FROM PLAYER p 
JOIN RECEIVER r on r.Player_ID = p.Player_ID
GROUP BY p.Player_Name
ORDER BY Receptions DESC
LIMIT 1;

-- 2. Which player had the most TD passes in the first 100 plays
SELECT 
p.Player_Name,
t.Team_Name,
COUNT(p2.Passer_ID) as Touchdown_Passes
FROM PLAYER p 
JOIN PASSER p2 on p2.Player_ID = p.Player_ID
JOIN PLAY p3 on p3.Play_ID = p2.Play_ID
JOIN DRIVE d on d.Drive_ID = p3.Drive_ID
JOIN TEAM t on t.Team_ID = d.PosTeam_ID
WHERE p3.Score_Result = 'Touchdown'
GROUP BY p.Player_Name, t.Team_Name
LIMIT 1;

-- 3. How many plays ended with 2 Tacklers recorded?
Select COUNT(DISTINCT t.play_ID)
FROM TACKLER t 
JOIN TACKLER t2 on t.Play_ID  = t2.Play_ID 
	AND t.Tackler_ID <> t2.Tackler_ID
JOIN PLAYER p on p.Player_ID = t.Player_ID;

-- 4. Which team gained the most yards on offense?

Select
t.Team_Name,
SUM(p.Yards_Gain) AS Total_Yards
FROM PLAY p 
JOIN DRIVE d ON d.Drive_ID = p.Drive_ID
JOIN TEAM t ON d.PosTeam_ID = t.Team_ID
GROUP BY t.Team_Name
ORDER BY SUM(p.Yards_Gain) DESC
LIMIT 1;

-- 5. Which team had the better performance in terms of pushing back the offense?
Select
t.Team_Name AS Defense,
SUM(p.Yards_Gain) AS 'Yards Lost By Offense'
FROM PLAY p 
JOIN DRIVE d on d.Drive_ID = p.Drive_ID
JOIN TEAM t on t.Team_ID = d.DefTeam_ID
WHERE Yards_Gain < 0
GROUP BY Defense 
ORDER BY SUM(p.Yards_Gain) ASC
LIMIT 1;
