CREATE TABLE [dbo].[M_Bank] (
    [Bankid]         INT           IDENTITY (1, 1) NOT NULL,
    [Bankbenf]       VARCHAR (255) NULL,
    [BankName]       VARCHAR (255) NULL,
    [BankAcNumber]   VARCHAR (255) NULL,
    [BankIFSC]       VARCHAR (50)  NULL,
    [BankBranchName] VARCHAR (255) NULL,
    CONSTRAINT [PK_M_Bank] PRIMARY KEY CLUSTERED ([Bankid] ASC)
);

