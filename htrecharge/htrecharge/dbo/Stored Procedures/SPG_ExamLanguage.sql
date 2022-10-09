-- =============================================
-- Author: Saurabh Verma
-- Create date: 14-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPG_ExamLanguage]
	@ExamLang_Id int
AS
BEGIN
	SET NOCOUNT ON;
	Select ExamLang_Id, ExamLang_Name, User_Id, EntryDate, UpdateDate From M_ExamLanguage
	where 1 = 1 
	and ExamLang_Id = case when isnull(@ExamLang_Id, 0) = 0 then ExamLang_Id else @ExamLang_Id end
END
