USE DBMS_Project;
GO

--DROP TABLE IF EXISTS band_singer;
--DROP TABLE IF EXISTS band;
--DROP TABLE IF EXISTS band_genre;
--DROP TABLE IF EXISTS song_album;
--DROP TABLE IF EXISTS song;
--DROP TABLE IF EXISTS song_director;
--DROP TABLE IF EXISTS song_producer;

-- Drop indexes
DROP INDEX IF EXISTS idx_director_name ON song_director;
DROP INDEX IF EXISTS idx_releasing_date ON song_album;
GO

--Drop trigger
DROP TRIGGER IF EXISTS CheckDirectorProducerExists;
GO

-- Drop views
DROP VIEW IF EXISTS latest_albums_view;
DROP VIEW IF EXISTS award_winning_directors_view;
GO

-- Drop function
DROP FUNCTION dbo.getAlbumCountByGenre;
GO

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS InsertAlbumWithTransaction;
GO

-- Create tables statements
CREATE TABLE song_producer 
(
    Producer_ID INT NOT NULL,
    Producer_Name NVARCHAR(25) NOT NULL,
    Production_House NVARCHAR(35) NOT NULL,
    CONSTRAINT song_producer_PK PRIMARY KEY (Producer_ID),
    CONSTRAINT Producer_Name_UK UNIQUE (Producer_Name)
);

CREATE TABLE song_director 
(
    Director_ID INT NOT NULL,
    Director_Name NVARCHAR(25) NOT NULL,
    Awards NVARCHAR(40),
    Speciality NVARCHAR(35),
    CONSTRAINT song_director_PK PRIMARY KEY (Director_ID),
    CONSTRAINT Director_Name_UK UNIQUE (Director_Name)
);

CREATE TABLE song
(
    Song_ID INT NOT NULL,
    Song_Title NVARCHAR(25) NOT NULL,
    Album_ID INT NOT NULL,
    CONSTRAINT Song_PK PRIMARY KEY (Song_ID),
    CONSTRAINT Song_name_UK UNIQUE (Song_Title)
);

CREATE TABLE song_album
(
    Album_ID INT NOT NULL,
    Album_Name NVARCHAR(25),
    ReleasingDate DATETIME NOT NULL,
    Song_ID INT NOT NULL,
    Director_ID INT NOT NULL,
    Producer_ID INT NOT NULL,
    CONSTRAINT Song_Album_PK PRIMARY KEY (Album_ID),
    CONSTRAINT Album_Name_UK UNIQUE (Album_Name),
    CONSTRAINT Sang_Album_FK FOREIGN KEY (Song_ID) REFERENCES song (Song_ID),
    CONSTRAINT Directed_Album_FK FOREIGN KEY (Director_ID) REFERENCES song_director (Director_ID),
    CONSTRAINT Produced_Album_FK FOREIGN KEY (Producer_ID) REFERENCES song_producer (Producer_ID)
);

CREATE TABLE band_genre
(
    Genre_ID INT NOT NULL,
    Genre_Name NVARCHAR(15) NOT NULL,
    CONSTRAINT band_genre_PK PRIMARY KEY(Genre_ID),
    CONSTRAINT Genre_Name_UK UNIQUE (Genre_Name)
);

CREATE TABLE band
(
    Band_ID INT NOT NULL,
    Band_Name NVARCHAR(25) NOT NULL,
    Genre_ID INT NOT NULL,
    Album_ID INT NOT NULL,
    CONSTRAINT band_PK PRIMARY KEY(Band_ID),
    CONSTRAINT band_Name_UK UNIQUE (Band_Name),
    CONSTRAINT sang_album_band_FK FOREIGN KEY (Album_ID) REFERENCES song_album (Album_ID),
    CONSTRAINT singing_band_genre_FK FOREIGN KEY (Genre_ID) REFERENCES band_genre (Genre_ID)
);

