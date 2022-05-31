DROP DATABASE IF EXISTS privatetutors
BEGIN
    CREATE DATABASE privatetutors
END
GO
--DATABASE USE--
USE privatetutors
GO
--TABLE CREATE--
--TABLE CREATE--
 CREATE TABLE locations
 (
	Locationid INT PRIMARY KEY,
	Locationname NVARCHAR(100)NOT NULL
 )
GO
CREATE TABLE classlevels
 (
	Levelid INT PRIMARY KEY,
	[level] NVARCHAR(30)NOT NULL
 )
GO
CREATE TABLE tutors 
(
	Tutorid INT PRIMARY KEY,
	Tutorname NVARCHAR(35) NOT NULL,
	PrimaryContat INT NOT NULL,
	SecondaryContact INT NULL,
	Email NVARCHAR(100) NULL,
	PreferredLevel INT  NOT NULL REFERENCES classlevels(Levelid)
)
GO
CREATE TABLE tutorlocations
(
	Tutorid INT NOT NULL REFERENCES tutors(Tutorid),
	Locationid INT NOT NULL REFERENCES Locations(Locationid),
	PRIMARY KEY(Tutorid, Locationid)
)
GO
SELECT * FROM tutorlocations
GO
CREATE TABLE subjects
 (
	Subjectid INT PRIMARY KEY,
	Subjectname NVARCHAR(80) NOT NULL
 )
GO
CREATE TABLE tutorsubjects
(
	Tutorid INT NOT NULL REFERENCES tutors(Tutorid),
	Subjectid INT NOT NULL REFERENCES subjects(Subjectid),
	PRIMARY KEY(Tutorid, Subjectid)
)
GO
CREATE TABLE subjectlimits
(
	Subjectid INT NOT NULL REFERENCES subjects(Subjectid) ,
	Limit INT NOT NULL DEFAULT 3
)
GO
 ---procedures---
CREATE PROC InstLocations @Ln NVARCHAR(100),
							@Lid INT OUTPUT
AS
SELECT @Lid = ISNULL(MAX(Locationid), 0) +1 FROM Locations
BEGIN TRY
	
	INSERT INTO Locations VALUES(@Lid, @Ln)
	
END TRY
BEGIN CATCH
	;
	THROW 50001,'Insert failed', 1
	RETURN
END CATCH
GO
CREATE PROC UpdateLocation @Lid INT,
					@Ln NVARCHAR(100) 

AS
BEGIN TRY
	UPDATE Locations SET Locationname=@Ln
	WHERE Locationid = @Lid
	
END TRY
BEGIN CATCH
	;
	THROW 50002, 'Update failed',  1
	
END CATCH
GO

CREATE PROC deleteLocation @Lid INT					
AS
BEGIN TRY
	DELETE Locations
	WHERE Locationid = @Lid
	
END TRY
BEGIN CATCH
	;
	THROW 50003, 'DELETE Failed',  1
	
END CATCH
GO

CREATE PROC InstClassLevel @L NVARCHAR(30),
							@Lvid INT 
AS
BEGIN TRY
	
	INSERT INTO ClassLevels VALUES(@Lvid, @L)
	
END TRY
BEGIN CATCH
	;
	THROW 50002,'Insert failed', 1
	RETURN
END CATCH
GO
select * from ClassLevels
go
CREATE PROC UpdateClassLevel @Lvid INT,
					@L NVARCHAR(30) 

AS
BEGIN TRY
	UPDATE ClassLevels SET [level]=@L
	WHERE Levelid = @Lvid
	
END TRY
BEGIN CATCH
	;
	THROW 50002, 'Update failed',  1
	
END CATCH
GO
CREATE PROC deleteClassLevel @Lvid INT					
AS
BEGIN TRY
	DELETE ClassLevels
	WHERE Levelid = @Lvid
	
END TRY
BEGIN CATCH
	;
	THROW 50003, 'DELETE Failed',  1
	
END CATCH
GO
CREATE PROC InstTutor @Ln NVARCHAR(35),
					@PC INT ,
					@SC INT ,
					@E NVARCHAR(100),
					@PL INT ,
					@Tid INT OUTPUT
AS
SELECT @Tid = ISNULL(MAX(Tutorid), 0) +1 FROM tutors
BEGIN TRY
	
	INSERT INTO tutors VALUES(@Tid, @Ln, @PC, @SC, @E, @PL)
	
END TRY
BEGIN CATCH
	;
	THROW 50005,'Insert failed', 1
	RETURN
END CATCH
GO
CREATE PROC UpdatetTutor @Tid INT OUTPUT,
					@Tn NVARCHAR(35),
					@PC INT ,
					@SC INT ,
					@E NVARCHAR(100),
					@PL INT 
					
AS
BEGIN TRY
	UPDATE tutors SET Tutorid=@Tid, Tutorname=@Tn, 
					  PrimaryContat=@PC, SecondaryContact=@SC,
					  Email=@E, PreferredLevel=@PL
	WHERE Tutorid=@Tid
END TRY
BEGIN CATCH
	;
	THROW 50006,'Update failed', 1
	RETURN
END CATCH
GO
CREATE PROC DeleteTutor @Tid INT					
AS
BEGIN TRY
	DELETE tutors
	WHERE Tutorid = @Tid
	
END TRY
BEGIN CATCH
	;
	THROW 50009, 'DELETE Failed',  1
	
END CATCH
GO
CREATE PROC Insttutorlocations @Tid INT,
							  @Lid INT
