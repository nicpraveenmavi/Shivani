-- =============================================
-- Author: Saurabh
-- Create date: 14-Jan-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_Order]
	@orderno varchar(20),
	@orderdate datetime,
	@booked_by_memid int,
	@merchantMemId int,
	@service_id bigint,
	@order_status int,
	@order_status_text varchar(50),
	@amount decimal(18, 2),
	@amount_sr_charge decimal(18, 2),
	@amount_gst decimal(18, 2),
	@amount_tot decimal(18, 2),
	@remarks varchar(500),
	@entrydate datetime,
	@updatedate datetime,
	@ipaddress varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	declare @order_id bigint, @service_category_id int, @service_sub_category_id int, @ServiceTypeSubName varchar(200),
		@OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100)

	set @service_category_id = isnull((select service_cateid from T_Service where service_memid = @merchantMemId and service_id = @service_id), 0)
	set @service_sub_category_id = isnull((select Service_Sub_Category_Id from M_Service_Type_Sub_Category where Service_Category_Id = @service_category_id), 0)
	set @ServiceTypeSubName = isnull((select Sub_Category_Name from M_Service_Type_Sub_Category where Service_Sub_Category_Id = @service_sub_category_id), '')
    
	if @service_category_id <= 0 or @service_sub_category_id <= 0
	begin
		set @order_id = -1
	end
	else
	begin
		insert into T_Order (
			orderno, orderdate, booked_by_memid, merchantMemId, service_sub_category_id, 
			service_id, order_status, order_status_text, amount, amount_sr_charge, amount_gst, amount_tot, remarks, 
			entrydate, updatedate, ipaddress
		) values (
			@orderno, @orderdate, @booked_by_memid, @merchantMemId, @service_sub_category_id, 
			@service_id, @order_status, @order_status_text, @amount, @amount_sr_charge, @amount_gst, @amount_tot, @remarks, 
			@entrydate, @updatedate, @ipaddress
		)
		set @order_id = isnull((Select SCOPE_IDENTITY()), 0)


		--Debit Amt
		set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @booked_by_memid), 0)
		set @ClosingBal = (@OpeningBal - @amount)
		if @amount > 0
		begin
			set @TxnComment = @ServiceTypeSubName+' Booking #'+@orderno+''
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@booked_by_memid, @Order_Id, @OpeningBal, 0, @amount, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
			)
		end

		set @OpeningBal = @ClosingBal
		set @ClosingBal = (@OpeningBal - @amount_sr_charge)
		if @amount_sr_charge > 0
		begin
			set @TxnComment = 'Surcharge on '+@ServiceTypeSubName+' Booking #'+@orderno+''
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@booked_by_memid, @Order_Id, @OpeningBal, 0, @amount_sr_charge, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
			)
		end

		set @OpeningBal = @ClosingBal
		set @ClosingBal = (@OpeningBal - @amount_gst)
		if @amount_gst > 0
		begin
			set @TxnComment = 'Gst on '+@ServiceTypeSubName+' Booking #'+@orderno+''
			insert into T_MainWallet (
				Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
			) values (
				@booked_by_memid, @Order_Id, @OpeningBal, 0, @amount_gst, @ClosingBal, @UpdateDate, @ipaddress, @TxnComment, '', 0, 0
			)
		end

		--Exec [dbo].[SPIU_ServiceOrder_Comm] @MemId, @Order_Id, @UpdateDate, @ipaddress
	end

	select @order_id
END
