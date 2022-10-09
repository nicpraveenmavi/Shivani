-- =============================================
-- Author: Saurabh
-- Create date: 27-Oct-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPU_RDMT_Service]
	@dmt_srv_id bigint,
	@mem_id int,
	@srv_type varchar(50),
	@srv_status varchar(10),
	@srv_status_desc varchar(500),
	@srv_resp_date datetime,
	@srv_resp_json varchar(MAX),
	@srv_resp_ref_no varchar(20),
	@srv_resp_trn_no varchar(20),
	@ipaddress varchar(20),
	@dmt_totalcharge float,
	@dmt_charge float,
	@dmt_gst float,
	@dmt_apbd float,
	@dmt_atds float
AS
BEGIN
	SET NOCOUNT ON;
	declare @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100), @TxnComment2 varchar(100), 
		@srv_amount decimal(18,2), @srv_charge decimal(18,2)

	set @TxnComment = case when @srv_type = 'DMT_VERIFYBENE' then 'Refund Beneficiary Verification' else 'Refund Money Transfer' end
	set @TxnComment2 = 'Refund Money Transfer Service Charge'

	update T_DmtService set srv_status = @srv_status, srv_status_desc = @srv_status_desc, srv_resp_date = @srv_resp_date, 
			srv_resp_json = @srv_resp_json, srv_resp_ref_no = @srv_resp_ref_no, srv_resp_trn_no = @srv_resp_trn_no,
			dmt_totalcharge = @dmt_totalcharge, dmt_charge = @dmt_charge, dmt_gst = @dmt_gst, dmt_apbd = @dmt_apbd, dmt_atds = @dmt_atds
	where dmt_srv_id = @dmt_srv_id
	
	if upper(@srv_status) = 'FAILED'
	begin
		--Rollback txn amount
		select @srv_amount = srv_amount, @srv_charge = srv_charge from T_DmtService where dmt_srv_id = @dmt_srv_id
		
		--Credit Txn Amt
		set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @mem_id), 0)
		set @ClosingBal = (@OpeningBal + @srv_amount)
		insert into T_MainWallet (
			Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
		) values (
			@mem_id, @dmt_srv_id, @OpeningBal, @srv_amount, 0, @ClosingBal, @srv_resp_date, @ipaddress, @TxnComment, '', 0, 0
		)
	
		--Debit Txn Service Charge Amt
		if @srv_charge > 0
		begin
			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal + @srv_charge)
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@mem_id, @dmt_srv_id, @OpeningBal, @srv_charge, 0, @ClosingBal, @srv_resp_date, @ipaddress, @TxnComment2, '', 0, 0
			)
		end

		--------Deduct the total amount from "Main_wallet" column in table T_Member
		------update T_Member set Main_wallet = @ClosingBal where Mem_ID = @mem_id
	end
	
	if upper(@srv_status) = 'SUCCESS'
	begin
		exec [dbo].[SPIU_Dmt_Comm] @mem_id, @dmt_srv_id, @srv_resp_date, @ipaddress
	end
END
