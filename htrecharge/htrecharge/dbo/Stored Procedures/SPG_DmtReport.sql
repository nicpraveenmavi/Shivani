-- =============================================
-- Author: Saurabh Verma
-- Create date: 1-Nov-2021
-- Alter date: 10-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_DmtReport]
	@pageno int,
	@pagesize int,
	@memberid bigint,
	@sdate datetime,
	@edate datetime,
	@srf_ref_no varchar(20) = null,
	@srv_resp_ref_no varchar(20) = null,
	@srv_resp_trn_no varchar(20) = null,
	@srv_status varchar(20) = null,
	@beneaccno varchar(20) = null,
	@benemobno varchar(20) = null,
	@sendermobno varchar(20) = null,
	@membercode varchar(20) = null,
	@srv_type varchar(20) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		dmt_srv_id bigint, srv_type varchar(50), txn_type varchar(50), mem_id bigint, srv_date datetime, sender_mobile_no varchar(20), sender_name varchar(100), 
		bene_id varchar(10), bene_name varchar(100), bene_mobile varchar(20), bene_bank_id int, bene_bank_name varchar(100), bene_bank_acno varchar(20), bene_bank_ifsc varchar(20),
		srv_amount decimal(18, 2), srv_charge decimal(18, 2), srv_totamt decimal(18, 2), srf_ref_no varchar(20), srv_status varchar(10), srv_status_desc varchar(500), 
		srv_resp_date datetime, srv_resp_ref_no varchar(20), srv_resp_trn_no varchar(20), ipaddress varchar(20),
		Mem_Code varchar(20), MemberName varchar(200), Mobile varchar(20)
	)

	Insert Into @TxnTable (
		rowno, dmt_srv_id, srv_type, txn_type, mem_id, srv_date, sender_mobile_no, sender_name, 
		bene_id, bene_name, bene_mobile, bene_bank_id, bene_bank_name, bene_bank_acno, bene_bank_ifsc,
		srv_amount, srv_charge, srv_totamt, srf_ref_no, srv_status, srv_status_desc, srv_resp_date, srv_resp_ref_no, srv_resp_trn_no, ipaddress,
		Mem_Code, MemberName, Mobile
	)
	Select 
		ROW_NUMBER() OVER (ORDER By srv_date desc) AS rowno, dmt_srv_id, srv_type, txn_type, mem_id, srv_date, sender_mobile_no, sender_name, 
		bene_id, bene_name, bene_mobile, bene_bank_id, bene_bank_name, bene_bank_acno, bene_bank_ifsc,
		srv_amount, srv_charge, srv_totamt, srf_ref_no, srv_status, srv_status_desc, srv_resp_date, srv_resp_ref_no, srv_resp_trn_no, ipaddress,
		Mem_Code, MemberName, Mobile
	From (
		Select srv_type,
			Case When srv_type = 'DMT_VERIFYBENE' Then 'Beneficiary Activation' Else 'Money Transfer' End as txn_type,
			dmt_srv_id, a.mem_id, srv_date, sender_mobile_no, sender_name, 
			bene_id, bene_name, bene_mobile, bene_bank_id, bene_bank_name, bene_bank_acno, bene_bank_ifsc,
			srv_amount, srv_charge, srv_totamt, srf_ref_no, srv_status, srv_status_desc, srv_resp_date, srv_resp_ref_no, srv_resp_trn_no, ipaddress,
			b.Mem_Code, b.[Name] as MemberName, b.Mobile
		From T_DmtService a
		Inner Join T_Member b On a.mem_id = b.Mem_ID
	) as t Where 1 = 1
	and srv_type = case when isnull(@srv_type, '') = '' then srv_type else @srv_type end
	and srv_date between @sdate and @edate
	and mem_id = case when isnull(@memberid, 0) = 0 then mem_id else @memberid end
	and sender_mobile_no = case when isnull(@sendermobno, '') = '' then sender_mobile_no else @sendermobno end
	and bene_bank_acno = case when isnull(@beneaccno, '') = '' then bene_bank_acno else @beneaccno end
	and bene_mobile = case when isnull(@benemobno, '') = '' then bene_mobile else @benemobno end
	and srv_status = case when isnull(@srv_status, '') = '' then srv_status else @srv_status end
	and srf_ref_no = case when isnull(@srf_ref_no, '') = '' then srf_ref_no else @srf_ref_no end
	and srv_resp_ref_no = case when isnull(@srv_resp_ref_no, '') = '' then srv_resp_ref_no else @srv_resp_ref_no end
	and srv_resp_trn_no = case when isnull(@srv_resp_trn_no, '') = '' then srv_resp_trn_no else @srv_resp_trn_no end
	and Mem_Code = case when isnull(@membercode, '') = '' then Mem_Code else @membercode end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
