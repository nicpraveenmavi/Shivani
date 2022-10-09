-- =============================================
-- Author: Saurabh Verma
-- Create date: 18-Nov-2021
-- Alter date: 19-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPU_Eko_Aeps_Member]
	@updatetype varchar(50),
	@updatedate datetime,
	@onboarduserid bigint = 0,

	@user_code varchar(20) = null,
	@merchantmobileno varchar(20) = null,
	@statuscode int = 0,
	@statustext varchar(250) = null,

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

	@biometricmodelname varchar(100) = null,
	@biometricdeviceno varchar(100) = null,
	@merchantofficeadd varchar(MAX) = null,
	@merchantofficecity varchar(100) = null,
	@merchantofficestate varchar(100) = null,
	@merchantofficepincode varchar(100) = null,
	@merchantproofadd varchar(MAX) = null,
	@merchantproofcity varchar(100) = null,
	@merchantproofstate varchar(100) = null,
	@merchantproofpincode varchar(100) = null,
	@panfilepath varchar(250) = null,
	@aadharfilefrontpath varchar(250) = null,
	@aadharfilebackpath varchar(250) = null,
	@currentScreenNo int
AS
BEGIN
	SET NOCOUNT ON;

	if @onboarduserid <= 0
	begin
		select @onboarduserid = onboarduserid from T_Eko_Aeps_Member where merchantmobileno = @merchantmobileno
		set @onboarduserid = isnull(@onboarduserid, 0)
	end

	if @onboarduserid > 0
	begin
		if @updatetype = 'UPDATE_USER_ONBOARD'
		begin
			Update T_Eko_Aeps_Member Set
				merchantfirstname = @merchantfirstname, merchantmiddlename = @merchantmiddlename, merchantlastname = @merchantlastname, 
				merchantpan = @merchantpan, merchantemail = @merchantemail, merchantdob = @merchantdob, merchantshopname = @merchantshopname, 
				merchantresiadd = @merchantresiadd, merchantresicity = @merchantresicity, merchantresistate = @merchantresistate, 
				merchantresipincode = merchantresipincode, updatedate = @updatedate, currentScreenNo = @currentScreenNo
			Where onboarduserid = @onboarduserid
		end
		else if @updatetype = 'UPDATE_USER_CODE'
		begin
			Update T_Eko_Aeps_Member Set
				user_code = @user_code, statuscode = @statuscode, statustext = @statustext, updatedate = @updatedate, currentScreenNo = @currentScreenNo
			Where onboarduserid = @onboarduserid
		end
		else if @updatetype = 'UPDATE_USER_STATUS'
		begin
			Update T_Eko_Aeps_Member Set
				statuscode = @statuscode, statustext = @statustext, updatedate = @updatedate, currentScreenNo = @currentScreenNo
			Where onboarduserid = @onboarduserid
		end
		else if @updatetype = 'UPDATE_ACTIVATE_SERVICE'
		begin
			Update T_Eko_Aeps_Member Set
				biometricmodelname = @biometricmodelname, biometricdeviceno = @biometricdeviceno, merchantofficeadd = @merchantofficeadd, 
				merchantofficecity = @merchantofficecity, merchantofficestate = @merchantofficestate, merchantofficepincode = @merchantofficepincode, 
				merchantproofadd = @merchantproofadd, merchantproofcity = @merchantproofcity, merchantproofstate = @merchantproofstate, 
				merchantproofpincode = @merchantproofpincode, updatedate = @updatedate, currentScreenNo = @currentScreenNo,
				panfilepath = case when isnull(@panfilepath, '') = '' then panfilepath else @panfilepath end, 
				aadharfilefrontpath = case when isnull(@aadharfilefrontpath, '') = '' then aadharfilefrontpath else @aadharfilefrontpath end, 
				aadharfilebackpath = case when isnull(@aadharfilebackpath, '') = '' then aadharfilebackpath else @aadharfilebackpath end
			Where onboarduserid = @onboarduserid
		end
	end

	Select @onboarduserid
END

