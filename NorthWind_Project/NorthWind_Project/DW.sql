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
    [City] [nvarchar](15) NULL,
    [Country] [nvarchar](15) NULL
);
GO

CREATE TABLE [dbo].[DimEmployee](
    [EmployeeSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [EmployeeID] [int] NOT NULL,
    [FullName] [nvarchar](40) NOT NULL,
    [Title] [nvarchar](30) NULL
);
GO

CREATE TABLE [dbo].[DimProduct](
    [ProductSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ProductID] [int] NOT NULL,
    [ProductName] [nvarchar](40) NOT NULL,
    [CategoryName] [nvarchar](15) NOT NULL,
    [SupplierName] [nvarchar](40) NOT NULL,
    [UnitPrice] [decimal](10,2) NULL, 
    [Discontinued] [bit] NOT NULL
);
GO

CREATE TABLE [dbo].[DimShipper](
    [ShipperSK] [int] IDENTITY(1,1) NOT NULL PRIMARY KEY,
    [ShipperID] [int] NOT NULL,
    [CompanyName] [nvarchar](40) NOT NULL
);
GO

CREATE TABLE [dbo].[DimDate](
    [DateKey] [int] NOT NULL PRIMARY KEY, 
    [FullDate] [date] NOT NULL,
    [Year] [int] NOT NULL,
    [Quarter] [int] NOT NULL,
    [Month] [int] NOT NULL,
    [MonthName] [nvarchar](15) NOT NULL,
    [Day] [int] NOT NULL
);
GO

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
GO

-- =============================================
-- 3. RELACIONES (Foreign Keys)
-- =============================================

ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Customer] FOREIGN KEY([CustomerSK]) REFERENCES [dbo].[DimCustomer]([CustomerSK]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Employee] FOREIGN KEY([EmployeeSK]) REFERENCES [dbo].[DimEmployee]([EmployeeSK]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Product] FOREIGN KEY([ProductSK]) REFERENCES [dbo].[DimProduct]([ProductSK]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Shipper] FOREIGN KEY([ShipperSK]) REFERENCES [dbo].[DimShipper]([ShipperSK]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Order] FOREIGN KEY([OrderDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Required] FOREIGN KEY([RequiredDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
GO
ALTER TABLE [dbo].[FactSales] ADD CONSTRAINT [FK_Fact_Date_Shipped] FOREIGN KEY([ShippedDateKey]) REFERENCES [dbo].[DimDate]([DateKey]);
GO

-- =============================================
-- 4. CAPA DE STAGING (Tablas para carga ETL)
-- =============================================

CREATE TABLE [staging].[Product](
    [ProductID] [int] NULL,
    [ProductName] [nvarchar](40) NULL,
    [CategoryName] [nvarchar](15) NULL,
    [SupplierName] [nvarchar](40) NULL,
    [UnitPrice] [decimal](10,2) NULL,
    [Discontinued] [bit] NULL
);
GO

CREATE TABLE [staging].[Orders](
    [OrderID] [int] NULL,
    [ProductID] [int] NULL,
    [OrderDate] [datetime] NULL,
    [RequiredDate] [datetime] NULL,
    [ShippedDate] [datetime] NULL,
    [CustomerID] [nvarchar](50 NULL,
    [EmployeeID] [int] NULL,
    [ShipVia] [int] NULL,
    [Quantity] [int] NULL,
    [UnitPrice] [decimal](182) NULL,
    [Discount] [decimal](18,2) NULL
);
GO