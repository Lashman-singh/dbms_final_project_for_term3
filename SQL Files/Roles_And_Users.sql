USE DBMS_Project;
GO

SELECT USER;
REVERT;

-- Drop users if they exist
DROP USER IF EXISTS ProducerUser;
DROP USER IF EXISTS DirectorUser;
DROP USER IF EXISTS SingerUser;

-- Drop roles if they exist
DROP ROLE IF EXISTS ProducerRole;
DROP ROLE IF EXISTS DirectorRole;
DROP ROLE IF EXISTS SingerRole;

-- Drop logins if they exist
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'ProducerUser')
    DROP LOGIN ProducerUser;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'DirectorUser')
    DROP LOGIN DirectorUser;
IF EXISTS (SELECT 1 FROM sys.server_principals WHERE name = 'SingerUser')
    DROP LOGIN SingerUser;

-- Create roles
CREATE ROLE ProducerRole;
CREATE ROLE DirectorRole;
CREATE ROLE SingerRole;

-- Create users
CREATE LOGIN ProducerUser WITH PASSWORD = 'lashmansingh', DEFAULT_DATABASE = DBMS_Project, CHECK_POLICY = OFF;
CREATE USER ProducerUser FOR LOGIN ProducerUser WITH DEFAULT_SCHEMA = DBMS_Project;

CREATE LOGIN DirectorUser WITH PASSWORD = 'lashmansingh', DEFAULT_DATABASE = DBMS_Project, CHECK_POLICY = OFF;
CREATE USER DirectorUser FOR LOGIN DirectorUser WITH DEFAULT_SCHEMA = DBMS_Project;

CREATE LOGIN SingerUser WITH PASSWORD = 'lashmansingh', DEFAULT_DATABASE = DBMS_Project, CHECK_POLICY = OFF;
CREATE USER SingerUser FOR LOGIN SingerUser WITH DEFAULT_SCHEMA = DBMS_Project;

-- Assign users to roles
ALTER ROLE ProducerRole ADD MEMBER ProducerUser;
ALTER ROLE DirectorRole ADD MEMBER DirectorUser;
ALTER ROLE SingerRole ADD MEMBER SingerUser;

-- Grant permissions to ProducerRole
GRANT SELECT ON dbo.song_producer TO ProducerRole;
GRANT SELECT ON dbo.song_album TO ProducerRole;

-- Grant permissions to DirectorRole
GRANT SELECT ON dbo.song_director TO DirectorRole;
GRANT SELECT ON dbo.song_album TO DirectorRole;
GRANT SELECT ON dbo.band TO DirectorRole;

-- Grant permissions to SingerRole
GRANT SELECT ON dbo.band_singer TO SingerRole;

------------------------------------

-- ProducerUser interaction
EXECUTE AS USER = 'ProducerUser';
SELECT USER;

-- Producer queries
SELECT * FROM song_producer; -- Allowed
SELECT * FROM song_album; -- Allowed

-- Attempt to access other tables
 SELECT * FROM song_director; -- Not allowed
 SELECT * FROM band; -- Not allowed

REVERT;

-- DirectorUser interaction
EXECUTE AS USER = 'DirectorUser';
SELECT USER;

-- Director queries
SELECT * FROM song_director; -- Allowed
SELECT * FROM song_album; -- Allowed
SELECT * FROM band; -- Allowed

REVERT;

-- Attempt to access other tables
-- SELECT * FROM song_producer; -- Not allowed

SELECT USER;
REVERT;

-- SingerUser interaction
EXECUTE AS USER = 'SingerUser';
SELECT USER;

-- Singer queries
SELECT * FROM band_singer; -- Allowed

-- Attempt to access other tables
-- SELECT * FROM band; -- Not allowed

REVERT;
SELECT USER;
