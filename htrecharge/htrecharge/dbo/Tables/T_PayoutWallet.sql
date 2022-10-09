CREATE TABLE [dbo].[T_PayoutWallet] (
    [pwt_id]                         INT             IDENTITY (1, 1) NOT NULL,
    [pwt_memid]                      INT             NULL,
    [pwt_servicerefid]               INT             NULL,
    [pwt_openingBalance]             DECIMAL (12, 3) NULL,
    [pwt_Credit]                     DECIMAL (12, 3) NULL,
    [pwt_Debit]                      DECIMAL (12, 3) NULL,
    [pwt_ClosingBalance]             DECIMAL (12, 3) NULL,
    [pwt_datetime]                   DATETIME        NULL,
    [pwt_IP]                         VARCHAR (100)   NULL,
    [pwt_comment]                    VARCHAR (255)   NULL,
    [Ref_No]                         VARCHAR (100)   NULL,
    [BankID]                         INT             NULL,
    [GuidCode]                       VARCHAR (500)   NULL,
    [RequestBankTransfer]            VARCHAR (2000)  NULL,
    [ResponseBankTransfer]           VARCHAR (2000)  NULL,
    [BankTransfer_Status_code]       VARCHAR (50)    NULL,
    [BankTransfer_Status]            VARCHAR (150)   NULL,
    [BankTransfer_Callback]          VARCHAR (2000)  NULL,
    [BankTransfer_Callback_DateTime] DATETIME        NULL,
    [Refund]                         VARCHAR (1)     NULL,
    [Charges_pwt_id]                 INT             NULL,
    [Charges_Type]                   VARCHAR (100)   NULL,
    [IncomeByMemId]                  INT             DEFAULT ((0)) NULL,
    [IncomeByLevelNo]                INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_PayoutWallet] PRIMARY KEY CLUSTERED ([pwt_id] ASC)
);


GO
CREATE TRIGGER [dbo].[AfterINSERTTriggerT_PayoutWallet] on [dbo].[T_PayoutWallet]
FOR INSERT 
AS DECLARE @Mwt_memid INT,
	   @Mwt_ClosingBalance  decimal(12,3)
	  
SELECT @Mwt_memid = ins.pwt_memid FROM INSERTED ins;
SELECT @Mwt_ClosingBalance = ins.pwt_ClosingBalance FROM INSERTED ins;
update T_Member set Payout_Wallet=@Mwt_ClosingBalance,Updated_DateTime=getdate() where Mem_ID=@Mwt_memid
