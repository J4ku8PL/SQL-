use s109070
--1. Napisz program, który dla zadanych dwóch liczb sprawdzi, która z nich jest większa
--i wypisze tekst: „Wprowadzono dwie liczby: xxx i yyy. Większa liczba to xxx.”
--Jeżeli liczby są równe: „Wprowadzono dwie liczby: xxx i yyy. Liczby są sobierówne.”
DECLARE @a INT = 10;
DECLARE @b INT = 20;

IF @a > @b
    PRINT 'Wprowadzono dwie liczby: ' + CAST(@a AS VARCHAR) + ' i ' + CAST(@b AS VARCHAR) + '. Większa liczba to ' + CAST(@a AS VARCHAR);
ELSE IF @b > @a
    PRINT 'Wprowadzono dwie liczby: ' + CAST(@a AS VARCHAR) + ' i ' + CAST(@b AS VARCHAR) + '. Większa liczba to ' + CAST(@b AS VARCHAR);
ELSE
    PRINT 'Wprowadzono dwie liczby: ' + CAST(@a AS VARCHAR) + ' i ' + CAST(@b AS VARCHAR) + '. Liczby są sobie równe';

--2. Napisz program, który dla numeru departamentu zdefiniowanego w zmiennej @departmentID:
--• wyświetli nazwę departamentu,
--• wyświetli liczbę pracowników w tym departamencie.
--Wynik przedstaw w postaci:
--• Nazwa departamentu o identyfikatorze xxx to: xxxxx.
--W departamencie pracuje xxxx pracowników.
DECLARE @departmentID INT = 3;
DECLARE @name VARCHAR(100);
DECLARE @count INT;

SELECT @name = [Name]
FROM Department d
WHERE DepartmentID = @departmentID;

SELECT @count = COUNT(*)
FROM EmployeeDepartmentHistory
WHERE DepartmentID = @departmentID;

PRINT 'Nazwa departamentu o identyfikatorze ' + CAST(@departmentID AS VARCHAR) + ' to: ' + @name;
PRINT 'W departamencie pracuje ' + CAST(@count AS VARCHAR) + ' pracowników';


--3. Sprawdź, czy są pracownicy, którzy obchodzą dzisiaj urodziny. Jeżeli tak to wyświetl
--ich imię i nazwisko. Jeżeli nie to wypisz „Nikt nie obchodzi dzisiaj urodzin”.

IF EXISTS (
    SELECT 1
    FROM Person p
    JOIN Employee e ON p.BusinessEntityID = e.BusinessEntityID
    WHERE MONTH(e.BirthDate) = MONTH(GETDATE())
    AND DAY(e.BirthDate) = DAY(GETDATE())
)
BEGIN
    SELECT p.FirstName, p.LastName
    FROM Person p
    JOIN Employee e ON p.BusinessEntityID = e.BusinessEntityID
    WHERE MONTH(e.BirthDate) = MONTH(GETDATE())
    AND DAY(e.BirthDate) = DAY(GETDATE());
END
ELSE
BEGIN
    PRINT 'Nikt nie obchodzi dzisiaj urodzin';
END

--4. Napisz program wyliczający sumę pięciu kolejnych liczb naturalnych. Zliczanie
--rozpocznij od liczby zdefiniowanej w zmiennej @liczbaStartowa. Do rozwiązania
--użyj pętli WHILE.
DECLARE @start INT = 5;
DECLARE @i INT = 0;
DECLARE @suma INT = 0;

WHILE @i < 5
BEGIN
    SET @suma = @suma + (@start + @i);
    SET @i = @i + 1;
END

PRINT 'Suma = ' + CAST(@suma AS VARCHAR);

--5. Do tabeli Zoo.Zookepers dodaj atrybut Salary DECIMAL(8,2), który będzie zawierał
--wartość wynagrodzenia dla opiekuna zwierząt.
--Napisz program, który:
--• dla pracownika o wskazanym ID sprawdzi, czy jego wynagrodzenie jest mniejsze od średniej,
--• jeżeli tak – zwiększy wynagrodzenie o 10%
ALTER TABLE Zoo.Zookeepers
ADD Salary DECIMAL(8,2);

DECLARE @id INT = 1;
DECLARE @salary DECIMAL(8,2);
DECLARE @avgSalary DECIMAL(8,2);

SELECT @salary = Salary FROM Zoo.Zookeepers WHERE ZookeeperID = @id;
SELECT @avgSalary = AVG(Salary) FROM Zoo.Zookeepers;

IF @salary < @avgSalary
BEGIN
    UPDATE Zoo.Zookeepers
    SET Salary = Salary * 1.1
    WHERE ZookeeperID = @id;

    PRINT 'Podwyżka przyznana';
