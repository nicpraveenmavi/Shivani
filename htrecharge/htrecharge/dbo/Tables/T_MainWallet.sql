CREATE TABLE [dbo].[T_MainWallet] (
    [Mwt_id]             INT             IDENTITY (1, 1) NOT NULL,
    [Mwt_memid]          INT             NULL,
    [Mwt_servicerefid]   INT             NULL,
    [Mwt_openingBalance] DECIMAL (12, 2) NULL,
    [Mwt_Credit]         DECIMAL (12, 2) NULL,
    [Mwt_Debit]          DECIMAL (12, 2) NULL,
    [Mwt_ClosingBalance] DECIMAL (12, 2) NULL,
    [Mwt_datetime]       DATETIME        NULL,
    [Mwt_IP]             VARCHAR (100)   NULL,
    [Mwt_comment]        VARCHAR (255)   NULL,
    [Ref_No]             VARCHAR (100)   NULL,
    [BankID]             INT             NULL,
    [Pg_Id]              INT             NULL,
    CONSTRAINT [PK_T_MainWallet] PRIMARY KEY CLUSTERED ([Mwt_id] ASC)
);


GO

CREATE TRIGGER [dbo].[AfterINSERTTrigger] on [dbo].[T_MainWallet]
FOR INSERT 
AS DECLARE @Mwt_memid INT,
	   @Mwt_ClosingBalance  decimal(12,2)
	  
SELECT @Mwt_memid = ins.Mwt_memid FROM INSERTED ins;
SELECT @Mwt_ClosingBalance = ins.Mwt_ClosingBalance FROM INSERTED ins;
--SELECT @EmpEducation = ins.Education FROM INSERTED ins;
--SELECT @EmpOccupation = ins.Occupation FROM INSERTED ins;
--SELECT @EmpYearlyIncome = ins.YearlyIncome FROM INSERTED ins;
--SELECT @EmpSales = ins.Sales FROM INSERTED ins;

update T_Member set Main_wallet=@Mwt_ClosingBalance,Updated_DateTime=getdate() where Mem_ID=@Mwt_memid
