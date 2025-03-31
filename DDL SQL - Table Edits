SELECT *
FROM NFLPlaybyPlay2015Load npl ;

-- CLEANING

UPDATE NFLPlaybyPlay2015Load
SET posteam = NULL
WHERE posteam = '';

UPDATE NFLPlaybyPlay2015Load
SET DefensiveTeam = NULL
WHERE DefensiveTeam  = '';

UPDATE NFLPlaybyPlay2015Load
SET Passer  = NULL
WHERE  Passer = '';

UPDATE NFLPlaybyPlay2015Load
SET  Rusher = NULL
WHERE  Rusher = '';

UPDATE NFLPlaybyPlay2015Load
SET Receiver = NULL
WHERE Receiver  = '';

UPDATE NFLPlaybyPlay2015Load
SET Tackler1 = NULL
WHERE  Tackler1 = '';

UPDATE NFLPlaybyPlay2015Load
SET Tackler2 = NULL
WHERE  Tackler2 = '';

UPDATE NFLPlaybyPlay2015Load
SET PelizedTeam = NULL
WHERE  PelizedTeam  = '';

UPDATE NFLPlaybyPlay2015Load
SET PeltyType = NULL
WHERE  PeltyType  = '';

UPDATE NFLPlaybyPlay2015Load
SET PelizedPlayer = NULL
WHERE  PelizedPlayer  = '';

UPDATE NFLPlaybyPlay2015Load
SET FirstDown = 0
WHERE FirstDown IS NULL;

-- Modify Game_Date to be a Date field

Select npl.Game_Date, CONVERT(npl.Game_Date,DATE)
FROM NFLPlaybyPlay2015Load npl;

ALTER TABLE NFLPlaybyPlay2015Load 
MODIFY COLUMN Game_Date DATE;

-- Modify First Down to be "boolean" tinyint(1)

ALTER TABLE NFLPlaybyPlay2015Load
MODIFY COLUMN FirstDown TINYINT(1);

-- Modify Touchdown to be tinyint(1)

ALTER TABLE NFLPlaybyPlay2015Load
MODIFY COLUMN Touchdown TINYINT(1);

-- Field goal result to tinyint(1)

ALTER TABLE NFLPlaybyPlay2015Load
MODIFY COLUMN FieldGoalResult TINYINT(1);

-- Get TeamID in import table

ALTER TABLE NFLPlaybyPlay2015Load 
ADD COLUMN posteam_ID INT NULL,
ADD COLUMN Def_Team_ID INT NULL;

UPDATE NFLPlaybyPlay2015Load npl 
JOIN TEAM T1 on npl.posteam = T1.Team_Name
SET npl.posteam_ID = T1.Team_ID;

UPDATE NFLPlaybyPlay2015Load npl 
JOIN TEAM T2 on npl.DefensiveTeam = T2.Team_Name
SET npl.Def_Team_ID = T2.Team_ID;

-- Allow to be null for quarter end play records
ALTER TABLE DRIVE 
MODIFY COLUMN PosTeam_ID INT NULL,
MODIFY COLUMN DefTeam_ID INT NULL;

-- Add DriveID to import table

ALTER TABLE NFLPlaybyPlay2015Load 
ADD COLUMN Drive_ID INT NULL;


UPDATE NFLPlaybyPlay2015Load npl
LEFT JOIN DRIVE d
    ON npl.qtr = d.Game_Quarter
    AND npl.Drive = d.Drive_Number
    AND (npl.posteam_ID = d.PosTeam_ID OR (npl.posteam_ID IS NULL AND d.PosTeam_ID IS NULL))
    AND (npl.Def_Team_ID = d.DefTeam_ID OR (npl.Def_Team_ID IS NULL AND d.DefTeam_ID IS NULL))
SET npl.Drive_ID = d.Drive_ID;

-- Add PlayTypeID to import table
ALTER TABLE NFLPlaybyPlay2015Load 
ADD COLUMN Play_Type_ID INT NULL;

UPDATE NFLPlaybyPlay2015Load npl 
JOIN PLAYTYPE p on p.Play_Type = npl.PlayType
SET npl.Play_Type_ID = p.Play_Type_ID;

-- Adjust DOWN table
ALTER TABLE PLAY 
MODIFY COLUMN DOWN INT NULL;

-- Drop PLAY NUMBER from PLAY. Too complicated, and not in my OG dataset
ALTER TABLE PLAY
DROP COLUMN Play_Number;

-- Fix PLAY/PLAYTYPE constraint

ALTER TABLE PLAY
DROP FOREIGN KEY FK_PLAYTYPE_PLAYTYPE_ID;

ALTER TABLE PLAY
DROP INDEX UNIQUE_Play_Type_ID;

ALTER TABLE PLAY
ADD CONSTRAINT FK_PLAYTYPE_PLAYTYPE_ID
FOREIGN KEY (Play_Type_ID) REFERENCES PLAYTYPE(Play_Type_ID)
ON DELETE CASCADE
ON UPDATE CASCADE;

-- Fix Start Yardline
ALTER TABLE PLAY 
MODIFY COLUMN Start_Yard_Line INT NULL;

-- allow for null penalty types due to data issue
ALTER TABLE PENALTIES
MODIFY COLUMN Penalty_Type VARCHAR(50) NULL;

-- Allow for null reciever player ID's for instances of interceptions
ALTER TABLE RECEIVER 
MODIFY COLUMN Player_ID INT NULL;

-- Creating the view
CREATE VIEW vw_ALL AS
SELECT *
FROM NFLPlaybyPlay2015Load;

