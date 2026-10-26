use s109070

/*
Napisz program w T-SQL, który dla ka¿dego obszaru sprzeda¿y (SalesTerritory) wyœwietli listê pracowników przypisanych do tego obszaru.

Dla ka¿dego pracownika nale¿y podaæ:

nazwê obszaru sprzeda¿y
nazwisko,
ostatni¹ (najbardziej aktualn¹) wartoœæ planu sprzeda¿owego (SalesQuota) na podstawie danych z tabeli SalesPersonQuotaHistory.
Dla ka¿dego obszaru sprzeda¿y wyœwietl tylko trzech pracowników o najwy¿szej wartoœci planu sprzeda¿owego.

Je¿eli do danego obszaru sprzeda¿y nie jest przypisany ¿aden pracownik, nale¿y wyœwietliæ tekst: brak

Rozwi¹zanie nale¿y zrealizowaæ z wykorzystaniem kursora przechodz¹cego po obszarach sprzeda¿y.

Wynik powinien mieæ postaæ:

Australia:
- Tsoflias - 421000.00
 
Canada:
- Saraiva - 830000.00
- Vargas - 390000.00
 
Central:
- Carson - 947000.00

itd
*/

DECLARE @TerritoryID INT;
DECLARE @TerritoryName NVARCHAR(50);

DECLARE obszary CURSOR FOR
SELECT TerritoryID, Name
FROM SalesTerritory;

OPEN obszary;

FETCH NEXT FROM obszary INTO @TerritoryID, @TerritoryName;

WHILE @@FETCH_STATUS = 0
BEGIN
    PRINT @TerritoryName + ':';

    DECLARE @LastName NVARCHAR(50);
    DECLARE @CurrentQuota MONEY;
    DECLARE @LicznikPracownikow INT = 0;

    DECLARE top_pracownicy CURSOR FOR
    WITH NajnowszePlany AS (
        SELECT 
            BusinessEntityID,
            SalesQuota,
            ROW_NUMBER() OVER (PARTITION BY BusinessEntityID ORDER BY QuotaDate DESC) AS RowNum
        FROM SalesPersonQuotaHistory
    ),
    RankingPracownikow AS (
        SELECT 
            p.LastName,
            np.SalesQuota,
            ROW_NUMBER() OVER (ORDER BY np.SalesQuota DESC) AS PozycjaWObszarze
        FROM SalesTerritoryHistory sth
        JOIN Person p ON sth.BusinessEntityID = p.BusinessEntityID
        JOIN NajnowszePlany np ON sth.BusinessEntityID = np.BusinessEntityID
        WHERE sth.TerritoryID = @TerritoryID 
          AND sth.EndDate IS NULL 
          AND np.RowNum = 1      
    )
    
    SELECT LastName, SalesQuota
    FROM RankingPracownikow
    WHERE PozycjaWObszarze <= 3;

    OPEN top_pracownicy;

    FETCH NEXT FROM top_pracownicy INTO @LastName, @CurrentQuota;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @LicznikPracownikow = @LicznikPracownikow + 1;
        
        PRINT '- ' + @LastName + ' - ' + CAST(@CurrentQuota AS VARCHAR(20));

        FETCH NEXT FROM top_pracownicy INTO @LastName, @CurrentQuota;
    END;

    CLOSE top_pracownicy;
    DEALLOCATE top_pracownicy;

    IF @LicznikPracownikow = 0
    BEGIN
        PRINT 'brak';
    END;

    PRINT '';

    FETCH NEXT FROM obszary INTO @TerritoryID, @TerritoryName;
END

CLOSE obszary
DEALLOCATE obszary

/*
Napisz zapytanie, które dla ka¿dego sprzedawcy (SalesPerson) obliczy ³¹czn¹ wartoœæ jego sprzeda¿y na podstawie pola SalesYTD w tabeli SalesPerson,
a nastêpnie pogrupuje wyniki wed³ug przypisanego terytorium sprzeda¿y (TerritoryID). Nastêpnie utwórz ranking sprzedawców w ramach ka¿dego terytorium,
który okreœli ich pozycjê wzglêdem pozosta³ych sprzedawców na podstawie wartoœci SalesYTD, oraz wyznacz procentowy udzia³ sprzeda¿y ka¿dego sprzedawcy
w ca³kowitej sprzeda¿y jego terytorium
*/

