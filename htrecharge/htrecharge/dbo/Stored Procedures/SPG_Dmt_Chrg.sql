-- =============================================
-- Author: Saurabh Verma
-- Create date: 15-Nov-2021
-- Alter date: 01-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPG_Dmt_Chrg]
	@memberid bigint,
	@txnamt decimal(18,2),
	@IP varchar(50) = null
AS
BEGIN
	SET NOCOUNT ON;
	Declare @startloop int, @PackageId bigint, @Service_Category_Id int, @pkgcom_commtype int, @pkgcom_commcharge int, 
		@uplinelevelupto int, @selfcommconfig decimal(18,2), @txncharge decimal(18,2), @PackageCommId bigint
		
	Select Top 1 @PackageId = Pp_Package_Id From T_Package Where Mem_Id = @memberid Order By Purchage_date Desc
	Set @txncharge = 0

	/*
	NOTES:
	1. @pkgcom_commtype		value:   1 = fixed commission, 2 = percent, 3 = slab --This column value will affect all columns (pkgcom_commvalueforself, pkgcom_commvalueforupliner, pkgcom_commvaluefor6level)
	2. @pkgcom_commcharge	value:   1 = credit, 2 = debit --This column value will affect only on column "pkgcom_commvalueforself"
	*/
	Set @Service_Category_Id = 24 ---Is Only for Money Transfer From Table "M_Service_Type_Sub_Category" Column "Service_Sub_Category_Id"
	Select 
		@PackageCommId = pkgcom_id,
		@pkgcom_commtype = pkgcom_commtype, @pkgcom_commcharge = pkgcom_commcharge, @selfcommconfig = pkgcom_commvalueforself
	From M_package_commission Where Packageid = @PackageId and pkgcom_servicesubcategoryid = @Service_Category_Id
	Set @pkgcom_commtype = isnull(@pkgcom_commtype, 0)
	Set @pkgcom_commcharge = isnull(@pkgcom_commcharge, 0)
	Set @selfcommconfig = isnull(@selfcommconfig, 0) 


	if @pkgcom_commtype = 3
	begin
		Select 
			@pkgcom_commtype = commtype, @pkgcom_commcharge = commcharge, @selfcommconfig = commissionself
		From [M_package_commission _slab] Where pkgcom_id = @PackageCommId And @txnamt Between mintramnt And maxtramnt
	end
	Set @pkgcom_commtype = isnull(@pkgcom_commtype, 0)
	Set @pkgcom_commcharge = isnull(@pkgcom_commcharge, 0)
	Set @selfcommconfig = isnull(@selfcommconfig, 0) 

	if @pkgcom_commtype = 1
	begin
		Set @txncharge = @selfcommconfig
	end
	else if @pkgcom_commtype = 2
	begin
		Set @txncharge = @txnamt * @selfcommconfig / 100
	end

	Select @txncharge
END

