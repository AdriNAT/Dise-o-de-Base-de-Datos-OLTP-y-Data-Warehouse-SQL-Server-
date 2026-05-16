CREATE   PROCEDURE dbo.GetLastPackageRowVersion
    @tableName NVARCHAR(100)
AS
BEGIN
    SET NOCOUNT ON;

    SELECT ISNULL(LastRowVersion, 0) AS LastRowVersion
    FROM dbo.PackageControl
    WHERE TableName = @tableName;
END;