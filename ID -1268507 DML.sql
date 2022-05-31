---DML---
USE privatetutors
GO
DECLARE @newid INT
EXEC InstLocations 'MIRPUR', @newid OUTPUT
EXEC InstLocations 'DHANMONDI', @newid OUTPUT
EXEC InstLocations 'GULSHAN', @newid OUTPUT
EXEC InstLocations 'BANANI', @newid OUTPUT
EXEC InstLocations 'TAJGAO', @newid OUTPUT
EXEC InstLocations 'UTTARA', @newid OUTPUT
EXEC InstLocations 'RAMPURA', @newid OUTPUT
SELECT @newid
GO
GO
EXEC UpdateLocation 7,'MALIBAG'
GO 
EXEC deleteLocation 7
GO
EXEC InstClassLevel 'A-LEVEL', 1 
EXEC InstClassLevel  'HSC', 2
EXEC InstClassLevel  'SSC',3
EXEC InstClassLevel  'O-LEVEL', 4
GO
EXEC UpdateClassLevel 4,'JSC'
GO
EXEC deleteClassLevel 4
GO
DECLARE @newid INT
EXEC InstTutor 'Shizan Rehman', '01850054848', '01775004848', 'rehman@gmail.com' ,1, @newid OUTPUT
EXEC InstTutor 'Naser Babul', '01711386445', NULL, 'nasar@gmail.com', 2, @newid OUTPUT
EXEC InstTutor 'Jamal', '01985522221', '01778521211', NULL, 3, @newid OUTPUT
EXEC InstTutor 'Abul', '01785655522', '01854556582', NULL, 4, 4
SELECT @newid
GO
---Update procedure---
EXEC UpdatetTutor 4,'NIROB', 01795582271, NULL,NULL,4
GO
---Delete procedure---
EXEC DeleteTutor 4
GO
EXEC Insttutorlocations 1,1
EXEC Insttutorlocations 2,2
EXEC Insttutorlocations 3,3
EXEC Insttutorlocations 4,1
EXEC Insttutorlocations 3,4
GO
EXEC Updatetutorlocations 3, 2
GO
---Delete procedure---
EXEC deleteTutorLocations 4
---Insert procedure--- 
GO
EXEC InstSubjects 101, 'Mathematics'
EXEC InstSubjects 102, 'Physics'
EXEC InstSubjects 103, 'Chemistry'
EXEC InstSubjects 155, 'ENGLISH'
EXEC InstSubjects 156, 'Biology'
GO
EXEC UpdateSubjects 155,'ENGLISH-2'
GO
EXEC deleteSubjects 155
GO
EXEC InstTutorSubjects 1,101
EXEC InstTutorSubjects 2,102
EXEC InstTutorSubjects 3,103
EXEC InstTutorSubjects 4,103
GO
EXEC UpdateTutorSubjects 4,102
GO
EXEC deleteTutorSubjects 4
GO
EXEC InstSubjectLimits 101,3
EXEC InstSubjectLimits 102,2
EXEC InstSubjectLimits 103,2
EXEC InstSubjectLimits 121,1
GO
EXEC UpdareSubjectLimits 101, 1
GO
EXEC deleteSubjectLimits 121
GO
---Trigger[dbo].[Functiontutor]---
EXEC InstTutorSubjects 2,101
EXEC InstTutorSubjects 3,101
EXEC InstTutorSubjects 2,102
---Udf---
SELECT [dbo].[Functiontutor]('Sharif Ahmed')
GO
SELECT * FROM fnTutor()
---View---
SELECT * FROM vtutors 
GO
/*
 * --Queries added
 */
 --1 Join Inner 

