-- =============================================
-- Author: Saurabh Verma
-- Create date: 29-Oct-2021
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPI_FundAddRequest]
	@mem_id int,
	@dep_mode varchar(50),
	@txn_ref_no varchar(50),
	@txn_remark varchar(200),
	@dep_amt decimal(18, 2),
	@req_ip varchar(20),
	@req_date datetime,
	@req_status varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	declare @autoid bigint

	set @autoid = 0

    insert into T_FundAddRequest (
		mem_id, dep_mode, txn_ref_no, txn_remark, dep_amt, req_ip, req_date, req_status
	) values (
		@mem_id, @dep_mode, @txn_ref_no, @txn_remark, @dep_amt, @req_ip, @req_date, @req_status
	)

	set @autoid = (select SCOPE_IDENTITY());
END

