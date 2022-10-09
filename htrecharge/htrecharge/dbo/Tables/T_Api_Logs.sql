CREATE TABLE [dbo].[T_Api_Logs] (
    [API_Log_Id]                INT             IDENTITY (1, 1) NOT NULL,
    [Recid]                     INT             NULL,
    [Request]                   NVARCHAR (2000) NULL,
    [Response]                  NVARCHAR (2000) NULL,
    [CalBack_Response]          NVARCHAR (2000) NULL,
    [Request_DateTime]          DATETIME        NULL,
    [Response_DateTime]         DATETIME        NULL,
    [CalBack_Response_DateTime] DATETIME        NULL,
    [ClientRefNo]               VARCHAR (20)    NULL,
    CONSTRAINT [PK_T_Api_Logs] PRIMARY KEY CLUSTERED ([API_Log_Id] ASC)
);

