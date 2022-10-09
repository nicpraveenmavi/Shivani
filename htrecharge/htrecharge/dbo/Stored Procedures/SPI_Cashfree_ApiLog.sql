-- =============================================
-- Author: Saurabh Verma
-- Create date: 24-Jan-2022
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_Cashfree_ApiLog]
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
	
	Insert Into T_Cashfree_ApiLog (
		endpoint, mem_id, apirequest, apiresponse, entrydate, requesttime, responsetime, ipaddress
	) Values (
		@endpoint, @mem_id, @apirequest, @apiresponse, @entrydate, @requesttime, @responsetime, @ipaddress
	)
END
