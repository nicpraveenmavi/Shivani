-- =============================================
-- Author: Saurabh Verma
-- Create date: 22-Nov-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_Eko_Aeps_Member]
	@user_code varchar(20) = null,
	@merchantmobileno varchar(20) = null
AS
BEGIN
	SET NOCOUNT ON;

    Select 
		onboarduserid, user_code, mem_id, merchantmobileno, merchantfirstname, merchantmiddlename, merchantlastName, 
		merchantpan, merchantemail, merchantdob, merchantshopname, merchantresiadd, merchantresicity, merchantresistate,
		merchantresipincode, statuscode, statustext, biometricmodelname, biometricdeviceno, merchantofficeadd, merchantofficecity, 
		merchantofficestate, merchantofficepincode, merchantproofadd, merchantproofcity, merchantproofstate, merchantproofpincode, 
		panfilepath, aadharfilefrontpath, aadharfilebackpath, isnull(currentScreenNo, 0) as currentScreenNo
	From T_Eko_Aeps_Member Where 1 = 1
	And user_code = Case When IsNull(@user_code, '') = '' Then user_code Else @user_code End
	And merchantmobileno = Case When IsNull(@merchantmobileno, '') = '' Then merchantmobileno Else @merchantmobileno End
END

