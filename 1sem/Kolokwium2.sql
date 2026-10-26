USE s109070
--1
--Napisz zapytanie SQL, które dla ka¿dego obszaru sprzeda¿y wyœwietli:
--nazwê obszaru,
--p³eæ pracowników,
--liczbê osób danej p³ci,
--³¹czn¹ wartoœæ sprzeda¿y przypisan¹ do tych osób.
--Do obliczeñ wykorzystaj pole SalesPerson.SalesYTD.
--Wynik posortuj rosn¹co wed³ug nazwy obszaru sprzeda¿y.

--Wynik zapytania:TerritoryName,Gender,EmployeesCount,TotalSales

SELECT
    st.[Name] AS TerritoryName,
    e.Gender,
    COUNT(e.BusinessEntityID) AS EmployeesCount,
    SUM(sp.SalesYTD) AS TotalSales
FROM SalesTerritory st
JOIN SalesPerson sp
    ON st.TerritoryID = sp.TerritoryID
JOIN Employee e
    ON sp.BusinessEntityID = e.BusinessEntityID
GROUP BY
    st.[Name],
    e.Gender
ORDER BY
    st.[Name] ASC;

--2
--Napisz zapytanie SQL zwracaj¹ce liczbê osób, które wystêpowa³y jako kandydaci do pracy, a nastêpnie rozpoczê³y pracê w firmie.
--Warunkiem jest wyst¹pienie identyfikatora BusinessEntityID w tabelach JobCandidate oraz EmployeeDepartmentHistory.

--Wynik zaprezentuj w podziale na rok i miesi¹c rozpoczêcia pracy (miesi¹c pisany du¿ymi literami).
--Wynik posortuj chronologicznie wed³ug daty rozpoczêcia pracy.
--Wyniki zapytania:Y,M,Cnt

SELECT
    YEAR(edh.StartDate) AS Y,
    UPPER(DATENAME(MONTH, edh.StartDate)) AS M,
    COUNT(DISTINCT edh.BusinessEntityID) AS Cnt
FROM EmployeeDepartmentHistory edh
JOIN JobCandidate jc
    ON edh.BusinessEntityID = jc.BusinessEntityID
GROUP BY
    YEAR(edh.StartDate),
    MONTH(edh.StartDate),
    DATENAME(MONTH, edh.StartDate)
ORDER BY
    YEAR(edh.StartDate),
    MONTH(edh.StartDate);

--3
--Oblicz œredni¹ wartoœæ wynagrodzenia dla pracowników, którym pensja wyp³acana jest raz w miesi¹cu.
--Pomiñ osoby otrzymuj¹ce wynagrodzenie w innym cyklu ni¿ miesiêczny.
--Kolumna PayFrequency:  1 - oznacza wynagrodzenie miesiêczne.
--Wynik: AvgSalary

SELECT AVG(Rate) AS AvgSalary
FROM EmployeePayHistory eph
WHERE PayFrequency = 1;

--4
--Wyœwietl listê loginów w postaci (alias Login):
--nazwisko_imie, zapisanych ma³ymi literami,
--tylko dla osób, które nie chc¹ otrzymywaæ promocji (EmailPromotion = 0).
--Posortuj alfabetycznie po nazwisku.
--Tabela Person alias p.

SELECT  LOWER(p.LastName + '_' + p.FirstName ) AS Login
FROM Person p
WHERE p.EmailPromotion = 0
ORDER BY p.LastName ASC;