CREATE TABLE band_singer
(
    Singer_ID INT NOT NULL,
    Singer_Name NVARCHAR(20) NOT NULL,
    Awards NVARCHAR(40),
    Band_ID INT NOT NULL,
	CONSTRAINT band_singer_PK PRIMARY KEY(singer_ID),
    CONSTRAINT singing_band_singer_FK FOREIGN KEY (Band_ID) REFERENCES band (Band_ID)
);

INSERT INTO song_producer (Producer_ID, Producer_Name, Production_House) VALUES
(51, 'Mahesh Bhatt', 'YRF Films'),
(52, 'Amritpal Singh', 'T-Series'),
(53, 'Jagdeep Singh', 'Qismat'),
(54, 'Karan Johar', 'Dharma Productions'),
(55, 'Ramesh Taurani', 'Tips Industries');

INSERT INTO song_director (Director_ID, Director_Name, Awards, Speciality) VALUES
(61, 'Deep Jandu', 'Royal Punjab', 'Cinema'),
(62, 'Gopy', 'Film Fair', 'Voice'),
(63, 'Neru Bajwa', 'Voice Of Punjab', 'Direction'),
(64, 'Rohit Shetty', NULL, 'Action'),
(65, 'Sanjay Leela Bhansali', 'National Film Award', 'Drama');

INSERT INTO song (Song_ID, Song_Title, Album_ID) VALUES
(54, 'Band Drwazze', 1),
(55, 'Udariyan', 2),
(56, 'Aroma', 3),
(57, 'Soulful Melody', 2),
(58, 'Eternal Love', 3);

INSERT INTO song_album (Album_ID, Album_Name, ReleasingDate, Song_ID, Director_ID, Producer_ID) VALUES
(21, 'Judaa 3', '2023-01-01', 54, 61, 51),
(22, 'Shayar', '2023-02-01', 55, 62, 52),
(23, 'The Last Ride', '2023-03-01', 56, 63, 53),
(24, 'Tum Hi Hoo', '2023-04-01', 57, 64, 54),
(25, 'Hasi', '2023-05-01', 58, 65, 55);

INSERT INTO band_genre (Genre_ID, Genre_Name) VALUES
(11, 'Pop'),
(12, 'Classic'),
(13, 'Jazz'),
(14, 'Rock'),
(15, 'Electronic');

INSERT INTO band (Band_ID, Band_Name, Genre_ID, Album_ID) VALUES
(48, 'Amrinder_Band', 11, 21),
(49, 'Sartaj_Band', 12, 22),
(50, 'Sidhu_Band', 13, 23),
(51, 'Rockers', 14, 24),
(52, 'Electric Beats', 15, 25);

INSERT INTO band_singer (Singer_ID, Singer_Name, Awards, Band_ID) VALUES
(16, 'Amrinder Gill', 'Melodious Voice Owner', 48),
(17, 'Satinder Sartaj', 'Shayar Saab', 49),
(18, 'Sidhu Moose Wala', 'Born To Shine', 50),
(19, 'Arijit Singh', 'Best Male Singer', 51),
(20, 'Shreya Ghoshal', 'Best Female Singer', 52);

-- Create indexes
CREATE INDEX idx_director_name ON song_director(Director_Name);
CREATE INDEX idx_releasing_date ON song_album(ReleasingDate);
GO

-- Create trigger
CREATE OR ALTER TRIGGER CheckDirectorProducerExists
ON song_album
AFTER INSERT
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @DirectorID INT, @ProducerID INT;

    SELECT @DirectorID = i.Director_ID, @ProducerID = i.Producer_ID
    FROM inserted i
    LEFT JOIN song_director sd ON i.Director_ID = sd.Director_ID
    LEFT JOIN song_producer sp ON i.Producer_ID = sp.Producer_ID
    WHERE sd.Director_ID IS NULL OR sp.Producer_ID IS NULL;

    IF @DirectorID IS NOT NULL OR @ProducerID IS NOT NULL
    BEGIN
        RAISERROR ('Cannot insert album. Director or Producer does not exist.', 16, 1);
        ROLLBACK TRANSACTION;
    END
END;


-- Insert an album with valid director and producer
INSERT INTO song_album (Album_ID, Album_Name, ReleasingDate, Song_ID, Director_ID, Producer_ID) 
VALUES (26, 'Yarr Anmule', '2024-04-09', 54, 61, 51);

