-- =============================================
-- Author: Saurabh
-- Create date: 14-Jan-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPU_Order]
	@order_id bigint,
	@updatebyMemId int,
	@order_status int,
	@order_status_text varchar(50),
	@remarks varchar(500),
	@updatedate datetime,
	@ipaddress varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
    declare @returnorderid bigint = 0, @service_sub_category_id int, @ServiceTypeSubName varchar(200),
		@OpeningBal decimal(18,2), @ClosingBal decimal(18,2), @TxnComment varchar(100), @booked_by_memid int,
		@orderno varchar(50), @amount decimal(18, 2), @amount_sr_charge decimal(18, 2), @amount_gst decimal(18, 2),
		@amount_tot decimal(18, 2)

	select * into #TempTOrder from T_Order where order_id = @order_id

	if exists (select orderdate from #TempTOrder)
	begin
		select @booked_by_memid = booked_by_memid, @amount = amount, @amount_sr_charge = amount_sr_charge, 
			@amount_gst = amount_gst, @amount_tot = amount_tot, @orderno = orderno, @service_sub_category_id = service_sub_category_id from #TempTOrder
			
		set @ServiceTypeSubName = isnull((select Sub_Category_Name from M_Service_Type_Sub_Category where Service_Sub_Category_Id = @service_sub_category_id), '')

		update T_Order set
			updatebyMemId = @updatebyMemId,
			order_status = @order_status, order_status_text = @order_status_text, 
			updatedate = @updatedate, ipaddress = @ipaddress
		where order_id = @order_id

		set @returnorderid  = @order_id

		if @order_status = 2 or @order_status = 3
		begin
			--Credt Amt
			set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @booked_by_memid), 0)
			set @ClosingBal = (@OpeningBal + @amount)
			if @amount > 0
			begin
				set @TxnComment = @order_status_text+' '+@ServiceTypeSubName+' Booking #'+isnull(@orderno,'')+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@booked_by_memid, @Order_Id, @OpeningBal, @amount, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end

			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal + @amount_sr_charge)
			if @amount_sr_charge > 0
			begin
				set @TxnComment = 'Reverse Surcharge on '+@ServiceTypeSubName+' Booking #'+@orderno+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@booked_by_memid, @Order_Id, @OpeningBal, @amount_sr_charge, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end

			set @OpeningBal = @ClosingBal
			set @ClosingBal = (@OpeningBal + @amount_gst)
			if @amount_gst > 0
			begin
				set @TxnComment = 'Reverse Gst on '+@ServiceTypeSubName+' Booking #'+@orderno+''
				insert into T_MainWallet (
					Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
				) values (
					@booked_by_memid, @Order_Id, @OpeningBal, @amount_gst, 0, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
				)
			end


			/*Rollback Service Commission here*/
		end
	end
	else
	begin
		set @returnorderid  = -1
	end

	select @returnorderid


	drop table #TempTOrder
END
