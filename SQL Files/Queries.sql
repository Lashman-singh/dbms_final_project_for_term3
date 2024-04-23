USE DBMS_Project;
GO

-- INNER QUERY
SELECT 
    s.Song_ID,
    s.Song_Title,
    sa.Album_ID,
    sa.Album_Name,
    sa.ReleasingDate,
    sd.Director_ID,
    sd.Director_Name
FROM 
    song s
INNER JOIN 
    song_album sa ON s.Album_ID = sa.Album_ID
INNER JOIN 
    song_director sd ON sa.Director_ID = sd.Director_ID;


-- OUTER JOIN
SELECT 
    s.Song_Title,
    sa.Album_Name,
    sd.Director_Name,
    b.Band_Name
FROM 
    song s
FULL OUTER JOIN 
    song_album sa ON s.Album_ID = sa.Album_ID
FULL OUTER JOIN 
    song_director sd ON sa.Director_ID = sd.Director_ID
FULL OUTER JOIN 
    band b ON sa.Album_ID = b.Album_ID;

-- NON CORELATED QUERY
SELECT Album_Name
FROM song_album
WHERE ReleasingDate > (SELECT DATEFROMPARTS(2021, 12, 31));

-- CORRELATED QUERY
SELECT Singer_Name
FROM band_singer bs
WHERE bs.Band_ID IN (
    SELECT Band_ID
    FROM band
    WHERE Album_ID IN (
        SELECT Album_ID
        FROM song_album
        WHERE ReleasingDate > (SELECT DATEFROMPARTS(2022, 12, 31))
    )
);

--AGGREGATE DATA
SELECT COUNT(bs.Singer_ID) AS Singer_Count
FROM band_singer bs
WHERE bs.Band_ID IN (
    SELECT Band_ID
    FROM band
    WHERE Album_ID IN (
        SELECT Album_ID
        FROM song_album
        WHERE ReleasingDate > (SELECT DATEFROMPARTS(2022, 12, 31))
    )
);
