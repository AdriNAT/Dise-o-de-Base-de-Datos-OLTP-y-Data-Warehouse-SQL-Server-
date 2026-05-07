USE [master]
GO
/****** Objeto: Database [NorthWind_DW] Fecha de script: 06/05/2026 20:45:32 ******/
CREATE DATABASE [NorthWind_DW]
 CONTAINMENT = NONE
 ON  PRIMARY 
( NAME = N'NorthWind_DW', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\NorthWind_DW.mdf' , SIZE = 8192KB , MAXSIZE = UNLIMITED, FILEGROWTH = 65536KB )
 LOG ON 
( NAME = N'NorthWind_DW_log', FILENAME = N'C:\Program Files\Microsoft SQL Server\MSSQL17.MSSQLSERVER\MSSQL\DATA\NorthWind_DW_log.ldf' , SIZE = 8192KB , MAXSIZE = 2048GB , FILEGROWTH = 65536KB )
 WITH CATALOG_COLLATION = DATABASE_DEFAULT, LEDGER = OFF
GO
ALTER DATABASE [NorthWind_DW] SET COMPATIBILITY_LEVEL = 170
GO
IF (1 = FULLTEXTSERVICEPROPERTY('IsFullTextInstalled'))
begin
EXEC [NorthWind_DW].[dbo].[sp_fulltext_database] @action = 'enable'
end
GO
ALTER DATABASE [NorthWind_DW] SET ANSI_NULL_DEFAULT OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ANSI_NULLS OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ANSI_PADDING OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ANSI_WARNINGS OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ARITHABORT OFF 
GO
ALTER DATABASE [NorthWind_DW] SET AUTO_CLOSE OFF 
GO
ALTER DATABASE [NorthWind_DW] SET AUTO_SHRINK OFF 
GO
ALTER DATABASE [NorthWind_DW] SET AUTO_UPDATE_STATISTICS ON 
GO
ALTER DATABASE [NorthWind_DW] SET CURSOR_CLOSE_ON_COMMIT OFF 
GO
ALTER DATABASE [NorthWind_DW] SET CURSOR_DEFAULT  GLOBAL 
GO
ALTER DATABASE [NorthWind_DW] SET CONCAT_NULL_YIELDS_NULL OFF 
GO
ALTER DATABASE [NorthWind_DW] SET NUMERIC_ROUNDABORT OFF 
GO
ALTER DATABASE [NorthWind_DW] SET QUOTED_IDENTIFIER OFF 
GO
ALTER DATABASE [NorthWind_DW] SET RECURSIVE_TRIGGERS OFF 
GO
ALTER DATABASE [NorthWind_DW] SET  ENABLE_BROKER 
GO
ALTER DATABASE [NorthWind_DW] SET AUTO_UPDATE_STATISTICS_ASYNC OFF 
GO
ALTER DATABASE [NorthWind_DW] SET DATE_CORRELATION_OPTIMIZATION OFF 
GO
ALTER DATABASE [NorthWind_DW] SET TRUSTWORTHY OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ALLOW_SNAPSHOT_ISOLATION OFF 
GO
ALTER DATABASE [NorthWind_DW] SET PARAMETERIZATION SIMPLE 
GO
ALTER DATABASE [NorthWind_DW] SET READ_COMMITTED_SNAPSHOT OFF 
GO
ALTER DATABASE [NorthWind_DW] SET HONOR_BROKER_PRIORITY OFF 
GO
ALTER DATABASE [NorthWind_DW] SET RECOVERY FULL 
GO
ALTER DATABASE [NorthWind_DW] SET  MULTI_USER 
GO
ALTER DATABASE [NorthWind_DW] SET PAGE_VERIFY CHECKSUM  
GO
ALTER DATABASE [NorthWind_DW] SET DB_CHAINING OFF 
GO
ALTER DATABASE [NorthWind_DW] SET FILESTREAM( NON_TRANSACTED_ACCESS = OFF ) 
GO
ALTER DATABASE [NorthWind_DW] SET TARGET_RECOVERY_TIME = 60 SECONDS 
GO
ALTER DATABASE [NorthWind_DW] SET DELAYED_DURABILITY = DISABLED 
GO
ALTER DATABASE [NorthWind_DW] SET OPTIMIZED_LOCKING = OFF 
GO
ALTER DATABASE [NorthWind_DW] SET ACCELERATED_DATABASE_RECOVERY = OFF  
GO
ALTER DATABASE [NorthWind_DW] SET QUERY_STORE = ON
GO
ALTER DATABASE [NorthWind_DW] SET QUERY_STORE (OPERATION_MODE = READ_WRITE, CLEANUP_POLICY = (STALE_QUERY_THRESHOLD_DAYS = 30), DATA_FLUSH_INTERVAL_SECONDS = 900, INTERVAL_LENGTH_MINUTES = 60, MAX_STORAGE_SIZE_MB = 1000, QUERY_CAPTURE_MODE = AUTO, SIZE_BASED_CLEANUP_MODE = AUTO, MAX_PLANS_PER_QUERY = 200, WAIT_STATS_CAPTURE_MODE = ON)
GO
USE [NorthWind_DW]
GO
/****** Objeto: Schema [staging] Fecha de script: 06/05/2026 20:45:32 ******/
CREATE SCHEMA [staging]
GO
/****** Objeto: Table [dbo].[DimCustomer] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimCustomer](
	[CustomerSK] [int] IDENTITY(1,1) NOT NULL,
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL,
PRIMARY KEY CLUSTERED 
(
	[CustomerSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DimDate] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimDate](
	[DateKey] [int] NOT NULL,
	[FullDate] [date] NOT NULL,
	[Year] [nvarchar](20) NOT NULL,
	[YearName] [int] NOT NULL,
	[Day] [int] NOT NULL,
	[DayName] [nvarchar](15) NOT NULL,
	[Month] [int] NOT NULL,
	[MonthName] [nvarchar](15) NOT NULL,
	[CalendarQuarter] [tinyint] NOT NULL,
	[CalendarYear] [smallint] NOT NULL,
	[CalendarSemester] [tinyint] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[DateKey] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DimEmployee] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimEmployee](
	[EmployeeSK] [int] IDENTITY(1,1) NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[Email] [varchar](255) NOT NULL,
	[Phone] [varchar](25) NULL,
	[ReportsTo] [int] NULL,
PRIMARY KEY CLUSTERED 
(
	[EmployeeSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DimProduct] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimProduct](
	[ProductSK] [int] IDENTITY(1,1) NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CategoryName] [nvarchar](15) NOT NULL,
	[SupplierName] [nvarchar](40) NOT NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Discontinued] [bit] NOT NULL,
PRIMARY KEY CLUSTERED 
(
	[ProductSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[DimShipper] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[DimShipper](
	[ShipperSK] [int] IDENTITY(1,1) NOT NULL,
	[ShipperID] [int] NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL,
PRIMARY KEY CLUSTERED 
(
	[ShipperSK] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [dbo].[FactSales] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [dbo].[FactSales](
	[OrderID] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[OrderDateKey] [int] NOT NULL,
	[RequiredDateKey] [int] NOT NULL,
	[ShippedDateKey] [int] NULL,
	[CustomerSK] [int] NOT NULL,
	[EmployeeSK] [int] NOT NULL,
	[ProductSK] [int] NOT NULL,
	[ShipperSK] [int] NOT NULL,
	[Quantity] [smallint] NOT NULL,
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Discount] [decimal](10, 2) NOT NULL,
	[LineTotal]  AS (CONVERT([money],([Quantity]*[UnitPrice])*((1)-[Discount]))) PERSISTED,
 CONSTRAINT [PK_FactSales] PRIMARY KEY CLUSTERED 
(
	[OrderID] ASC,
	[ProductID] ASC
)WITH (PAD_INDEX = OFF, STATISTICS_NORECOMPUTE = OFF, IGNORE_DUP_KEY = OFF, ALLOW_ROW_LOCKS = ON, ALLOW_PAGE_LOCKS = ON, OPTIMIZE_FOR_SEQUENTIAL_KEY = OFF) ON [PRIMARY]
) ON [PRIMARY]
GO
/****** Objeto: Table [staging].[Customer] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Customer](
	[CustomerSK] [int] NOT NULL,
	[CustomerID] [nchar](5) NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[ContactName] [nvarchar](30) NULL,
	[City] [nvarchar](15) NULL,
	[Region] [nvarchar](15) NULL,
	[Country] [nvarchar](15) NULL,
	[Phone] [nvarchar](24) NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [staging].[Employee] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Employee](
	[EmployeeSK] [int] NOT NULL,
	[EmployeeID] [int] NOT NULL,
	[LastName] [nvarchar](20) NOT NULL,
	[FirstName] [nvarchar](10) NOT NULL,
	[Title] [nvarchar](30) NULL,
	[Email] [varchar](255) NOT NULL,
	[Phone] [varchar](25) NULL,
	[ReportsTo] [int] NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [staging].[Orders] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
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
	[UnitPrice] [decimal](10, 2) NOT NULL,
	[Discount] [decimal](10, 2) NOT NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [staging].[Product] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Product](
	[ProductSK] [int] NOT NULL,
	[ProductID] [int] NOT NULL,
	[ProductName] [nvarchar](40) NOT NULL,
	[CategoryName] [nvarchar](15) NOT NULL,
	[SupplierName] [nvarchar](40) NOT NULL,
	[UnitPrice] [decimal](10, 2) NULL,
	[Discontinued] [bit] NOT NULL
) ON [PRIMARY]
GO
/****** Objeto: Table [staging].[Shipper] Fecha de script: 06/05/2026 20:45:32 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER ON
GO
CREATE TABLE [staging].[Shipper](
	[ShipperSK] [int] NOT NULL,
	[ShipperID] [int] NOT NULL,
	[CompanyName] [nvarchar](40) NOT NULL,
	[Phone] [nvarchar](24) NULL
) ON [PRIMARY]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Customer] FOREIGN KEY([CustomerSK])
REFERENCES [dbo].[DimCustomer] ([CustomerSK])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Customer]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Date_Order] FOREIGN KEY([OrderDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Date_Order]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Date_Required] FOREIGN KEY([RequiredDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Date_Required]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Date_Shipped] FOREIGN KEY([ShippedDateKey])
REFERENCES [dbo].[DimDate] ([DateKey])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Date_Shipped]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Employee] FOREIGN KEY([EmployeeSK])
REFERENCES [dbo].[DimEmployee] ([EmployeeSK])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Employee]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Product] FOREIGN KEY([ProductSK])
REFERENCES [dbo].[DimProduct] ([ProductSK])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Product]
GO
ALTER TABLE [dbo].[FactSales]  WITH CHECK ADD  CONSTRAINT [FK_Fact_Shipper] FOREIGN KEY([ShipperSK])
REFERENCES [dbo].[DimShipper] ([ShipperSK])
GO
ALTER TABLE [dbo].[FactSales] CHECK CONSTRAINT [FK_Fact_Shipper]
GO
USE [master]
GO
ALTER DATABASE [NorthWind_DW] SET  READ_WRITE 
GO
