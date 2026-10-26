USE s109070

--2. Wyœwietl w jakich latach by³y modernizowane dane osób w tabeli Person, których nazwisko rozpoczyna siê na literê „K”. Lata posortuj rosn¹co.

SELECT DISTINCT YEAR(p.ModifiedDate) as RokModyfikacji
FROM Person p
WHERE p.LastName LIKE 'K%'
ORDER BY RokModyfikacji ASC;

--3. Wyœwietl imiê i nazwisko osób, których dane by³y modyfikowane w roku 2013. Wyœwietl równie¿ datê modyfikacji. Wynik posortuj rosn¹co wed³ug tej daty.
SELECT p.FirstName, p.LastName, p.ModifiedDate
FROM Person p
WHERE YEAR(p.ModifiedDate) = 2013
ORDER BY p.ModifiedDate ASC;

--"4. Wyœwietl login i datê urodzenia pracowników urodzonych 21 stycznia 1979.Uwaga! Data jest w formacie date (bez czasu), wiêc wystarczy zwyk³e porównanie"
SELECT e.LoginID,e.BirthDate
FROM Employee e
WHERE e.BirthDate = '1979-01-21';

--5. Wyœwietl imiê i nazwisko osób, które mia³y modyfikowane dane 28 listopada 2007 roku. Uwaga! Data jest w formacie datetime, wiêc trzeba przeprowadziæ konwersjê.
SELECT p.FirstName,p.LastName,p.ModifiedDate,
    CAST(p.ModifiedDate AS date) AS cast_date,
    CAST(p.ModifiedDate AS varchar) AS cast_varch,
    CONVERT(date, p.ModifiedDate) AS conv
FROM Person p
WHERE CAST(p.ModifiedDate AS date) = '2007-11-28';

--6. Wyœwietl login i datê zatrudnienia osób urodzonych w latach 90-tych. Dodaj kolumnê z informacj¹ w jakim wieku by³y osoby w dniu zatrudnienia.
SELECT e.LoginID,e.BirthDate,e.HireDate,
    DATEDIFF(YEAR, e.BirthDate, e.HireDate)
      - CASE
            WHEN DATEADD(YEAR,
                DATEDIFF(YEAR, e.BirthDate, e.HireDate),
                e.BirthDate) > e.HireDate
            THEN 1
            ELSE 0
        END AS WiekPrzyZatrudnieniu
FROM Employee e
WHERE YEAR(e.BirthDate) BETWEEN 1990 AND 1999;

--7. SprawdŸ, czy s¹ pracownicy, którzy maj¹ dzisiaj urodziny. Przygotuj zapytanie najpierw dla sta³ych wartoœci, a potem z u¿yciem funkcji GETDATE().
SELECT e.LoginID,e.BirthDate
FROM Employee e
WHERE MONTH(e.BirthDate) = 1
  AND DAY(e.BirthDate) = 3;

  SELECT e.LoginID, e.BirthDate
FROM Employee e
WHERE MONTH(e.BirthDate) = MONTH(GETDATE())
  AND DAY(e.BirthDate) = DAY(GETDATE());

  --8. Wyœwietl login, datê urodzenia i datê zatrudnienia osób, które zosta³y zatrudnione w wieku 20 lat
  SELECT e.LoginID, e.BirthDate, e.HireDate
  FROM Employee e
  WHERE DATEDIFF(YEAR, e.BirthDate, e.HireDate)
    - CASE
          WHEN DATEADD(YEAR,
              DATEDIFF(YEAR, e.BirthDate, e.HireDate),
              e.BirthDate) > e.HireDate
          THEN 1
          ELSE 0
      END = 20;

--9. Niektórzy z pracowników zmieniali dzia³. Korzystaj¹c z tabeli EmployeeDepartmentHistory sprawdŸ, ile dni pracowali w dziale, który opuszczali.
SELECT edh.BusinessEntityID,edh.DepartmentID, edh.StartDate,edh.EndDate,
    DATEDIFF(DAY, edh.StartDate, edh.EndDate) AS LiczbaDniWdziale
FROM EmployeeDepartmentHistory edh
WHERE edh.EndDate IS NOT NULL;