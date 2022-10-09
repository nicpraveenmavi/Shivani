CREATE TABLE [dbo].[M_Country] (
    [Country_Id]       INT           IDENTITY (1, 1) NOT NULL,
    [Country_Name]     VARCHAR (250) NULL,
    [Status]           VARCHAR (1)   NULL,
    [Created_By]       INT           NULL,
    [Created_DateTime] DATETIME      NULL,
    [Updated_By]       INT           NULL,
    [Updated_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_M_Country] PRIMARY KEY CLUSTERED ([Country_Id] ASC)
);

