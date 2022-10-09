CREATE TABLE [dbo].[T_OTTRecharge_log] (
    [id]                 INT            IDENTITY (1, 1) NOT NULL,
    [mem_id]             NVARCHAR (MAX) NULL,
    [mobile_no]          NVARCHAR (MAX) NULL,
    [srv_type]           NVARCHAR (MAX) NULL,
    [plan_id]            NVARCHAR (MAX) NULL,
    [operator_code]      NVARCHAR (MAX) NULL,
    [customer_email]     NVARCHAR (MAX) NULL,
    [End_point]          NVARCHAR (MAX) NULL,
    [RechargeAmount]     NVARCHAR (MAX) NULL,
    [partner_request_id] NVARCHAR (MAX) NULL,
    [RequestDate]        DATETIME       NULL,
    [ResponseDate]       DATETIME       NULL,
    [API_Request]        NVARCHAR (MAX) NULL,
    [Status]             NVARCHAR (MAX) NULL,
    [Message_Desc]       NVARCHAR (MAX) NULL,
    [Recid]              INT            NULL,
    [PlanName]           NVARCHAR (MAX) NULL,
    [Duration]           DATETIME       NULL,
    CONSTRAINT [PK_tbl_OTTRecharge_log] PRIMARY KEY CLUSTERED ([id] ASC)
);

