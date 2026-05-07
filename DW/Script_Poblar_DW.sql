-- =======================================================
-- Script para poblar las dimensiones y la tabla de hechos
-- =======================================================
USE [NorthWind_DW];
GO

-- 1. Poblar DimCustomer
INSERT INTO [dbo].[DimCustomer] (CustomerID, CompanyName, City, Country)
SELECT CustomerID, CompanyName, City, Country
FROM Northwind.dbo.Customers;
GO

-- 2. Poblar DimEmployee
INSERT INTO [dbo].[DimEmployee] (EmployeeID, FullName, Title)
SELECT EmployeeID, FirstName + ' ' + LastName AS FullName, Title
FROM Northwind.dbo.Employees;
GO

-- 3. Poblar DimShipper
INSERT INTO [dbo].[DimShipper] (ShipperID, CompanyName)
SELECT ShipperID, CompanyName
FROM Northwind.dbo.Shippers;
GO

-- 4. Poblar DimProduct
INSERT INTO [dbo].[DimProduct] (ProductID, ProductName, CategoryName, SupplierName, UnitPrice, Discontinued)
SELECT 
    p.ProductID, 
    p.ProductName, 
    c.CategoryName, 
    s.CompanyName AS SupplierName, 
    p.UnitPrice, 
    p.Discontinued
FROM Northwind.dbo.Products p
INNER JOIN Northwind.dbo.Categories c ON p.CategoryID = c.CategoryID
INNER JOIN Northwind.dbo.Suppliers s ON p.SupplierID = s.SupplierID;
GO

-- 5. Poblar DimDate (Generar fechas desde 1996 hasta 2000)
DECLARE @StartDate DATE = '1996-01-01';
DECLARE @EndDate DATE = '2000-12-31';

WHILE @StartDate <= @EndDate
BEGIN
    INSERT INTO [dbo].[DimDate] (DateKey, FullDate, Year, Quarter, Month, MonthName, Day)
    VALUES (
        CAST(CONVERT(VARCHAR(8), @StartDate, 112) AS INT),
        @StartDate,
        YEAR(@StartDate),
        DATEPART(QUARTER, @StartDate),
        MONTH(@StartDate),
        DATENAME(MONTH, @StartDate),
        DAY(@StartDate)
    );
    SET @StartDate = DATEADD(DAY, 1, @StartDate);
END;
GO

-- Poblar Fecha Desconocida para las fechas ShippedDate que sean NULL
IF NOT EXISTS (SELECT 1 FROM [dbo].[DimDate] WHERE DateKey = 0)
BEGIN
    INSERT INTO [dbo].[DimDate] (DateKey, FullDate, Year, Quarter, Month, MonthName, Day)
    VALUES (0, '1900-01-01', 1900, 1, 1, 'Unknown', 1);
END
GO

-- 6. Poblar FactSales
INSERT INTO [dbo].[FactSales] (
    OrderID, ProductID, OrderDateKey, RequiredDateKey, ShippedDateKey,
    CustomerSK, EmployeeSK, ProductSK, ShipperSK,
    Quantity, UnitPrice, Discount,LineTotal
)
SELECT 
    o.OrderID,
    od.ProductID,
    CAST(CONVERT(VARCHAR(8), o.OrderDate, 112) AS INT) AS OrderDateKey,
    CAST(CONVERT(VARCHAR(8), o.RequiredDate, 112) AS INT) AS RequiredDateKey,
    ISNULL(CAST(CONVERT(VARCHAR(8), o.ShippedDate, 112) AS INT), 0) AS ShippedDateKey,
    dc.CustomerSK,
    de.EmployeeSK,
    dp.ProductSK,
    ds.ShipperSK,
    od.Quantity,
    od.UnitPrice,
    od.Discount
    CAST((od.Quantity * od.UnitPrice) * (1 - od.Discount) AS MONEY)
FROM Northwind.dbo.Orders o
INNER JOIN Northwind.dbo.[Order Details] od ON o.OrderID = od.OrderID
LEFT JOIN [dbo].[DimCustomer] dc ON o.CustomerID = dc.CustomerID
LEFT JOIN [dbo].[DimEmployee] de ON o.EmployeeID = de.EmployeeID
LEFT JOIN [dbo].[DimProduct] dp ON od.ProductID = dp.ProductID
LEFT JOIN [dbo].[DimShipper] ds ON o.ShipVia = ds.ShipperID;
GO
