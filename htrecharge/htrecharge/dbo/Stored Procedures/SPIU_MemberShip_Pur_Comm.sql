-- =============================================
-- Author: Saurabh Verma
-- Create date: 12-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPIU_MemberShip_Pur_Comm]
	@memberid bigint,
	@purchasedate datetime,
	@IP varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @PkgPurch_id bigint, @PackageId bigint, @TempMemId bigint, @uplinelevelupto int, @startloop int, @pkg_price_wo_gst decimal(18,2), @uplinecommper decimal(18,2), 
		@nextuplinelevelcommper decimal(18,2), @uplinecommper_inact decimal(18,2), @nextuplinelevelcommper_inact decimal(18,2), @TempMemberCode varchar(50)

	Select @TempMemberCode = Mem_Code From T_Member Where Mem_ID = @memberid
    Select @PkgPurch_id = Pp_id, @PackageId = Pp_Package_Id From T_Package Where Mem_Id = @memberid and Purchage_date = @purchasedate
	Set @PackageId = IsNull(@PackageId, 0)

	Select @pkg_price_wo_gst = pkg_price_wo_gst, @uplinecommper = uplinecommper, @nextuplinelevelcommper = nextuplinelevelcommper, 
				@uplinelevelupto = uplinelevelupto, @uplinecommper_inact = uplinecommper_inact, @nextuplinelevelcommper_inact = nextuplinelevelcommper_inact 
	From M_Package Where Package_ID = @PackageId
	Set @pkg_price_wo_gst = IsNull(@pkg_price_wo_gst, 0)
	Set @uplinecommper = IsNull(@uplinecommper, 0)
	Set @nextuplinelevelcommper = IsNull(@nextuplinelevelcommper, 0)
	Set @uplinelevelupto = IsNull(@uplinelevelupto, 0)
	Set @uplinecommper_inact = IsNull(@uplinecommper_inact, 0)
	Set @nextuplinelevelcommper_inact = IsNull(@nextuplinelevelcommper_inact, 0)

	Declare @MembersTable as Table (
		RowNo int identity(1,1), SponsorId bigint, IncomeByMemberId bigint, IncomeByMemberCode varchar(50), SponsorLastPkgVal decimal(18,2), MemberJoinPkgVal decimal(18,2), 
		CommPer decimal(18,2), CommAmt decimal(18,2), LevelNo int
	)
	if @pkg_price_wo_gst > 0
	begin
		Set @TempMemId = @memberid
		Set @startloop = 1
		
		While @startloop <= (@uplinelevelupto+1) ---@uplinelevelupto+1 == Because 1-Direct Upline + 6-next Upline after Direct Upline
		Begin
			If @TempMemId > 0
			Begin
				Insert Into @MembersTable (SponsorId, IncomeByMemberId, IncomeByMemberCode, SponsorLastPkgVal, MemberJoinPkgVal, LevelNo)
				Select sponsor_id as SponsorId, @memberid as IncomeByMemberId, @TempMemberCode as IncomeByMemberCode,
					isnull((Select top 1 bb.pkg_price_wo_gst From T_Package aa Inner Join M_Package bb On aa.Pp_Package_Id = bb.Package_ID Where aa.Mem_Id = a.sponsor_id order by aa.Purchage_date desc), 0) as SponsorLastPkgVal, 
					@pkg_price_wo_gst as MemberJoinPkgVal, @startloop as LevelNo
				From T_Member_Genealogy a Where mem_id = @TempMemId

				Select @TempMemId = isnull(sponsor_id, 0) From T_Member_Genealogy a Where mem_id = @TempMemId
			End
			
			Set @startloop = @startloop + 1
		End
	end

	Delete From @MembersTable Where SponsorId = 0
	Delete From @MembersTable Where RowNo > @uplinelevelupto
	Update @MembersTable Set CommPer = Case When SponsorLastPkgVal > 0 Then @uplinecommper Else @uplinecommper_inact End Where RowNo = 1
	Update @MembersTable Set CommPer = Case When SponsorLastPkgVal > 0 Then @nextuplinelevelcommper Else @nextuplinelevelcommper_inact End Where RowNo > 1 And RowNo <= @uplinelevelupto
	Update @MembersTable Set CommAmt = MemberJoinPkgVal * CommPer / 100
	Delete From @MembersTable Where CommAmt = 0


	Declare @rowno int, @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @CommAmt decimal(18,2), @CommPer decimal(18,2),
		@TxnComment varchar(500), @CommOnAmt Decimal(18,2), @IncomeByMemberId bigint, @LevelNo int
	Set @TempMemId = 0
	Select @rowno = min(RowNo) From @MembersTable
	While @rowno Is Not Null
	Begin
		Select @CommAmt = CommAmt, @CommPer = CommPer, @TempMemId = SponsorId, @TempMemberCode = IncomeByMemberCode, @CommOnAmt = MemberJoinPkgVal, @IncomeByMemberId = IncomeByMemberId, @LevelNo = LevelNo From @MembersTable Where RowNo = @rowno
		Set @TxnComment = 'Membership Purchase Commission @'+Convert(Varchar(10), @CommPer)+'% On Amount '+Convert(Varchar(10), @CommOnAmt)+' by Member Code ' + @TempMemberCode

		--Credit Txn Amt
		set @OpeningBal = IsNull((select Payout_Wallet From T_Member where Mem_ID = @TempMemId), 0)
		set @ClosingBal = (@OpeningBal + @CommAmt)

		if not exists (select pwt_id from T_PayoutWallet where pwt_memid = @TempMemId and pwt_servicerefid = @PkgPurch_id and pwt_datetime = @purchasedate And pwt_comment Like 'Membership Purchase Commission%')
		begin
			insert into T_PayoutWallet (
				pwt_memid, pwt_servicerefid, pwt_openingBalance, pwt_Credit, pwt_Debit, pwt_ClosingBalance, pwt_datetime, pwt_IP, pwt_comment, IncomeByMemId, IncomeByLevelNo
			) values (
				@TempMemId, @PkgPurch_id, @OpeningBal, @CommAmt, 0, @ClosingBal, @purchasedate, @IP, @TxnComment, @IncomeByMemberId, @LevelNo
			)
		end

		Select @rowno = min(RowNo) From @MembersTable Where RowNo > @rowno
	End

	--Select * From @MembersTable
END
