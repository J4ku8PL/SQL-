use s109070

/*1. Wypisz wszystkie zmiany (Shift) oraz godziny rozpoczêcia i zakoñczenia pracy w formacie: 
Day: 07:00 - 15:00 
Evening: 15:00 - 23:00 */

DECLARE @NazwaZmiany NVARCHAR(50);
DECLARE @Start TIME;
DECLARE @Koniec TIME;

DECLARE szukaj_zmian CURSOR FOR
SELECT [Name], StartTime, EndTime
FROM Shift;

OPEN szukaj_zmian;

FETCH NEXT FROM szukaj_zmian INTO @NazwaZmiany, @Start, @Koniec;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @NazwaZmiany + ': ' + CONVERT(VARCHAR(5), @Start, 108) + ' ' + CONVERT(VARCHAR(5), @Koniec, 108);
    
    FETCH NEXT FROM szukaj_zmian INTO @NazwaZmiany, @Start, @Koniec;
END;

CLOSE szukaj_zmian;
DEALLOCATE szukaj_zmian;


/*2. Napisz program, który dla ka¿dego obszaru sprzeda¿y (SalesTerritory) wypisze 
pracowników, którzy s¹ lub byli do tego obszaru przypisani i poda ich identyfikator, imiê, 
nazwisko jak w przyk³adzie. Je¿eli obszar nie ma przypisanych pracowników to powinien 
siê pojawiæ tekst „brak”. 
Northwest: 234 - Abacki Abak, 123 – Babacki Babak 
Northeast: brak 
itd.*/ 

DECLARE obszary CURSOR
FOR
SELECT st.Name,sth.BusinessEntityID,p.FirstName,p.LastName
FROM SalesTerritory st LEFT JOIN SalesTerritoryHistory sth ON st.TerritoryID = sth.TerritoryID LEFT JOIN Person p ON p.BusinessEntityID = sth.BusinessEntityID ORDER BY st.Name ASC

OPEN obszary
DECLARE @nazwa VARCHAR(64),@poprzednia_nazwa VARCHAR(64),@id INT,@imie VARCHAR(64),@nazwisko VARCHAR(64),@zdanie VARCHAR(MAX)
FETCH NEXT FROM obszary INTO @nazwa, @id, @imie, @nazwisko
SET @poprzednia_nazwa = @nazwa
IF @id IS NULL
    SET @zdanie = CONCAT(@nazwa, ': brak')
ELSE
    SET @zdanie = CONCAT(@nazwa, ': ',@id, ' - ',@imie, ' ',@nazwisko)
FETCH NEXT FROM obszary INTO @nazwa, @id, @imie, @nazwisko
WHILE @@FETCH_STATUS = 0
    BEGIN
        IF @nazwa = @poprzednia_nazwa
        BEGIN
        IF @id IS NOT NULL
            SET @zdanie = @zdanie + CONCAT(', ',@id, ' - ',@imie, ' ',@nazwisko)
        END
        ELSE
        BEGIN
            PRINT @zdanie
            IF @id IS NULL
                SET @zdanie = CONCAT(@nazwa, ': brak')
            ELSE
                SET @zdanie = CONCAT(@nazwa, ': ',@id, ' - ',@imie, ' ',@nazwisko)
    SET @poprzednia_nazwa = @nazwa
        END
        FETCH NEXT FROM obszary 
        INTO @nazwa, @id, @imie, @nazwisko
    END
PRINT @zdanie

CLOSE obszary
DEALLOCATE obszary


/*3. Napisz program, który dla ka¿dego roku, w którym byli zatrudniani pracownicy wyœwietli 
pracowników zatrudnionych w tym roku, jak w przyk³adzie. Lata powinny byæ wyœwietlone 
rosn¹co, a pracownicy alfabetycznie wed³ug nazwiska. 
2006: - Abacki Abak – Babacki Babak 
2007 - Cabacki Cabak - Dabacki Dabak 
itd. */

DECLARE employed CURSOR
FOR
SELECT e.HireDate, p.FirstName, p.LastName
FROM Employee as e
JOIN Person as p ON
	e.BusinessEntityID = p.BusinessEntityID
ORDER BY e.HireDate

OPEN employed

DECLARE @RokZatrudnienia varchar(4)
DECLARE @Imie varchar(10)
DECLARE @Nazwisko varchar(10)
DECLARE @RokWstecz varchar(4)

FETCH NEXT FROM employed INTO @RokZatrudnienia, @Imie, @Nazwisko
PRINT CONCAT(@RokZatrudnienia,':')
PRINT CONCAT('- ',@Imie,' ',@Nazwisko)
SET @RokWstecz = @RokZatrudnienia

FETCH NEXT FROM zatrudnieni INTO @RokZatrudnienia, @Imie, @Nazwisko
WHILE @@FETCH_STATUS = 0
BEGIN
	IF @RokWstecz = @RokZatrudnienia
		PRINT CONCAT('- ',@Imie,' ',@Nazwisko)
	ELSE
		BEGIN
			PRINT CONCAT(@RokZatrudnienia,':')
			PRINT CONCAT('- ',@Imie,' ',@Nazwisko)
			SET @RokWstecz = @RokZatrudnienia
		END
	FETCH NEXT FROM employed INTO @RokZatrudnienia, @Imie, @Nazwisko

END

CLOSE employed

DEALLOCATE employed


/*4. Do tabeli Shift dodaj atrybut NumberOffEmployees. Kolumna powinna mieæ taki typ 
danych, aby mo¿na by³o zapisaæ liczbê pracowników. Przygotuj program, który zliczy 
pracowników przypisanych obecnie do danej zmiany na podstawie tabeli 
EmployeeDepartmentHistory, gdzie EndDate IS NULL i zapisze t¹ sumê w nowo 
utworzonym atrybucie.*/

ALTER TABLE Shift ADD NumberOffEmployees INT

CREATE PROCEDURE count_employee
AS
BEGIN
    DECLARE ilosc_pracownikow CURSOR
    FOR
    SELECT s.ShiftID, COUNT(edh.BusinessEntityID) 
    FROM Shift s JOIN EmployeeDepartmentHistory edh ON edh.ShiftID = s.ShiftID WHERE edh.EndDate IS NULL GROUP BY s.ShiftID

    OPEN ilosc_pracownikow
    DECLARE @id_shift INT, @count INT
    FETCH NEXT FROM ilosc_pracownikow INTO @id_shift, @count
    WHILE @@FETCH_STATUS = 0
        BEGIN
            UPDATE Shift SET NumberOffEmployees = @count WHERE ShiftID = @id_shift
            FETCH NEXT FROM ilosc_pracownikow INTO @id_shift, @count
        END
    PRINT 'Ukoñczono zliczanie pracowników'

    CLOSE ilosc_pracownikow
    DEALLOCATE ilosc_pracownikow
END

EXEC count_employee