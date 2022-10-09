-- =============================================
-- Author: Saurabh Verma
-- Create date: 06-Jan-2022
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_CourierTrack]
	@Order_Id bigint = null,
	@Our_Order_Id varchar(20) = null,
	@Api_Tracking_Id varchar(20) = null
AS
BEGIN
	SET NOCOUNT ON;

	Select * From T_CourierOrderStatus Where 1 = 1
	And Order_Id = Case When IsNull(@Order_Id, 0) = 0 Then Order_Id Else @Order_Id End
	And Our_Order_Id = Case When IsNull(@Our_Order_Id, '') = '' Then Our_Order_Id Else @Our_Order_Id End
	And Api_Tracking_Id = Case When IsNull(@Api_Tracking_Id, '') = '' Then Api_Tracking_Id Else @Api_Tracking_Id End
	Order by EntryTime Desc
END
