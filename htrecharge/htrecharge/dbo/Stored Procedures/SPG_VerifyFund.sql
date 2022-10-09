-- =============================================
-- Author: Saurabh Verma
-- Create date: 08-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_VerifyFund]
	@sdate datetime,
	@edate datetime,
	@membermobno varchar(20) = null,
	@membercode varchar(20) = null,
	@status varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Table as Table (
		rowno bigint, record_id bigint, mem_id int, dep_mode varchar(50), txn_ref_no varchar(50), txn_remark varchar(200), dep_amt decimal(18, 2), 
		req_ip varchar(20), req_date datetime, req_status varchar(10), req_status_id int, status_remark varchar(200), status_upd_date datetime, 
		status_upd_by varchar(50), status_upd_ip varchar(20), status_upd_by_name varchar(100),
		Mem_Code varchar(20), Name varchar(200), Mobile varchar(20),

		prev_req_date datetime, prev_dep_amt decimal(18, 2), prev_req_status varchar(10), prev_req_status_id int, prev_status_remark varchar(200), prev_txn_ref_no varchar(50), prev_status_upd_date datetime
	)

	Insert Into @Table (
		rowno, record_id, mem_id, dep_mode, txn_ref_no, txn_remark, dep_amt, req_ip, req_date, req_status, req_status_id, status_remark, status_upd_date, 
		status_upd_by, status_upd_ip, Mem_Code, Name, Mobile, status_upd_by_name,
		prev_req_date, prev_dep_amt, prev_req_status, prev_status_remark, prev_txn_ref_no, prev_status_upd_date, prev_req_status_id
	)
	Select 
		ROW_NUMBER() OVER (ORDER By a.req_date) AS rowno, a.auto_id,
		a.mem_id, a.dep_mode, a.txn_ref_no, a.txn_remark, a.dep_amt, a.req_ip, a.req_date, a.req_status, a.req_status_id, a.status_remark, a.status_upd_date, 
		a.status_upd_by, a.status_upd_ip, b.Mem_Code, b.Name, b.Mobile,
		(Select Name From T_Users ia Where ia.User_ID = Convert(int, IsNull(status_upd_by, '0'))) as status_upd_by_name,

		(Select top 1 req_date From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc) as prev_req_date,
		IsNull((Select top 1 dep_amt From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc), 0) as prev_dep_amt,
		IsNull((Select top 1 req_status From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc), '') as prev_req_status,
		IsNull((Select top 1 status_remark From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc), '') as prev_status_remark,
		IsNull((Select top 1 txn_ref_no From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc), '') as prev_txn_ref_no,
		(Select top 1 status_upd_date From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc) as prev_status_upd_date,
		IsNull((Select top 1 req_status_id From T_FundAddRequest aa Where aa.mem_id = a.mem_id and aa.req_date < a.req_date order by aa.req_date desc), 0) as prev_req_status_id
	From T_FundAddRequest a
	Inner Join T_Member b On a.mem_id = b.Mem_ID
	Where 1 = 1
	And a.req_date between @sdate And @edate
	And b.Mobile = Case When IsNull(@membermobno, '') = '' Then b.Mobile Else @membermobno End
	And b.Mem_Code = Case When IsNull(@membercode, '') = '' Then b.Mem_Code Else @membercode End
	And a.req_status = Case When IsNull(@status, '') = '' Then a.req_status Else @status End


	Select * From @Table
END
