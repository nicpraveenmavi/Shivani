-- =============================================
-- Author: Saurabh Verma
-- Create date: 02-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_TeamTree_LevelWiseList]
	@pageno int,
	@pagesize int,
	@memberid int,
	@levelno int
AS
BEGIN
	SET NOCOUNT ON;
	Declare @recordcount int, @pagecount int, @Depth int
	Set @Depth = IsNull((Select [Level] From T_Member_Genealogy Where mem_id = @memberid), 0)

	Declare @NewTable as Table (
		RowNo bigint, SelfLevelNo int,
		MemberId int, MemberCode varchar(50), MemberName varchar(100), MemberMobile varchar(20), 
		SponsorMemberId int, SponsorMemberCode varchar(50), SponsorMemberName varchar(100), SponsorMemberMobile varchar(20),
		LevelEarning decimal(18,2)
	)

	Insert Into @NewTable (
		RowNo, SelfLevelNo, MemberId, MemberCode, MemberName, MemberMobile, SponsorMemberId, SponsorMemberCode, SponsorMemberName, SponsorMemberMobile, LevelEarning
	)
	Select ROW_NUMBER() OVER (ORDER By created_on) AS RowNo, SelfLevelNo, MemberId, MemberCode, MemberName, MemberMobile, SponsorMemberId, SponsorMemberCode, SponsorMemberName, SponsorMemberMobile, LevelEarning
	From (
		Select 
			Len(m_tree) - Len(Replace(m_tree, ',', '')) - (2+@Depth) as SelfLevelNo,
			a.mem_id as MemberId, b.Mem_Code as MemberCode, IsNull(b.Name, '') as MemberName, b.Mobile as MemberMobile, 
			a.sponsor_id as SponsorMemberId, c.Mem_Code as SponsorMemberCode, IsNull(c.Name, '') as SponsorMemberName, c.Mobile as SponsorMemberMobile, 
			0 LevelEarning, a.created_on
		From T_Member_Genealogy a
			Inner Join T_Member b On a.mem_id = b.Mem_ID
			Inner Join T_Member c On a.sponsor_id = c.Mem_ID
		Where m_tree Like '%,'+Convert(Varchar(10), @memberid)+',%'
	) as T Where SelfLevelNo = @levelno
	

	Select pwt_id, pwt_memid, pwt_Credit, IncomeByMemId, IncomeByLevelNo Into #PayoutTable From T_PayoutWallet Where pwt_memid = @memberid And IncomeByMemId > 0 And IncomeByLevelNo > 0
	--Select * From #PayoutTable

	Update a Set 
		a.LevelEarning = IsNull((Select Sum(aa.pwt_Credit) From #PayoutTable aa Where aa.IncomeByLevelNo = a.SelfLevelNo And aa.IncomeByMemId = a.MemberId), 0)
	From @NewTable a 

	--Select * From @NewTable


	select @recordcount = count(RowNo) from @NewTable
	set @pagecount = ceiling(cast(@recordcount as decimal(10, 2)) / cast(@PageSize as decimal(10, 2)))

	SELECT * FROM @NewTable where RowNo between(@PageNo -1) * @PageSize + 1 and(((@PageNo -1) * @PageSize + 1) + @PageSize) - 1
	select @pagecount as totalpagecount, IsNull((Select Count(RowNo) From @NewTable), 0) as totalrecords

	Drop Table #PayoutTable
END
