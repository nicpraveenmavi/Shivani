CREATE TABLE [dbo].[T_User_Role] (
    [User_Role_Id]     BIGINT      IDENTITY (1, 1) NOT NULL,
    [User_Id]          BIGINT      NULL,
    [User_Type_Id]     BIGINT      NULL,
    [Status]           VARCHAR (1) NULL,
    [Created_DateTime] DATETIME    NULL,
    [Updated_DateTime] DATETIME    NULL,
    [created_by]       INT         NULL,
    CONSTRAINT [PK_T_User_Role] PRIMARY KEY CLUSTERED ([User_Role_Id] ASC)
);

