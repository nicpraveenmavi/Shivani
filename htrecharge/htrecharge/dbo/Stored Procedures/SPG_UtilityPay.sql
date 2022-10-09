-- =============================================
-- Author: Saurabh
-- Create date: 31-Dec-2021
-- Create date: 31-Jan-2022
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPG_UtilityPay]
	@pageno int,
	@pagesize int,
	@memberid bigint,
	@sdate datetime,
	@edate datetime,
	@accountNo varchar(20) = null,
	@refMobileNo varchar(20) = null,
	@txnStatusCode int = null,
	@transactionRefNo varchar(30) = null,
	@transactionId varchar(30) = null,
	@membermobno varchar(20) = null,
	@membercode varchar(20) = null,
	@servicecategoryid int = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		Recid int, memcode int, mobileno varchar(50), operatorcode varchar(50), amount decimal(12, 2), reqtime datetime, restime datetime, 
		statusdesc varchar(500), status varchar(50), Res_TRNID varchar(50), Ref_MobileNo bigint, StatusCode int, ClientRefNo varchar(20), 
		TrnStatusCode int, TrnStatusMsg varchar(500), OprId varchar(50), TrnStatus varchar(50),
		Mem_Code varchar(50), MemberName varchar(150), Mobile varchar(50), ServiceName varchar(150)
	)

	Insert Into @TxnTable (
		rowno, Recid, memcode, mobileno, operatorcode, amount, reqtime, restime, statusdesc, status, Res_TRNID, Ref_MobileNo, StatusCode, ClientRefNo, 
		TrnStatusCode, TrnStatusMsg, OprId, TrnStatus, Mem_Code, MemberName, Mobile, ServiceName
	)
	Select 
		ROW_NUMBER() OVER (ORDER By reqtime desc) AS rowno, Recid, memcode, mobileno, operatorcode, amount, reqtime, restime, statusdesc,
		status, Res_TRNID, Ref_MobileNo, StatusCode, ClientRefNo, TrnStatusCode, TrnStatusMsg, OprId, TrnStatus,
		Mem_Code, MemberName, MemberMobile, ServiceName
	From (
		Select Recid, memcode, mobileno, operatorcode, amount, reqtime, restime, statusdesc,
			a.status, Res_TRNID, Ref_MobileNo, StatusCode, ClientRefNo, TrnStatusCode, TrnStatusMsg, OprId, TrnStatus,
			b.Mem_Code, b.[Name] as MemberName, b.Mobile as MemberMobile, a.Service_Sub_Category_Id, c.Service_Category_Id,
			c.Sub_Category_Name as ServiceName
		From T_Recharegerec a
		Inner Join T_Member b On a.memcode = b.Mem_ID
		Inner Join M_Service_Type_Sub_Category c On a.Service_Sub_Category_Id = c.Service_Sub_Category_Id
	) as t Where 1 = 1
	and Service_Category_Id = 6
	and reqtime between @sdate and @edate
	and memcode = case when isnull(@memberid, 0) = 0 then memcode else @memberid end
	and mobileno = case when isnull(@accountNo, '') = '' then mobileno else @accountNo end
	and Ref_MobileNo = case when isnull(@refMobileNo, '') = '' then Ref_MobileNo else @refMobileNo end
	and TrnStatusCode = case when isnull(@txnStatusCode, -1) = -1 then TrnStatusCode else @txnStatusCode end
	and ClientRefNo = case when isnull(@transactionRefNo, '') = '' then ClientRefNo else @transactionRefNo end
	and Ref_MobileNo = case when isnull(@transactionId, '') = '' then Ref_MobileNo else @transactionId end
	and Mem_Code = case when isnull(@membercode, '') = '' then Mem_Code else @membercode end
	and MemberMobile = case when isnull(@membermobno, '') = '' then MemberMobile else @membermobno end
	and Service_Category_Id = case when isnull(@servicecategoryid, 0) = 0 then Service_Category_Id else @servicecategoryid end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
