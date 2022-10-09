-- =============================================
-- Author: Saurabh Verma
-- Create date: 13-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPIU_CourierPickUpPoint]
	@PickupPointId bigint,
	@ContactPerson varchar(100) = null,
	@ContactNo varchar(20) = null,
	@FullAddress varchar(MAX) = null,
	@PinCode varchar(10) = null,
	@Gstin varchar(20) = null,
	@MemId bigint,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;

	if @PickupPointId > 0 and not exists (Select ContactPerson From T_M_CourierPickUpPoint where PickupPointId = @PickupPointId and MemId = @MemId)
	begin
		set @PickupPointId = -2
	end
	
	if @PickupPointId = 0
	begin
		insert into T_M_CourierPickUpPoint (
			ContactPerson, ContactNo, FullAddress, PinCode, Gstin, MemId, EntryDate, UpdateDate
		) values (
			@ContactPerson, @ContactNo, @FullAddress, @PinCode, @Gstin, @MemId, @EntryDate, @EntryDate
		)

		Set @PickupPointId = (Select SCOPE_IDENTITY());
	end
	else if @PickupPointId > 0
	begin
		update T_M_CourierPickUpPoint set
			ContactPerson = @ContactPerson, ContactNo = @ContactNo, FullAddress = @FullAddress, PinCode = @PinCode, Gstin = @Gstin, UpdateDate = @EntryDate
		where PickupPointId = @PickupPointId and MemId = @MemId
	end

	select @PickupPointId
END
