-- =============================================
-- Author: Saurabh Verma
-- Create date: 09-Nov-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPU_FundAddRequest]
	@auto_id int,
	@req_status varchar(10),
	@status_remark varchar(200) = null,
	@status_upd_date datetime,
	@status_upd_by varchar(50),
	@status_upd_ip varchar(20),
	@req_status_id int
AS
BEGIN
	SET NOCOUNT ON;
	declare @OpeningBal decimal(18,2), @ClosingBal decimal(18,2), @TxnComment varchar(100), @srv_type varchar(50), @mem_id int, @srv_amount decimal(18,2)

	set @srv_type = 'AFR_Funds'
	set @TxnComment = 'Add Fund Request Verified'
	select @mem_id = mem_id, @srv_amount = dep_amt from T_FundAddRequest where auto_id = @auto_id

	if exists (select mem_id from T_FundAddRequest where auto_id = @auto_id and status_upd_date is null)
	begin
		update T_FundAddRequest set 
			req_status = @req_status, status_remark = @status_remark, status_upd_date = @status_upd_date,
			status_upd_by = @status_upd_by, status_upd_ip = @status_upd_ip, req_status_id = @req_status_id
		where auto_id = @auto_id
		
		if @req_status_id = 1
		begin
			--Credit Txn Amt
			set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @mem_id), 0)
			set @ClosingBal = (@OpeningBal + @srv_amount)
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@mem_id, @auto_id, @OpeningBal, @srv_amount, 0, @ClosingBal, @status_upd_date, @status_upd_ip, @TxnComment, '', 0, 0
			)
		end
	end
END