AS
BEGIN TRY
	
	INSERT INTO tutorlocations VALUES(@Tid, @Lid)
	
END TRY
BEGIN CATCH
	;
	THROW 500012,'Insert failed', 1
	RETURN
END CATCH
GO
CREATE PROC Updatetutorlocations @Tid INT,
							@Lid INT 
AS
BEGIN TRY
	UPDATE tutorlocations SET Locationid=@Lid
	WHERE Tutorid = @Tid
	
END TRY
BEGIN CATCH
	;
	THROW 50010, 'Update failed',  1
	
END CATCH
GO
CREATE PROC deletetutorlocations @Tid INT					
AS
BEGIN TRY
	DELETE tutorlocations
	WHERE Tutorid = @Tid
	
END TRY
BEGIN CATCH
	;
	THROW 50013, 'Delete Failed',  1
	
END CATCH
GO
CREATE PROC Instsubjects @sid INT, @sn NVARCHAR(80)
AS
BEGIN TRY
	INSERT INTO subjects VALUES (@sid, @sn)
END TRY
BEGIN CATCH 
	;
	THROW 50009, '@message1', 1
END CATCH 
GO
CREATE PROC Updatesubjects @sid INT, @sn NVARCHAR(80)
AS
BEGIN TRY
	UPDATE subjects SET Subjectname=@sn
	WHERE Subjectid= @sid
END TRY
BEGIN CATCH 
	;
	THROW 50014, '@message1', 1
END CATCH 
GO
CREATE PROC deletesubjects @sid INT 
AS
BEGIN TRY
	DELETE subjects 
	WHERE Subjectid=@sid
END TRY	
BEGIN CATCH
	;
	THROW 50013, 'Delete Failed',  1
	
END CATCH
GO
CREATE PROC Insttutorsubjects @Tid INT, @Sid INT
AS
BEGIN TRY
	INSERT INTO tutorsubjects VALUES (@Tid, @Sid)
END TRY
BEGIN CATCH
	;
	THROW 50015, '@message', 1

END CATCH
GO
CREATE PROC Updatetutorsubjects @Tid INT, @sid INT
AS
BEGIN TRY 
	UPDATE tutorsubjects SET Subjectid=@sid
	WHERE Tutorid=@Tid
END TRY 
BEGIN CATCH
	;
	THROW 50018, '@MSG' ,1
END CATCH
GO
CREATE PROC deletetutorsubjects @Tid INT 
AS
BEGIN TRY
	DELETE tutorsubjects 
	WHERE Tutorid=@Tid
END TRY	
BEGIN CATCH
	;
	THROW 50015, 'Delete Failed',  1
	
END CATCH
GO
CREATE PROC Instsubjectlimits @Sid INT, @L INT = 3
AS
BEGIN TRY
	INSERT INTO subjectlimits VALUES (@Sid, @L)
END TRY
BEGIN CATCH
	;
	THROW 50015, '@message', 1

END CATCH
GO
CREATE PROC Updaresubjectlimits @Sid INT, @L INT
AS
BEGIN TRY
	UPDATE subjectlimits SET Limit= @L 
	WHERE Subjectid=@Sid
END TRY
BEGIN CATCH
	;
	THROW 50016, '@message', 1

END CATCH
GO
CREATE PROC deletesubjectlimits @Sid INT
AS
BEGIN TRY
	DELETE subjectlimits 
	WHERE Subjectid=@Sid
END TRY
BEGIN CATCH
	;
	THROW 50021, '@message', 1

END CATCH
GO
--view--
CREATE VIEW vtutors
AS
SELECT t.Tutorid,t.Tutorname, l.Locationname,s.Subjectname, cl.[level], sl.Limit
FROM tutors t
INNER JOIN tutorlocations tl ON tl.Tutorid=t.Tutorid
INNER JOIN Locations l ON tl.Locationid=l.Locationid
INNER JOIN tutorsubjects ts ON t.Tutorid=ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid=s.Subjectid
INNER JOIN subjectlimits sl ON s.Subjectid=sl.Subjectid
INNER JOIN ClassLevels cl ON t.Tutorid=cl.Levelid
GO
--UDF--
CREATE FUNCTION Functiontutor (@Tn NVARCHAR(35)) RETURNS INT
AS
BEGIN
DECLARE @T INT
	SELECT @T=COUNT(*) 
	FROM tutors
	WHERE Tutorname=@Tn
RETURN @T
END
GO
CREATE FUNCTION fnTutor() RETURNS TABLE
AS
RETURN (
	SELECT Tutorname,COUNT(*) AS 'Count'
	FROM tutors
	GROUP BY Tutorname
	
)
GO
--trigger
CREATE TRIGGER trInsertTutorSubject 
ON tutorsubjects
FOR INSERT
AS
BEGIN
	DECLARE @s_id INT, @t_id INT, @c INT, @l INT
	SELECT @s_id=Subjectid, @t_id = Tutorid FROM inserted 
	SELECT        COUNT(tutorsubjects.Subjectid)
					FROM            tutorsubjects INNER JOIN
											 subjectlimits ON tutorsubjects.Subjectid = subjectlimits.Subjectid
					GROUP BY tutorsubjects.Tutorid
					HAVING        (tutorsubjects.Tutorid = @t_id)
	SELECT        @l= Limit
	FROM            subjectlimits
	WHERE        (Subjectid = @s_id)
	IF @c > @l 
	BEGIN
		RAISERROR( 'Exceeds tutor limits', 11, 1)
		ROLLBACK TRAN
	END
END
GO