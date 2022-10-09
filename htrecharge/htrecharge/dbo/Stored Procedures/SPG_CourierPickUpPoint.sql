-- =============================================
-- Author: Saurabh Verma
-- Create date: 13-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPG_CourierPickUpPoint]
	@PickupPointId bigint,
	@MemId bigint
AS
BEGIN
	SET NOCOUNT ON;

	select PickupPointId, ContactPerson, ContactNo, FullAddress, PinCode, Gstin from T_M_CourierPickUpPoint
	where 1 = 1 and MemId = @MemId
	and PickupPointId = case when isnull(@PickupPointId, 0) = 0 then PickupPointId else @PickupPointId end
END
