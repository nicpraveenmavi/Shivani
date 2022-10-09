CREATE TABLE [dbo].[T_APES_Transection] (
    [APES_TXN_Id]                   INT             IDENTITY (1, 1) NOT NULL,
    [apisourceid]                   INT             NULL,
    [Mem_Id]                        INT             NULL,
    [Pan_Card]                      VARCHAR (50)    NULL,
    [Amount]                        DECIMAL (18, 3) NULL,
    [Status]                        VARCHAR (200)   NULL,
    [Created_DateTime]              DATETIME        NULL,
    [Updated_DateTime]              DATETIME        NULL,
    [APESCallBackResponse]          VARCHAR (500)   NULL,
    [APESCallBackResponse_DateTime] DATETIME        NULL,
    CONSTRAINT [PK_T_APES_Transection] PRIMARY KEY CLUSTERED ([APES_TXN_Id] ASC)
);

