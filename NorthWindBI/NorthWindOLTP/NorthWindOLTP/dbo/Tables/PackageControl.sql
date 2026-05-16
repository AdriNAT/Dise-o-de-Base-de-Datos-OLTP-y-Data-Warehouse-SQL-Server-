CREATE TABLE [dbo].[PackageControl] (
    [TableName]      NVARCHAR (100) NOT NULL,
    [LastRowVersion] BIGINT         NOT NULL,
    PRIMARY KEY CLUSTERED ([TableName] ASC)
);

