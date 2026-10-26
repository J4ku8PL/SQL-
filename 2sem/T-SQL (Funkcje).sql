use s109070

/* 1. Napisz funkcjê, która wyœwietli skrót stanowiska sk³adaj¹cy siê z pierwszych liter
ka¿dego wyrazu. Przetestuj funkcjê na pracownikach w tabeli Employee.*/
CREATE FUNCTION dbo.skrot(@JobTitle VARCHAR(100))
RETURNS NVARCHAR(20)
AS
BEGIN
    DECLARE @Wynik VARCHAR(20) = '', @i INT = 1, @T VARCHAR(110) = ' ' + LTRIM(@JobTitle);

    WHILE @i < LEN(@T)
    BEGIN
        IF SUBSTRING(@T, @i, 1) = ' ' 
            SET @Wynik = @Wynik + SUBSTRING(@T, @i + 1, 1);
        SET @i = @i + 1;
    END

    RETURN UPPER(@Wynik);
END

Drop Function skrot

SELECT JobTitle, dbo.skrot(JobTitle) AS Skrot
FROM Employee e 

/* 2. Zmodyfikuj funkcjê tworz¹c¹ skrót nazwiska, aby w miejscu, gdzie pojawia siê wyraz and
funkcja zwraca³a symbol &, np. dla stanowiska Research and Development Manager
funkcja utworzy skrót R&DM.*/

CREATE FUNCTION dbo.SkrotNazwiska(@TekstWejsciowy VARCHAR(100))
RETURNS VARCHAR(20)
AS
BEGIN
   
    DECLARE @S VARCHAR(100) = REPLACE(@TekstWejsciowy, ' and ', ' & ');
    
    DECLARE @Wynik VARCHAR(20) = '';
    DECLARE @i INT = 1;
    
    DECLARE @T VARCHAR(110) = ' ' + LTRIM(@S);

    WHILE @i < LEN(@T)
    BEGIN
       
        IF SUBSTRING(@T, @i, 1) = ' ' 
            SET @Wynik = @Wynik + SUBSTRING(@T, @i + 1, 1);
        
        SET @i = @i + 1;
    END

    RETURN UPPER(@Wynik);
END;

drop function dbo.SkrotNazwiska

SELECT JobTitle, dbo.SkrotNazwiska(JobTitle) AS Skrot
FROM Employee e

/* 3. Napisz funkcjê, która zbuduje adres email. Funkcja ma przyjmowaæ trzy parametry:
domena (np. @aw.com), nazwisko, imiê. Przetestuj funkcjê na osobach w tabeli Person,
bêd¹cych pracownikami.*/

Create Function email(
	@domena as varchar(15),
	@imie as varchar(15),
	@nazwisko as varchar(15)
	)
returns varchar(20)
AS
BEGIN

Return(@imie + @nazwisko + @domena)
END

Drop Function email

Select dbo.email('@gmail.eu', p.LastName,p.FirstName)
FROM Person p 
join Employee e on p.BusinessEntityID = e.BusinessEntityID 
join EmployeeDepartmentHistory edh on e.BusinessEntityID = edh.BusinessEntityID 
Where EndDate is not null



/* 4. Napisz funkcjê, która bêdzie zwraca³a tabelê zawieraj¹ wykaz pracowników pracuj¹cych
na danej zmianie. Identyfikator zmiany ma byæ parametrem funkcji. Funkcja ma zwracaæ
identyfikator, imiê i nazwisko pracowników.*/
CREATE FUNCTION tabelazmiany(
	@idzmiany as INT
	)
RETURNS TABLE
AS
RETURN(
	SELECT p.BusinessEntityID,p.FirstName,p.LastName
	FROM [Shift] as s
	LEFT JOIN EmployeeDepartmentHistory as edh ON
	s.ShiftID = edh.ShiftID
	LEFT JOIN Employee as e ON
	edh.BusinessEntityID = e.BusinessEntityID
	LEFT JOIN Person as p ON
	e.BusinessEntityID = p.BusinessEntityID
	WHERE s.ShiftID = @idzmiany
)

DROP FUNCTION tabelezmiany


SELECT * FROM tabelazmiany(1)


/* 5. Napisz funkcjê, która bêdzie zwraca³a tabelê zawieraj¹ wykaz pracowników pracuj¹cych
w danym oddziale. Identyfikator oddzia³u ma byæ parametrem funkcji. Funkcja ma
zwracaæ identyfikator, imiê i nazwisko pracowników.*/
-- department to oddzial
CREATE FUNCTION tabelaoddzialu(
	@idoddzialu as INT
	)
RETURNS TABLE
AS
RETURN(
	SELECT p.BusinessEntityID,p.FirstName,p.LastName
	FROM Department as d
	LEFT JOIN EmployeeDepartmentHistory as edh ON
	d.DepartmentID = edh.DepartmentID
	LEFT JOIN Employee as e ON
	edh.BusinessEntityID = e.BusinessEntityID
	LEFT JOIN Person as p ON
	e.BusinessEntityID = p.BusinessEntityID
	WHERE d.DepartmentID = @idoddzialu
)

DROP FUNCTION tabelaoddzialu


SELECT * FROM tabelaoddzialu(2)

/* 6. Napisz funkcjê, która sprawdzi, czy pracownik jest sprzedawc¹. Funkcja jako parametr
powinna przyj¹æ identyfikator pracownika. Funkcja ma zwracaæ wartoœæ 0 w przypadku,
gdy pracownik nie jest sprzedawc¹ i wartoœæ 1, gdy jest sprzedawc¹. Do weryfikacji
pracownika wykorzystaj tabelê SalesPerson.*/

/* 7. Napisz funkcjê, obliczaj¹c¹ wiek pracownika. Funkcja powinna przyjmowaæ jeden
parametr – datê urodzenia. Funkcja powinna zwracaæ wiek w latach, bêd¹cy liczb¹
ca³kowit¹.*/