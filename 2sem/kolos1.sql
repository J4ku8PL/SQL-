use s109070

/*Napisz program, który dla zadanych dwóch liczb sprawdzi, czy pierwsza liczba jest wielokrotnoœci¹ drugiej i wypisze:
„Liczba xxx jest wielokrotnoœci¹ liczby xxxx.”
W przeciwnym razie wypisz:
„Liczba xxx nie jest wielokrotnoœci¹ liczby xxxx.”*/

Declare @a as int 
declare @b as int 

set @a = 10
set @b = 2

if @a % @b = 0
	begin 
		PRINT(CONCAT_WS(' ','Liczba', @a , 'jest wielokrotnoœci¹ liczby ', @b))
	end 

Else
	begin
		PRINT(CONCAT_WS(' ','Liczba', @a , 'nie jest wielokrotnoœci¹ liczby ', @b))
	end


/*Napisz procedurê, która policzy sumê kwadratów kolejnych liczb naturalnych, zaczynaj¹c od liczby startowej.
Parametry: liczba startowa i iloœæ liczb do zsumowania.

np.: dla danych wejœciowych:

liczba startowa: 1 

iloœæ liczb do zsumowania 3

wynik to 14 */


CREATE PROCEDURE S_K

	@Liczba_startowa int,
	@ilosc int 

as
begin 
	declare @Suma int = 0;
    declare @i int = 0;
    declare @Biezaca_liczba int;

    while @i < @ilosc
    begin
        set @Biezaca_liczba = @Liczba_startowa + @i;
        set @Suma = @Suma + (@Biezaca_liczba * @Biezaca_liczba);
        set @i = @i + 1;
    end

    select @Suma as wynik;
end

EXEC S_K 1,3
	
DROP PROCEDURE S_K

/*Napisz procedurê, która dla zadanej liczby startowej i iloœci kolejnych liczb naturalnych wypisze sumê liczb nieparzystych.

np.: dla danych wejœciowych:

liczba startowa: 1

iloœæ kolejnych liczb naturalnych: 4 (czyli: 1,2,3,4)

wynik: 4 */

CREATE PROCEDURE S_N
    @Liczba_start int,
    @Ilosc_liczb int
as
begin
    declare @ODP int = 0;
    declare @i int = 0;
    declare @Liczba_teraz int;

    while @i < @Ilosc_liczb
    begin
       
        set @Liczba_teraz = @Liczba_start + @i; 
        
        if @Liczba_teraz % 2 <> 0
        begin
            set @ODP = @ODP + @Liczba_teraz;
        end
        
        set @i = @i + 1;
    end

    select @ODP as Wynik;
end;

EXEC S_N 1,4

DROP PROCEDURE S_N

/*Napisz procedurê addAnimal, która do tabeli Zoo.Animals doda nowe wierzê na podstawie przekazanych parametrów: imiê zwierzêcia, nazwisko opiekuna, nazwa wybiegu. 
Je¿eli nie ma opiekuna o takim nazwisku to powinien pojawiæ siê komunikat.
*/

CREATE PROCEDURE addAnimal
    @imie VARCHAR(50),
    @nazwisko VARCHAR(50),
    @wybieg VARCHAR(50)
AS 
BEGIN
    IF NOT EXISTS (SELECT 1 FROM Zoo.Zookeepers WHERE LastName = @nazwisko)
    BEGIN
        PRINT 'B£¥D: Nie ma pracownika o nazwisku ' + @nazwisko
        RETURN
    END

    IF NOT EXISTS (SELECT 1 FROM Zoo.Enclosures WHERE EnclosureName = @wybieg)
    BEGIN
        PRINT 'B£¥D: Nie istnieje wybieg o nazwie ' + @wybieg
        RETURN
    END

    DECLARE @opiekun INT = (SELECT ZookeeperID FROM Zoo.Zookeepers WHERE LastName = @nazwisko)
    DECLARE @miejsce INT = (SELECT EnclosureID FROM Zoo.Enclosures WHERE EnclosureName = @wybieg)

    
    INSERT INTO Zoo.Animals (AnimalName, ZookeeperID, EnclosureID, ArrivalDate)
    VALUES (@imie, @opiekun, @miejsce, NULL)

    PRINT 'Sukces: Dodano zwierzê ' + @imie
END

EXEC addAnimal 'Lynx', 'Smith', 'Lion Enclosure'

DROP PROCEDURE addAnimal


