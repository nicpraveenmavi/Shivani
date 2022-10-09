CREATE TABLE [dbo].[T_User_Login_Log] (
    [Log_Id]          BIGINT        IDENTITY (1, 1) NOT NULL,
    [User_Id]         BIGINT        NULL,
    [IP]              VARCHAR (100) NULL,
    [Login_DateTime]  DATETIME      NULL,
    [Logout_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_T_User_Login_Log] PRIMARY KEY CLUSTERED ([Log_Id] ASC)
);

