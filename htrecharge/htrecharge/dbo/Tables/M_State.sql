CREATE TABLE [dbo].[M_State] (
    [State_Id]         INT           IDENTITY (1, 1) NOT NULL,
    [Country_Id]       INT           NULL,
    [State_Name]       VARCHAR (150) NULL,
    [Status]           VARCHAR (1)   NULL,
    [Created_By]       INT           NULL,
    [Created_DateTime] DATETIME      NULL,
    [Updated_By]       INT           NULL,
    [Updated_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_M_State] PRIMARY KEY CLUSTERED ([State_Id] ASC)
);

