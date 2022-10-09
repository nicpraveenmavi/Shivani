-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Nov-2021
-- Alter date: 01-Dec-2021, 06-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPIU_Dmt_Comm]
	@memberid bigint,
	@txnid bigint,
	@txndate datetime,
	@IP varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @startloop int, @PackageId bigint, @TempMemId bigint, @Service_Category_Id int, @pkgcom_commtype int, @pkgcom_commcharge int, @txnamt decimal(18,2), 
		@uplinelevelupto int, @selfcommconfig decimal(18,2), @uplinecommconfig decimal(18,2), @uplineteamcommconfig decimal(18,2), @TempMemberCode varchar(50),
		@PackageCommId bigint
		
	Select @TempMemberCode = Mem_Code From T_Member Where Mem_ID = @memberid
	Select Top 1 @PackageId = Pp_Package_Id From T_Package Where Mem_Id = @memberid Order By Purchage_date Desc
	
	Select @txnamt = srv_amount From T_DmtService Where mem_id = @memberid And dmt_srv_id = @txnid And srv_type = 'DMT_MONEYTRNF' And srv_status = 'Success'

	/*
	NOTES:
	1. @pkgcom_commtype		value:   1 = fixed commission, 2 = percent, 3 = slab --This column value will affect all columns (pkgcom_commvalueforself, pkgcom_commvalueforupliner, pkgcom_commvaluefor6level)
	2. @pkgcom_commcharge	value:   1 = credit, 2 = debit --This column value will affect only on column "pkgcom_commvalueforself"
	*/
	Set @Service_Category_Id = 13 ---Is Only for Money Transfer From Table "M_Service_Type_Sub_Category" Column "Service_Sub_Category_Id"
	Set @uplinelevelupto = 6
	Select 
		@PackageCommId = pkgcom_id,
		@pkgcom_commtype = pkgcom_commtype, @pkgcom_commcharge = pkgcom_commcharge, @selfcommconfig = pkgcom_commvalueforself, 
		@uplinecommconfig = pkgcom_commvalueforupliner, @uplineteamcommconfig = pkgcom_commvaluefor6level
	From M_package_commission Where Packageid = @PackageId and pkgcom_servicesubcategoryid = @Service_Category_Id
	Set @pkgcom_commtype = isnull(@pkgcom_commtype, 0)
	Set @pkgcom_commcharge = isnull(@pkgcom_commcharge, 0)
	Set @selfcommconfig = isnull(@selfcommconfig, 0) 
	Set @uplinecommconfig = isnull(@uplinecommconfig, 0)
	Set @uplineteamcommconfig = isnull(@uplineteamcommconfig, 0)


	if @pkgcom_commtype = 3
	begin
		Select 
			@pkgcom_commtype = commtype, @pkgcom_commcharge = commcharge, @selfcommconfig = commissionself, 
			@uplinecommconfig = commissionupliner, @uplineteamcommconfig = commission6level
		From [M_package_commission _slab] Where pkgcom_id = @PackageCommId And @txnamt Between mintramnt And maxtramnt
	end
	Set @pkgcom_commtype = isnull(@pkgcom_commtype, 0)
	Set @pkgcom_commcharge = isnull(@pkgcom_commcharge, 0)
	Set @selfcommconfig = isnull(@selfcommconfig, 0) 
	Set @uplinecommconfig = isnull(@uplinecommconfig, 0)
	Set @uplineteamcommconfig = isnull(@uplineteamcommconfig, 0)

	
	Declare @MembersTable as Table (
		RowNo int identity(1,1), IsSelf int, SponsorId bigint, IncomeByMemberId bigint, IncomeByMemberCode varchar(50), SponsorLastPkgVal decimal(18,2), TxnAmount decimal(18,2), 
		CommPer decimal(18,2), CommAmt decimal(18,2), LevelNo int
	)
	if @pkgcom_commtype > 0 and @txnamt > 0
	begin
		-----Self Commission	
		--Insert Into @MembersTable (IsSelf, SponsorId, IncomeByMemberId, IncomeByMemberCode, SponsorLastPkgVal, TxnAmount, LevelNo)
		--Values (0, -1, @memberid, @TempMemberCode, isnull((Select top 1 bb.pkg_price_wo_gst From T_Package aa Inner Join M_Package bb On aa.Pp_Package_Id = bb.Package_ID Where aa.Mem_Id = @memberid order by aa.Purchage_date desc), 0), @txnamt, 0)

		Set @TempMemId = @memberid
		Set @startloop = 1
		While @startloop <= (@uplinelevelupto+1) ---@uplinelevelupto+1 == Because 1-Direct Upline + 6-next Upline after Direct Upline
		Begin
			If @TempMemId > 0
			Begin
				Insert Into @MembersTable (IsSelf, SponsorId, IncomeByMemberId, IncomeByMemberCode, SponsorLastPkgVal, TxnAmount, LevelNo)
				Select Case When @startloop = 1 Then 1 Else 2 End, sponsor_id as SponsorId, @memberid as IncomeByMemberId, @TempMemberCode as IncomeByMemberCode,
					isnull((Select top 1 bb.pkg_price_wo_gst From T_Package aa Inner Join M_Package bb On aa.Pp_Package_Id = bb.Package_ID Where aa.Mem_Id = a.sponsor_id order by aa.Purchage_date desc), 0) as SponsorLastPkgVal, 
					@txnamt as TxnAmount, @startloop as LevelNo
				From T_Member_Genealogy a Where mem_id = @TempMemId

				Select @TempMemId = isnull(sponsor_id, 0) From T_Member_Genealogy a Where mem_id = @TempMemId
			End
			
			Set @startloop = @startloop + 1
		End
	end

	Delete From @MembersTable Where SponsorId = 0
	Delete From @MembersTable Where RowNo > @uplinelevelupto
	Update @MembersTable Set CommPer = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 2 Then @selfcommconfig Else 0 End Where IsSelf = 0
	Update @MembersTable Set CommPer = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 2 Then @uplinecommconfig Else 0 End Where IsSelf = 1
	Update @MembersTable Set CommPer = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 2 Then @uplineteamcommconfig Else 0 End Where IsSelf = 2
	Update @MembersTable Set CommAmt = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 1 Then @selfcommconfig Else 0 End Where IsSelf = 0
	Update @MembersTable Set CommAmt = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 1 Then @uplinecommconfig Else 0 End Where IsSelf = 1
	--Update @MembersTable Set CommAmt = Case When SponsorLastPkgVal > 0 And @pkgcom_commtype = 1 Then @uplineteamcommconfig Else 0 End Where IsSelf = 2
	Update @MembersTable Set CommAmt = Case When CommPer > 0 Then (TxnAmount * CommPer / 100) Else CommAmt End
	Delete From @MembersTable Where CommAmt = 0


	Declare @rowno int, @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @CommAmt decimal(18,2), @CommPer decimal(18,2),
		@TxnComment varchar(500), @CommOnAmt Decimal(18,2), @IncomeByMemberId bigint, @LevelNo int
	Set @TempMemId = 0
	Select @rowno = min(RowNo) From @MembersTable
	While @rowno Is Not Null
	Begin
		Select @CommAmt = CommAmt, @CommPer = CommPer, @TempMemId = SponsorId, @TempMemberCode = IncomeByMemberCode, @CommOnAmt = TxnAmount, @IncomeByMemberId = IncomeByMemberId, @LevelNo = LevelNo From @MembersTable Where RowNo = @rowno
		Set @TxnComment = 'DMT Commission @'+Convert(Varchar(10), @CommPer)+'% On Amount '+Convert(Varchar(10), @CommOnAmt)+' by Member Code ' + @TempMemberCode

		--Credit Txn Amt
		set @OpeningBal = IsNull((select Payout_Wallet From T_Member where Mem_ID = @TempMemId), 0)
		set @ClosingBal = (@OpeningBal + @CommAmt)

		if not exists (select pwt_id from T_PayoutWallet where pwt_memid = @TempMemId and pwt_servicerefid = @txnid and pwt_datetime = @txndate And pwt_comment Like 'DMT Commission%')
		begin
			insert into T_PayoutWallet (
				pwt_memid, pwt_servicerefid, pwt_openingBalance, pwt_Credit, pwt_Debit, pwt_ClosingBalance, pwt_datetime, pwt_IP, pwt_comment, IncomeByMemId, IncomeByLevelNo
			) values (
				@TempMemId, @txnid, @OpeningBal, @CommAmt, 0, @ClosingBal, @txndate, @IP, @TxnComment, @IncomeByMemberId, @LevelNo
			)
		end

		Select @rowno = min(RowNo) From @MembersTable Where RowNo > @rowno
	End

	--Select * From @MembersTable
END
