-- =============================================
-- Author: Saurabh Verma
-- Create date: 20-Jan-2021
-- Alter date: 21-Jan-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_OrderReport]
	@pageno int,
	@pagesize int,
	@sdate datetime,
	@edate datetime,
	@reportfor int = null,
	@memberid bigint,
	@order_no varchar(50) = null,
	@customercode varchar(20) = null,
	@customermobno varchar(20) = null,
	@merchantcode varchar(20) = null,
	@merchantmobno varchar(20) = null,
	@status int = -1
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int

	Declare @TxnTable as Table (
		rowno bigint,
		order_id bigint, orderno varchar(20), orderdate datetime, booked_by_memid int, merchantMemId int, service_sub_category_id int, service_id bigint, 
		order_status int, order_status_text varchar(50), amount decimal(18, 2), amount_sr_charge decimal(18, 2), amount_gst decimal(18, 2), amount_tot decimal(18, 2),
		remarks varchar(500), entrydate datetime, updatedate datetime, updatebyMemId int, ServiceName varchar(100),
		booked_by_memcode varchar(20), booked_by_memname varchar(300), booked_by_memmobile varchar(30),
		merchantMemcode varchar(20), merchantMemname varchar(300), merchantMemmobile varchar(30),
		updatebyMemcode varchar(20), updatebyMemname varchar(300), updatebyMemmobile varchar(30),Cust_Address  varchar(150),Cust_pincode  varchar(150),Cust_State  varchar(150),Cust_Gstin  varchar(150),Marchant_Address  varchar(150),Marchant_pincode  varchar(150),Marchant_State  varchar(150),Marchant_Gstin  varchar(150)
	)

	Insert Into @TxnTable (
		rowno,
		order_id, orderno, orderdate, booked_by_memid, merchantMemId, service_sub_category_id, service_id, order_status, order_status_text, 
		amount, amount_sr_charge, amount_gst, amount_tot, remarks, entrydate, updatedate, updatebyMemId, ServiceName,
		booked_by_memcode, booked_by_memname, booked_by_memmobile,
		merchantMemcode, merchantMemname, merchantMemmobile,
		updatebyMemcode, updatebyMemname, updatebyMemmobile
		,Cust_Address,Cust_pincode,Cust_State,Cust_Gstin,Marchant_Address,Marchant_pincode,Marchant_State,Marchant_Gstin
	)
	Select 
		ROW_NUMBER() OVER (ORDER By entrydate desc) AS rowno, 
		order_id, orderno, orderdate, booked_by_memid, merchantMemId, service_sub_category_id, service_id, order_status, order_status_text, 
		amount, amount_sr_charge, amount_gst, amount_tot, remarks, entrydate, updatedate, updatebyMemId, ServiceName,
		booked_by_memcode, booked_by_memname, booked_by_memmobile,
		merchantMemcode, merchantMemname, merchantMemmobile,
		updatebyMemcode, updatebyMemname, updatebyMemmobile
		,Meminfo_address,Meminfo_pincode,Meminfo_state,Meminfo_gstin,Marchant_Address,Marchant_pincode,Marchant_State,Marchant_Gstin
	From (
		Select 
			order_id, orderno, orderdate, booked_by_memid, merchantMemId, a.service_sub_category_id, service_id, order_status, order_status_text, 
			amount, amount_sr_charge, amount_gst, amount_tot, remarks, entrydate, updatedate, updatebyMemId, d.Sub_Category_Name as ServiceName,
			b.Mem_Code as booked_by_memcode, b.Name as booked_by_memname, b.Mobile as booked_by_memmobile,
			c.Mem_Code as merchantMemcode, c.Name as merchantMemname, c.Mobile as merchantMemmobile,
			e.Mem_Code as updatebyMemcode, e.Name as updatebyMemname, e.Mobile as updatebyMemmobile,
			TMI.Meminfo_address,TMI.Meminfo_pincode,TMI.Meminfo_state,TMI.Meminfo_gstin,
			TMI2.Meminfo_address as marchant_Address,TMI2.Meminfo_pincode as Marchant_Pincode,TMI2.Meminfo_state as Marchant_State,TMI2.Meminfo_gstin as Marchant_Gstin
		From T_Order a
		Inner Join T_Member b On a.booked_by_memid = b.Mem_ID
		Inner Join T_Member c On a.merchantMemId = c.Mem_ID
		inner join M_Service_Type_Sub_Category d on a.service_sub_category_id = d.Service_Sub_Category_Id
		Left Outer Join T_Member e On IsNull(a.updatebyMemId, 0) = e.Mem_ID
		left join T_Member_Info TMI  on TMI.Memid=b.Mem_id
		left join T_Member_Info TMI2  on TMI2.Memid=e.Mem_id
	) as t Where 1 = 1
	and EntryDate between @sdate and @edate
	and case isnull(@reportfor, 0) when 1 then booked_by_memid when 2 then merchantMemId else -1 end
		= case when isnull(@memberid, 0) = 0 then -1 else @memberid end
	and orderno = case when isnull(@order_no, '') = '' then orderno else @order_no end
	and booked_by_memcode = case when isnull(@customercode, '') = '' then booked_by_memcode else @customercode end
	and booked_by_memmobile = case when isnull(@customermobno, '') = '' then booked_by_memmobile else @customermobno end
	and merchantMemcode = case when isnull(@merchantcode, '') = '' then merchantMemcode else @merchantcode end
	and merchantMemmobile = case when isnull(@merchantmobno, '') = '' then merchantMemmobile else @merchantmobno end
	and order_status = case when isnull(@status, -1) = -1 then order_status else @status end


	select @recordcount = count(*) from @TxnTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @TxnTable where rowno between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(rowno) From @TxnTable), 0) as totalrecords
END
