-- =============================================
-- Author: Saurabh
-- Create date: 27-Oct-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_RDMT_Service]
	@mem_id int,
	@srv_type varchar(50),
	@srv_date datetime,
	@sender_mobile_no varchar(20),
	@sender_name varchar(100),
	@sender_transferlimit decimal(18, 2),
	@sender_used decimal(18, 2),
	@sender_remain decimal(18, 2),
	@bene_id varchar(10),
	@bene_name	varchar(100),
	@bene_mobile varchar(20),
	@bene_bank_id int,
	@bene_bank_name varchar(100),
	@bene_bank_acno varchar(20),
	@bene_bank_ifsc varchar(20),
	@srv_amount decimal(18, 2),
	@srv_charge decimal(18, 2),
	@srv_totamt decimal(18, 2),
	@srf_ref_no varchar(20),
	@srv_status varchar(10),
	@srv_status_desc varchar(500),
	@srv_resp_date datetime = null,
	@srv_resp_json varchar(MAX),
	@srv_resp_ref_no varchar(20),
	@srv_resp_trn_no varchar(20),
	@ipaddress varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	declare @dmt_srv_id bigint, @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100), @TxnComment2 varchar(100)

	set @TxnComment = case when @srv_type = 'DMT_VERIFYBENE' then 'Beneficiary Verification' else 'Money Transfer' end
	set @TxnComment2 = 'Money Transfer Service Charge'
	set @dmt_srv_id = 0

	insert into T_DmtService (
		mem_id, srv_type, srv_date, sender_mobile_no, sender_name, sender_transferlimit, sender_used, sender_remain, 
		bene_id, bene_name, bene_mobile, bene_bank_id, bene_bank_name, bene_bank_acno, bene_bank_ifsc, 
		srv_amount, srv_charge, srv_totamt, srf_ref_no, srv_status, srv_status_desc, srv_resp_date, srv_resp_json, srv_resp_ref_no, srv_resp_trn_no, 
		ipaddress, dmt_totalcharge, dmt_charge, dmt_gst, dmt_apbd, dmt_atds
	) values (
		@mem_id, @srv_type, @srv_date, @sender_mobile_no, @sender_name, @sender_transferlimit, @sender_used, @sender_remain, 
		@bene_id, @bene_name, @bene_mobile, @bene_bank_id, @bene_bank_name, @bene_bank_acno, @bene_bank_ifsc, 
		@srv_amount, @srv_charge, @srv_totamt, @srf_ref_no, @srv_status, @srv_status_desc, @srv_resp_date, @srv_resp_json, @srv_resp_ref_no, @srv_resp_trn_no, 
		@ipaddress, 0, 0, 0, 0, 0
	)
	set @dmt_srv_id = (select SCOPE_IDENTITY());

	--Debit Txn Amt
	set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @mem_id), 0)
	set @ClosingBal = (@OpeningBal - @srv_amount)
	insert into T_MainWallet (
		Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
	) values (
		@mem_id, @dmt_srv_id, @OpeningBal, 0, @srv_amount, @ClosingBal, @srv_date, @ipaddress, @TxnComment, '', 0, 0
	)
	
	--Debit Txn Service Charge Amt
	if @srv_charge > 0
	begin
		set @OpeningBal = @ClosingBal
		set @ClosingBal = (@OpeningBal - @srv_charge)
		insert into T_MainWallet (
			Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
		) values (
			@mem_id, @dmt_srv_id, @OpeningBal, 0, @srv_charge, @ClosingBal, @srv_date, @ipaddress, @TxnComment2, '', 0, 0
		)
	end

	--------Deduct the total amount from "Main_wallet" column in table T_Member
	------update T_Member set Main_wallet = @ClosingBal where Mem_ID = @mem_id
	
	if upper(@srv_status) = 'SUCCESS'
	begin
		exec [dbo].[SPIU_Dmt_Comm] @mem_id, @dmt_srv_id, @srv_date, @ipaddress
	end

	select @dmt_srv_id
END
