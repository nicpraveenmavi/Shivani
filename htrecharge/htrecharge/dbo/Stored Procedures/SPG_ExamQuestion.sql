-- =============================================
-- Author: Saurabh Verma
-- Create date: 21-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPG_ExamQuestion]
	@Question_Id int = null,
	@ExamSet_Id int = null
AS
BEGIN
	SET NOCOUNT ON;
	Select a.Question_Id, a.ExamSet_Id, b.ExamSet_Name, a.Question_Text, a.Option_1, a.Option_2, a.Option_3, a.Option_4,
		a.Question_Image_VirPath, a.Option_1_Image_VirPath, a.Option_2_Image_VirPath, a.Option_3_Image_VirPath, a.Option_4_Image_VirPath, 
		a.HasMultipleRightAns, a.Is_Option_1_Right, a.Is_Option_2_Right, a.Is_Option_3_Right, a.Is_Option_4_Right,
		a.User_Id, a.EntryDate, a.UpdateDate
	From M_ExamQuestions a
	Left Outer Join M_ExamSet b On a.ExamSet_Id = b.ExamSet_Id
	where 1 = 1 
	and Question_Id = case when isnull(@Question_Id, 0) = 0 then Question_Id else @Question_Id end
	and a.ExamSet_Id = case when isnull(@ExamSet_Id, 0) = 0 then a.ExamSet_Id else @ExamSet_Id end
END
