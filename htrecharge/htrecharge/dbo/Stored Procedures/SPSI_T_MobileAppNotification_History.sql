CREATE procedure [dbo].[SPSI_T_MobileAppNotification_History]
@QueryType varchar(200)=null,@Notification_Id int =null,@Notification_Title varchar(500)=null,
@Notification_Body  varchar(2000)=null, @Data_Title varchar(500)=null ,@Data_Body varchar(2000)=null ,@IP varchar(200)=null,@Created_By int =null,
@APIResponse varchar(3000) =null,@APIRequest varchar(3000)=null
as
begin

if(@QueryType='Insert')
begin
insert into T_MobileAppNotification_History(Notification_Title,Notification_Body,Data_Title,Data_Body,Created_DateTime,Created_By,IP,APIRequest,Request_Time)
 output inserted.Notification_Id values (@Notification_Title,@Notification_Body,@Data_Title,@Data_Body,getdate(),@Created_By,@IP,@APIRequest,getdate())
end


if(@QueryType='UpdateAPIResponse')
begin
update T_MobileAppNotification_History  set APIResponse=@APIResponse,Updated_DateTime=getdate(),Updated_By=@Created_By,Response_Time=getdate()
 where Notification_Id =@Notification_Id
 
end

if(@QueryType='GetNotification')
begin
select *From T_MobileAppNotification_History order by Created_DateTime desc
end

end