SELECT t.Tutorname, lc.Locationname 'preferredlocation',  COALESCE (t.PrimaryContat, t.SecondaryContact) AS Contact, s.Subjectname
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GO
--2
-- specific loaction
SELECT t.Tutorname, lc.Locationname 'preferredlocation',  COALESCE (t.PrimaryContat, t.SecondaryContact) AS Contact, s.Subjectname
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
WHERE lc.Locationname ='Dhanmondi'
GO
--3
-- specific subject
SELECT t.Tutorname, lc.Locationname 'preferredlocation',  COALESCE (t.PrimaryContat, t.SecondaryContact) AS Contact, s.Subjectname
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
WHERE s.Subjectname ='Mathematics'
GO
--4 Left outer
SELECT  s.Subjectname, t.Tutorname, t.PrimaryContat, t.SecondaryContact, t.Email, t.PreferredLevel
FROM  tutors  t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid 
RIGHT OUTER JOIN subjects s ON ts.Subjectid = s.Subjectid
GO
--5 same with CTE
WITH tscte AS
(
SELECT s.Subjectid, ts.Tutorid, s.Subjectname
FROM tutorsubjects ts 
RIGHT OUTER JOIN subjects s ON ts.Subjectid = s.Subjectid
)
SELECT tscte.Subjectname, t.Tutorname, t.PrimaryContat, t.SecondaryContact, t.PreferredLevel
FROM tutors t
RIGHT OUTER JOIN tscte ON t.Tutorid = tscte.Tutorid
GO
--6 Left outer not matched only [No teachers yest for the subject]
SELECT  s.Subjectname, t.Tutorname, t.PrimaryContat, t.SecondaryContact, t.Email, t.PreferredLevel
FROM  tutors  t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid 
RIGHT OUTER JOIN subjects s ON ts.Subjectid = s.Subjectid
WHERE ts.Subjectid IS NULL
GO

--7 same with sub-query [No teachers yest for the subject]
SELECT  s.Subjectname, t.Tutorname, t.PrimaryContat, t.SecondaryContact, t.Email, t.PreferredLevel
FROM  tutors  t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid 
RIGHT OUTER JOIN subjects s ON ts.Subjectid = s.Subjectid
WHERE t.Tutorid NOT IN (SELECT Tutorid FROM tutorsubjects)
GO
--8 aggregate
--location wise
SELECT lc.Locationname, COUNT(*) 'tutorcount'
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GROUP BY lc.Locationname
GO
--subject wise
SELECT s.Subjectname, COUNT(*) 'tutorcount'
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GROUP BY s.Subjectname
GO
--9 aggregate + having
SELECT lc.Locationname, COUNT(*) 'tutorcount'
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GROUP BY lc.Locationname
HAVING lc.Locationname = 'Dhanmondi'
GO
SELECT s.Subjectname, COUNT(*) 'tutorcount'
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GROUP BY s.Subjectname
HAVING s.Subjectname = 'Mathematics'
GO
--10 window functions
SELECT lc.Locationname, COUNT(*)  OVER(ORDER BY lc.locationid) 'tutorcount',
ROW_NUMBER() OVER(ORDER BY lc.locationid) 'ROW #',
RANK() OVER(ORDER BY lc.locationid) 'RANK',
DENSE_RANK() OVER(ORDER BY lc.locationid) 'DENSE RANK',
NTILE(2) OVER(ORDER BY lc.locationid) 'NTILE 2'
FROM tutors t
INNER JOIN tutorsubjects ts ON t.Tutorid = ts.Tutorid
INNER JOIN subjects s ON ts.Subjectid = s.Subjectid
INNER JOIN classlevels l ON l.Levelid = t.PreferredLevel
INNER JOIN  tutorlocations tl ON t.Tutorid = t.Tutorid
INNER JOIN locations lc ON tl.Locationid =lc.Locationid
GO
--11 SELECt case
SELECT Tutorid, Tutorname, PrimaryContat, 
CASE
	WHEN SecondaryContact IS NULL THEN 'NA'
	ELSE CAST(SecondaryContact AS VARCHAR)
END AS 'SecondaryContact', 
CASE
	WHEN Email IS NULL THEN 'NA'
	ELSE Email
END AS 'Email'
, PreferredLevel
FROM tutors
GO
