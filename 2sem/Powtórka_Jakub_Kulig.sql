USE s109070

--2. Ile sprzedawców jest w ka¿dym obszarze. Podaj nazwê obszaru, kod kraju oraz liczbê
--osób. Przyjmij, ¿e liczymy tylko obszary, w których pracuje co najmniej jeden sprzedawca.
--[SalesTerritory, SalesPerson]

SELECT
    st.Name,
    st.CountryRegionCode,
    COUNT(sp.BusinessEntityID) AS EmployeesCount
FROM SalesTerritory st
JOIN SalesPerson sp
    ON st.TerritoryID = sp.TerritoryID
GROUP BY
    st.Name,
    st.CountryRegionCode
HAVING COUNT(sp.BusinessEntityID) > 0;

--3. Podaj imiê i nazwisko sprzedawcy oraz numer zmiany, na której aktualnie pracuje.
--Uwzglêdnij tylko sprzedawców z tabeli SalesPerson, których nazwisko zaczyna siê na
--literê S. Numer zmiany pobierz z tabeli EmployeeDepartmentHistory (rekordy
--z EndDate IS NULL).
SELECT
    p.FirstName,
    p.LastName,
    edh.ShiftID
FROM SalesPerson sp
JOIN Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
JOIN EmployeeDepartmentHistory edh
    ON sp.BusinessEntityID = edh.BusinessEntityID
WHERE p.LastName LIKE 'S%'
  AND edh.EndDate IS NULL;

--4. Wyœwietl nazwê, kod kraju, sprzeda¿ YTD dla obszaru sprzeda¿y który ma najwiêksz¹
--sprzeda¿. [SalesTerritory, SalesYTD; Zapytanie powinno zwróciæ jeden wiersz]
SELECT TOP 1
    Name,
    CountryRegionCode,
    SalesYTD
FROM SalesTerritory
ORDER BY SalesYTD DESC;

--5. Wyœwietl nazwê aktualnego dzia³u (kolumna Name w tabeli Department, korzystaj¹c
--z tabeli EmployeeDepartmentHistory , tylko rekordy z EndDate IS NULL), w którym
--pracuj¹ sprzedawcy (identyfikowani po tabeli SalesPerson). Wyœwietl tak¿e ich nazwisko
--(LastName, tabela Person), imiê (FirstName, tabela Person) i sprzeda¿
--w bie¿¹cym roku (SalesYTD, tabela SalesPerson).
SELECT
    d.Name AS DepartmentName,
    p.LastName,
    p.FirstName,
    sp.SalesYTD
FROM SalesPerson sp
JOIN Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
JOIN EmployeeDepartmentHistory edh
    ON sp.BusinessEntityID = edh.BusinessEntityID
JOIN Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL;

--6. Wyœwietl imiona wszystkich sprzedawczyñ zdefiniowanych w tabeli SalesPerson.
--Wykorzystaj atrybut p³eæ z tabeli Employee.
SELECT
    p.FirstName
FROM SalesPerson sp
JOIN Employee e
    ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
WHERE e.Gender = 'F';

--7. Wyœwietl imiê i nazwisko pracowników (Person), którzy aktualnie zarabiaj¹ najmniej
--(tabela EmployeePayHistory, Rate, uwzglêdniaj¹c tylko rekordy, dla których EndDate
--IS NULL).
SELECT
    p.FirstName,
    p.LastName
FROM EmployeePayHistory eph
JOIN Person p
    ON eph.BusinessEntityID = p.BusinessEntityID
WHERE eph.EndDate IS NULL
  AND eph.Rate = (
        SELECT MIN(Rate)
        FROM EmployeePayHistory 
        WHERE EndDate IS NULL );