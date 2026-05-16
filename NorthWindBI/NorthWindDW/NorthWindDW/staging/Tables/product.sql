CREATE TABLE [staging].[product] (
    [ProductSK]       INT             NOT NULL,
    [ProductID]       INT             NOT NULL,
    [ProductName]     NVARCHAR (40)   NOT NULL,
    [CategoryName]    NVARCHAR (15)   NOT NULL,
    [SupplierName]    NVARCHAR (40)   NOT NULL,
    [QuantityPerUnit] NVARCHAR (20)   NULL,
    [UnitPrice]       DECIMAL (10, 2) NOT NULL,
    [UnitsInStock]    SMALLINT        NULL,
    [UnitsOnOrder]    SMALLINT        NULL,
    [ReorderLevel]    SMALLINT        NULL,
    [Discontinued]    BIT             NOT NULL
);

