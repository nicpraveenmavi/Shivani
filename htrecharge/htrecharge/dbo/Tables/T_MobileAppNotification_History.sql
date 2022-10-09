CREATE TABLE [dbo].[T_MobileAppNotification_History] (
    [Notification_Id]    INT            IDENTITY (1, 1) NOT NULL,
    [Notification_Title] VARCHAR (500)  NULL,
    [Notification_Body]  VARCHAR (2000) NULL,
    [Data_Title]         VARCHAR (500)  NULL,
    [Data_Body]          VARCHAR (2000) NULL,
    [Created_DateTime]   DATETIME       NULL,
    [Created_By]         INT            NULL,
    [IP]                 VARCHAR (200)  NULL,
    [APIRequest]         VARCHAR (3000) NULL,
    [APIResponse]        VARCHAR (3000) NULL,
    [Updated_DateTime]   DATETIME       NULL,
    [Request_Time]       DATETIME       NULL,
    [Response_Time]      DATETIME       NULL,
    [Updated_By]         INT            NULL,
    CONSTRAINT [PK_T_MobileAppNotification_History] PRIMARY KEY CLUSTERED ([Notification_Id] ASC)
);

