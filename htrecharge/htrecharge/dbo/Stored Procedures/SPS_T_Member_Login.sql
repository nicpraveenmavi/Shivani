
CREATE procedure [dbo].[SPS_T_Member_Login]
@QueryType varchar(200)=null,@Mobile bigint =null,@IP varchar(50)=null,@Mem_Id int =null
as
begin

if(@QueryType='CheckMobileForLogin')
begin
select Mobile from T_Member where Mobile=@Mobile
end

if(@QueryType='Login')
begin
update T_Member set Web_Last_Login_DateTime=getdate()  where Mobile=@Mobile
select Mem_ID,Name from T_Member  where Mobile=@Mobile
end


if(@QueryType='Logout')
begin
update T_Member set Web_LogOutDateTime=getdate()  where Mobile=@Mobile

end
end

