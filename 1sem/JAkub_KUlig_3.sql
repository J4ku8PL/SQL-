--1. PrzejdŸ do swojego schematu bazy danych
USE s109070

--2. Wyœwietl listê wartoœci w atrybucie p³eæ w tabeli Employee.
SELECT DISTINCT e.Gender
FROM Employee e

--3. Wyœwietl listê stanowisk dla osób bêd¹cych mê¿czyznami.
SELECT DISTINCT e.JobTitle
FROM Employee e
WHERE e.Gender='M'

--4. Wyœwietl listê stanowisk dla osób bêd¹cych kobietami. Wynik posortuj od A do Z wed³ug nazwy stanowiska.
SELECT DISTINCT e.JobTitle
FROM Employee e
WHERE e.Gender='F'
ORDER BY e.JobTitle ASC

--5. Poka¿ login, stanowisko pracy, datê urodzenia osób urodzonych w latach 80-tych.
SELECT e.LoginID, e.JobTitle, e.BirthDate
FROM Employee e
WHERE BirthDate BETWEEN '1980-01-01' AND '1989-12-31'
ORDER BY BirthDate ASC
--6. Wyœwietl datê urodzenia kobiet urodzonych w latach 90-tych. Wynik posortuj malej¹co wg daty urodzenia.
SELECT e.BirthDate
FROM Employee e
WHERE (BirthDate BETWEEN '1990-01-01' AND '1999-12-31') AND (e.Gender='F')
ORDER BY BirthDate DESC

--7. Wyœwietl tytu³, imiê i nazwisko osób, które maj¹ tytu³. [tabela Person]
SELECT p.Title, p.FirstName, p.LastName
FROM Person p
WHERE p.Title IS NOT NULL

--8. Wyœwietl login tych pracowników, u których login koñczy siê na cyfrê 5.
SELECT e.LoginID
FROM Employee e
WHERE e.LoginID LIKE '%5'

--9. Wyœwietl login tych pracowników, u których login zawiera literê „i”.
SELECT e.LoginID
FROM Employee e
WHERE e.LoginID LIKE '%i%'

--10. Wyœwietl nazwisko osób, u których nazwisko rozpoczyna siê na sylabê „Ke”. (tabela Person)
SELECT p.LastName
FROM Person p
WHERE p.LastName LIKE 'Ke%'

--11. Wyœwietl nazwisko osób, u których druga litera w nazwisku to „w”. (tabela Person)
SELECT p.LastName
FROM Person p
WHERE p.LastName LIKE '_w%'

--12. Wyœwietl imiona osób, u których imiê posiada literê „r” jako przed ostatni¹. (tabela Person)
SELECT p.FirstName
FROM Person p
WHERE p.FirstName LIKE '%r_'

--13. Wyœwietl pracowników, którzy w organizacji s¹ przypisani do poziomu 2 i 3.
SELECT e.OrganizationLevel
FROM Employee e
WHERE OrganizationLevel in (2,3)

--14. Wyœwietl pracowników, którzy nie maj¹ zdefiniowanego przypisania do poziomu w organizacji
SELECT e.OrganizationLevel
FROM Employee e
WHERE OrganizationLevel is Null

--15. Poka¿ listê stanowisk pracy, które maj¹ w stanowisku tekst „Engineer”.
SELECT e.JobTitle
FROM Employee e
WHERE e.JobTitle LIKE '%Engineer%'

--16. Poka¿ listê stanowisk pracy, których nazwa koñczy siê na „Engineer”
SELECT e.JobTitle
FROM Employee e
WHERE e.JobTitle LIKE '%Engineer'

--17. Poka¿ listê stanowisk pracy, który zawieraj¹ s³owo „and”
SELECT e.JobTitle
FROM Employee e
WHERE e.JobTitle LIKE '%and%'

--18. Wyœwietl osoby (tabela Person), których dane by³y modyfikowane ostatni raz w roku 2007.
SELECT p.ModifiedDate
FROM Person p 
WHERE (ModifiedDate  >'2007') and (ModifiedDate < '2008')


--19. Wyœwietl osoby, których imiê ma 5 liter
SELECT p.FirstName
FROM Person p
WHERE FirstName like '_____'

