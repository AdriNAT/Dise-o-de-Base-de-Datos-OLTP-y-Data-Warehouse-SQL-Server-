
CREATE   PROCEDURE [dbo].[UpdateLastPackageRowVersion]
    @tableName VARCHAR(50),
    @lastRowVersion BIGINT
AS
BEGIN
    UPDATE [dbo].[PackageConfig]
    SET LastRowVersion = @lastRowVersion
    WHERE TableName = @tableName;
    
    IF @@ROWCOUNT = 0
    BEGIN
        INSERT INTO [dbo].[PackageConfig] (TableName, LastRowVersion)
        VALUES (@tableName, @lastRowVersion);
    END;
END;
