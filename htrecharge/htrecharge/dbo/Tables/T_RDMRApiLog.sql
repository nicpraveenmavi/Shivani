CREATE TABLE [dbo].[T_RDMRApiLog] (
    [autoid]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [EndPoint]     VARCHAR (50)  NULL,
    [MemId]        INT           NULL,
    [SenderNo]     VARCHAR (50)  NULL,
    [ApiRequest]   VARCHAR (MAX) NULL,
    [ApiResponse]  VARCHAR (MAX) NULL,
    [EntryDate]    DATETIME      NULL,
    [RequestTime]  DATETIME      NULL,
    [ResponseTime] DATETIME      NULL,
    [IPAddress]    VARCHAR (50)  NULL,
    [ClientTxnNo]  VARCHAR (20)  NULL,
    CONSTRAINT [PK_T_RDMRApiLog] PRIMARY KEY CLUSTERED ([autoid] ASC)
);

