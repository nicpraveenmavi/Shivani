-- =============================================
-- Author: Saurabh Verma
-- Create date: 11-Feb-2022
-- Alter date:
-- Description:
-- =============================================
CREATE PROCEDURE [dbo].[SPIUD_ExamPayType]
	@CRUDType int, --Insert=1, Update=2, Delete=3
	@ExamPay_TypeId int,
	@ExamPay_TypeName varchar(50),
	@User_Id int,
	@EntryDate datetime
AS
BEGIN
	SET NOCOUNT ON;
	
	--Check is Name already exists 
	if(@CRUDType = 1 or @CRUDType = 2)
	begin
		if exists (select ExamPay_TypeName from M_ExamPayType where ExamPay_TypeName = @ExamPay_TypeName and ExamPay_TypeId <> @ExamPay_TypeId)
		begin
			set @ExamPay_TypeId = -3
		end
	end

	if @ExamPay_TypeId >= 0
	begin
		--Insert
		if @CRUDType = 1
		begin
			insert into M_ExamPayType (ExamPay_TypeName, User_Id, EntryDate, UpdateDate)
			values (@ExamPay_TypeName, @User_Id, @EntryDate, @EntryDate)

			set @ExamPay_TypeId = (select SCOPE_IDENTITY());
		end
		--Update
		else if @CRUDType = 2
		begin
			--Update record if id exists
			if exists (select ExamPay_TypeName from M_ExamPayType where ExamPay_TypeId = @ExamPay_TypeId)
			begin
				update M_ExamPayType set ExamPay_TypeName = @ExamPay_TypeName, UpdateDate = @EntryDate, User_Id = @User_Id
				where ExamPay_TypeId = @ExamPay_TypeId
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamPay_TypeId = -1
			end
		end
		--Delete
		else if @CRUDType = 3
		begin
			--Delete record if id exists
			if exists (select ExamPay_TypeName from M_ExamPayType where ExamPay_TypeId = @ExamPay_TypeId)
			begin
				--Delete record if id is not using in children table
				if not exists (select ExamSet_Id from M_ExamSet where ExamPay_TypeId = @ExamPay_TypeId)
				begin
					delete from M_ExamPayType where ExamPay_TypeId = @ExamPay_TypeId
				end
				--Return error code if record is using somewhere
				else
				begin
					set @ExamPay_TypeId = -2
				end
			end
			--Return error code if record does not exists
			else
			begin
				set @ExamPay_TypeId = -1
			end
		end
	end

	select @ExamPay_TypeId
END
