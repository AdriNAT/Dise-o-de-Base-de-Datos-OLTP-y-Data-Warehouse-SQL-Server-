CREATE TABLE [staging].[orders] (
    [OrderID]         INT             NOT NULL,
    [ProductID]       INT             NOT NULL,
    [OrderDateKey]    INT             NOT NULL,
    [RequiredDateKey] INT             NOT NULL,
    [ShippedDateKey]  INT             NULL,
    [CustomerSK]      INT             NULL,
    [EmployeeSK]      INT             NULL,
    [ShipperSK]       INT             NULL,
    [ProductSK]       INT             NULL,
    [Quantity]        SMALLINT        NOT NULL,
    [UnitPrice]       DECIMAL (10, 2) NOT NULL,
    [Discount]        REAL            NOT NULL,
    [GrossAmount]     DECIMAL (12, 2) NOT NULL,
    [NetAmount]       DECIMAL (12, 2) NOT NULL,
    [OrderDate]       DATE            NOT NULL
);

