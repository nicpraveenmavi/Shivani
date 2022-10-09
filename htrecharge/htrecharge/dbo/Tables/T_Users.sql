CREATE TABLE [dbo].[T_Users] (
    [User_ID]          INT           IDENTITY (1, 1) NOT NULL,
    [Name]             VARCHAR (150) NULL,
    [Mobile]           VARCHAR (150) NULL,
    [Email]            VARCHAR (150) NULL,
    [Created_DateTime] DATETIME      NULL,
    [Updated_DateTime] DATETIME      NULL,
    [created_by]       INT           NULL,
    [Updated_By]       INT           NULL,
    CONSTRAINT [PK_Users] PRIMARY KEY CLUSTERED ([User_ID] ASC)
);

