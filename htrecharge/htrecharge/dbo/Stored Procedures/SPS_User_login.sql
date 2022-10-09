CREATE procedure [dbo].[SPS_User_login]
@QueryType varchar(255)=null, @User_Name varchar(255)=null,@User_Id int =null,@IP varchar(100)=null,
@NewPassword varchar(255)=null,@OldPassword varchar(255)=null,@User_Login_Id int =null,@ForgotPasswordToken varchar(200)=null
as
begin

if(@QueryType ='ResetPassword')
begin
select @User_Id=User_Id from T_User_Login where User_Login_Id=@User_Login_Id
insert into T_PasswordChange_History(User_Id,Old_Password,New_Password,IP,Created_DateTime) 
select  user_Id,Password,@NewPassword,@IP,getdate() from T_user_login where User_ID=@User_Id

update T_user_login set Password=@NewPassword,ForgotPasswordToken=null where user_id=@User_Id


end

if(@QueryType ='CheckForgotLinkExpire')
begin

select ForgotPasswordToken from T_User_Login  where User_Login_Id=1 and ForgotPasswordToken=@ForgotPasswordToken
end


if(@QueryType ='ChangePassword')
begin
if exists (select top 1 1 from T_user_login where user_id=@User_Id and Password=@OldPassword )
begin
insert into T_PasswordChange_History(User_Id,Old_Password,New_Password,IP,Created_DateTime) 
select  user_Id,Password,@NewPassword,@IP,getdate() from T_user_login where User_ID=@User_Id
update T_user_login set Password=@NewPassword where user_id=@User_Id
end
else
begin
select -1
end

end


if(@QueryType ='ForgotPassword')
begin
update T_User_Login set ForgotPasswordToken=@ForgotPasswordToken where  User_Name COLLATE Latin1_general_CS_AS =@User_Name

select l.User_Login_Id,u.Email,u.Mobile,u.Name,l.ForgotPasswordToken from T_User_Login l
inner join T_Users as  u on l.User_ID=u.User_ID
 where User_Name COLLATE Latin1_general_CS_AS =@User_Name
 
end



if(@QueryType ='Login')
begin
select  user_id,user_name,password,status from T_user_login where User_Name COLLATE Latin1_general_CS_AS =@User_Name
end
if(@QueryType ='AfterLoginUpdate')
begin
update T_User_Login set Last_Login_IP=@IP,Last_Login_DateTime=getdate() where user_id=@User_Id
end
if(@QueryType ='LoginUserData')
begin
select  u.User_ID,r.User_Type_Id,u.Name from T_users as u
inner join T_User_Role as r on u.User_ID=r.User_Id 
where u.user_id=@User_Id
end

if(@QueryType ='Loginlog')
begin
insert into  t_user_login_log (user_Id,Login_DateTime,ip) values (@User_Id,getdate(),@IP)
end
if(@QueryType ='Loginoutlog')
begin
insert into  t_user_login_log (user_Id,Logout_DateTime,ip) values (@User_Id,getdate(),@IP)
end
end
