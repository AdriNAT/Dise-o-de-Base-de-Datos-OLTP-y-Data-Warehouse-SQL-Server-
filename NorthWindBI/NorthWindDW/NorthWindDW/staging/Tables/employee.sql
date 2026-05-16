CREATE TABLE [staging].[employee] (
    [EmployeeSK]      INT           NOT NULL,
    [EmployeeID]      INT           NOT NULL,
    [FirstName]       NVARCHAR (10) NOT NULL,
    [LastName]        NVARCHAR (20) NOT NULL,
    [FullName]        NVARCHAR (50) NOT NULL,
    [Title]           NVARCHAR (30) NOT NULL,
    [TitleOfCourtesy] NVARCHAR (25) NULL,
    [BirthDate]       DATE          NULL,
    [HireDate]        DATE          NULL,
    [City]            NVARCHAR (15) NULL,
    [Region]          NVARCHAR (15) NULL,
    [Country]         NVARCHAR (15) NULL,
    [ReportsTo]       INT           NULL,
    [ManagerSK]       INT           NULL
);

