-- =============================================
-- Author: Saurabh Verma
-- Create date: 13-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPD_CourierPickUpPoint]
	@PickupPointId bigint,
	@MemId bigint,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	declare @deleteFlag int
	set @deleteFlag = 0

	if exists (Select ContactPerson From T_M_CourierPickUpPoint where PickupPointId = @PickupPointId and MemId = @MemId)
		---add condition to check that this pickup point should not use in Courier order table
	begin
		delete From T_M_CourierPickUpPoint where PickupPointId = @PickupPointId and MemId = @MemId

		set @deleteFlag = 1
	end
	else
	begin
		set @deleteFlag = 2
	end

	select @deleteFlag
END
