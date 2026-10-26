USE s109070

--2. Wyœwietl imiê, nazwisko i stanowisko pracowników oraz nazwê ich departamentu.
--Wynik ogranicz do osób, które urodzi³y siê po roku 1980.
SELECT 
    p.FirstName,
    p.LastName,
    e.JobTitle,
    d.Name AS DepartmentName
FROM Employee e
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID
JOIN EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
  AND YEAR(e.BirthDate) > 1980;


--3. ZnajdŸ nazwy departamentów, które maj¹ wiêcej ni¿ 10 pracowników.
SELECT 
    d.Name,
    COUNT(e.BusinessEntityID) AS EmployeeCount
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
JOIN Employee e
    ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name]
HAVING COUNT(e.BusinessEntityID) > 10;

--4. Wyœwietl nazwy departamentów, w których pracownicy pracuj¹ na 3 zmianie.
SELECT DISTINCT
    d.[Name] AS DepartmentName
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
WHERE edh.ShiftID = 3
  AND edh.EndDate IS NULL;


--5. Wyœwietl œredni wiek osób w ka¿dym z departamentów. Poka¿ nazwê
--departamentu i œredni wiek osób.
SELECT 
    d.Name AS DepartmentName,
    AVG(DATEDIFF(YEAR, e.BirthDate, GETDATE())) AS AverageAge
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
JOIN Employee e
    ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name];


--6. Wyœwietl nazwy departamentów, w których pracownicy byli zatrudnieni od roku
--2008.
SELECT DISTINCT    d.[Name] AS DepartmentName
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
WHERE YEAR(edh.StartDate) >= 2008;



--7. Wyœwietl nazwê departamentu oraz datê urodzenia najm³odszego i najstarszego
--pracownika.
SELECT 
    d.Name AS DepartmentName,
    MAX(e.BirthDate) AS YoungestBirthDate,
    MIN(e.BirthDate) AS OldestBirthDate
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
JOIN Employee e
    ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name];


--8. Wyœwietl, ile kobiet i mê¿czyzn pracuje w ka¿dym z dzia³ów i grup dzia³ów. Poka¿
--odpowiednie nazwy.

SELECT 
    d.GroupName,
    d.Name AS DepartmentName,
    SUM(CASE WHEN e.Gender = 'F' THEN 1 ELSE 0 END) AS Women,
    SUM(CASE WHEN e.Gender = 'M' THEN 1 ELSE 0 END) AS Men
FROM Department d
JOIN EmployeeDepartmentHistory edh
    ON d.DepartmentID = edh.DepartmentID
JOIN Employee e
    ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.GroupName, d.[Name]
ORDER BY d.GroupName, d.[Name];
