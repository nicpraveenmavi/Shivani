-- =============================================
-- Author: Saurabh
-- Create date: 31-Oct-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_UtilityPay]
	@memcode int,
	@apisourceid int,
	@mobileno bigint,
	@operatorcode varchar(50),
	@amount decimal(12, 2),
	@recmedium varchar(50),
	@reqtime datetime,
	@status varchar(500),
	@statusdesc varchar(50),
	@promo_id int,
	@IP varchar(50),
	@Res_TRNID varchar(50),
	@Ref_MobileNo bigint,
	@get_disc decimal(12, 3),
	@Mem_disc decimal(12, 3),
	@Org_disc decimal(12, 3),
	@StatusCode int,
	@ClientRefNo varchar(20),
	@ExtraFieldName1 varchar(50) = null,
	@ExtraFieldValue1 varchar(50) = null,
	@ExtraFieldName2 varchar(50) = null,
	@ExtraFieldValue2 varchar(50) = null,
	@TrnStatusCode int,
	@TrnStatusMsg varchar(500),
	@OprId varchar(50),
	@TrnStatus varchar(50),
	@Service_Sub_Category_Id int
AS
BEGIN
	SET NOCOUNT ON;
	declare @Recid int, @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100)

	set @TxnComment = 'Utility Payment against '+@operatorcode+' Bill';
	set @Recid = 0

	insert into T_Recharegerec (
		memcode, apisourceid, mobileno, operatorcode, amount, recmedium, reqtime, status, statusdesc, promo_id, IP, Res_TRNID, 
		Ref_MobileNo, get_disc, Mem_disc, Org_disc, StatusCode, ClientRefNo, ExtraFieldName1, ExtraFieldValue1, ExtraFieldName2, 
		ExtraFieldValue2, TrnStatusCode, TrnStatusMsg, OprId, TrnStatus, Service_Sub_Category_Id
	) values (
		@memcode, @apisourceid, @mobileno, @operatorcode, @amount, @recmedium, @reqtime, @status, @statusdesc, @promo_id, @IP, @Res_TRNID, 
		@Ref_MobileNo, @get_disc, @Mem_disc, @Org_disc, @StatusCode, @ClientRefNo, @ExtraFieldName1, @ExtraFieldValue1, @ExtraFieldName2, 
		@ExtraFieldValue2, @TrnStatusCode, @TrnStatusMsg, @OprId, @TrnStatus, @Service_Sub_Category_Id
	)
	set @Recid = (select SCOPE_IDENTITY());

	----Debit Txn Amt
	if @Recid > 0
	begin
		set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @memcode), 0)
		set @ClosingBal = (@OpeningBal - @amount)
		insert into T_MainWallet (
			Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
		) values (
			@memcode, @Recid, @OpeningBal, 0, @amount, @ClosingBal, @reqtime, @IP, @TxnComment, '', 0, 0
		)
	end

	select @Recid
END
