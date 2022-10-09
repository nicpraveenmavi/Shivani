-- =============================================
-- Author: Saurabh Verma
-- Create date: 14-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPG_ExamPayType]
	@ExamPay_TypeId int = null
AS
BEGIN
	SET NOCOUNT ON;
	Select ExamPay_TypeId, ExamPay_TypeName, User_Id, EntryDate, UpdateDate From M_ExamPayType
	where 1 = 1 
	and ExamPay_TypeId = case when isnull(@ExamPay_TypeId, 0) = 0 then ExamPay_TypeId else @ExamPay_TypeId end
END
