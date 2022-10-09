CREATE TABLE [dbo].[T_CoinWallet] (
    [cwt_id]             INT             IDENTITY (1, 1) NOT NULL,
    [cwt_memid]          INT             NULL,
    [cwt_servicerefid]   INT             NULL,
    [cwt_openingBalance] DECIMAL (12, 2) NULL,
    [cwt_Credit]         DECIMAL (12, 2) NULL,
    [cwt_Debit]          DECIMAL (12, 2) NULL,
    [cwt_ClosingBalance] DECIMAL (12, 2) NULL,
    [cwt_datetime]       DATETIME        NULL,
    [cwt_IP]             VARCHAR (100)   NULL,
    [cwt_comment]        VARCHAR (255)   NULL,
    [Ref_No]             VARCHAR (100)   NULL,
    [BankID]             INT             NULL,
    [GuidCode]           VARCHAR (250)   NULL,
    [IncomeByMemId]      INT             DEFAULT ((0)) NULL,
    [IncomeByLevelNo]    INT             DEFAULT ((0)) NULL,
    [IsRedeemed]         INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_CoinWallet] PRIMARY KEY CLUSTERED ([cwt_id] ASC)
);


GO

CREATE TRIGGER [dbo].[AfterINSERTTriggerT_CoinWallet] on [dbo].[T_CoinWallet]
FOR INSERT 
AS DECLARE @Mwt_memid INT,
	   @Mwt_ClosingBalance  decimal(12,2)
	  
SELECT @Mwt_memid = ins.cwt_memid,@Mwt_ClosingBalance = ins.cwt_ClosingBalance FROM INSERTED ins;
--SELECT @Mwt_ClosingBalance = ins.cwt_ClosingBalance FROM INSERTED ins;
update T_Member set  Coin_Wallet =@Mwt_ClosingBalance,Updated_DateTime=getdate() where Mem_ID=@Mwt_memid
