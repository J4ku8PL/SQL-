use s109070

--1. Zbuduj zapytanie, które dla ka¿dego stanowiska znajdzie liczbê pracowników na nim
--pracuj¹cych. Nastêpnie utwórz ranking stanowisk ze wzglêdu liczbê na pracowników.
--Pierwsze miejsce zajmuje stanowisko z najwiêksz¹ liczb¹ pracowników.
SELECT
    JobTitle AS Stanowisko,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
FROM Employee
GROUP BY JobTitle
ORDER BY Ranking
--a) Zmodyfikuj zapytanie w taki sposób, aby w zbiorze wynikowym pojawi³a siê dodatkowa
--kolumna pokazuj¹ca ranking gêsty. Czy wystêpuj¹ ró¿nice pomiêdzy rankingami?
SELECT
    JobTitle AS Stanowisko,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankingGesty
FROM Employee
GROUP BY JobTitle
ORDER BY Ranking
--b) Przydziel ka¿dej pozycji w rankingu unikalny numer porz¹dkowy (wykorzystaj funkcjê
--ROW_NUMBER). Porównaj numer porz¹dkowy rekordu z pozycj¹ w rankingu.
SELECT
    JobTitle AS Stanowisko,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankingGesty,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS NumerPorzadkowy
FROM Employee
GROUP BY JobTitle
ORDER BY Ranking
--c) Zmodyfikuj zapytanie w taki sposób, aby otrzymaæ dane jedynie dla stanowisk, które
--zajmuj¹ trzy pierwsze miejsca w rankingu (weŸ pod uwagê ranking zwyk³y).
WITH Podstawa AS (
    SELECT
        JobTitle AS Stanowisko,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
    FROM Employee
    GROUP BY JobTitle
)
SELECT * FROM Podstawa
WHERE Ranking <= 3
ORDER BY Ranking
--d) Dokonaj modyfikacji zapytania, tym razem chcemy uzyskaæ informacje o piêciu
--najmniej licznych stanowiskach (ponownie u¿yj zwyk³ego rankingu).
WITH Podstawa AS (
    SELECT
        JobTitle AS Stanowisko,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) ASC) AS Ranking
    FROM Employee
    GROUP BY JobTitle
)
SELECT * FROM Podstawa
WHERE Ranking <= 5
ORDER BY Ranking
--e) Przekszta³æ ranking, uzyskany w ranking procentowy (u¿yj funkcji PERCENT_RANK).
SELECT
    JobTitle AS Stanowisko,
    COUNT(*) AS LiczbaPracownikow,
    PERCENT_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankingProcentowy
FROM Employee
GROUP BY JobTitle
ORDER BY RankingProcentowy
--f) Ogranicz wynik do dwóch pozycji po przecinku.
SELECT
    JobTitle AS Stanowisko,
    COUNT(*) AS LiczbaPracownikow,
    ROUND(PERCENT_RANK() OVER (ORDER BY COUNT(*) DESC), 2) AS RankingProcentowy
FROM Employee
GROUP BY JobTitle
ORDER BY RankingProcentowy
--g) Podziel stanowiska na cztery "koszyki" w zale¿noœci od ich pozycji w rankingu
--zbudowanym wg liczby pracowników. W ka¿dym koszyku powinno znaleŸæ siê tyle
--samo stanowisk (liczba stanowisk w poszczególnych koszykach mo¿e siê ró¿niæ o co najwy¿ej 1).
WITH Podstawa AS (
    SELECT
        JobTitle AS Stanowisko,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
    FROM Employee
    GROUP BY JobTitle
)
SELECT
    Stanowisko,
    LiczbaPracownikow,
    Ranking,
    NTILE(4) OVER (ORDER BY Ranking) AS Koszyk
