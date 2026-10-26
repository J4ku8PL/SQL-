use s109070

/*1. Zbuduj zapytanie, które znajdzie liczbê wszystkich pracowników z podzia³em na p³eæ.
Wynik posortuj wg p³ci (p³eæ powinna byæ wyœwietlona jako M/F.). W wyniku ma siê pojawiæ
dodatkowo wiersz z ca³kowit¹ liczb¹ pracowników (ROLLUP).*/
SELECT e.Gender, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(e.Gender)
ORDER BY e.Gender

/*a. Zmodyfikuj zapytanie, aby dla pola, które jest podsumowaniem wg p³ci i ma wartoœæ
NULL pojawi³a siê wartoœæ „Razem” – wykorzystaj GROUPING*/

SELECT CASE WHEN GROUPING(e.Gender) = 1 then 'Razem' ELSE e.Gender END, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(e.Gender)
ORDER BY e.Gender

/*2. Zbuduj zapytanie, które znajdzie liczbê wszystkich pracowników z podzia³em na
stanowisko. Wynik posortuj wg nazwy stanowiska. W wyniku ma siê pojawiæ dodatkowo
wiersz z ca³kowit¹ liczb¹ pracowników (ROLLUP).*/
SELECT e.JobTitle, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(e.JobTitle)
ORDER BY e.JobTitle

/*a. Zmodyfikuj zapytanie, aby dla pola, które jest podsumowaniem wg stanowiska i ma
wartoœæ NULL pojawi³a siê wartoœæ „Razem” – wykorzystaj GROUPING*/
SELECT CASE WHEN GROUPING(e.JobTitle) = 1 THEN 'Razem' ELSE e.JobTitle END, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(e.JobTitle)
ORDER BY e.JobTitle

/*3. Podaj liczbê pracowników zatrudnianych w poszczególnych latach z podzia³em na
stanowiska. Zestawienie powinno równie¿ zawieraæ podsumowanie liczby pracowników
dla ka¿dego roku oraz ca³kowit¹ liczbê pracowników (ROLLUP).*/
SELECT YEAR(e.HireDate), e.JobTitle, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(YEAR(e.HireDate),e.JobTitle)
ORDER BY YEAR(e.HireDate)

/*a. Zmodyfikuj zapytanie tak, aby:
• dla wierszy zawieraj¹cych podsumowanie dla danego roku zamiast wartoœci NULL
pojawi³ siê napis „Razem w roku”,
• dla wiersza zawieraj¹cego podsumowanie ca³kowite zamiast wartoœci NULL pojawi³
siê napis „Razem”.
Wykorzystaj funkcjê GROUPING().*/
SELECT CASE WHEN GROUPING(YEAR(e.HireDate)) = 1 THEN 'Razem' ELSE YEAR(e.HireDate) END rok, CASE WHEN GROUPING(e.JobTitle) = 1 THEN 'Razem w roku' ELSE e.JobTitle END stanowisko, COUNT(e.BusinessEntityID)
FROM Employee as e
GROUP BY ROLLUP(YEAR(e.HireDate),e.JobTitle)
ORDER BY YEAR(e.HireDate)