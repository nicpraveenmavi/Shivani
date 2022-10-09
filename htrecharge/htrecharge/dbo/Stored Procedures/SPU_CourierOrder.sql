-- =============================================
-- Author: Saurabh Verma
-- Create date: 17-Dec-2021
-- Alter date: 20-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPU_CourierOrder]
	@UpdType varchar(50),
	@Order_Id bigint = 0,
	@UpdateDate datetime,
	@Api_Tracking_Id varchar(20),
	@Api_Order_Id varchar(20) = null,
	@Api_Order_Pk varchar(20) = null,
	@Api_Manifest_Link varchar(max) = null,
	@Api_Routing_Code varchar(20) = null,
	@Api_Courier varchar(200) = null,
	@Api_Dispatch_Mode varchar(100) = null,
	@Api_Child_WayBill_List varchar(max) = null,
	@Api_Response_Remark varchar(500) = null,
	@Our_Order_Id varchar(20) = null,
	@MemId bigint,
	@ipaddress varchar(20),
	@statuscode int,
	@Track_Url varchar(max) = null,
	@StatusText varchar(50) = null,
	@Api_Manifest_Link_Img varchar(max) = null,
	@Api_Manifest_Link_Img_V2 varchar(max) = null,
	@Api_Manifest_Link_Pdf varchar(max) = null
