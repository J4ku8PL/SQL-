--2
CREATE SCHEMA Zoo;

--3
CREATE TABLE Zoo.Zookeepers (
ZookeeperID INT,
LastName VARCHAR(50) NOT NULL,
FirstName VARCHAR(50),
BirthDate DATE NULL
);

--4
--z b³êdem
ALTER TABLE Zoo.Zookeepers
ADD PRIMARY KEY (ZookeeperID)
--bez b³êdu
ALTER TABLE Zoo.Zookeepers
ALTER COLUMN ZookeeperID INT NOT NULL

--5
--z b³edem
INSERT INTO Zoo.Zookeepers (LastName, FirstName, BirthDate)
VALUES
('Smith', 'John', '1980-05-15'),
('Jones', 'Emily', '1992-08-21'),
('Brown', 'Michael', '1975-11-03');

--bez 
DROP TABLE Zoo.Zookeepers
CREATE TABLE Zoo.Zookeepers
(
ZookeeperID INT PRIMARY KEY IDENTITY (1,1),
LastName VARCHAR(50) NOT NULL,
FirstName VARCHAR(50),
BirthDate DATE NULL
);

--6
CREATE TABLE Zoo.Animals
(
AnimalID INT PRIMARY KEY IDENTITY,
AnimalName VARCHAR(50),
ZookeeperID INT,
CONSTRAINT FK_ZookeeperID
FOREIGN KEY (ZookeeperID ) REFERENCES Zoo.Zookeepers (ZookeeperID)
);

--7
-- Przyk³ad wstawiania po jednej linii
INSERT INTO Zoo.Animals
VALUES ('Lion', 1)
-- Przyk³ad wstawiania wielu linii

INSERT INTO Zoo.Animals
VALUES
('Elephant', 2),
('Giraffe', 3)

--8
CREATE TABLE Zoo.Areas (
AreaID INT PRIMARY KEY IDENTITY(1,1),
AreaName VARCHAR(50),
[Description] VARCHAR(MAX),
AreaType VARCHAR(50)
);

--9 
CREATE TABLE Zoo.Enclosures ( 
EnclosureID INT PRIMARY KEY IDENTITY(1,1), 
EnclosureName VARCHAR(100), 
Description VARCHAR(MAX), 
AreaID INT, 
CONSTRAINT FK_AreaID_Enclosures FOREIGN KEY (AreaID) REFERENCES 
Zoo.Areas(AreaID) 
); 

--10
CREATE TABLE Zoo.Enclosures
(
    EnclosureID INT PRIMARY KEY IDENTITY(1,1),
    EnclosureName VARCHAR(100),
    Description VARCHAR(MAX),
    AreaID INT,
    CONSTRAINT FK_AreaID_Enclosures FOREIGN KEY (AreaID) REFERENCES Zoo.Areas(AreaID))
    
    drop table Zoo.Enclosures

INSERT INTO Zoo.Enclosures (EnclosureName, Description, AreaID)
VALUES
('Lion Enclosure', 'Area for lions.', 1),
('Panda Enclosure', 'Area for pandas.', 2),
('Goat Enclosure', 'Area for goats.', 3);
--11
ALTER TABLE Zoo.Animals 
ADD EnclosureID INT, 
CONSTRAINT FK_EnclosureID 
FOREIGN KEY (EnclosureID) 
REFERENCES Zoo.Enclosures(EnclosureID);

--12
UPDATE Zoo.Animals SET EnclosureID = 1 WHERE AnimalName = 'Lion'; 
-- Przypisanie wielu zwierz¹t do tego samego wybiegu 
UPDATE Zoo.Animals 
SET EnclosureID = 2 
WHERE AnimalName IN ('Elephant', 'Giraffe'); 

--13
UPDATE Zoo.Animals
SET EnclosureID = 1
WHERE AnimalName = 'Lion';

--do tego samego wybiegu
UPDATE Zoo.Animals
SET EnclosureID = 2
WHERE AnimalName IN ('Elephant','Giraffe');

--14
INSERT INTO Zoo.Animals (AnimalName, ZookeeperID, EnclosureID)
VALUES ('Tiger', 1, NULL);

--15
UPDATE Zoo.Animals
SET ZookeeperID = 3
WHERE AnimalName LIKE 'G%';

--16
INSERT INTO Zoo.Animals (AnimalName, ZookeeperID)
VALUES ('Wolf', 99);
-- Nie mo¿na dodaæ rekordu poniewa¿ ZookeeperID = 99
-- nie istnieje w tabeli Zoo.Zookeepers.
-- Klucz obcy wymaga aby wartoœæ istnia³a w tabeli nadrzêdnej.

--17
ALTER TABLE Zoo.Animals
ADD ArrivalDate DATE NULL;