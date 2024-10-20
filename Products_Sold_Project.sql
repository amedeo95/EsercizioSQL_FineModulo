/* 

Products_sold

*/

-- Database creation
CREATE DATABASE Toysgroup

/* 

Tables creation:
- Product
- Region
- Sales

*/

CREATE TABLE Product (
ProductID INT PRIMARY KEY,
Name VARCHAR(55),
Category VARCHAR(55),
Price DECIMAL(10,2)
)

CREATE TABLE Nation (
NationID INT PRIMARY KEY,
Nation VARCHAR(55),
Region VARCHAR(55)
)

CREATE TABLE Sales (
SalesID INT PRIMARY KEY,
ProductID INT,
NationID INT,
SaleDate DATE,
Quantity INT,
TotalAmount DECIMAL(10,2),
FOREIGN KEY (ProductID) REFERENCES Product(ProductID),
FOREIGN KEY (NationID) REFERENCES Nation(NationID)
)

-- Populate the tables

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
(10, 'Baby Einstein Take Along Tunes Musical Toy', 'Infant Toys', 8.99)

INSERT INTO Nation (NationID, Nation, Region) VALUES
(1, 'USA', 'North America'),
(2, 'Italy', 'Europe'),
(3, 'China', 'Asia'),
(4, 'Brazil', 'South America'),
(5, 'Australia', 'Oceania'),
(6, 'South Africa', 'Africa'),
(7, 'Mexico', 'Central America'),
(8, 'Saudi Arabia', 'Middle East'),
(9, 'Jamaica', 'Caribbean'),
(10, 'Sweden', 'Scandinavia')


INSERT INTO Sales (SalesID, ProductID, NationID, SaleDate, Quantity, TotalAmount) VALUES
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
(11,2,7, '2023-04-10', 5, 64.95)


-- Verifying that the fields defined as PK are unique

-- Product
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT ProductID) AS UniqueProductIDs
FROM Product

-- Nation
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT NationID) AS UniqueRegionIDs
FROM Nation

-- Sales
SELECT COUNT(*) AS TotalRows, COUNT(DISTINCT SalesID) AS UniqueSalesIDs
FROM Sales


-- Display the list of only products sold and for each the total sales by year
SELECT
    pd.ProductID
   ,pd.[Name]
   ,YEAR(sl.SaleDate) AS Year
   ,SUM(sl.TotalAmount) AS TotalRevenue
FROM 
    Product pd
JOIN
    Sales sl 
    ON pd.ProductID = sl.ProductID
WHERE 
    sl.Quantity IS NOT NULL
GROUP BY 
    pd.ProductID
   ,pd.[Name] 
   ,YEAR(sl.SaleDate)
ORDER BY 
    TotalRevenue DESC

--  Display total sales by state by year. Sort the result by date and by decreasing turnover
SELECT
    nt.Nation
   ,YEAR(sl.SaleDate) AS Year
   ,sl.TotalAmount
FROM 
    Nation nt
JOIN 
    Sales sl
    ON nt.NationID = sl.NationID
ORDER BY 
    TotalAmount DESC,
    SaleDate DESC
    
-- Which item category is most in demand in the market?
SELECT TOP 1
    pd.Category AS Category
   ,SUM(sl.Quantity) AS TotalQuantitySold
FROM 
    Product pd
JOIN
    Sales sl
    ON pd.ProductID = sl.ProductID
GROUP BY 
    pd.Category
ORDER BY 
    TotalQuantitySold DESC


-- What, if any, are the unsold products?

-- First approach
SELECT 
    pd.ProductID
   ,pd.[Name]
FROM
    Product pd
LEFT JOIN 
    Sales sl 
    ON pd.ProductID = sl.ProductID
WHERE
    sl.ProductID IS NULL

-- Second approach
SELECT 
    ProductID 
   ,[Name]
FROM
    Product
WHERE 
    ProductID NOT IN (SELECT ProductID FROM Sales);


-- Displaying the list of products with their respective last date of sale
SELECT
    pd.[Name]
   ,pd.Category
   ,sl.SaleDate
FROM
    Product pd
JOIN 
    Sales sl
    ON pd.ProductID = sl.ProductID
ORDER BY
    SaleDate DESC
