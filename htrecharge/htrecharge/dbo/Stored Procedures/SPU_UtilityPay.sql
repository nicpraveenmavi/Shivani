-- =============================================
-- Author: Saurabh
-- Create date: 31-Oct-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPU_UtilityPay]
	@Recid int,
	@memcode int,
	@restime datetime,
	@status varchar(500),
	@statusdesc varchar(50),
	@Res_TRNID varchar(50),
	@StatusCode int,
	@TrnStatusCode int,
	@TrnStatusMsg varchar(500),
	@OprId varchar(50),
	@IP varchar(50),
	@TrnStatus varchar(50)
AS
BEGIN
	SET NOCOUNT ON;
	declare @OpeningBal decimal(18,2), @ClosingBal decimal(18,2), @TxnComment varchar(100), @amount decimal(18,2)

	select * into #TempRecTable from T_Recharegerec where Recid = @Recid and memcode = @memcode
	if exists (select recid from #TempRecTable)
	begin
		set @TxnComment = 'Failed Utility Payment against '+isnull((select operatorcode from #TempRecTable), '')+' Bill ('+@TrnStatusMsg+')';
		set @amount = isnull((select amount from #TempRecTable), 0)

		update T_Recharegerec set
			restime = @restime, status = @status, statusdesc = @statusdesc, Res_TRNID = @Res_TRNID, StatusCode = @StatusCode, 
			TrnStatusCode = @TrnStatusCode, TrnStatusMsg = @TrnStatusMsg, OprId = @OprId, TrnStatus = @TrnStatus
		where Recid = @Recid and memcode = @memcode

		if upper(@TrnStatusCode) in (2,3,5)
		begin
			----Debit Txn Amt
			set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @memcode), 0)
			set @ClosingBal = (@OpeningBal + @amount)
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@memcode, @Recid, @OpeningBal, @amount, 0, @ClosingBal, @restime, @IP, @TxnComment, '', 0, 0
			)
		end
	end
	else
	begin
		set @Recid = -1
	end

	drop table #TempRecTable
	select @Recid

	if upper(@status) = 'SUCCESS'
	begin
	declare @Servive_sub_Categoryid varchar(50),@memberid int
	set @memberid=@Recid
	select @Servive_sub_Categoryid=Service_Sub_Category_Id from T_Recharegerec
		exec [dbo].[SPI_Dmt_Commission] @memberid, @memcode, @Res_TRNID, @restime, @IP,@TrnStatus,@Servive_sub_Categoryid
	end

	
END

