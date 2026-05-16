
-- =====================================================
-- 7. PROCEDIMIENTOS DE MERGE (ETL)
-- =====================================================

-- ------------------------------------------------
-- MERGE DimCustomer
-- ------------------------------------------------
CREATE   PROCEDURE [dbo].[DW_MergeDimCustomer]
AS
BEGIN
    UPDATE dc
    SET [CompanyName] = sc.[CompanyName],
        [ContactName] = sc.[ContactName],
        [ContactTitle] = sc.[ContactTitle],
        [Phone] = sc.[Phone],
        [Fax] = sc.[Fax],
        [Address] = sc.[Address],
        [City] = sc.[City],
        [Region] = sc.[Region],
        [PostalCode] = sc.[PostalCode],
        [Country] = sc.[Country]
    FROM [dbo].[DimCustomer] dc
    INNER JOIN [staging].[customer] sc ON (dc.[CustomerSK] = sc.[CustomerSK]);
END;
