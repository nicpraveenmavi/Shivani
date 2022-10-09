CREATE TABLE [dbo].[T_PasswordChange_History] (
    [Pass_History_Id]  INT           IDENTITY (1, 1) NOT NULL,
    [User_Id]          INT           NULL,
    [Old_Password]     VARCHAR (255) NULL,
    [New_Password]     VARCHAR (255) NULL,
    [IP]               VARCHAR (50)  NULL,
    [Created_DateTime] DATETIME      NULL,
    CONSTRAINT [PK_T_PasswordChange_History] PRIMARY KEY CLUSTERED ([Pass_History_Id] ASC)
);

