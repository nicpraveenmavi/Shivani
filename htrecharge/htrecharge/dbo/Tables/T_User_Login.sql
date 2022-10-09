CREATE TABLE [dbo].[T_User_Login] (
    [User_Login_Id]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [User_ID]             BIGINT        NULL,
    [User_Name]           VARCHAR (255) NULL,
    [Password]            VARCHAR (255) NULL,
    [Last_Login_DateTime] DATETIME      NULL,
    [Last_Login_IP]       VARCHAR (100) NULL,
    [Created_DateTime]    DATETIME      NULL,
    [Updated_DateTime]    DATETIME      NULL,
    [Status]              VARCHAR (1)   NULL,
    [ForgotPasswordToken] VARCHAR (200) NULL,
    [created_by]          INT           NULL,
    [Updated_By]          INT           NULL,
    CONSTRAINT [PK_T_User_Login] PRIMARY KEY CLUSTERED ([User_Login_Id] ASC)
);

