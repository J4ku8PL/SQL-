--1
"
INTO SalesTerritory
FROM AdventureWorks2019.Sales.SalesTerritory;

ALTER TABLE SalesTerritory
ADD CONSTRAINT PK_SalesTerritory_TerritoryID
PRIMARY KEY CLUSTERED
(
    TerritoryID ASC
);

--2
SELECT *
INTO SalesPerson
FROM AdventureWorks2019.Sales.SalesPerson;

ALTER TABLE SalesPerson
ADD CONSTRAINT PK_SalesPerson_BusinessEntityID
PRIMARY KEY CLUSTERED
(
    BusinessEntityID ASC
);
"
--3
"SELECT *
INTO SalesPerson
FROM AdventureWorks2019.Sales.SalesPerson;

ALTER TABLE SalesPerson
ADD CONSTRAINT PK_SalesPerson_BusinessEntityID
PRIMARY KEY CLUSTERED
(
    BusinessEntityID ASC
);
"
--4
SELECT *
INTO SalesPersonQuotaHistory
FROM AdventureWorks2019.Sales.SalesPersonQuotaHistory;
ALTER TABLE SalesPersonQuotaHistory
ADD CONSTRAINT PK_SalesPersonQuotaHistory_BusinessEntityID_QuotaDate
PRIMARY KEY CLUSTERED
(
    BusinessEntityID ASC,
    QuotaDate ASC
);

--5
SELECT *
INTO SalesTerritoryHistory
FROM AdventureWorks2019.Sales.SalesTerritoryHistory;

ALTER TABLE SalesTerritoryHistory
ADD CONSTRAINT PK_SalesTerritoryHistory_BusinessEntityID_StartDate_TerritoryID
PRIMARY KEY CLUSTERED
(
    BusinessEntityID ASC,
    StartDate ASC,
    TerritoryID ASC
);

--6
SELECT DISTINCT
    CountryRegionCode
FROM SalesTerritory
ORDER BY CountryRegionCode;

--7
SELECT
    *
FROM SalesTerritoryHistory
WHERE EndDate IS NULL;