SELECT 
    TerritoryID,
    BusinessEntityID,
    SalesYTD,
    SUM(SalesYTD) OVER (PARTITION BY TerritoryID) AS Ca³kowitaSprzedazTerytorium,
    RANK() OVER (PARTITION BY TerritoryID ORDER BY SalesYTD DESC) AS RankingSprzedazy,
    CAST(ROUND((SalesYTD / NULLIF(SUM(SalesYTD) OVER (PARTITION BY TerritoryID), 0)) * 100, 2) AS DECIMAL(5,2)) AS ProcentowyUdzia³
FROM SalesPerson sp
ORDER BY 
    TerritoryID, 
    RankingSprzedazy;

/*
Wyœwietl listê kobiet zatrudnionych w firmie. Dla ka¿dego stanowiska ponumeruj pracownice wed³ug liczby godzin urlopowych (VacationHours) malej¹co,
rozpoczynaj¹c od osoby posiadaj¹cej najwiêksz¹ liczbê godzin. Wyniki maj¹ zawieraæ nazwê stanowiska, nazwisko pracownicy, liczbê godzin urlopowych oraz jej miejsce w rankingu.
*/

SELECT 
    e.JobTitle AS [Stanowisko],
    p.LastName AS [Nazwisko pracownicy],
    e.VacationHours AS [Godziny urlopowe],
    
    ROW_NUMBER() OVER (
        PARTITION BY e.JobTitle 
        ORDER BY e.VacationHours DESC
    ) AS [Miejsce w rankingu]

FROM Employee e
JOIN Person p ON e.BusinessEntityID = p.BusinessEntityID
WHERE e.Gender = 'F'
ORDER BY e.JobTitle, [Miejsce w rankingu];



/*
Napisz funkcjê, która z daty urodzenia wyodrêbni wszystkie cyfry i obliczy ich sumê, a nastêpnie bêdzie powtarzaæ operacjê sumowania a¿ do uzyskania liczby jednocyfrowej (tzw. redukcja cyfrowa), np. 12-10-1998 ma daæ 1+2+1+0+1+9+9+8=31; 3+1=4. 

Przetestuj funkcjê na tabeli Employee (BirthDate).


Wklej jako odpowiedŸ kod funkcji, wywo³anie funkcji w zapytaniu i usuniêcie funkcji
*/
CREATE FUNCTION dbo.SumaDatyUrodzin(
    @dzien INT,
    @miesiac INT,
    @rok INT
)
RETURNS INT
AS
BEGIN

    DECLARE @txt VARCHAR(50) = CAST(@dzien AS VARCHAR) + CAST(@miesiac AS VARCHAR) + CAST(@rok AS VARCHAR);
    DECLARE @Suma INT = 0;
    DECLARE @i INT;

    WHILE LEN(@txt) > 1
    BEGIN
        SET @Suma = 0;
        SET @i = 1;

        
        WHILE @i <= LEN(@txt)
        BEGIN
            SET @Suma = @Suma + CAST(SUBSTRING(@txt, @i, 1) AS INT);
            SET @i = @i + 1;
        END

      
        SET @txt = CAST(@Suma AS VARCHAR);
    END

 
    RETURN CAST(@txt AS INT);
END;
GO


SELECT 
    BirthDate AS [Oryginalna Data],
    CONVERT(VARCHAR(10), BirthDate, 112) AS [Data_w_Liczbie],
    SumaDatyUrodzin(DAY(BirthDate), MONTH(BirthDate), YEAR(BirthDate)) AS [Redukcja Cyfrowa]
FROM Employee e;
GO

DROP FUNCTION SumaDatyUrodzin;
GO