-- Attempt to insert an album with a director who doesn't exist
INSERT INTO song_album (Album_ID, Album_Name, ReleasingDate, Song_ID, Director_ID, Producer_ID) 
VALUES (27, 'Test', '2024-04-09', 54, 999, 51);

DELETE FROM song_album WHERE Album_ID = 26;
GO

--VIEWS
CREATE VIEW latest_albums_view AS
SELECT sa.Album_ID, sa.Album_Name, sa.ReleasingDate, sd.Director_Name, sp.Producer_Name
FROM song_album sa
JOIN song_director sd ON sa.Director_ID = sd.Director_ID
JOIN song_producer sp ON sa.Producer_ID = sp.Producer_ID
WHERE sa.ReleasingDate >= DATEADD(year, -1, GETDATE());
GO

--2
CREATE VIEW award_winning_directors_view AS
SELECT Director_ID, Director_Name, Awards, Speciality
FROM song_director
WHERE Awards IS NULL;
GO

--FUNCTION
CREATE FUNCTION dbo.getAlbumCountByGenre (@genreName NVARCHAR(15))
RETURNS INT
AS
BEGIN
    DECLARE @albumCount INT;
    SELECT @albumCount = COUNT(sa.Album_ID)
    FROM song_album sa
    JOIN band b ON sa.Album_ID = b.Album_ID
    JOIN band_genre bg ON b.Genre_ID = bg.Genre_ID
    WHERE bg.Genre_Name = @genreName;

    RETURN @albumCount;
END;
GO

-- Call the function to get the count of albums for the genre 'Rock'
DECLARE @rockAlbumCount INT;
SET @rockAlbumCount = dbo.getAlbumCountByGenre('Jazz');
SELECT @rockAlbumCount AS RockAlbumCount;
Go

-- Drop the stored procedure if it already exists
DROP PROCEDURE IF EXISTS InsertAlbumWithTransaction;
GO

-- Create the stored procedure
CREATE PROCEDURE InsertAlbumWithTransaction
(
    @Album_ID INT,
    @Album_Name NVARCHAR(25),
    @ReleasingDate DATETIME,
    @Song_ID INT,
    @Director_ID INT,
    @Producer_ID INT
)
AS
BEGIN
    SET NOCOUNT ON;
    
    BEGIN TRY
        BEGIN TRANSACTION; -- Start the transaction

        -- Insert into song_album table
        INSERT INTO song_album (Album_ID, Album_Name, ReleasingDate, Song_ID, Director_ID, Producer_ID)
        VALUES (@Album_ID, @Album_Name, @ReleasingDate, @Song_ID, @Director_ID, @Producer_ID);

        -- If insertion is successful, commit the transaction
        COMMIT TRANSACTION;
        PRINT 'Album inserted successfully.';
    END TRY
    BEGIN CATCH
        -- If an error occurs, rollback the transaction
        IF @@TRANCOUNT > 0
            ROLLBACK TRANSACTION;
        
        -- Raise an error message
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR('Error: %s', 16, 1, @ErrorMessage);
    END CATCH;
END;


-- Call the stored procedure to insert an album with valid data
EXEC InsertAlbumWithTransaction
    @Album_ID = 35,
    @Album_Name = 'New Album',
    @ReleasingDate = '2024-04-22',
    @Song_ID = 58,
    @Director_ID = 67,
    @Producer_ID = 56;

-- Attempt to insert an album with an invalid director ID to demonstrate rollback
EXEC InsertAlbumWithTransaction
    @Album_ID = 31,
    @Album_Name = 'Invalid Album',
    @ReleasingDate = '2024-04-22',
    @Song_ID = 58,
    @Director_ID = 999, -- Invalid Director ID
    @Producer_ID = 55;


-- Select statements
SELECT * FROM song;
SELECT * FROM song_album;
SELECT * FROM band_genre; 
SELECT * FROM band;
SELECT * FROM song_director;
SELECT * FROM song_producer;
SELECT * FROM band_singer;
