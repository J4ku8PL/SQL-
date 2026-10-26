USE s109070
--2. Wyœwietl imiê, nazwisko i stanowisko pracowników oraz nazwê ich departamentu.
--Wynik ogranicz do osób, które urodzi³y siê po roku 1980.
SELECT p.FirstName,p.LastName,e.JobTitle, d.[Name]
FROM Person p 
INNER JOIN Employee e
ON p.BusinessEntityID = e.BusinessEntityID
INNER JOIN EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN Department d
ON edh.DepartmentID = d.DepartmentID

--3. ZnajdŸ nazwy departamentów, które maj¹ wiêcej ni¿ 10 pracowników.
SELECT d.[Name], COUNT(edh.BusinessEntityID)
FROM Department d
INNER JOIN EmployeeDepartmentHistory edh
ON d.DepartmentID = edh.DepartmentID
GROUP BY d.[Name]
HAVING COUNT(edh.BusinessEntityID) > 10
--4. Wyœwietl nazwy departamentów, w których pracownicy pracuj¹ na 3 zmianie.
SELECT d.[Name]
FROM Department d
Inner JOIN EmployeeDepartmentHistory edh
ON d.DepartmentID = edh.DepartmentID
WHERE edh.ShiftID = 3
GROUP BY d.[Name]

--5. Wyœwietl œredni wiek osób w ka¿dym z departamentów. Poka¿ nazwê
--departamentu i œredni wiek osób.
SELECT d.[Name], AVG(DATEDIFF(YEAR,e.BirthDate,GETDATE())) as Œrednia_wieku
FROM Employee e
INNER JOIN EmployeeDepartmentHistory edh
ON e.BusinessEntityID = edh.BusinessEntityID
INNER JOIN Department d 
ON edh.DepartmentID = d.DepartmentID
GROUP BY d.[Name]

--6. Wyœwietl nazwy departamentów, w których pracownicy byli zatrudnieni od roku
--2008.
SELECT d.[Name]
FROM Department d
INNER JOIN EmployeeDepartmentHistory edh
ON d.DepartmentID = edh.DepartmentID
INNER JOIN Employee e
ON edh.BusinessEntityID = e.BusinessEntityID 
GROUP BY d.[Name]
HAVING e.HireDate BETWEEN '01-01-2008' AND '31-12-2008'; 

--7. Wyœwietl nazwê departamentu oraz datê urodzenia najm³odszego i najstarszego
--pracownika.
SELECT
    d.Name AS DepartmentName,
    MIN(e.BirthDate) AS Najstarszy,
    MAX(e.BirthDate) AS Najm³odszy
FROM Employee e
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID
JOIN EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name]
ORDER BY d.[Name];

--8. Wyœwietl, ile kobiet i mê¿czyzn pracuje w ka¿dym z dzia³ów i grup dzia³ów. Poka¿
--odpowiednie nazwy.
SELECT
    d.GroupName,
    d.[Name] AS DepartmentName,
    e.Gender,
    COUNT(*) AS EmployeeCount
FROM Employee e
JOIN EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
JOIN Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
GROUP BY
    d.GroupName,
    d.Name,
    e.Gender
ORDER BY
    d.GroupName,
    d.Name,
    e.Gender;
