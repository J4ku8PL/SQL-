use s109070
/*
1. Korzystaj¹c z tabeli SalesPersonQuotaHistory, przygotuj zapytanie dla pracownika o 
identyfikatorze 274. 
a. Wyœwietl szczegó³owy rozk³ad kwot sprzeda¿y z podzia³em na kolejne 
miesi¹ce. 
b. Dla ka¿dego miesi¹ca poka¿ sumê bie¿¹c¹ (narastaj¹c¹) kwot sprzeda¿y. 
c. Poka¿ sumê bie¿¹c¹ (narastaj¹c¹) kwot sprzeda¿y osobno dla ka¿dego roku. 
d. Dla ka¿dego miesi¹ca wyœwietl równie¿ wartoœæ sprzeda¿y z poprzedniego 
miesi¹ca. 
Je¿eli poprzedni miesi¹c nie istnieje, wyœwietl wartoœæ 0. 
W zadaniu warto wykorzystaæ: 
• SUM() OVER(...)  
• PARTITION BY  
• ORDER BY  
• LAG()  
*/

WITH PrzygotowaneDane AS (
    SELECT 
        BusinessEntityID,
        QuotaDate,
        YEAR(QuotaDate) AS Rok,    
        MONTH(QuotaDate) AS Miesiac, 
        SalesQuota
    FROM SalesPersonQuotaHistory
    WHERE BusinessEntityID = 274
)
SELECT 
    BusinessEntityID,
    QuotaDate AS [Data],
    Rok AS [Rok],
    Miesiac AS [Miesiac],
    SalesQuota AS [Kwota sprzedazy],

    -- a & b
    SUM(SalesQuota) OVER (
        ORDER BY QuotaDate
    ) AS [Suma narastajaca ogolem],

    -- c.
    SUM(SalesQuota) OVER (
        PARTITION BY Rok 
        ORDER BY QuotaDate
    ) AS [Suma narastajaca w roku],

    -- d.
    LAG(SalesQuota, 1, 0) OVER (
        ORDER BY QuotaDate
    ) AS [Sprzedaz poprzedni miesiac]

FROM PrzygotowaneDane
ORDER BY QuotaDate;




/*
2. Dla ka¿dego departamentu przygotuj listê pracowników nale¿¹cych do danego dzia³u. 
a. Wyœwietl: nazwê departamentu, listê identyfikatorów pracowników oddzielonych 
przecinkami.  
b. Zmodyfikuj zapytanie tak, aby zamiast identyfikatorów wyœwietla³y siê: imiona, 
nazwiska pracowników.  
W zadaniu warto wykorzystaæ: 
• STRING_AGG()  
• GROUP BY  
*/

-- a.
SELECT 
    d.[Name] AS [Nazwa Departamentu],
    STRING_AGG(CAST(e.BusinessEntityID AS VARCHAR(10)), ', ') WITHIN GROUP (ORDER BY e.BusinessEntityID) AS [Identyfikatory Pracownikow]
FROM Department d
JOIN EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
JOIN Employee e ON edh.BusinessEntityID = e.BusinessEntityID
WHERE edh.EndDate IS NULL
GROUP BY d.[Name];


-- b.
SELECT 
    d.[Name] AS [Nazwa Departamentu],
    STRING_AGG(p.FirstName + ' ' + p.LastName, ', ') WITHIN GROUP (ORDER BY p.LastName, p.FirstName) AS [Pracownicy (Imie Nazwisko)]
FROM Department d
JOIN EmployeeDepartmentHistory edh ON d.DepartmentID = edh.DepartmentID
JOIN Person p ON edh.BusinessEntityID = p.BusinessEntityID
WHERE edh.EndDate IS NULL 
GROUP BY d.[Name];