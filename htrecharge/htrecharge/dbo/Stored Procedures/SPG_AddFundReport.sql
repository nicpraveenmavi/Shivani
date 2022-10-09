-- =============================================
-- Author: Saurabh Verma
-- Create date: 10-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_AddFundReport]
	@pageno int,
	@pagesize int,
	@memberid bigint,
	@sdate datetime,
	@edate datetime,
	@srf_ref_no varchar(20) = null,
	@req_status_id int = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		auto_id bigint, mem_id bigint, dep_mode varchar(20), txn_ref_no varchar(100), txn_remark varchar(200), dep_amt decimal(18, 2), req_date datetime, 
		req_status_id int, req_status varchar(10), status_remark varchar(200), 
		status_upd_date datetime
	)

	Insert Into @TxnTable (
		rowno, auto_id, mem_id, dep_mode, txn_ref_no, txn_remark, dep_amt, req_date, req_status_id, req_status, status_remark, status_upd_date
	)
	Select 
		ROW_NUMBER() OVER (ORDER By req_date desc) AS rowno, auto_id, mem_id, dep_mode, txn_ref_no, txn_remark, dep_amt, req_date, req_status_id, 
		req_status, status_remark, status_upd_date
	From T_FundAddRequest Where 1 = 1
	and req_date between @sdate and @edate
	and mem_id = case when isnull(@memberid, 0) = 0 then mem_id else @memberid end
	and txn_ref_no = case when isnull(@srf_ref_no, '') = '' then txn_ref_no else @srf_ref_no end
	and req_status_id = case when isnull(@req_status_id, -1) = -1 then req_status_id else @req_status_id end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
