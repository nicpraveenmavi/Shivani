
-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPG_ExamSet]
	@ExamSet_Id int = null,
	@ExamLang_Id int = null,
	@ExamPay_TypeId int = null,
	@Service_Sub_Category_Id int = null,
	@Service_Category_Id int = null
AS
BEGIN
	SET NOCOUNT ON;
	Select ExamSet_Id, a.Service_Sub_Category_Id, d.Sub_Category_Name, ExamSet_Name, a.ExamLang_Id, b.ExamLang_Name, 
	a.ExamPay_TypeId, c.ExamPay_TypeName, Noof_Question, Time_Duration_Minute, 
	a.User_Id, a.EntryDate, a.UpdateDate, d.Service_Category_Id, e.Category_Name
	From M_ExamSet a
	Left Outer Join M_ExamLanguage b On a.ExamLang_Id = b.ExamLang_Id
	Left Outer Join M_ExamPayType c On a.ExamPay_TypeId = c.ExamPay_TypeId
	Left Outer Join M_Service_Type_Sub_Category d On a.Service_Sub_Category_Id = d.Service_Sub_Category_Id
	Left Outer Join M_Service_Type_Category e On d.Service_Category_Id = e.Service_Category_Id
	where 1 = 1 
	and ExamSet_Id = case when isnull(@ExamSet_Id, 0) = 0 then ExamSet_Id else @ExamSet_Id end
	and a.ExamLang_Id = case when isnull(@ExamLang_Id, 0) = 0 then a.ExamLang_Id else @ExamLang_Id end
	and a.ExamPay_TypeId = case when isnull(@ExamPay_TypeId, 0) = 0 then a.ExamPay_TypeId else @ExamPay_TypeId end
	and a.Service_Sub_Category_Id = case when isnull(@Service_Sub_Category_Id, 0) = 0 then a.Service_Sub_Category_Id else @Service_Sub_Category_Id end
	and d.Service_Category_Id = case when isnull(@Service_Category_Id, 0) = 0 then d.Service_Category_Id else @Service_Category_Id end
END
