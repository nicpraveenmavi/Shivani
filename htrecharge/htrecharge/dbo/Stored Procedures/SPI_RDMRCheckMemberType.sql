-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_RDMRCheckMemberType]
	@MemId int
AS
BEGIN
	SET NOCOUNT ON;
	Declare @membertype varchar(50), @isauthorized int
	Set @membertype = IsNull((select Meminfo_membertype from T_Member_Info Where Memid = @MemId), '')

	Set @isauthorized = Case When UPPER(@membertype) = Upper('Customer') Then 0 Else 1 End

	Select @isauthorized as isauthorized
END
