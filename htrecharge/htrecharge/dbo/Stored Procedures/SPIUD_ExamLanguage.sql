-- =============================================
-- Author: Saurabh Verma
-- Create date: 10-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPIUD_ExamLanguage]
	@CRUDType int, --Insert=1, Update=2, Delete=3
	@ExamLang_Id int,
	@ExamLang_Name varchar(50),
	@User_Id int,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;

	--Check is Name already exists 
	if(@CRUDType = 1 or @CRUDType = 2)
	begin
		if exists (select ExamLang_Name from M_ExamLanguage where ExamLang_Name = @ExamLang_Name And ExamLang_Id <> @ExamLang_Id)
		begin
			set @ExamLang_Id = -3
		end
	end

	if @ExamLang_Id >= 0
	begin
		--Insert
		if @CRUDType = 1
		begin
			insert into M_ExamLanguage (ExamLang_Name, User_Id, EntryDate, UpdateDate)
			values (@ExamLang_Name, @User_Id, @EntryDate, @EntryDate)

			set @ExamLang_Id = (select SCOPE_IDENTITY());
		end
		--Update
		else if @CRUDType = 2
		begin
			--Update record if id exists
			if exists (select ExamLang_Name from M_ExamLanguage where ExamLang_Id = @ExamLang_Id)
			begin
				update M_ExamLanguage set ExamLang_Name = @ExamLang_Name, UpdateDate = @EntryDate, User_Id = @User_Id
				where ExamLang_Id = @ExamLang_Id
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamLang_Id = -1
			end
		end
		--Delete
		else if @CRUDType = 3
		begin
			--Delete record if id exists
			if exists (select ExamLang_Name from M_ExamLanguage where ExamLang_Id = @ExamLang_Id)
			begin
				--Delete record if id is not using in children table
				if not exists (select ExamSet_Id from M_ExamSet where ExamLang_Id = @ExamLang_Id)
				begin
					delete from M_ExamLanguage where ExamLang_Id = @ExamLang_Id
				end
				--Return error code if record is using somewhere
				else
				begin
					set @ExamLang_Id = -2
				end
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamLang_Id = -1
			end
		end
	end

	select @ExamLang_Id
END
