-- =============================================
-- Author: Saurabh Verma
-- Create date: 21-Dec-2021
-- Alter date: 22-Dec-2021, 27-Dec-2021
-- Description:	Modify procedure to work for both Api and Web
-- =============================================
CREATE PROCEDURE [dbo].[SPG_CourierReport]
	@pageno int,
	@pagesize int,
	@memberid bigint,
	@sdate datetime,
	@edate datetime,
	@courier_order_no varchar(50) = null,
	@tracking_id varchar(50) = null,
	@membermobno varchar(20) = null,
	@membercode varchar(20) = null,
	@status int = -1
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		Order_Id bigint, Item_Detail varchar(MAX), PickupPointId bigint, From_Name varchar(100), From_PhoneNo varchar(20), From_Address varchar(MAX), 
		From_PinCode varchar(10), From_Gstin varchar(20), To_Name varchar(100), To_Email varchar(150), To_PhoneNo varchar(20), To_Address varchar(MAX),
		To_PinCode varchar(10), To_Gstin varchar(20), Total_Quantity decimal(18, 2), Invoice_Value decimal(18, 2), Cod_Amount decimal(18, 2), Our_Order_Id varchar(20), 
		Item_Breadth decimal(18, 2), Item_Length decimal(18, 2), Item_Weight decimal(18, 2), Item_Height decimal(18, 2), Is_Reverse bit, Invoice_No varchar(10), 
		Total_Discount decimal(18, 2), Shipping_Charge decimal(18, 2), Transaction_Charge decimal(18, 2), GiftWarp_Charge decimal(18, 2), Total_Charge decimal(18, 2), 
		Member_Courier_Charge decimal(18, 2), Member_Ser_Charge decimal(18, 2), Member_Net_Charge decimal(18, 2), MemId bigint, EntryDate datetime, 
		Api_Tracking_Id varchar(20), Api_Order_Id varchar(20), Api_Order_Pk varchar(20), Api_Manifest_Link varchar(MAX), Api_Routing_Code varchar(20), Api_Courier varchar(200),
		Api_Dispatch_Mode varchar(100), Api_Child_WayBill_List varchar(MAX), Api_Response_Remark varchar(500), CourierStatus int,
		Mem_Code varchar(20), MemberName varchar(200), Mobile varchar(20), Track_Url varchar(MAX), Api_Manifest_Link_Img varchar(MAX), Api_Manifest_Link_Img_V2 varchar(MAX),
		Api_Manifest_Link_Pdf varchar(MAX)
	)

	Insert Into @TxnTable (
		rowno, Order_Id, Item_Detail, PickupPointId, From_Name, From_PhoneNo, From_Address, From_PinCode, From_Gstin, To_Name, To_Email, To_PhoneNo, 
		To_Address, To_PinCode, To_Gstin, Total_Quantity, Invoice_Value, Cod_Amount, Our_Order_Id, Item_Breadth, Item_Length, Item_Weight, Item_Height, 
		Is_Reverse, Invoice_No, Total_Discount, Shipping_Charge, Transaction_Charge, GiftWarp_Charge, Total_Charge, Member_Courier_Charge, Member_Ser_Charge, 
		Member_Net_Charge, MemId, EntryDate, Api_Tracking_Id, Api_Order_Id, Api_Order_Pk, Api_Manifest_Link, Api_Routing_Code, Api_Courier, Api_Dispatch_Mode,
		Api_Child_WayBill_List, Api_Response_Remark, CourierStatus, Mem_Code, MemberName, Mobile, Track_Url, Api_Manifest_Link_Img, Api_Manifest_Link_Img_V2,
		Api_Manifest_Link_Pdf
	)
	Select 
		ROW_NUMBER() OVER (ORDER By EntryDate desc) AS rowno, Order_Id, Item_Detail, PickupPointId, From_Name, From_PhoneNo, From_Address, From_PinCode, From_Gstin, To_Name, To_Email, To_PhoneNo, 
		To_Address, To_PinCode, To_Gstin, Total_Quantity, Invoice_Value, Cod_Amount, Our_Order_Id, Item_Breadth, Item_Length, Item_Weight, Item_Height, 
		Is_Reverse, Invoice_No, Total_Discount, Shipping_Charge, Transaction_Charge, GiftWarp_Charge, Total_Charge, Member_Courier_Charge, Member_Ser_Charge, 
		Member_Net_Charge, MemId, EntryDate, Api_Tracking_Id, Api_Order_Id, Api_Order_Pk, Api_Manifest_Link, Api_Routing_Code, Api_Courier, Api_Dispatch_Mode,
		Api_Child_WayBill_List, Api_Response_Remark, CourierStatus, Mem_Code, MemberName, Mobile, Track_Url, Api_Manifest_Link_Img, Api_Manifest_Link_Img_V2,
		Api_Manifest_Link_Pdf
	From (
		Select Order_Id, Item_Detail, PickupPointId, From_Name, From_PhoneNo, From_Address, From_PinCode, From_Gstin, To_Name, To_Email, To_PhoneNo, 
			To_Address, To_PinCode, To_Gstin, Total_Quantity, Invoice_Value, Cod_Amount, Our_Order_Id, Item_Breadth, Item_Length, Item_Weight, Item_Height, 
			Is_Reverse, Invoice_No, Total_Discount, Shipping_Charge, Transaction_Charge, GiftWarp_Charge, Total_Charge, Member_Courier_Charge, Member_Ser_Charge, 
			Member_Net_Charge, MemId, EntryDate, Api_Tracking_Id, Api_Order_Id, Api_Order_Pk, Api_Manifest_Link, Api_Routing_Code, Api_Courier, Api_Dispatch_Mode,
			Api_Child_WayBill_List, Api_Response_Remark, CourierStatus, b.Mem_Code, b.[Name] as MemberName, b.Mobile, a.Track_Url, a.Api_Manifest_Link_Img, 
			a.Api_Manifest_Link_Img_V2, a.Api_Manifest_Link_Pdf
		From T_CourierOrder a
		Inner Join T_Member b On a.MemId = b.Mem_ID
	) as t Where 1 = 1
	and EntryDate between @sdate and @edate
	and MemId = case when isnull(@memberid, 0) = 0 then MemId else @memberid end
	and Our_Order_Id = case when isnull(@courier_order_no, '') = '' then Our_Order_Id else @courier_order_no end
	and Api_Tracking_Id = case when isnull(@tracking_id, '') = '' then Api_Tracking_Id else @tracking_id end
	and Mem_Code = case when isnull(@membercode, '') = '' then Mem_Code else @membercode end
	and Mobile = case when isnull(@membermobno, '') = '' then Mobile else @membermobno end
	and CourierStatus = case when isnull(@status, -1) = -1 then CourierStatus else @status end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
