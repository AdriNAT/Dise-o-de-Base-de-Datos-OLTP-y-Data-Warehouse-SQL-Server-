
-- ------------------------------------------------
-- MERGE DimEmployee
-- ------------------------------------------------
CREATE   PROCEDURE [dbo].[DW_MergeDimEmployee]
AS
BEGIN
    UPDATE de
    SET [FirstName] = se.[FirstName],
        [LastName] = se.[LastName],
        [FullName] = se.[FullName],
        [Title] = se.[Title],
        [TitleOfCourtesy] = se.[TitleOfCourtesy],
        [BirthDate] = se.[BirthDate],
        [HireDate] = se.[HireDate],
        [City] = se.[City],
        [Region] = se.[Region],
        [Country] = se.[Country],
        [ReportsTo] = se.[ReportsTo],
        [ManagerSK] = se.[ManagerSK]
    FROM [dbo].[DimEmployee] de
    INNER JOIN [staging].[employee] se ON (de.[EmployeeSK] = se.[EmployeeSK]);
END;
