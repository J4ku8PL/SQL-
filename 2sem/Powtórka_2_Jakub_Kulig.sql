USE s109070

--2. ZnajdŸ imiê i nazwisko sprzedawcy, który ma najwy¿szy bonus (wyœwietl jednego 
SELECT TOP 1
    p.FirstName,
    p.LastName,
    sp.Bonus
FROM SalesPerson sp
JOIN Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
ORDER BY sp.Bonus DESC;

--3. ZnajdŸ imiê i nazwisko pracowników, którzy maj¹ najwiêcej lat. 
SELECT
    p.FirstName,
    p.LastName,
    e.BirthDate
FROM Employee e
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID
ORDER BY e.BirthDate ASC

--4. Wyœwietl imiê i nazwisko pracowników, którzy pracuj¹ na 2 lub 3 zmianie. Wyœwietl 
--tak¿e nazwê departamentu. Uwzglêdnij tylko aktualne przydzia³y do dzia³ów. 
SELECT
    p.FirstName,
    p.LastName,
    d.[Name] AS DepartmentName
FROM EmployeeDepartmentHistory edh
JOIN Employee e
    ON edh.BusinessEntityID = e.BusinessEntityID
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID
JOIN Department d
    ON edh.DepartmentID = d.DepartmentID
WHERE edh.EndDate IS NULL
  AND edh.ShiftID IN (2,3);

--5. Oblicz liczbê dni przepracowanych przez sprzedawców w poszczególnych obszarach 
--sprzeda¿y. Uwzglêdnij tylko sprzedawców, którzy zmieniali obszar sprzeda¿y. Dla 
--aktualnego obszaru przyjmij bie¿¹c¹ datê jako datê koñcow¹. Wyœwietl nazwê 
--obszaru, nazwisko sprzedawcy oraz liczbê dni. [SalesTerritoryHistory, 
--SalesTerritory] 
SELECT
    st.Name AS TerritoryName,
    p.LastName,
    SUM(DATEDIFF(DAY,
                 sth.StartDate,
                 ISNULL(sth.EndDate, GETDATE())
        )) AS DaysWorked
FROM SalesTerritoryHistory sth
JOIN SalesTerritory st
    ON sth.TerritoryID = st.TerritoryID
JOIN SalesPerson sp
    ON sth.BusinessEntityID = sp.BusinessEntityID
JOIN Person p
    ON sp.BusinessEntityID = p.BusinessEntityID
WHERE sth.BusinessEntityID IN (
    SELECT BusinessEntityID
    FROM SalesTerritoryHistory
    GROUP BY BusinessEntityID
    HAVING COUNT(*) > 1
)
GROUP BY
    st.[Name],
    p.LastName;

--6. Sprzedawcy pracuj¹ na ró¿nych stanowiskach. Wyœwietl imiê i nazwisko sprzedawcy 
--oraz nazwê aktualnego stanowiska sprzedawcy. 
SELECT p.FirstName,
    p.LastName,
    e.JobTitle
FROM SalesPerson sp
JOIN Employee e
    ON sp.BusinessEntityID = e.BusinessEntityID
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID;

--7. Policz, ile jest kobiet a ile mê¿czyzn wœród sprzedawców zdefiniowanych w tabeli 
--SalesPerson. 
SELECT
    e.Gender,
    COUNT(*) AS Cnt
FROM SalesPerson sp
JOIN Employee e
    ON sp.BusinessEntityID = e.BusinessEntityID
GROUP BY e.Gender;

--8. Poka¿ jakie s¹ najni¿sze aktualne stawki wynagrodzeñ dla kobiet i dla mê¿czyzn. 
SELECT
    e.Gender,
    MIN(eph.Rate) AS MinRate
FROM EmployeePayHistory eph
JOIN Employee e
    ON eph.BusinessEntityID = e.BusinessEntityID
JOIN EmployeeDepartmentHistory edh
    ON e.BusinessEntityID = edh.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY e.Gender;

--9. ZnajdŸ imiê i nazwisko oraz datê urodzenia najstarszego pracownika, który jest 
--mê¿czyzn¹. Zapytanie mo¿e zwróciæ wiêcej ni¿ jeden wiersz.
SELECT
    p.FirstName,
    p.LastName,
    e.BirthDate
FROM Employee e
JOIN Person p
    ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.Gender = 'M'
  AND e.BirthDate = (
        SELECT MIN(BirthDate)
        FROM Employee
        WHERE Gender = 'M'
  );
