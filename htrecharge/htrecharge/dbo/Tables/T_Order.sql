CREATE TABLE [dbo].[T_Order] (
    [order_id]                BIGINT          IDENTITY (1, 1) NOT NULL,
    [orderno]                 VARCHAR (20)    NULL,
    [orderdate]               DATETIME        NULL,
    [booked_by_memid]         INT             NULL,
    [merchantMemId]           INT             NULL,
    [service_sub_category_id] INT             NULL,
    [service_id]              BIGINT          NULL,
    [order_status]            INT             NULL,
    [order_status_text]       VARCHAR (50)    NULL,
    [amount]                  DECIMAL (18, 2) NULL,
    [amount_sr_charge]        DECIMAL (18, 2) NULL,
    [amount_gst]              DECIMAL (18, 2) NULL,
    [amount_tot]              DECIMAL (18, 2) NULL,
    [remarks]                 VARCHAR (500)   NULL,
    [entrydate]               DATETIME        NULL,
    [updatedate]              DATETIME        NULL,
    [ipaddress]               VARCHAR (20)    NULL,
    [updatebyMemId]           INT             NULL,
    CONSTRAINT [PK_T_Order] PRIMARY KEY CLUSTERED ([order_id] ASC)
);

