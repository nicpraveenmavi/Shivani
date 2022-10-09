CREATE TABLE [dbo].[T_PG] (
    [Pg_Id]                  INT             IDENTITY (1, 1) NOT NULL,
    [Pg_mainwallet_txn_id]   INT             NULL,
    [pg_membertableid]       INT             NULL,
    [pg_amount]              DECIMAL (12, 2) NULL,
    [pg_gateway]             VARCHAR (50)    NULL,
    [pg_status]              VARCHAR (255)   NULL,
    [pg_txnrefofgateway]     VARCHAR (255)   NULL,
    [pg_date]                DATETIME        NULL,
    [pg_IP]                  VARCHAR (100)   NULL,
    [GateWayPaymentResponse] VARCHAR (2000)  NULL,
    [InitializeResponse]     VARCHAR (500)   NULL,
    [Created_DateTime]       DATETIME        NULL,
    [Updated_DateTime]       DATETIME        NULL,
    CONSTRAINT [PK_T_PG] PRIMARY KEY CLUSTERED ([Pg_Id] ASC)
);

