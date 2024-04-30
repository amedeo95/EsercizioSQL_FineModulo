/* ESERCIZIO DI FINE MODULO DI SQL
*/

-- Creazione database 
CREATE DATABASE Toysgroup;

/* Creazione tabelle:
- Product
- Region
- Sales
*/

CREATE TABLE Product (
ProductID INT PRIMARY KEY,
Name VARCHAR(55),
Category VARCHAR(55),
Price DECIMAL(10,2)
);

CREATE TABLE Region (
RegionID INT PRIMARY KEY,
Name VARCHAR(55),
Country VARCHAR(55)
);

CREATE TABLE Sales (
SalesID INT PRIMARY KEY,
ProductID INT,
RegionID INT,
SaleDate DATE,
Quantity INT,
TotalAmount DECIMAL(10,2),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
FOREIGN KEY (RegionID) REFERENCES Region(RegionID)
);

-- Popolo le tabelle

INSERT INTO Product (ProductID, Name, Category, Price) VALUES
(1, 'Barbie Dreamhouse', 'Dolls', 199.99),
(2, 'Nerf N-Strike Elite Disruptor', 'Blaster', 12.99),
(3, 'LEGO Star Wars Millennium Falcon', 'Building Blocks', 149.99),
(4, 'Hot Wheels 20 Car Gift Pack', 'Vehicles', 21.99),
(5, 'Fisher-Price Laugh & Learn Smart Stages Chair', 'Learning Toys', 39.99),
(6, 'Melissa & Doug Wooden Building Blocks Set', 'Wooden Toys', 69.99),
(7, 'Hatchimals Surprise Twins', 'Electronic Toys', 69.99),
(8, 'Play-Doh Modeling Compound 10-Pack', 'Arts & Crafts', 7.99),
(9, 'the Trick-Lovin’ Interactive Plush Pet Toy', 'Interactive Toys', 129.99),
(10, 'Baby Einstein Take Along Tunes Musical Toy', 'Infant Toys', 8.99);

INSERT INTO Region (RegionID, Name, Country) VALUES
(1, 'North America', 'USA'),
(2, 'Europe', 'Italy'),
(3, 'Asia', 'China'),
(4, 'South America', 'Brazil'),
(5, 'Oceania', 'Australia'),
(6, 'Africa', 'South Africa'),
(7, 'Central America', 'Mexico'),
(8, 'Middle East', 'Saudi Arabia'),
(9, 'Caribbean', 'Jamaica'),
(10, 'Scandinavia', 'Sweden');

INSERT INTO Sales (SalesID, ProductID, RegionID, SaleDate, Quantity, TotalAmount) VALUES
(1, 1, 1, '2023-08-13', 1, 199.99), 
(2, 2, 2, '2023-05-17', 2, 25.98),  
(3, 3, 3, '2023-03-12', 3, 449.97), 
(4, 4, 4, '2023-01-15', 4, 87.96),  
(5, 5, 5, '2023-06-08', 5, 199.95), 
(6, 6, 6, '2023-02-27', 6, 419.94), 
(7, 7, 7, '2023-10-12', 7, 489.93), 
(8, 8, 8, '2023-11-19', 8, 63.92),  
(9, 9, 9, '2023-05-15', 9, 1169.91),
(10, 10, 10, '2023-04-11', 10, 89.90),
(11,2,7, '2023-04-10', 5, 64.95);


-- Verificare che i campi definiti come PK siano univoci

-- Product
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT ProductID) AS UniqueProductIDs
FROM Product;

-- Region
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT RegionID) AS UniqueRegionIDs
FROM Region;

-- Sales
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT SalesID) AS UniqueSalesIDs
FROM Sales;


-- Esporre l'elenco dei soli prodotti venduti e per ognuno di questi il fatturato totale per anno
SELECT
    pd.ProductID,
    pd.Name,
    YEAR(sl.SaleDate) AS Year,
    SUM(sl.TotalAmount) AS TotalRevenue
FROM 
    Product pd
INNER JOIN Sales sl 
	ON pd.ProductID = sl.ProductID
WHERE 
    sl.Quantity IS NOT NULL
GROUP BY 
    pd.ProductID,
    pd.Name, 
    YEAR(sl.SaleDate)
ORDER BY 
    TotalRevenue DESC;

-- Esporre il fatturato totale per stato per anno. Ordina il risultato per data e per fatturato decrescente
SELECT
	rg.Country,
	YEAR(sl.SaleDate) AS Year,
    sl.TotalAmount
FROM Region rg
JOIN Sales sl
	ON rg.RegionID = sl.RegionID
ORDER BY 
	TotalAmount DESC,
    SaleDate DESC;
    
-- Qual è la categoria di articoli maggiormente richiesta dal mercato?
SELECT 
    pd.Category AS Category,
    SUM(sl.Quantity) AS TotalQuantitySold
FROM Product pd
JOIN Sales sl
	ON pd.ProductID = sl.ProductID
GROUP BY pd.Category
ORDER BY TotalQuantitySold DESC
LIMIT 1;

-- Quali sono, se ci sono, i prodotti invenduti? Proponi due approcci risolutivi differenti. 

-- Approccio 1

SELECT 
	pd.ProductID, 
    pd.Name
FROM Product pd
LEFT JOIN Sales sl 
	ON pd.ProductID = sl.ProductID
WHERE sl.ProductID IS NULL;

-- Approccio 2
SELECT 
	ProductID, 
	Name
FROM Product
WHERE 
	ProductID NOT IN (SELECT ProductID FROM Sales);

-- Esporre l’elenco dei prodotti con la rispettiva ultima data di vendita (la data di vendita più recente).

SELECT
	pd.Name,
    pd.Category,
    sl.SaleDate
FROM Product pd
INNER JOIN Sales sl
	ON pd.ProductID = sl.ProductID
ORDER BY
	SaleDate DESC;