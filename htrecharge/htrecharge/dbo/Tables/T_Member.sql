CREATE TABLE [dbo].[T_Member] (
    [Mem_ID]                  INT             IDENTITY (1, 1) NOT NULL,
    [Mem_Code]                VARCHAR (10)    NULL,
    [Name]                    VARCHAR (100)   NULL,
    [Mobile]                  BIGINT          NULL,
    [Password]                NCHAR (10)      NULL,
    [Main_wallet]             DECIMAL (12, 3) CONSTRAINT [DF_T_Member_Main_wallet] DEFAULT ((0.00)) NULL,
    [Payout_Wallet]           DECIMAL (12, 3) CONSTRAINT [DF_T_Member_Payout_Wallet] DEFAULT ((0.00)) NULL,
    [Coin_Wallet]             DECIMAL (12, 2) CONSTRAINT [DF_T_Member_Coin_Wallet] DEFAULT ((0.00)) NULL,
    [Referred_By]             VARCHAR (50)    CONSTRAINT [df_Referred_By] DEFAULT ('S100002720') NULL,
    [Created_By]              INT             NULL,
    [Created_On]              DATETIME        NULL,
    [Mem_Status]              VARCHAR (1)     NULL,
    [Token]                   VARCHAR (255)   NULL,
    [OTP]                     INT             NULL,
    [OTP_EntryDateTime]       DATETIME        NULL,
    [Updated_By]              INT             NULL,
    [Updated_DateTime]        DATETIME        NULL,
    [Last_Login_DateTime]     DATETIME        NULL,
    [LogOutDateTime]          DATETIME        NULL,
    [Mobile_Verified]         VARCHAR (1)     NULL,
    [Web_Last_Login_DateTime] DATETIME        NULL,
    [Web_LogOutDateTime]      DATETIME        NULL,
    [Aeps_Wallet]             DECIMAL (18, 3) CONSTRAINT [df_Aeps_Wallet] DEFAULT ('0.000') NULL,
    CONSTRAINT [PK_T_Member] PRIMARY KEY CLUSTERED ([Mem_ID] ASC)
);


GO
CREATE TRIGGER [dbo].[AfterT_Member] 
	ON [dbo].[T_Member] 
	FOR INSERT 
AS 
	DECLARE @memid INT, @Referred_By varchar(50), @Referred_By_mem_ID int, @m_tree Varchar(50) = null, 
		@S_m_tree Varchar(50) = null, @Validfor int = null

	SELECT @memid = ins.Mem_ID, @Referred_By = Referred_By FROM INSERTED ins;
	select  @Referred_By_mem_ID = mem_Id from T_Member where Mem_Code = @Referred_By

	insert into T_Member_Info(Memid, Meminfo_membertype) values (@memid,'Customer')

	select @Validfor = Validfor from [M_Package]  where Package_Id = 1
	insert into [T_Package] (Pp_Package_Id,Mem_Id,Purchage_date,Created_DateTime,Expiry_Date) values (1,@memid,getdate(),getdate(), DATEADD(day, @Validfor, getdate()))

	declare @level int =null
	select @level = level from  T_Member_Genealogy  where mem_id=@Referred_By_mem_ID
	set @level =(convert( int, isnull(@level,'0'))+1)

	select @S_m_tree=m_tree from T_Member_Genealogy where mem_id=@Referred_By_mem_ID
	if(@S_m_tree is not null )
	begin
		--set @m_tree=   @S_m_tree +','+convert(varchar(30), @Referred_By) --Code commented by Saurabh, On 29-Nov-2021
		--set @m_tree = @S_m_tree +','+convert(varchar(30), @memid) --Add by Saurabh, On 29-Nov-2021
		set @m_tree = @S_m_tree+convert(varchar(30), @memid)+',' --Add by Saurabh, On 03-Dec-2021
	end
	else
	begin
		--set @m_tree = @Referred_By
		set @m_tree = @Referred_By_mem_ID
	end

	insert into T_Member_Genealogy (mem_id,sponsor_id,sponsor_code,created_on,m_tree,Level) values (@memid,@Referred_By_mem_ID,@Referred_By,getdate(),@m_tree,@level)

	---- default coin balance-----
	insert into T_CoinWallet (
		cwt_memid, cwt_openingBalance, cwt_Credit, cwt_Debit, cwt_ClosingBalance, cwt_datetime, cwt_comment, IncomeByMemId, IncomeByLevelNo
	) values (
		@memid, 0.0, 50.0, 0.0, 50.0, getdate(), 'Joining Coin', 0, 0
	)
	
	---- Refered coin balance-----
	declare @OpenBlancce decimal(18,3) = null
	select @OpenBlancce = Coin_Wallet From T_Member where Mem_ID = @Referred_By_mem_ID
	insert into T_CoinWallet (
		cwt_memid, cwt_openingBalance, cwt_Credit, cwt_Debit, cwt_ClosingBalance, cwt_datetime, cwt_comment, IncomeByMemId, IncomeByLevelNo
	) values (
		@Referred_By_mem_ID, @OpenBlancce, 50.0, 0.0, (@OpenBlancce + 50.0), getdate(), 'Refered Coin', @memid, 1
	)

