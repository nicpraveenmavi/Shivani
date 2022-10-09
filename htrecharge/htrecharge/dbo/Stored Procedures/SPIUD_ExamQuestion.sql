-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPIUD_ExamQuestion]
	@CRUDType int, --Insert=1, Update=2, Delete=3
	@Question_Id int,
	@ExamSet_Id int,
	@Question_Text nvarchar(max),
	@Option_1 nvarchar(max) = null,
	@Option_2 nvarchar(max) = null,
	@Option_3 nvarchar(max) = null,
	@Option_4 nvarchar(max) = null,
	@Question_Image_VirPath varchar(max) = null,
	@Option_1_Image_VirPath varchar(max) = null,
	@Option_2_Image_VirPath varchar(max) = null,
	@Option_3_Image_VirPath varchar(max) = null,
	@Option_4_Image_VirPath varchar(max) = null,
	@HasMultipleRightAns bit,
	@Is_Option_1_Right bit,
	@Is_Option_2_Right bit,
	@Is_Option_3_Right bit,
	@Is_Option_4_Right bit,
	@User_Id int,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	--Check is Name already exists 
	if(@CRUDType = 1 or @CRUDType = 2)
	begin
		if exists (select Question_Text from M_ExamQuestions where Question_Text = @Question_Text
						and ExamSet_Id = @ExamSet_Id and Question_Id <> @Question_Id)
		begin
			set @Question_Id = -3
		end
	end

	if @ExamSet_Id >= 0
	begin
		--Insert
		if @CRUDType = 1
		begin
			insert into M_ExamQuestions (
				ExamSet_Id, Question_Text, Question_Image_VirPath, Option_1, Option_2, Option_3, Option_4, 
				Option_1_Image_VirPath, Option_2_Image_VirPath, Option_3_Image_VirPath, Option_4_Image_VirPath, HasMultipleRightAns,
				Is_Option_1_Right, Is_Option_2_Right, Is_Option_3_Right, Is_Option_4_Right, User_Id, EntryDate, UpdateDate
			)
			values (
				@ExamSet_Id, @Question_Text, @Question_Image_VirPath, @Option_1, @Option_2, @Option_3, @Option_4, 
				@Option_1_Image_VirPath, @Option_2_Image_VirPath, @Option_3_Image_VirPath, @Option_4_Image_VirPath, @HasMultipleRightAns,
				@Is_Option_1_Right, @Is_Option_2_Right, @Is_Option_3_Right, @Is_Option_4_Right, @User_Id, @EntryDate, @EntryDate
			)

			set @Question_Id = (select SCOPE_IDENTITY());
		end
		--Update
		else if @CRUDType = 2
		begin
			--Update record if id exists
			if exists (select Question_Text from M_ExamQuestions where Question_Id = @Question_Id)
			begin
				update M_ExamQuestions set ExamSet_Id = @ExamSet_Id, Question_Text = @Question_Text, Question_Image_VirPath = @Question_Image_VirPath, 
					Option_1 = @Option_1, Option_2 = @Option_2, Option_3 = @Option_3, Option_4 = @Option_4, 
					Option_1_Image_VirPath = @Option_1_Image_VirPath, Option_2_Image_VirPath = @Option_2_Image_VirPath, 
					Option_3_Image_VirPath = @Option_3_Image_VirPath, Option_4_Image_VirPath = @Option_4_Image_VirPath, 
					HasMultipleRightAns = @HasMultipleRightAns, Is_Option_1_Right = @Is_Option_1_Right, Is_Option_2_Right = @Is_Option_2_Right, 
					Is_Option_3_Right = @Is_Option_3_Right, Is_Option_4_Right = @Is_Option_4_Right, UpdateDate = @EntryDate, User_Id = @User_Id
				where Question_Id = @Question_Id
			end
			--Return error code if record does not exists
			else
			begin
				set @Question_Id = -1
			end
		end
		--Delete
		else if @CRUDType = 3
		begin
			--Delete record if id exists
			if exists (select Question_Text from M_ExamQuestions where Question_Id = @Question_Id)
			begin
				--------Delete record if id is not using in children table
				------if not exists (select Question_Id from M_ExamQuestions..... where Question_Id = @Question_Id)
				------begin
					delete from M_ExamQuestions where Question_Id = @Question_Id
				------end
				--------Return error code if record is using somewhere
				------else
				------begin
				------	set @Question_Id = -2
				------end
			end
			--Return error code if record does not exists
			else
			begin
				set @Question_Id = -1
			end
		end
	end

	select @Question_Id
END
