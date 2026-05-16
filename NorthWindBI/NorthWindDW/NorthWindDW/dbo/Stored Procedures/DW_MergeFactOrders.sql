
-- ------------------------------------------------
-- MERGE FactOrders
-- ------------------------------------------------
CREATE   PROCEDURE [dbo].[DW_MergeFactOrders]
AS
BEGIN
    UPDATE fs
	SET [OrderDateKey]     = sc.[OrderDateKey]
	   ,[RequiredDateKey]  = sc.[RequiredDateKey]
	   ,[ShippedDateKey]   = sc.[ShippedDateKey]
	   ,[CustomerSK]       = sc.[CustomerSK]
	   ,[ProductSK]        = sc.[ProductSK]
	   ,[EmployeeSK]       = sc.[EmployeeSK]
	   ,[ShipperSK]        = sc.[ShipperSK]
	   ,[UnitPrice]        = sc.[UnitPrice]
	   ,[Quantity]         = sc.[Quantity]
	   ,[Discount]         = sc.[Discount]
	   ,[GrossAmount]      = sc.[GrossAmount]
	   ,[NetAmount]        = sc.[NetAmount]

	FROM [dbo].[FactOrders] fs
	INNER JOIN [staging].[orders] sc ON (fs.[OrderID] = sc.[OrderID] AND fs.[ProductID] = sc.[ProductID])
END
