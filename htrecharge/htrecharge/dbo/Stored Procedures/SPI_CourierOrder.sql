-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_CourierOrder]
	@PickupPointId bigint,
	@Item_Detail varchar(MAX),
	@To_Name varchar(100),
	@To_Email varchar(150),
	@To_PhoneNo varchar(20),
	@To_Address varchar(MAX),
	@To_PinCode varchar(10),
	@To_Gstin varchar(20),
	@Total_Quantity decimal(18, 2),
	@Invoice_Value decimal(18, 2),
	@Cod_Amount decimal(18, 2),
	@Our_Order_Id varchar(20),
	@Item_Breadth decimal(18, 2),
	@Item_Length decimal(18, 2),
	@Item_Weight decimal(18, 2),
	@Item_Height decimal(18, 2),
	@Is_Reverse bit,
	@Invoice_No varchar(10),
	@Total_Discount decimal(18, 2),
	@Shipping_Charge decimal(18, 2),
	@Transaction_Charge decimal(18, 2),
	@GiftWarp_Charge decimal(18, 2),
	@Member_Courier_Charge decimal(18, 2),
	@MemId bigint,
	@EntryDate datetime,
	@ipaddress varchar(20),
	@statuscode int,
	@Api_CourierId bigint,
	@Member_Gst_Charge decimal(18,2),
	@Member_Ser_Charge decimal(18,2),
	@Member_Net_Charge decimal(18,2)
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Order_Id bigint
	declare @OpeningBal decimal(18,2),  @ClosingBal decimal(18,2), @TxnComment varchar(100), 
		@TotalCharges decimal(18,2)
	
	Set @TotalCharges = @Shipping_Charge + @Transaction_Charge + @GiftWarp_Charge
	

	Insert Into T_CourierOrder (
		Item_Detail, PickupPointId, From_Name, From_PhoneNo, From_Address, From_PinCode, From_Gstin, To_Name, To_Email, To_PhoneNo, To_Address, 
		To_PinCode, To_Gstin, Total_Quantity, Invoice_Value, Cod_Amount, Our_Order_Id, Item_Breadth, Item_Length, Item_Weight, Item_Height, 
		Is_Reverse, Invoice_No, Total_Discount, Shipping_Charge, Transaction_Charge, GiftWarp_Charge, MemId, EntryDate, UpdateDate, 
		Api_Tracking_Id, Api_Order_Id, Api_Order_Pk, Api_Manifest_Link, Api_Routing_Code, Api_Courier, Api_Dispatch_Mode, 
		Api_Child_WayBill_List, Api_Response_Remark, Total_Charge, Member_Courier_Charge, Member_Ser_Charge, Member_Net_Charge, CourierStatus,
		Api_CourierId, Member_Gst_Charge, StatusText
	)
	Select 
		@Item_Detail as Item_Detail, PickupPointId, ContactPerson as From_Name, ContactNo as From_PhoneNo, FullAddress as From_Address, PinCode as From_PinCode, 
		Gstin as From_Gstin, @To_Name as To_Name, @To_Email as To_Email, @To_PhoneNo as To_PhoneNo, @To_Address as To_Address, @To_PinCode as To_PinCode, 
		@To_Gstin as To_Gstin, @Total_Quantity as Total_Quantity, @Invoice_Value as Invoice_Value, @Cod_Amount as Cod_Amount, @Our_Order_Id as Our_Order_Id, 
		@Item_Breadth as Item_Breadth, @Item_Length as Item_Length, @Item_Weight as Item_Weight, @Item_Height as Item_Height, @Is_Reverse as Is_Reverse, 
		@Invoice_No as Invoice_No, @Total_Discount as Total_Discount, @Shipping_Charge as Shipping_Charge, @Transaction_Charge as Transaction_Charge, 
		@GiftWarp_Charge as GiftWarp_Charge, @MemId as MemId, @EntryDate as EntryDate, @EntryDate as UpdateDate, 
		'' as Api_Tracking_Id, '' as Api_Order_Id, 0 as Api_Order_Pk, '' as Api_Manifest_Link, '' as Api_Routing_Code, '' as Api_Courier, '' as Api_Dispatch_Mode, 
		'' as Api_Child_WayBill_List, '' as Api_Response_Remark, @TotalCharges as Total_Charge, @Member_Courier_Charge as Member_Courier_Charge, 
		@Member_Ser_Charge as Ser_Charge, @Member_Net_Charge as Net_Charge, @statuscode as CourierStatus, @Api_CourierId, @Member_Gst_Charge, 'Order Initiated'
	From T_M_CourierPickUpPoint 
	Where MemId = @MemId And PickupPointId = @PickupPointId

	Set @Order_Id = (Select SCOPE_IDENTITY());

	select @Order_Id
END
