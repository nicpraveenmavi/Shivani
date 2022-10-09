CREATE TABLE [dbo].[T_aepswallet] (
    [Awt_Id]                         BIGINT          IDENTITY (1, 1) NOT NULL,
    [Awt_memid]                      INT             NULL,
    [Awt_servicerefid]               INT             NULL,
    [Awt_openingBalance]             DECIMAL (18, 3) NULL,
    [Awt_Credit]                     DECIMAL (18, 3) NULL,
    [Awt_Debit]                      DECIMAL (18, 3) NULL,
    [Awt_ClosingBalance]             DECIMAL (18, 3) NULL,
    [Awt_datetime]                   DATETIME        NULL,
    [Awt_IP]                         VARCHAR (50)    NULL,
    [Awt_response1]                  VARCHAR (2000)  NULL,
    [Awt_response2]                  VARCHAR (2000)  NULL,
    [Awt_comment]                    VARCHAR (255)   NULL,
    [APES_TXN_Id]                    INT             NULL,
    [GuidCode]                       VARCHAR (250)   NULL,
    [Charges_pwt_id]                 INT             NULL,
    [Charges_Type]                   VARCHAR (100)   NULL,
    [RequestBankTransfer]            VARCHAR (2000)  NULL,
    [ResponseBankTransfer]           VARCHAR (2000)  NULL,
    [BankTransfer_Status_code]       VARCHAR (50)    NULL,
    [BankTransfer_Status]            VARCHAR (150)   NULL,
    [BankTransfer_Callback]          VARCHAR (2000)  NULL,
    [BankTransfer_Callback_DateTime] DATETIME        NULL,
    [Refund]                         VARCHAR (1)     NULL,
    CONSTRAINT [PK_T_aepswallet] PRIMARY KEY CLUSTERED ([Awt_Id] ASC)
);


GO

CREATE TRIGGER [dbo].[AfterT_aepswallet] on [dbo].[T_aepswallet]
FOR INSERT 
AS DECLARE @Awt_memid INT,
	   @Awt_ClosingBalance  decimal(12,2)	  
SELECT @Awt_memid = ins.Awt_memid FROM INSERTED ins;
SELECT @Awt_ClosingBalance = ins.Awt_ClosingBalance FROM INSERTED ins;
update T_Member set Aeps_Wallet=@Awt_ClosingBalance,Updated_DateTime=getdate() where Mem_ID=@Awt_memid
