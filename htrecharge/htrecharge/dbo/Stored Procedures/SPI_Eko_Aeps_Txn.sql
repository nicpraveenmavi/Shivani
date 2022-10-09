-- =============================================
-- Author: Saurabh Verma
-- Create date: 26-Nov-2021
-- Alter date: 01-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPI_Eko_Aeps_Txn]
	@entrylogdate datetime,
	@status	int,
	@response_status_id int,
	@response_type_id int,
	@message varchar(300),
	@tx_status int,
	@transaction_date varchar(30) = '',
	@reason varchar(300) = '',
	@amount varchar(20) = '',
	@merchant_code varchar(150) = '',
	@tds varchar(20) = '',
	@shop varchar(150) = '',
	@sender_name varchar(150) = '',
	@tid varchar(150) = '',
	@auth_code varchar(150) = '',
	@balance varchar(20) = '',
	@shop_address_line1 varchar(150) = '',
	@user_code varchar(50) = '',
	@merchantname varchar(150) = '',
	@stan varchar(150) = '',
	@aadhaar varchar(50) = '',
	@customer_balance varchar(20) = '',
	@transaction_time varchar(20) = '',
	@commission varchar(20) = '',
	@bank_ref_num varchar(30) = '',
	@terminal_id varchar(30) = '',
	@ipaddress varchar(20) = ''
AS
BEGIN
	SET NOCOUNT ON;
	Declare @mem_id int, @onboarduserid bigint, @TxnId bigint

	Select @mem_id = mem_id, @onboarduserid = onboarduserid From T_Eko_Aeps_Member Where user_code = @user_code
	set @mem_id = isnull(@mem_id, 0)
	set @onboarduserid = isnull(@onboarduserid, 0)

    Insert Into T_Eko_Aeps_Txn (
		entrylogdate, mem_id, onboarduserid, status, response_status_id, response_type_id, message, tx_status, transaction_date, reason, amount, 
		merchant_code, tds, shop, sender_name, tid, auth_code, balance, shop_address_line1, user_code, merchantname, stan, aadhaar, 
		customer_balance, transaction_time, commission, bank_ref_num, terminal_id, ipaddress
	) Values (
		@entrylogdate, @mem_id, @onboarduserid, @status, @response_status_id, @response_type_id, @message, @tx_status, @transaction_date, @reason, @amount, 
		@merchant_code, @tds, @shop, @sender_name, @tid, @auth_code, @balance, @shop_address_line1, @user_code, @merchantname, @stan, @aadhaar, 
		@customer_balance, @transaction_time, @commission, @bank_ref_num, @terminal_id, @ipaddress
	)
	Set @TxnId = (Select Scope_Identity())

	--add transation amount in wallet for successfull transaction
	declare @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100)
	if @tx_status = 0
	begin
		Set @TxnComment = 'Aeps Transaction for Aadhar '+@aadhaar
		--Credit Txn Amt
		set @OpeningBal = IsNull((select Aeps_Wallet From T_Member where Mem_ID = @mem_id), 0)
		set @ClosingBal = (@OpeningBal + @amount)
		insert into T_aepswallet(
			Awt_memid, Awt_servicerefid, Awt_openingBalance, Awt_Credit, Awt_Debit, Awt_ClosingBalance, Awt_datetime, Awt_IP, Awt_comment, APES_TXN_Id, BankTransfer_Status, Refund
		) values (
			@mem_id, @TxnId, @OpeningBal, @amount, 0, @ClosingBal, @entrylogdate, @ipaddress, @TxnComment, @bank_ref_num, 'Success', 0
		)


		exec [dbo].[SPIU_Eko_Aeps_Comm] @mem_id, @TxnId, @entrylogdate, @ipaddress
	end
END

