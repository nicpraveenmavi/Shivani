CREATE TABLE [dbo].[M_Sevice_Type] (
    [Service_Type_Id]  INT           IDENTITY (1, 1) NOT NULL,
    [Service_Name]     VARCHAR (150) NOT NULL,
    [Created_By]       INT           NULL,
    [Created_DateTime] DATETIME      NULL,
    [Status]           VARCHAR (1)   NULL,
    [Updated_By]       INT           NULL,
    [Updated_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_M_Sevice_Type] PRIMARY KEY CLUSTERED ([Service_Type_Id] ASC)
);

