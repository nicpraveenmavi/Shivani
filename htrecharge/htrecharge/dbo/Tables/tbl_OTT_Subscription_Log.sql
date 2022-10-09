CREATE TABLE [dbo].[tbl_OTT_Subscription_Log] (
    [id]                 INT             IDENTITY (1, 1) NOT NULL,
    [Memid]              INT             NULL,
    [Mobile_no]          NVARCHAR (MAX)  NULL,
    [Service_type]       NVARCHAR (MAX)  NULL,
    [Plan_id]            NVARCHAR (MAX)  NULL,
    [Operator_code]      NVARCHAR (MAX)  NULL,
    [Customer_email]     NVARCHAR (MAX)  NULL,
    [RechargeAmount]     DECIMAL (18, 2) NULL,
    [partner_request_id] NVARCHAR (MAX)  NULL,
    [RequestDate]        DATETIME        NULL,
    [Status]             NVARCHAR (MAX)  NULL,
    [End_point]          NVARCHAR (MAX)  NULL,
    [Request_API]        NVARCHAR (MAX)  NULL,
    [Response_API]       NVARCHAR (MAX)  NULL,
    [Request_Time]       DATETIME        NULL,
    [Response_Time]      DATETIME        NULL,
    [Message_Desc]       NVARCHAR (MAX)  NULL,
    [PlanName]           NVARCHAR (MAX)  NULL,
    [Duration]           DATETIME        NULL,
    CONSTRAINT [PK_tbl_OTT_Subscription_Log] PRIMARY KEY CLUSTERED ([id] ASC)
);

