USE s109070

--2. ZnajdŸ najmniejsz¹ i najwiêksz¹ stawkê wynagrodzenia za godzinê. Wyœwietl
--tak¿e œredni¹ stawkê zaokr¹glon¹ do drugiego miejsca po przecinku.
--[EmEmployeePayHistorypl]
SELECT
    MIN(Rate) AS NajmniejszaStawka,
    MAX(Rate) AS NajwiekszaStawka,
    ROUND(AVG(Rate), 2) AS SredniaStawka
FROM EmployeePayHistorypl;

--3. Policz, ile stawek wynagrodzeñ by³o modyfikowanych w roku 2013.
SELECT
    COUNT(*) AS LiczbaModyfikacji
FROM EmployeePayHistorypl
WHERE YEAR(ModifiedDate) = 2013;

--4. Poka¿ osoby, które s¹ zatrudnione na drugiej zmianie i ich dane by³y
--modyfikowane 14 grudnia 2008 roku.
SELECT p.FirstName, p.LastName, edh.ShiftID, edh.ModifiedDate
FROM EmployeeDepartmentHistory edh
JOIN Person p
    ON p.BusinessEntityID = edh.BusinessEntityID
WHERE edh.ShiftID = 2
  AND CAST(edh.ModifiedDate AS date) = '2008-12-14';

  --5. SprawdŸ jakie jest œrednie wynagrodzenie osób, które otrzymuj¹ je co dwa
--tygodnie (1 =Wynagrodzenie otrzymywane miesiêcznie, 2 = Wynagrodzenie
--otrzymywane co dwa tygodnie).
SELECT ROUND(AVG(Rate), 2) AS SrednieWynagrodzenie
FROM EmployeePayHistorypl
WHERE PayFrequency = 2;

--6. Oceñ wartoœæ wynagrodzenia pracowników, którzy otrzymuj¹ je miesiêcznie. Je¿eli
--jest powy¿ej 11 dolarów za godzinê wypisz „powy¿ej œredniej”, w przeciwnym razie
--wypisz „poni¿ej œredniej”.
SELECT BusinessEntityID,Rate,
    CASE
        WHEN Rate > 11 THEN 'powy¿ej œredniej'
        ELSE 'poni¿ej œredniej'
    END AS OcenaWynagrodzenia
FROM EmployeePayHistorypl
WHERE PayFrequency = 1;

