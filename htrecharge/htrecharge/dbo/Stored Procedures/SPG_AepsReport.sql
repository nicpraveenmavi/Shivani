-- =============================================
-- Author: Saurabh Verma
-- Create date: 28-Dec-2021
-- Alter date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_AepsReport]
	@pageno int,
	@pagesize int,
	@memberid bigint,
	@merchantusercode varchar(20) = null,
	@merchantusermob varchar(20) = null,
	@sdate datetime,
	@edate datetime,
	@bankrefno varchar(20) = null,
	@txnid varchar(20) = null,
	@txstatus int = null,
	@membermobno varchar(20) = null,
	@membercode varchar(20) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		mem_id bigint, onboarduserid bigint, status int, response_status_id int, response_type_id int, 
		message varchar(500), tx_status int, transaction_date varchar(30), reason varchar(500), amount varchar(30), 
		merchant_code varchar(50), tds decimal(18,2), shop varchar(100), sender_name varchar(100), tid varchar(100), 
		balance decimal(18,2), shop_address_line1 varchar(500), user_code varchar(50), merchantname varchar(100), 
		transaction_time varchar(30), commission decimal(18,2), bank_ref_num varchar(50), entrylogdate datetime, ipaddress varchar(20),
		Mem_Code varchar(20), MemberName varchar(200), Mobile varchar(20), MerchantMob varchar(20)
	)

	Insert Into @TxnTable (
		rowno, mem_id, onboarduserid, status, response_status_id, response_type_id, message, tx_status, transaction_date, reason, amount, 
		merchant_code, tds, shop, sender_name, tid, balance, shop_address_line1, user_code, merchantname, transaction_time, commission, 
		bank_ref_num, entrylogdate, ipaddress, Mem_Code, MemberName, Mobile, MerchantMob
	)
	Select 
		ROW_NUMBER() OVER (ORDER By entrylogdate desc) AS rowno, mem_id, onboarduserid, status, response_status_id, response_type_id, message, tx_status, transaction_date, reason, amount, 
		merchant_code, tds, shop, sender_name, tid, balance, shop_address_line1, user_code, merchantname, transaction_time, commission, 
		bank_ref_num, entrylogdate, ipaddress, Mem_Code, MemberName, Mobile, MerchantMob
	From (
		Select a.mem_id, a.onboarduserid, status, response_status_id, response_type_id, message, tx_status, transaction_date, reason, amount, 
			merchant_code, tds, shop, sender_name, tid, balance, shop_address_line1, a.user_code, merchantname, transaction_time, commission, 
			bank_ref_num, entrylogdate, ipaddress,
			b.Mem_Code, b.[Name] as MemberName, b.Mobile, c.merchantmobileno as MerchantMob
		From T_Eko_Aeps_Txn a
		Inner Join T_Member b On a.mem_id = b.Mem_ID
		Inner Join T_Eko_Aeps_Member c On a.onboarduserid = c.onboarduserid
	) as t Where 1 = 1
	and mem_id = case when isnull(@memberid, 0) = 0 then mem_id else @memberid end
	and user_code = case when isnull(@merchantusercode, '') = '' then user_code else @merchantusercode end
	and MerchantMob = case when isnull(@merchantusermob, '') = '' then MerchantMob else @merchantusermob end
	and entrylogdate between @sdate and @edate
	and bank_ref_num = case when isnull(@bankrefno, '') = '' then bank_ref_num else @bankrefno end
	and tid = case when isnull(@txnid, '') = '' then tid else @txnid end
	and case when isnull(@txstatus, -1) <= 2 then tx_status else @txstatus end = case when isnull(@txstatus, -1) = -1 then tx_status else @txstatus end
	and Mobile = case when isnull(@membermobno, '') = '' then Mobile else @membermobno end
	and Mem_Code = case when isnull(@membercode, '') = '' then Mem_Code else @membercode end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
