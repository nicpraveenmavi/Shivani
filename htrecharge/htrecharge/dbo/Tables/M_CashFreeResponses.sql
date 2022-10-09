CREATE TABLE [dbo].[M_CashFreeResponses] (
    [autoid]     INT           IDENTITY (1, 1) NOT NULL,
    [statuscode] VARCHAR (10)  NULL,
    [statustype] VARCHAR (10)  NULL,
    [statusmsg]  VARCHAR (300) NULL,
    [refund]     VARCHAR (1)   NULL,
    CONSTRAINT [PK_M_CashFreeResponses] PRIMARY KEY CLUSTERED ([autoid] ASC)
);

