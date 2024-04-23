USE DBMS_Website_Project;

DROP TABLE IF EXISTS band_singer;
DROP TABLE IF EXISTS band;
DROP TABLE IF EXISTS band_genre;
DROP TABLE IF EXISTS song_album;
DROP TABLE IF EXISTS song;
DROP TABLE IF EXISTS song_director;
DROP TABLE IF EXISTS song_producer;

CREATE TABLE song_producer 
(
    Producer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Producer_Name NVARCHAR(25) NOT NULL,
    Production_House NVARCHAR(25) NOT NULL,
    CONSTRAINT Producer_Name_UK UNIQUE (Producer_Name)
);

CREATE TABLE song_director 
(
    Director_ID INT AUTO_INCREMENT PRIMARY KEY,
    Director_Name NVARCHAR(25) NOT NULL,
    Awards NVARCHAR(25),
    Speciality NVARCHAR(20),
    CONSTRAINT Director_Name_UK UNIQUE (Director_Name)
);

CREATE TABLE song
(
    Song_ID INT AUTO_INCREMENT PRIMARY KEY,
    Song_Title NVARCHAR(25) NOT NULL,
    Album_ID INT NOT NULL,
    CONSTRAINT Song_name_UK UNIQUE (Song_Title)
);

CREATE TABLE song_album
(
    Album_ID INT AUTO_INCREMENT PRIMARY KEY,
    Album_Name NVARCHAR(15),
    ReleasingDate DATETIME NOT NULL,
    Song_ID INT NOT NULL,
    Director_ID INT NOT NULL,
    Producer_ID INT NOT NULL,
    CONSTRAINT Album_Name_UK UNIQUE (Album_Name),
    CONSTRAINT album__song_FK FOREIGN KEY (Song_ID) REFERENCES song (Song_ID),
    CONSTRAINT album__director_FK FOREIGN KEY (Director_ID) REFERENCES song_director (Director_ID),
    CONSTRAINT album__producer_FK FOREIGN KEY (Producer_ID) REFERENCES song_producer (Producer_ID)
);

CREATE TABLE band_genre
(
    Genre_ID INT AUTO_INCREMENT PRIMARY KEY,
    Genre_Name NVARCHAR(15) NOT NULL,
    CONSTRAINT Genre_Name_UK UNIQUE (Genre_Name)
);

CREATE TABLE band
(
    Band_ID INT AUTO_INCREMENT PRIMARY KEY,
    Band_Name NVARCHAR(15) NOT NULL,
    Genre_ID INT NOT NULL,
    Album_ID INT NOT NULL,
    CONSTRAINT band_Name_UK UNIQUE (Band_Name),
    CONSTRAINT album__band_FK FOREIGN KEY (Album_ID) REFERENCES song_album (Album_ID),
    CONSTRAINT album__genre_FK FOREIGN KEY (Genre_ID) REFERENCES band_genre (Genre_ID)
);

CREATE TABLE band_singer
(
    Singer_ID INT AUTO_INCREMENT PRIMARY KEY,
    Singer_Name NVARCHAR(20) NOT NULL,
    Awards NVARCHAR(25),
    Band_ID INT NOT NULL,
    CONSTRAINT band_singer_FK FOREIGN KEY (Band_ID) REFERENCES band (Band_ID)
);

INSERT INTO song_producer (Producer_Name, Production_House) VALUES
('Mahesh Bhatt', 'YRF Films'),
('Amritpal Singh', 'T-Series'),
('Jagdeep Singh', 'Qismat'),
('Karan Johar', 'Dharma Productions'),
('Ramesh Taurani', 'Tips Industries');

INSERT INTO song_director (Director_Name, Awards, Speciality) VALUES
('Deep Jandu', 'Royal Punjab', 'Cinema'),
('Gopy', 'Film Fair', 'Voice'),
('Neru Bajwa', 'Voice Of Punjab', 'Direction'),
('Rohit Shetty', 'Filmfare', 'Action'),
('Sanjay Leela Bhansali', 'National Film Award', 'Drama');

INSERT INTO song (Song_Title, Album_ID) VALUES
('Band Drwazze', 1),
('Udariyan', 2),
('Aroma', 3),
('Soulful Melody', 2),
('Eternal Love', 3);

INSERT INTO song_album (Album_Name, ReleasingDate, Song_ID, Director_ID, Producer_ID) VALUES
('Judaa 3', '2023-01-01', 1, 1, 1),
('Shayar', '2023-02-01', 2, 2, 2),
('The Last Ride', '2023-03-01', 3, 3, 3),
('Tum Hi Hoo', '2023-04-01', 4, 4, 4),
('Hasi', '2023-05-01', 5, 5, 5);

INSERT INTO band_genre (Genre_Name) VALUES
('Pop'),
('Classic'),
('Jazz'),
('Rock'),
('Electronic');

INSERT INTO band (Band_Name, Genre_ID, Album_ID) VALUES
('Amrinder_Band', 1, 1),
('Sartaj_Band', 2, 2),
('Sidhu_Band', 3, 3),
('Rockers', 4, 4),
('Electric Beats', 5, 5);

INSERT INTO band_singer (Singer_Name, Awards, Band_ID) VALUES
('Amrinder Gill', 'Melodious Voice Owner', 1),
('Satinder Sartaj', 'Shayar Saab', 2),
('Sidhu Moose Wala', 'Born To Shine', 3),
('Arijit Singh', 'Best Male Singer', 4),
('Shreya Ghoshal', 'Best Female Singer', 5);

SELECT * FROM song;
SELECT * FROM song_album;
SELECT * FROM band_genre;
SELECT * FROM band;
SELECT * FROM song_director;
SELECT * FROM song_producer;
SELECT * FROM band_singer;
