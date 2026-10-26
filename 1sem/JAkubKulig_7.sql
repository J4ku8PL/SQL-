USE s109070

--2. Poka¿, ile pracowników jest z ka¿dego rocznika, wyœwietl datê urodzenia
--najstarszej i najm³odszej osoby w ka¿dej z grup.
SELECT
    YEAR(e.BirthDate) AS Rocznik,
    COUNT(*) AS LiczbaPracownikow,
    MIN(e.BirthDate) AS NajstarszaOsoba,
    MAX(e.BirthDate) AS NajmlodszaOsoba
FROM Employee e
GROUP BY YEAR(e.BirthDate)
ORDER BY Rocznik;

--3. Poka¿, ile osób obchodzi urodziny w ka¿dym z miesi¹cu roku kalendarzowego.
--Wyœwietl datê najm³odszej i najstarszej osoby.
SELECT
    MONTH(e.BirthDate) AS Miesiac,
    COUNT(*) AS LiczbaOsob,
    MIN(e.BirthDate) AS NajstarszaOsoba,
    MAX(e.BirthDate) AS NajmlodszaOsoba
FROM Employee e
GROUP BY MONTH(e.BirthDate)
ORDER BY Miesiac;

--4. Ile pracownicy maj¹ œrednio dostêpnych godzin urlopowych. Wynik pogrupuj
--wzglêdem stanowisk.
SELECT
    e.JobTitle AS Stanowisko,
    AVG(e.VacationHours) AS SrednieGodzinyUrlopu
FROM Employee e
GROUP BY e.JobTitle
ORDER BY e.JobTitle;

--5. Policz, ile osób aktualnie pracuje na ka¿dej ze zmian.
--[EmployeeDepartmentHistory]
SELECT
    edh.ShiftID,
    COUNT(DISTINCT edh.BusinessEntityID) AS LiczbaPracownikow
FROM EmployeeDepartmentHistory edh
WHERE edh.EndDate IS NULL
GROUP BY edh.ShiftID
ORDER BY edh.ShiftID;

--6. Policz, ile jest imion o tej samej d³ugoœci znaków.
SELECT
    LEN(p.FirstName) AS DlugoscImienia,
    COUNT(*) AS LiczbaImion
FROM Person p
GROUP BY LEN(p.FirstName)
ORDER BY DlugoscImienia;

--7. Policz, ile jest osób, u których powtarza siê imiê i nazwisko. Wyœwietl imiê i
--nazwisko, liczbê osób, a wynik posortuj najpierw od A do Z wg nazwiska, a potem
--wg imienia.
SELECT
    p.LastName,
    p.FirstName,
    COUNT(*) AS LiczbaOsob
FROM Person p
GROUP BY
    p.LastName,
    p.FirstName
HAVING COUNT(*) > 1
ORDER BY
    p.LastName ASC,
    p.FirstName ASC;

--8. Policz, ile jest osób zatrudnionych na ka¿dej zmianie, w ka¿dym oddziale. Wynik
--posortuj od A do Z wed³ug identyfikatora oddzia³u
SELECT
    edh.DepartmentID,
    edh.ShiftID,
    COUNT(DISTINCT edh.BusinessEntityID) AS LiczbaPracownikow
FROM EmployeeDepartmentHistory edh
WHERE edh.EndDate IS NULL
GROUP BY
    edh.DepartmentID,
    edh.ShiftID
ORDER BY
    edh.DepartmentID ASC,
    edh.ShiftID ASC;
