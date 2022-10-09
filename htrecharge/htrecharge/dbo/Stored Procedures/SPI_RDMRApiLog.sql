-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_RDMRApiLog]
	@EndPoint varchar(50),
	@MemId int,
	@SenderNo varchar(50),
	@ApiRequest varchar(max),
	@ApiResponse varchar(max),
	@EntryDate datetime,
	@RequestTime datetime,
	@ResponseTime datetime,
	@IPAddress varchar(50),
	@ClientTxnNo varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	
	Insert Into T_RDMRApiLog (
		EndPoint, MemId, SenderNo, ApiRequest, ApiResponse, EntryDate, RequestTime, ResponseTime, IPAddress, ClientTxnNo
	) Values (
		@EndPoint, @MemId, @SenderNo, @ApiRequest, @ApiResponse, @EntryDate, @RequestTime, @ResponseTime, @IPAddress, @ClientTxnNo
	)
END