AS
BEGIN
	SET NOCOUNT ON;
	declare @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100), 
		@Member_Courier_Charge decimal(18,2), @Member_Ser_Charge decimal(18,2), @Member_Gst_Charge decimal(18,2), @Member_Net_Charge decimal(18,2)
	
	if @UpdType = 'Normal'
	begin
		Update T_CourierOrder Set
			UpdateDate = @UpdateDate, Api_Tracking_Id = @Api_Tracking_Id, Api_Order_Id = @Api_Order_Id, Api_Order_Pk = @Api_Order_Pk, 
			Api_Manifest_Link = @Api_Manifest_Link, Api_Routing_Code = @Api_Routing_Code, Api_Courier = @Api_Courier, Api_Dispatch_Mode = @Api_Dispatch_Mode, 
			Api_Child_WayBill_List = @Api_Child_WayBill_List, Api_Response_Remark = @Api_Response_Remark, CourierStatus = @statuscode, Track_Url = @Track_Url,
			StatusText = @StatusText, Api_Manifest_Link_Img = @Api_Manifest_Link_Img, Api_Manifest_Link_Img_V2 = @Api_Manifest_Link_Img_V2,
			Api_Manifest_Link_Pdf = @Api_Manifest_Link_Pdf
		Where Order_Id = @Order_Id

		Select @Member_Courier_Charge = Member_Courier_Charge, @Member_Ser_Charge = Member_Ser_Charge, @Member_Gst_Charge = Member_Gst_Charge, @Member_Net_Charge = Member_Net_Charge From T_CourierOrder Where Order_Id = @Order_Id
		
		--Debit Amt
		if @Member_Net_Charge > 0 and @statuscode = 5 
		begin
			set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @MemId), 0)
			set @ClosingBal = (@OpeningBal - @Member_Courier_Charge)
			if @Member_Courier_Charge > 0
			begin
				set @TxnComment = 'Courier Booking #'+@Our_Order_Id+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, 0, @Member_Courier_Charge, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end
			
			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal - @Member_Ser_Charge)
			if @Member_Ser_Charge > 0
			begin
				set @TxnComment = 'Surcharge on Courier Booking #'+@Our_Order_Id+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, 0, @Member_Ser_Charge, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end
			
			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal - @Member_Gst_Charge)
			if @Member_Gst_Charge > 0
			begin
				set @TxnComment = 'Gst on Courier Booking #'+@Our_Order_Id+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, 0, @Member_Gst_Charge, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end

			Exec [dbo].[SPIU_Courier_Comm] @MemId, @Order_Id, @UpdateDate, @ipaddress
		end
	end
	else if @UpdType = 'Cancel'
	begin
		Update T_CourierOrder Set
			UpdateDate = @UpdateDate, Api_Response_Remark = @Api_Response_Remark, CourierStatus = @statuscode, StatusText = @StatusText
		Where Api_Tracking_Id = @Api_Tracking_Id and MemId = @MemId

		Select @Order_Id = Order_Id, @Our_Order_Id = Our_Order_Id, @Member_Courier_Charge = Member_Courier_Charge, @Member_Ser_Charge = Member_Ser_Charge, @Member_Gst_Charge = Member_Gst_Charge, @Member_Net_Charge = Member_Net_Charge From T_CourierOrder Where Api_Tracking_Id = @Api_Tracking_Id and MemId = @MemId
		

		--Credit Amt if Deducted and Rollback Payout Entry
		if @Member_Net_Charge > 0
		begin
			set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @MemId), 0)
			set @ClosingBal = (@OpeningBal + @Member_Courier_Charge)
			if @Member_Courier_Charge > 0
			begin
				set @TxnComment = 'Courier Booking Cancelled #'+@Our_Order_Id+', Tracking Id #' + @Api_Tracking_Id
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, @Member_Courier_Charge, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end
			
			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal + @Member_Ser_Charge)
			if @Member_Ser_Charge > 0
			begin
				set @TxnComment = 'Credited Surcharge on Courier Booking Cancelled #'+@Our_Order_Id+', Tracking Id #' + @Api_Tracking_Id
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, @Member_Ser_Charge, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end
			
			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal + @Member_Gst_Charge)
			if @Member_Gst_Charge > 0
			begin
				set @TxnComment = 'Credited GST on Courier Booking Cancelled #'+@Our_Order_Id+', Tracking Id #' + @Api_Tracking_Id
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@MemId, @Order_Id, @OpeningBal, @Member_Gst_Charge, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end

			Declare @pwt_id bigint, @pwt_memid bigint, @CommAmt decimal(18,2)
			Select * into #TempPO From T_PayoutWallet Where pwt_servicerefid = @Order_Id And pwt_comment like 'Courier Booking Commission%' And pwt_Credit > 0
			Select @pwt_id = Min(pwt_id) From #TempPO 
			While @pwt_id Is Not Null
			Begin
				Select @pwt_memid = pwt_memid From #TempPO Where pwt_id = @pwt_id
				set @OpeningBal = IsNull((select Payout_Wallet From T_Member where Mem_ID = @pwt_memid), 0)
				set @CommAmt = IsNull((Select pwt_Credit From #TempPO Where pwt_id = @pwt_id), 0)
				set @ClosingBal = (@OpeningBal - @CommAmt)
				set @TxnComment = ''

				if not exists (select pwt_id from T_PayoutWallet where pwt_memid = @pwt_memid and pwt_servicerefid = @Order_Id and pwt_datetime = @UpdateDate And pwt_comment Like 'Rollback Courier Booking Commission%' And pwt_Debit > 0)
				begin
					insert into T_PayoutWallet (
						pwt_memid, pwt_servicerefid, pwt_openingBalance, pwt_Credit, pwt_Debit, pwt_ClosingBalance, pwt_datetime, pwt_IP, pwt_comment, IncomeByMemId, IncomeByLevelNo
					)
					select @pwt_memid as pwt_memid, @Order_Id as pwt_servicerefid, @OpeningBal as pwt_openingBalance, 0 as pwt_Credit, @CommAmt as pwt_Debit, 
						@ClosingBal as pwt_ClosingBalance, @UpdateDate as pwt_datetime, @ipaddress as pwt_IP, 
							Replace(pwt_comment, 'Courier Booking Commission', 'Rollback Courier Booking Commission') as pwt_comment, 
						IncomeByMemId, IncomeByLevelNo from #TempPO Where pwt_id = @pwt_id
				end

				Select @pwt_id = Min(pwt_id) From #TempPO Where pwt_id > @pwt_id
			End
			Drop Table #TempPO
		end
	end



	select @Order_Id
END
