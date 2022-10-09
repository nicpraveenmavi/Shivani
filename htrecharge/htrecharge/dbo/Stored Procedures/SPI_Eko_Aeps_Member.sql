-- =============================================
-- Author: Saurabh Verma
-- Create date: 18-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPI_Eko_Aeps_Member]
	@entrydate datetime,
	@user_code varchar(20),
	@mem_id int,
	@merchantmobileno varchar(20),
	@merchantfirstname varchar(150) = null,
	@merchantmiddlename varchar(50) = null,
	@merchantlastname varchar(50) = null,
	@merchantpan varchar(20) = null,
	@merchantemail varchar(150) = null,
	@merchantdob varchar(20) = null,
	@merchantshopname varchar(150) = null,
	@merchantresiadd varchar(max) = null,
	@merchantresicity varchar(100) = null,
	@merchantresistate varchar(100) = null,
	@merchantresipincode varchar(10) = null,
	@currentScreenNo int = 0
AS
BEGIN
	SET NOCOUNT ON;
	Declare @onboarduserid	bigint

	select @onboarduserid = onboarduserid from T_Eko_Aeps_Member where merchantmobileno = @merchantmobileno
	set @onboarduserid = isnull(@onboarduserid, 0)

	if @onboarduserid <= 0
	begin
		Insert Into T_Eko_Aeps_Member (
			entrydate, updatedate, user_code, mem_id, merchantmobileno, merchantfirstname, merchantmiddlename, 
			merchantlastname, merchantpan, merchantemail, merchantdob, merchantshopname, merchantresiadd, 
			merchantresicity, merchantresistate, merchantresipincode, currentScreenNo
		) Values (
			@entrydate, @entrydate, @user_code, @mem_id, @merchantmobileno, @merchantfirstname, @merchantmiddlename, 
			@merchantlastname, @merchantpan, @merchantemail, @merchantdob, @merchantshopname, @merchantresiadd, 
			@merchantresicity, @merchantresistate, @merchantresipincode, @currentScreenNo
		)

		Set @onboarduserid = (Select SCOPE_IDENTITY());
	end

	Select @onboarduserid
END

