-- =============================================
-- Author: Saurabh Verma
-- Create date: 02-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_TeamTree_Summary]
	@memberid int
AS
BEGIN
	SET NOCOUNT ON;
	Declare @Depth int
	Set @Depth = IsNull((Select [Level] From T_Member_Genealogy Where mem_id = @memberid), 0)

	Declare @NewTable as Table (
		LevelNo int, LevelName Varchar(50), MemberCount int, LevelEarning decimal(18,2)
	)

	Insert Into @NewTable (LevelNo, LevelName, MemberCount, LevelEarning)
    Select LevelNo, LevelName, 0 as MemberCount, 0 as LevelEarning From v_SponsorLevel

	Select mem_id, sponsor_id, Len(m_tree) - Len(Replace(m_tree, ',', '')) - (2+@Depth) as SelfLevelNo Into #HierTable From T_Member_Genealogy Where m_tree Like '%,'+Convert(Varchar(10), @memberid)+',%'
	--Select * From #HierTable

	Select pwt_id, pwt_memid, pwt_Credit, IncomeByMemId, IncomeByLevelNo Into #PayoutTable From T_PayoutWallet Where pwt_memid = @memberid And IncomeByMemId > 0 And IncomeByLevelNo > 0
	--Select * From #PayoutTable

	Update a Set 
		a.MemberCount = IsNull((Select Count(aa.mem_id) From #HierTable aa Where aa.SelfLevelNo = a.LevelNo), 0),
		a.LevelEarning = IsNull((Select Sum(aa.pwt_Credit) From #PayoutTable aa Where aa.IncomeByLevelNo = a.LevelNo), 0)
	From @NewTable a 

	Select * From @NewTable

	Drop Table #PayoutTable
	Drop Table #HierTable
END
