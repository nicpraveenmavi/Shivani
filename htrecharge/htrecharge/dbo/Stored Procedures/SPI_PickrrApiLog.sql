-- =============================================
-- Author: Saurabh Verma
-- Create date: 09-Dec-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_PickrrApiLog]
	@endpoint varchar(50),
	@mem_id int,
	@apirequest varchar(MAX) = null,
	@apiresponse varchar(MAX) = null,
	@entrydate datetime,
	@requesttime datetime,
	@responsetime datetime,
	@ipaddress varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	Insert Into T_Pickrr_ApiLog (
		endpoint, mem_id, apirequest, apiresponse, entrydate, requesttime, responsetime, ipaddress
	) Values (
		@endpoint, @mem_id, @apirequest, @apiresponse, @entrydate, @requesttime, @responsetime, @ipaddress
	)
END
