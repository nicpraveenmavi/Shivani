CREATE TABLE [dbo].[M_City] (
    [City_Id]          INT           IDENTITY (1, 1) NOT NULL,
    [Country_Id]       INT           NULL,
    [State_Id]         INT           NULL,
    [City_Name]        VARCHAR (255) NULL,
    [Status]           VARCHAR (1)   NULL,
    [Created_By]       INT           NULL,
    [Created_DateTime] DATETIME      NULL,
    [Updated_By]       INT           NULL,
    [Updated_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_M_City] PRIMARY KEY CLUSTERED ([City_Id] ASC)
);