FROM Podstawa
ORDER BY Ranking
--2. Zbuduj zapytanie, które dla ka¿dego roku zatrudnienia znajdzie liczbê pracowników w
--danym roku przyjêtych. Nastêpnie utwórz ranking lat ze wzglêdu liczbê zatrudnionych
--pracowników. Pierwsze miejsce zajmuje rok z najwiêksz¹ liczb¹ pracowników.
SELECT
    YEAR(HireDate) AS Rok,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
FROM Employee
GROUP BY YEAR(HireDate)
ORDER BY Ranking
--a) Zmodyfikuj zapytanie w taki sposób, aby w zbiorze wynikowym pojawi³a siê dodatkowa
--kolumna pokazuj¹ca ranking gêsty. Czy wystêpuj¹ ró¿nice pomiêdzy rankingami?
SELECT
    YEAR(HireDate) AS Rok,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankingGesty
FROM Employee
GROUP BY YEAR(HireDate)
ORDER BY Ranking
--b) Przydziel ka¿dej pozycji w rankingu unikalny numer porz¹dkowy (wykorzystaj funkcjê
--ROW_NUMBER). Porównaj numer porz¹dkowy rekordu z pozycj¹ w rankingu.
SELECT
    YEAR(HireDate) AS Rok,
    COUNT(*) AS LiczbaPracownikow,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking,
    DENSE_RANK() OVER (ORDER BY COUNT(*) DESC) AS RankingGesty,
    ROW_NUMBER() OVER (ORDER BY COUNT(*) DESC) AS NumerPorzadkowy
FROM Employee
GROUP BY YEAR(HireDate)
ORDER BY Ranking
--c) Zmodyfikuj zapytanie w taki sposób, aby otrzymaæ dane jedynie dla lat, które zajmuj¹
--trzy pierwsze miejsca w rankingu (weŸ pod uwagê ranking zwyk³y).
WITH Podstawa AS (
    SELECT
        YEAR(HireDate) AS Rok,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
    FROM Employee
    GROUP BY YEAR(HireDate)
)
SELECT * FROM Podstawa
WHERE Ranking <= 3
ORDER BY Ranking
--d) Dokonaj modyfikacji zapytania, tym razem chcemy uzyskaæ informacje o trzech
--najmniej licznych latach zatrudnienia (ponownie u¿yj zwyk³ego rankingu).
WITH Podstawa AS (
    SELECT
        YEAR(HireDate) AS Rok,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) ASC) AS Ranking
    FROM Employee
    GROUP BY YEAR(HireDate)
)
SELECT * FROM Podstawa
WHERE Ranking <= 3
ORDER BY Ranking
--e) Przekszta³æ ranking, uzyskany w ranking procentowy (u¿yj funkcji PERCENT_RANK).
--Ogranicz wynik do dwóch pozycji po przecinku.
SELECT
    YEAR(HireDate) AS Rok,
    COUNT(*) AS LiczbaPracownikow,
    ROUND(PERCENT_RANK() OVER (ORDER BY COUNT(*) DESC), 2) AS RankingProcentowy
FROM Employee
GROUP BY YEAR(HireDate)
ORDER BY RankingProcentowy
--f) Podziel lata zatrudnienia na trzy "koszyki" w zale¿noœci od ich pozycji w rankingu
--zbudowanym wed³ug liczby pracowników. W ka¿dym koszyku powinno znaleŸæ siê tyle
--samo lat zatrudnienia (liczba lat w poszczególnych koszykach mo¿e siê ró¿niæ o co najwy¿ej 1). 
WITH Podstawa AS (
    SELECT
        YEAR(HireDate) AS Rok,
        COUNT(*) AS LiczbaPracownikow,
        RANK() OVER (ORDER BY COUNT(*) DESC) AS Ranking
    FROM Employee
    GROUP BY YEAR(HireDate)
)
SELECT
    Rok,
    LiczbaPracownikow,
    Ranking,
    NTILE(3) OVER (ORDER BY Ranking) AS Koszyk
FROM Podstawa
ORDER BY Ranking