CREATE procedure [dbo].[SPSU_M_SystemSetting]
	@QueryType varchar(100) = null
as
begin
	if(@QueryType='GetMaintenance')
	begin
		select 
			systemstatus, Maintenance_Message, adminfee, tdsfee, CoinConversionRate, CourierSerCharge, TaxPerOnCourierCharge
		From M_SystemSetting
	end
end
