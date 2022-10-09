CREATE TABLE [dbo].[M_ApiSource] (
    [Api_Source_Id]    INT           IDENTITY (1, 1) NOT NULL,
    [Api_Source_Code]  VARCHAR (10)  NULL,
    [Api_Source_Name]  VARCHAR (55)  NULL,
    [Api_Status]       VARCHAR (1)   NULL,
    [Key_Parameter1]   VARCHAR (255) NULL,
    [Key_Parameter2]   VARCHAR (255) NULL,
    [Key_Parameter3]   VARCHAR (255) NULL,
    [Created_By]       INT           NULL,
    [Created_DateTime] DATETIME      NULL,
    [Updated_By]       INT           NULL,
    [Updated_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_M_ApiSource] PRIMARY KEY CLUSTERED ([Api_Source_Id] ASC)
);

