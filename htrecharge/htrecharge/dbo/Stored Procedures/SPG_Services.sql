-- =============================================
-- Author: Saurabh Verma
-- Create date: 13-Jan-2022
-- Alter date: 
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_Services]
	@pageno int,
	@pagesize int,
	@memberid bigint = null,
	@membercode varchar(20) = null,
	@membermobno varchar(20) = null,
	@servicetypeid int = null,
	@servicecateid int = null,
	@specialisation varchar(100) = null,
	@locationaddress varchar(100) = null,
	@lat decimal(18,16) = null,
	@lng decimal(18,16) = null,
	@distance decimal(18,16) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		service_id bigint, service_memid int, Mem_Code varchar(50), Name varchar(150), Mobile varchar(20),
		Service_Type_Id int, service_cateid int, Service_Name varchar(100), Category_Name varchar(100),
		LocationAddress varchar(max), Latitude decimal(18,16), Longitude decimal(18,16), Booking_fee decimal(18,2),
		Specialisation varchar(max), distance decimal(18,16), profilepic varchar(max)
	)

	Insert Into @TxnTable (
		rowno, 
		service_id, service_memid, Mem_Code, Name, Mobile, Service_Type_Id, service_cateid, Service_Name, Category_Name, LocationAddress, 
		Latitude, Longitude, Booking_fee, Specialisation, distance, profilepic
	)
	Select 
		ROW_NUMBER() OVER (ORDER By distance) AS rowno, 
		service_id, service_memid, Mem_Code, Name, Mobile, Service_Type_Id, service_cateid, Service_Name, Category_Name, LocationAddress, 
		Latitude, Longitude, Booking_fee, Specialisation, distance, profilepic
	From (
			select 
				a.service_id, a.service_memid, b.Mem_Code, b.Name, b.Mobile, c.Service_Type_Id, a.service_cateid, d.Service_Name, c.Category_Name, 
				a.LocationAddress, a.Latitude, a.Longitude, a.Booking_fee,
				isnull(a.Specialisation1, '') + case when isnull(a.Specialisation1, '') = '' then '' else ', ' end 
					+ isnull(a.Specialisation2, '') + case when isnull(a.Specialisation2, '') = '' then '' else ', ' end 
					+ isnull(a.Specialisation3, '') + case when isnull(a.Specialisation3, '') = '' then '' else ', ' end 
					+ isnull(a.Specialisation4, '') + case when isnull(a.Specialisation4, '') = '' then '' else ', ' end 
					+ isnull(a.Specialisation5, '') as Specialisation,
				SQRT(POWER(69.1 * ( a.Latitude - @lat),  2) + POWER(69.1 * ( @lng  - a.Longitude )  * COS(a.Latitude / 57.3), 2)) as distance,
				IsNull((select aa.Meminfo_profilepic From T_Member_Info aa where aa.Memid = a.service_memid), '') as profilepic
			from T_Service a
			inner join T_Member b on a.service_memid = b.Mem_ID
			inner join M_Service_Type_Category c on a.service_cateid = c.Service_Category_Id
			inner join M_Sevice_Type d on c.Service_Type_Id = d.Service_Type_Id
	) as t Where 1 = 1
	and service_memid = case when isnull(@memberid, 0) = 0 then service_memid else @memberid end
	and Mem_Code = case when isnull(@membercode, '') = '' then Mem_Code else @membercode end
	and Mobile = case when isnull(@membermobno, '') = '' then Mobile else @membermobno end
	and Service_Type_Id = case when isnull(@servicetypeid, 0) = 0 then Service_Type_Id else @servicetypeid end
	and service_cateid = case when isnull(@servicecateid, 0) = 0 then service_cateid else @servicecateid end
	and Specialisation like case when isnull(@specialisation, '') = '' then Specialisation else '%'+@specialisation+'%' end
	and LocationAddress like case when isnull(@locationaddress, '') = '' then LocationAddress else '%'+@locationaddress+'%' end
	and distance <= @distance


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
