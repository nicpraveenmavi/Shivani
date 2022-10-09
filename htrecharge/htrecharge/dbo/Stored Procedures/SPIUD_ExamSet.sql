
-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPIUD_ExamSet]
	@CRUDType int, --Insert=1, Update=2, Delete=3
	@ExamSet_Id int,
	@Service_Sub_Category_Id int,
	@ExamSet_Name nvarchar(max),
	@ExamLang_Id int,
	@ExamPay_TypeId int,
	@Noof_Question int,
	@Time_Duration_Minute int,
	@User_Id int,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	--Check is Name already exists 
	if(@CRUDType = 1 or @CRUDType = 2)
	begin
		if exists (select ExamSet_Name from M_ExamSet where ExamSet_Name = @ExamSet_Name 
						and ExamLang_Id = @ExamLang_Id and ExamPay_TypeId = @ExamPay_TypeId 
						and ExamSet_Id <> @ExamSet_Id)
		begin
			set @ExamSet_Id = -3
		end
	end

	if @ExamSet_Id >= 0
	begin
		--Insert
		if @CRUDType = 1
		begin
			insert into M_ExamSet (Service_Sub_Category_Id, ExamSet_Name, ExamLang_Id, ExamPay_TypeId, Noof_Question, 
									Time_Duration_Minute, User_Id, EntryDate, UpdateDate)
			values (@Service_Sub_Category_Id, @ExamSet_Name, @ExamLang_Id, @ExamPay_TypeId, @Noof_Question, 
					@Time_Duration_Minute, @User_Id, @EntryDate, @EntryDate)

			set @ExamSet_Id = (select SCOPE_IDENTITY());
		end
		--Update
		else if @CRUDType = 2
		begin
			--Update record if id exists
			if exists (select ExamSet_Name from M_ExamSet where ExamSet_Id = @ExamSet_Id)
			begin
				update M_ExamSet set Service_Sub_Category_Id = @Service_Sub_Category_Id, ExamSet_Name = @ExamSet_Name, 
						ExamLang_Id = @ExamLang_Id, ExamPay_TypeId = @ExamPay_TypeId, Noof_Question = @Noof_Question, 
						Time_Duration_Minute = @Time_Duration_Minute, UpdateDate = @EntryDate, User_Id = @User_Id
				where ExamSet_Id = @ExamSet_Id
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamSet_Id = -1
			end
		end
		--Delete
		else if @CRUDType = 3
		begin
			--Delete record if id exists
			if exists (select ExamSet_Name from M_ExamSet where ExamSet_Id = @ExamSet_Id)
			begin
				--Delete record if id is not using in children table
				if not exists (select Question_Id from M_ExamQuestions where ExamSet_Id = @ExamSet_Id)
				begin
					delete from M_ExamSet where ExamSet_Id = @ExamSet_Id
				end
				--Return error code if record is using somewhere
				else
				begin
					set @ExamSet_Id = -2
				end
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamSet_Id = -1
			end
		end
	end

	select @ExamSet_Id
END
