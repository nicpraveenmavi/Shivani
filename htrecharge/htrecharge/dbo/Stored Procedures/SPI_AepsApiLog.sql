-- =============================================
-- Author: Saurabh Verma
-- Create date: 18-Nov-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_AepsApiLog]
	@endpoint varchar(50),
	@mem_id int,
	@onboarduserid bigint,
	@merchantmobileno varchar(50) = null,
	@apirequest varchar(MAX) = null,
	@apiresponse varchar(MAX) = null,
	@entrydate datetime,
	@requesttime datetime,
	@responsetime datetime,
	@ipaddress varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	
	Insert Into T_Eko_Aeps_ApiLog (
		endpoint, mem_id, onboarduserid, merchantmobileno, apirequest, apiresponse, entrydate, requesttime, responsetime, ipaddress
	) Values (
		@endpoint, @mem_id, @onboarduserid, @merchantmobileno, @apirequest, @apiresponse, @entrydate, @requesttime, @responsetime, @ipaddress
	)
END
