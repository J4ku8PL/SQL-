use s109070
/*1  Napisz procedurê, która dla dwóch liczb przekazanych jako parametr sprawdzi, która
z nich jest wiêksza i wypisze tekst „Wprowadzono dwie liczby: xxx i xxxx. Wiêksza
liczba to xxx:” W przypadku, gdy liczby bêd¹ sobie równe ma byæ tekst: „Wprowadzono
dwie liczby: xxx i xxxx. Liczby s¹ sobie równe.”*/
CREATE PROCEDURE ktora_wieksza
	@a INT,
	@b INT
AS
BEGIN
	IF @a > @b
		PRINT CONCAT_WS(' ','Wprowadzono dwie liczby:',CAST(@a AS VARCHAR),'i',CAST(@b AS varchar),'Wiêksza liczba to',CAST(@a AS VARCHAR))
	ELSE
		IF @b > @a
			PRINT CONCAT_WS(' ','Wprowadzono dwie liczby:',CAST(@a AS VARCHAR),'i',CAST(@b AS varchar),'Wiêksza liczba to',CAST(@b AS VARCHAR))
		ELSE
			PRINT CONCAT_WS(' ','Wprowadzono dwie liczby:',CAST(@a AS VARCHAR),'i',CAST(@b AS varchar),'Liczby s¹ sobie równe')
END

EXEC ktora_wieksza 7,7

DROP PROCEDURE ktora_wieksza

/*2 Napisz procedurê wyliczaj¹c¹ sumê kolejnych liczb naturalnych. Procedura powinna
przyj¹æ dwa parametry: liczba startowa oraz iloœæ dodawanych liczb.*/

CREATE PROCEDURE dodawanie
	@liczba_start INT,
	@iloœæ_dodawanych INT
AS
BEGIN
	DECLARE @suma AS INT
	DECLARE @licznik AS INT
	SET @suma = @liczba_start
	SET @licznik = 1

	WHILE @licznik < @iloœæ_dodawanych + 1
		BEGIN
			SET @suma = @suma + @liczba_start + @licznik
			SET @licznik =  @licznik + 1 
		END
	PRINT CONCAT_WS(' ','Suma wynosi',CAST(@suma as varchar))

END

EXEC dodawanie 3,4

DROP PROCEDURE dodawanie

/*3 Napisz procedurê wyliczaj¹c¹ NWD – najwiêkszy wspólny podzielnik dwóch liczb
 naturalnych a,b. (Algorytm Euklidesa – mo¿na zastosowaæ wersjê z odejmowaniem lub
 z operacj¹ modulo).*/

CREATE PROCEDURE NWD
	@liczba1 INT,
	@liczba2 INT
AS
BEGIN
	DECLARE @TEMP AS INT
	DECLARE @TEMP1 AS INT
	SET @TEMP = @liczba1
	SET @TEMP1 = @liczba2
	WHILE @liczba1 <> @liczba2
		BEGIN
			IF @liczba1 > @liczba2
				SET @liczba1 = @liczba1 - @liczba2
			ELSE
				SET @liczba2 = @liczba2 - @liczba1
		END
	PRINT CONCAT_WS(' ','NWD z liczb',CAST(@TEMP as varchar),'i',CAST(@TEMP1 as varchar),'wynosi',CAST(@liczba1 as varchar))
END

EXEC NWD 1071,462

DROP PROCEDURE NWD

/*5. Napisz procedurê, która dla zadanego DepartmentID sprawdzi, ile pracowników
 pracuje na ka¿dej zmianie i wyœwietli komunikat zbiorczy komunikat:
 Liczba osób zatrudnionych w dziale xxx_nazwa_xxx wynosi:
 - zmiana aaaa - yyyy
 - zmiana bbbb - zzzz
 - zmiana ccc - wwww*/

CREATE PROCEDURE depIlosc
	@nrDep INT

AS 
BEGIN
	DECLARE @nazwa_dep as varchar(20)
	SELECT @nazwa_dep = d.[Name] FROM Department as d WHERE d.DepartmentID = @nrDep	
	DECLARE @shift1 as int
	DECLARE @shift2 as int
	DECLARE @shift3 as int
	
	SELECT @shift1 = COUNT(edh.BusinessEntityID) FROM EmployeeDepartmentHistory as edh WHERE edh.DepartmentID = @nrDep and edh.EndDate IS NULL and edh.ShiftID = 1
	SELECT @shift2 = COUNT(edh.BusinessEntityID) FROM EmployeeDepartmentHistory as edh WHERE edh.DepartmentID = @nrDep and edh.EndDate IS NULL and edh.ShiftID = 2
	SELECT @shift3 = COUNT(edh.BusinessEntityID) FROM EmployeeDepartmentHistory as edh WHERE edh.DepartmentID = @nrDep and edh.EndDate IS NULL and edh.ShiftID = 3

	PRINT 'Liczba osób zatrudnionych w dziale ' + @nazwa_dep + ' wynosi' + CHAR(13) + CHAR(10) + 'zmiana day ' + '- ' + CAST(@shift1 as varchar) + CHAR(13) + CHAR(10) + 'zmiana Evening ' + '- ' + CAST(@shift2 as varchar) + CHAR(13) + CHAR(10) + 'zmiana Night ' + '- ' + CAST(@shift3 as varchar)
END

EXEC depIlosc 7

DROP PROCEDURE depIlosc


/*6. Napisz procedurê, która dla wskazanego ShiftID wyœwietli:
 liczbê pracowników pracuj¹cych na tej zmianie z podzia³em na dzia³y,
 nazwê dzia³u oraz liczbê pracowników w ka¿dym dziale.*/

CREATE PROCEDURE liczba_w_shift
	@shift_nr INT
AS
BEGIN

	SELECT COUNT(edh.BusinessEntityID) as liczba_pracownikow ,d.[Name]
	FROM EmployeeDepartmentHistory as edh
	JOIN Department as d ON
	edh.DepartmentID = d.DepartmentID
	WHERE edh.EndDate IS NULL and edh.ShiftID = @shift_nr
	GROUP BY d.[Name]

	SELECT COUNT(edh.BusinessEntityID) as liczba_pracownikow_bez_shift ,d.[Name]
	FROM EmployeeDepartmentHistory as edh
	JOIN Department as d ON
	edh.DepartmentID = d.DepartmentID
	WHERE edh.EndDate IS NULL
	GROUP BY d.[Name]
END

EXEC liczba_w_shift 2

DROP PROCEDURE liczba_w_shift
