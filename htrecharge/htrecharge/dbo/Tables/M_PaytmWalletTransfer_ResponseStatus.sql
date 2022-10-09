CREATE TABLE [dbo].[M_PaytmWalletTransfer_ResponseStatus] (
    [Row_Id]        INT           IDENTITY (1, 1) NOT NULL,
    [statusCode]    VARCHAR (150) NULL,
    [status]        VARCHAR (150) NULL,
    [statusMessage] VARCHAR (500) NULL,
    [Refund]        VARCHAR (1)   NULL,
    CONSTRAINT [PK_M_PaytmWalletTransfer_ResponseStatus] PRIMARY KEY CLUSTERED ([Row_Id] ASC)
);

