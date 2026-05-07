CREATE DATABASE NorthWind_DW;
GO
USE NorthWind_DW;
GO

-- Crear esquema de Staging para el proceso ETL
CREATE SCHEMA [staging];
GO

-- =============================================
-- 1. TABLAS DE DIMENSIONES (Capa dbo)
-- =============================================

CREATE TABLE [dbo].[DimCustomer](
    [CustomerSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [CustomerID] [nchar](5) NOT NULL, 
    [CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
    [City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
    [Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL
);

CREATE TABLE [dbo].[DimEmployee](
    [EmployeeSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [EmployeeID] [int] NOT NULL,
    [LastName] [nvarchar](20) NOT NULL,
    [FirstName] [nvarchar](10) NOT NULL,
    [Title] [nvarchar](30) NULL,
	[Email] [varchar](255) NOT NULL,
	[Phone] [varchar](25) NULL,
    [ReportsTo] [int] NULL -- Para jerarquías
);

CREATE TABLE [dbo].[DimProduct](
    [ProductSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProductID] [int] NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [CategoryName] [nvarchar](15) NOT NULL,
    [SupplierName] [nvarchar](40) NOT NULL,
    [UnitPrice] [decimal](10,2) NULL, 
    [Discontinued] [bit] NOT NULL
);

CREATE TABLE [dbo].[DimShipper](
    [ShipperSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ShipperID] [int] NOT NULL,
    [CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL
);

CREATE TABLE [dbo].[DimDate](
    [DateKey] [int] NOT NULL PRIMARY KEY, 
    [FullDate] [date] NOT NULL,
	[Year] [nvarchar](20) NOT NULL,
	[YearName] [int] NOT NULL,
    [Day] [int] NOT NULL,
	[DayName] [nvarchar](15) NOT NULL,
	[Month] [int] NOT NULL,
    [MonthName] [nvarchar](15) NOT NULL,
    [CalendarQuarter] [tinyint] NOT NULL,
    [CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL
);

-- =============================================
-- 2. TABLA DE HECHOS (FactSales)
-- =============================================

CREATE TABLE [dbo].[FactSales](
    [OrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [OrderDateKey] [int] NOT NULL,
    [RequiredDateKey] [int] NOT NULL,
    [ShippedDateKey] [int] NULL,
    
    -- Claves Sustitutas (SK) - NOT NULL para integridad
    [CustomerSK] [int] NOT NULL,
    [EmployeeSK] [int] NOT NULL,
    [ProductSK] [int] NOT NULL,
    [ShipperSK] [int] NOT NULL,
    
    -- Métricas con tipos de datos solicitados
    [Quantity] [smallint] NOT NULL,
    [UnitPrice] [decimal](10,2) NOT NULL, -- Ajustado a decimal(10,2)
    [Discount] [decimal](10,2) NOT NULL,  -- Ajustado a decimal(10,2)
    
    -- Métrica Calculada Persistida como MONEY
    [LineTotal] AS (CAST(([Quantity] * [UnitPrice]) * (1 - [Discount]) AS MONEY)) PERSISTED,
    
    CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED ([OrderID], [ProductID])
);

-- =============================================
-- 3. RELACIONES (Foreign Keys)
-- =============================================

ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Customer] FOREIGN KEY([CustomerSK]) REFERENCES [dbo].[DimCustomer]([CustomerSK]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Employee] FOREIGN KEY([EmployeeSK]) REFERENCES [dbo].[DimEmployee]([EmployeeSK]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Product] FOREIGN KEY([ProductSK]) REFERENCES [dbo].[DimProduct]([ProductSK]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Shipper] FOREIGN KEY([ShipperSK]) REFERENCES [dbo].[DimShipper]([ShipperSK]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Order] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Required] FOREIGN KEY([RequiredDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Shipped] FOREIGN KEY([ShippedDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);

-- =============================================
-- 4. CAPA DE STAGING (Tablas para carga ETL)
-- =============================================

CREATE TABLE [staging].[Orders](
    [OrderID] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [OrderDateKey] [int] NOT NULL,
    [RequiredDateKey] [int] NOT NULL,
    [ShippedDateKey] [int] NULL,
	[CustomerSK] [int] NOT NULL,
    [EmployeeSK] [int] NOT NULL,
    [ProductSK] [int] NOT NULL,
    [ShipperSK] [int] NOT NULL,
    [CustomerID] [nchar](5) NULL,
    [EmployeeID] [int] NOT NULL,
    [ShipVia] [int] NOT NULL,
    [Quantity] [smallint] NOT NULL,
    [UnitPrice] [decimal](10,2) NOT NULL,
    [Discount] [decimal](10,2) NOT NULL
);

CREATE TABLE [staging].[Customer](
    [CustomerSK] [int] NOT NULL,
    [CustomerID] [nchar](5) NOT NULL, 
    [CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
    [City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
    [Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL
);

CREATE TABLE [staging].[Employee](
    [EmployeeSK] [int] NOT NULL,
    [EmployeeID] [int] NOT NULL,
    [LastName] [nvarchar](20) NOT NULL,
    [FirstName] [nvarchar](10) NOT NULL,
    [Title] [nvarchar](30) NULL,
	[Email] [varchar](255) NOT NULL,
	[Phone] [varchar](25) NULL,
    [ReportsTo] [int] NULL 
);

CREATE TABLE [staging].[Product](
    [ProductSK] [int] NOT NULL,
    [ProductID] [int] NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [CategoryName] [nvarchar](15) NOT NULL,
    [SupplierName] [nvarchar](40) NOT NULL,
    [UnitPrice] [decimal](10,2) NULL, 
    [Discontinued] [bit] NOT NULL
);

CREATE TABLE [staging].[Shipper](
    [ShipperSK] [int] NOT NULL,
    [ShipperID] [int] NOT NULL,
    [CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL
);