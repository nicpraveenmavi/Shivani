-- =============================================
-- Author: Saurabh Verma
-- Create date: 06-Jan-2022
-- Description:	This procedure is used to insert Courier Staus Log
-- =============================================
CREATE PROCEDURE [dbo].[SPI_CourierStatus]
	@Our_Order_Id varchar(20),
	@Api_Tracking_Id varchar(20),
	@CurrentStatusType varchar(10),
	@CurrentStatusDesc varchar(500),
	@CurrentStatusLocation varchar(300),
	@CurrentStatusTime varchar(50),
	@ReceivedBy varchar(150)
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Order_Id bigint, @CurrentStatusText varchar(50)

	Set @Order_Id = IsNull((Select Order_Id From T_CourierOrder Where Our_Order_Id = @Our_Order_Id And Api_Tracking_Id = @Api_Tracking_Id), 0)
	Set @CurrentStatusText = IsNull((Select StatusText From M_CourierStatus Where StatusCode = @CurrentStatusType), 'N/A')

	Insert Into T_CourierOrderStatus (
		Order_Id, Our_Order_Id, Api_Tracking_Id, CurrentStatusType, CurrentStatusText, 
		CurrentStatusDesc, CurrentStatusLocation, CurrentStatusTime, EntryTime, ReceivedBy
	) Values (
		@Order_Id, @Our_Order_Id, @Api_Tracking_Id, @CurrentStatusType, @CurrentStatusText,
		@CurrentStatusDesc, @CurrentStatusLocation, @CurrentStatusTime, getdate(), @ReceivedBy
	)

	Update T_CourierOrder Set StatusText = @CurrentStatusText, Api_Response_Remark = @CurrentStatusDesc Where Order_Id = @Order_Id

END
