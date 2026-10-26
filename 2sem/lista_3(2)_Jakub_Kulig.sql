use s109070
/*7. Napisz procedurê, która zliczy pracowników w tabeli Employee urodzonych w danym
dniu, miesi¹cu lub roku. Trzeba podaæ przynajmniej jeden z parametrów. Je¿eli nie
bêdzie przekazany np. dzieñ to zlicz osoby wg roku i miesi¹ca, je¿eli nie bêdzie
przekazany rok i dzieñ to wg miesi¹ca itp. Je¿eli nie bêdzie jubilatów to trzeba napisaæ:
Nie znaleziono ¿adnego solenizanta.*/

CREATE PROCEDURE kiedy
	@dzientemp INT,
	@miesiactemp INT,
	@roktemp INT
AS
BEGIN
	IF @dzientemp IS NULL AND @miesiactemp IS NULL AND @roktemp IS NULL
		BEGIN
			PRINT 'Trzeba podaæ przynajmniej jeden z parametrów.'
			RETURN
		END
	DECLARE @ile INT

	SELECT @ile = COUNT(e.BusinessEntityID)
	FROM Employee as e
	WHERE ((YEAR(e.BirthDate) = @roktemp) or (@roktemp IS NULL))  and 
		((MONTH(e.BirthDate) = @miesiactemp) or (@miesiactemp IS NULL))  and 
		((DAY(e.BirthDate) = @dzientemp) or (@dzientemp IS NULL))

	IF @ile = 0
		PRINT 'Nie znaleziono ¿adnego solenizanta.'
	ELSE
		PRINT CONCAT_WS(' ','Znaleziono',CAST(@ile AS varchar(100)),'osób pokrywaj¹cych kryteria')
END
EXEC kiedy 12,10,2006

DROP PROCEDURE kiedy

/*8. Napisz procedurê, która bêdzie przyjmowa³a dwa parametry: DepartmentID, Litera.
Procedura ma sprawdziæ czy w danym dziale s¹ osoby, których nazwisko rozpoczyna
siê na literê przekazan¹ w parametrze Litera. Je¿eli tak to nale¿y podaæ, ile jest takich
osób oraz datê urodzenia najstarszej osoby.*/

CREATE PROCEDURE ile_takich
	@DepartamentID INT,
	@Litera varchar

AS
BEGIN
	DECLARE @ile INT
	DECLARE @najstarszy DATE
	--zliczamy iloœæ typa zgadzaj¹cych sie z warunkami do zmiennej temp
	SELECT @ile = COUNT(p.BusinessEntityID), @najstarszy = MAX(e.BirthDate)
	FROM Person as p
	JOIN Employee as e ON
	p.BusinessEntityID = e.BusinessEntityID
	JOIN EmployeeDepartmentHistory as edh ON
	e.BusinessEntityID = edh.BusinessEntityID
	WHERE (edh.EndDate IS NOT NULL) and (LEFT(p.LastName,1) = @Litera) and (edh.DepartmentID = @DepartamentID)

	IF @ile = 0
		PRINT CONCAT_WS(' ','W dziale numer',CAST(@DepartamentID as varchar),'nie ma ludzi z nazwiskiem zaczynaj¹cym sie na litere',@Litera)
	ELSE
		PRINT CONCAT_WS(' ','W dziale numer',CAST(@DepartamentID as varchar),'znajduje sie',CAST(@ile as varchar(50)),'ludzi z nazwiskiem zaczynaj¹cym sie na litere',@Litera,'najstarszy z nich urodzi³ siê',CAST(@najstarszy as varchar(50)))

END

EXEC ile_takich 1,'W'

DROP PROCEDURE ile_takich

/*9. Napisz procedurê, która przyjmuje dwa parametry: nazwisko, liczba. Procedura ma
podnosiæ wynagrodzenie pracownika o nazwisku przekazanym w parametrze nazwisko
i wartoœæ procentow¹ przekazan¹ jako drugi parametr liczba, tak d³ugo a¿
wynagrodzenie bêdzie wiêksze od œredniej. W przypadku gdy jest wy¿sze powinien
pojawiæ siê komunikat.*/

CREATE PROCEDURE Podwyzka
    @Nazwisko VARCHAR(50),
    @Liczba FLOAT
AS
BEGIN
    DECLARE @Srednia FLOAT = (SELECT AVG(Rate) FROM EmployeePayHistory)

	  
	 declare @rate float
	 Select @rate = eph.Rate
	 FROM EmployeePayHistory eph
	JOIN Employee e ON eph.BusinessEntityID = e.BusinessEntityID
	JOIN Person p ON e.BusinessEntityID = p.BusinessEntityID
	Where @Nazwisko = p.LastName
	WHILE @rate < @Srednia
		set @rate = @rate * (1 + (@Liczba / 100))
	Print CONCAT_WS(' ','Nowa stawka wtnosi', cast(@rate as varchar(50)))
END

EXEC Podwyzka 'Miller', 5

DROP PROCEDURE Podwyzka


SELECT p.LastName, eph.Rate 
FROM Person p
JOIN EmployeePayHistory eph ON p.BusinessEntityID = eph.BusinessEntityID
WHERE p.LastName = 'Miller';


/*12. Napisz procedurê delEnclosure, która z tabeli z tabeli Enclosures usunie wybieg,
na którym nie ma ¿adnych zwierz¹t. Nazwa wybiegu jest przekazywana jako parametr.
Je¿eli nie mo¿na usun¹æ wybiegu to powinien pojawiæ siê odpowiedni komunikat. Je¿eli
nie ma wybiegu o takiej nazwie to równie¿ powinien pojawiæ siê odpowiedni komunikat.*/
create procedure delEnclosure
@wybieg varchar(50)
as 
BEGIN 
declare @idwybiegu int;
declare @zwierzeta int

select @idwybiegu = EnclosureID
From Zoo.Enclosures as e 
where e.EnclosureName = @wybieg

if @idwybiegu IS NULL 
Begin
	print'Nie ma wybiegu z tak¹ nazw¹ '
	Return
END

Select @zwierzeta
from Zoo.Animals 
where @idwybiegu = EnclosureID

select @zwierzeta = Count(AnimalID)
FROM Zoo.Animals
Where @idwybiegu = EnclosureID

if @zwierzeta > 0 
	print 'Nie mo¿na usun¹æ wybiegu ze zwierzêtami '
else
	Delete from Zoo.Enclosures
	Where EnclosureID = @idwybiegu

END

EXEC delEnclosure 'Goat Enclosure' 

select *
From Zoo.Enclosures