--20. Wyœwietl osoby, których nazwisko ma 5 liter i zawiera sylabê „ma”.
SELECT p.LastName
FROM Person p
WHERE LastName LIKE '_____' AND LastName LIKE '%ma%'

--21. Wyœwietl wszystkie informacje o osobach, które nie maja drugiego imienia.
SELECT p.MiddleName
FROM Person p
WHERE MiddleName is NULL

--22. Poka¿ login pracowników urodzonych w roku 70, którzy pracuj¹ na stanowisku „Janitor”
SELECT e.LoginID
FROM Employee e
Where e.BirthDate BETWEEN '01-01-1970' AND '31-12-1970'
AND e.JobTitle like 'Janitor'

--23. Poka¿ login pracowników urodzonych w roku 1970 lub w roku 1980, którzy pracuj¹ na stanowisku „Janitor”
SELECT e.LoginID
FROM Employee e
Where (e.BirthDate BETWEEN '01-01-1970' AND '31-12-1970') 
or (e.BirthDate BETWEEN'01-01-1980' AND '31-12-1980')
AND e.JobTitle like 'Janitor'

--24. Wyœwietl pracowników o tytule „Design Engineer”
SELECT e.JobTitle
FROM Employee e
WHERE JobTitle LIkE 'Design Engineer'

--25. Wyœwietl pracowników (Employee), którzy MaritalStatus maj¹ wartoœæ NULL
SELECT e.MaritalStatus
FROM Employee e 
WHERE MaritalStatus is NULL

--26. Wyœwietl LoginID dla których BusinessEntityID s¹ parzyste.
SELECT e.LoginID
FROM Employee e
WHERE BusinessEntityID % 2 = 0

--27. Wyœwietl kobiety zamê¿ne (F i M).
SELECT *
FROM Employee e
WHERE e.Gender ='F' AND e.MaritalStatus='M'

--28. Sformatuj datê zatrudnienia w formacie 'dd-MM-yyyy'.
SELECT 
    FORMAT(HireDate, 'dd-MM-yyyy') AS data_zatrudnienia_sformatowana
FROM Employee;
--29. Posortuj pracowników wg daty zatrudnienia malej¹co.
SELECT *
FROM Employee e 
ORDER BY HireDate DESC;

--30. Posortuj pracowników wg p³ci i daty urodzenia.
SELECT *
FROM Employee e
ORDER BY Gender ASC, BirthDate ASC;

--31. Wyœwietl dwóch najstarszych pracowników.
SELECT TOP 2*
FROM Employee e
ORDER BY BirthDate ASC;

--32. Wyœwietl 5 pierwszych pracowników z pominiêciem pierwszych 3
SELECT *
FROM Employee e 
ORDER BY LoginID
LIMIT 5 OFFSET 3;

--33. Wyœwietl zmiany (tabela Shift) z godzin¹ rozpoczêcia mniejsz¹ ni¿ 9:00.
SELECT ShiftID
FROM Shift s 
WHERE StartTime  > '9:00'

--34. Wyœwietl osoby pracuj¹ce aktualnie (EndDate jest NULL).
SELECT BusinessEntityID
FROM EmployeeDepartmentHistory 
WHERE EndDate is NULL 
--35. Wyœwietl pracowników o nazwisku zaczynaj¹cym siê na literê „A”
SELECT p.BusinessEntityID
FROM Person p
WHERE LastName LIKE 'A%'
--36. Wyœwietl pracowników zatrudnionych dok³adnie 1 stycznia 2005
SELECT e.BusinessEntityID
FROM Employee 
WHERE HireDate IS '01.01.2005';

--37. Wyœwietl pracowników urodzonych przed rokiem 1970
SELECT e.BusinessEntityID
FROM Employee e 
WHERE BirthDate < '01.01.1970'
--38. Wyœwietl pracowników o p³ci mêskiej i stanie cywilnym „¿onaty/zamê¿na”
SELECT *
FROM Employee e
WHERE e.Gender ='M' AND e.MaritalStatus='F'
--39. Wyœwietl pracowników urodzonych pomiêdzy 1975 a 1985 rokiem
SELECT *
FROM Employee e
WHERE e.BirthDate BETWEEN  '01.01.1975' AND '01.01.1985'