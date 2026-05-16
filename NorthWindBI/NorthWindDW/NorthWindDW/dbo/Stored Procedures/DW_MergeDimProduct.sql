
-- ------------------------------------------------
-- MERGE DimProduct
-- ------------------------------------------------
CREATE   PROCEDURE [dbo].[DW_MergeDimProduct]
AS
BEGIN
    UPDATE dp
    SET [ProductName] = sp.[ProductName],
        [CategoryName] = sp.[CategoryName],
        [SupplierName] = sp.[SupplierName],
        [QuantityPerUnit] = sp.[QuantityPerUnit],
        [UnitPrice] = sp.[UnitPrice],
        [UnitsInStock] = sp.[UnitsInStock],
        [UnitsOnOrder] = sp.[UnitsOnOrder],
        [ReorderLevel] = sp.[ReorderLevel],
        [Discontinued] = sp.[Discontinued]
    FROM [dbo].[DimProduct] dp
    INNER JOIN [staging].[product] sp ON (dp.[ProductSK] = sp.[ProductSK]);
END;