END
ELSE
    PRINT 'Pensja jest OK';

--6. Zmodyfikuj program z zadania 5 tak, aby wynagrodzenie było zwiększane tak długo,
--aż będzie większe od średniego wynagrodzenia. Do rozwiązania użyj pętli.
 DECLARE @id INT = 1;
DECLARE @salary DECIMAL(8,2);
DECLARE @avgSalary DECIMAL(8,2);

SELECT @avgSalary = AVG(Salary) FROM Zoo.Zookeepers;

SELECT @salary = Salary FROM Zoo.Zookeepers WHERE ZookeeperID = @id;

WHILE @salary < @avgSalary
BEGIN
    UPDATE Zoo.Zookeepers
    SET Salary = Salary * 1.1
    WHERE ZookeeperID = @id;

    SELECT @salary = Salary FROM Zoo.Zookeepers WHERE ZookeeperID = @id;
END

PRINT 'Pensja została wyrównana';

--7. Napisz program, który będzie wyliczał pole dla zadanej figury.
--A. Przygotuj dwie tabele:
--• RodzajFigury – zawierająca dwa atrybut RodzajFiguryID oraz NazwaFigury.
--Atrybut RodzajFiguryID powinien być kluczem głównym.
--• Figury – zawierającą dane różnych figur potrzebnych do policzenia pola. Tabela
--zawiera atrybuty:
--□ 1. FiguraID – klucz główny, wartość automatycznie numerowana
--□ 2. RodzajFiguryID – klucz obcy do tabeli RodzajFigury
--□ 3. Pozostałe pola potrzebne do wyliczenia pól poszczególnych fogur
CREATE TABLE RodzajFigury
(
RodzajFiguryID INT PRIMARY KEY,
NazwaFigury VARCHAR(50)
);

CREATE TABLE Figury
(
FiguraID INT PRIMARY KEY IDENTITY,
RodzajFiguryID INT,
A FLOAT,
B FLOAT,
R FLOAT,
CONSTRAINT FK_Figury FOREIGN KEY (RodzajFiguryID)
REFERENCES RodzajFigury(RodzajFiguryID)
);

--B. Wprowadź do tabeli RodzajFigury przykładowe nazwy: trójkąt, koło, kwadrat, prostokąt.
INSERT INTO RodzajFigury VALUES
(1,'Trojkat'),
(2,'Kolo'),
(3,'Kwadrat'),
(4,'Prostokat');
--C. Wprowadź do tabeli Figury dwie przykładowe figury dla każdego rodzaju
INSERT INTO Figury (RodzajFiguryID, A, B, R)
VALUES
-- trójkąty (ID = 1)
(1, 3, 4, NULL),
(1, 5, 6, NULL),

-- koła (ID = 2)
(2, NULL, NULL, 2),
(2, NULL, NULL, 5),

-- kwadraty (ID = 3)
(3, 4, NULL, NULL),
(3, 6, NULL, NULL),

-- prostokąty (ID = 4)
(4, 4, 5, NULL),
(4, 3, 7, NULL);
--D. Napisz program, który policzy pole dla zadanej wartości atrybutu FiguraID
DECLARE @id INT = 1;
DECLARE @typ INT;
DECLARE @a FLOAT, @b FLOAT, @r FLOAT;
DECLARE @pole FLOAT;

SELECT @typ = RodzajFiguryID, @a = A, @b = B, @r = R
FROM Figury
WHERE FiguraID = @id;

IF @typ = 1 -- trojkat
    SET @pole = (@a * @b) / 2;
ELSE IF @typ = 2 -- kolo
    SET @pole = 3.14 * @r * @r;
ELSE IF @typ = 3 -- kwadrat
    SET @pole = @a * @a;
ELSE IF @typ = 4 -- prostokat
    SET @pole = @a * @b;

PRINT 'Pole = ' + CAST(@pole AS VARCHAR);

--8. Napisz program, który wypisze liczby od 1 do 100, ale pominie liczby podzielne przez 3.
DECLARE @i INT = 1;

WHILE @i <= 100
BEGIN
    IF @i % 3 <> 0
        PRINT @i;

    SET @i = @i + 1;
END
--9. Napisz program, który dla podanego wynagrodzenia pracownika, wypisze:
--• „niskie wynagrodzenie” – poniżej 4000,
--• „średnie wynagrodzenie” – 4000–7000,
--• „wysokie wynagrodzenie” – powyżej 7000.

DECLARE @salary INT = 5000;

IF @salary < 4000
    PRINT 'niskie wynagrodzenie';
ELSE IF @salary <= 7000
    PRINT 'średnie wynagrodzenie';
ELSE
    PRINT 'wysokie wynagrodzenie';