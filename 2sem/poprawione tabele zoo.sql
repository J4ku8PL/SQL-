UPDATE Zoo.Animals SET EnclosureID = NULL;

DELETE FROM Zoo.Enclosures;

DBCC CHECKIDENT ('Zoo.Enclosures', RESEED, 0);

INSERT INTO Zoo.Enclosures (EnclosureName, Description, AreaID)
VALUES
('Lion Enclosure', 'Area for lions.', 1),
('Panda Enclosure', 'Area for pandas.', 2),
('Goat Enclosure', 'Area for goats.', 3);



-- KROK 1: Odpinamy zwierzêta od opiekunów (¿eby nie by³o b³êdu klucza obcego)
UPDATE Zoo.Animals SET ZookeeperID = NULL;

-- KROK 2: Czyœcimy tabelê opiekunów
DELETE FROM Zoo.Zookeepers;

-- KROK 3: Resetujemy licznik IDENTITY dla pracowników
DBCC CHECKIDENT ('Zoo.Zookeepers', RESEED, 0);

-- KROK 4: Wstawiamy ich ponownie (teraz dostan¹ ID 1, 2, 3)
INSERT INTO Zoo.Zookeepers (LastName, FirstName, BirthDate)
VALUES
('Smith', 'John', '1980-05-15'),
('Jones', 'Emily', '1992-08-21'),
('Brown', 'Michael', '1975-11-03');


-- 1. Czyœcimy tabelê zwierz¹t
DELETE FROM Zoo.Animals;

-- 2. Resetujemy licznik, ¿eby Lion mia³ ID 1
DBCC CHECKIDENT ('Zoo.Animals', RESEED, 0);

-- 3. Wstawiamy zwierzêta od nowa (zgodnie z Twoim plikiem i instrukcj¹)
-- Od razu przypisujemy poprawne ID opiekunów i wybiegów
INSERT INTO Zoo.Animals (AnimalName, ZookeeperID, EnclosureID)
VALUES 
('Lion', 1, 1),      -- Lew: opiekun 1, wybieg 1
('Elephant', 2, 2),  -- S³oñ: opiekun 2, wybieg 2
('Giraffe', 3, 2);   -- ¯yrafa: opiekun 3, wybieg 2 (razem ze s³oniem)

-- 4. Dodajemy Tygrysa z punktu 14 (opiekun 1, brak wybiegu)
INSERT INTO Zoo.Animals (AnimalName, ZookeeperID, EnclosureID)
VALUES ('Tiger', 1, NULL);

SELECT 
    AnimalID, 
    AnimalName, 
    ZookeeperID, -- Powinno byæ 1, 2, 3
    EnclosureID  -- Powinno byæ 1, 2, 2, NULL
FROM Zoo.Animals;



SELECT * FROM Zoo.Areas;
SELECT * FROM Zoo.Enclosures;
SELECT * FROM Zoo.Zookeepers;
SELECT * FROM Zoo.Animals;