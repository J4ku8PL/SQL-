USE s109070

SELECT     LOWER(LEFT(p.FirstName, 1) + '.' + p.LastName + '@aw.com') AS Email
FROM Person p
WHERE p.EmailPromotion = 1;


SELECT DISTINCT LOWER(SUBSTRING(e.LoginID, CHARINDEX('\', e.LoginID) + 1, 6)) AS Login
FROM Employee e
WHERE e.LoginID IS NOT NULL;

--Wyœwietl listê loginów w postaci:
--Poka¿ tylko osoby, których nazwisko koñczy siê na „ski” lub „son”.
--Kolumna wynikowa ma mieæ alias Login.
--Tabela Person, alias per.

SELECT 
    LOWER(LEFT(per.FirstName, 1) + '.' + per.LastName) AS Login
FROM Person  per
WHERE per.LastName LIKE '%ski'
   OR per.LastName LIKE '%son';

SELECT TOP 12
    e.LoginID, UPPER(e.JobTitle) AS JobTitleUpper,
    LEN(e.JobTitle) AS TitleLength
FROM Employee e
ORDER BY LoginID ASC;

SELECT TOP 5
    emp.LoginID AS Login,
    emp.HireDate AS Data,
    FORMAT(HireDate, 'yyyy-MM-dd') AS DataFormat
FROM Employee emp
ORDER BY emp.HireDate ASC;