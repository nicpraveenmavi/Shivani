
CREATE procedure [dbo].[SPIU_T_Users]
@QueryType varchar(200)=null,
@Name varchar(150)=null ,@Mobile varchar(10)=null,@Email varchar(150)=null,@Status varchar(1)=null,@User_Name varchar(255)=null,@Password varchar(255)=null
,@User_ID int =null,@User_Type_Id int =null,@LogedinUser_Id int =null
as
begin



if(@QueryType='GetUserDetails')
begin
select u.Name,u.Email,u.User_ID,u.Mobile,l.Status,l.User_Name from T_Users as u
inner join T_User_Login as l on u.User_ID=l.User_Id
where u.User_ID=@User_ID
end

if(@QueryType='GetUserRolesForEdit')
begin
select m.User_Type_Id,r.Status,m.User_Type  from M_UserType as m
left join  T_User_Role r on m.User_Type_Id=r.User_Type_Id  and r.User_ID=@User_ID

end

if(@QueryType='GetRegisteredUser')
begin

select u.Name,u.Mobile,u.Email,u.user_id,
case when l.Status ='Y' then 'Active'
 when  isnull(l.Status,'N') ='N' then 'Inactive' end 'Login_Status' ,u.Created_DateTime
 from T_Users as u
inner join T_User_Login as l on l.User_ID=u.User_ID
order by u.Created_DateTime desc
end

if(@QueryType='GetUserRoles')
begin

select  m.User_Type +' (Status : '+
case when ur.Status ='Y' then 'Active )'
 when  isnull(ur.Status,'N') ='N' then 'Inactive )' end 'Role_Status', 

  m.User_Type ,
case when ur.Status ='Y' then 'Active'
 when  isnull(ur.Status,'N') ='N' then 'Inactive' end 'Status'
 From T_User_Role as ur 
inner join M_UserType as m on m.User_Type_Id=ur.User_Type_Id
where ur.User_Id=@User_ID
end

if(@QueryType='BindRole')
begin
select  User_Type_Id as 'Value',User_Type as 'Text'  From M_UserType
end

if(@QueryType='InsertUser')
begin
insert into T_Users(Name,Mobile,Email,Created_DateTime,created_by) output inserted.User_ID values (@Name,@Mobile,@Email,getdate(),@LogedinUser_Id)
end

if(@QueryType='UpdateUser')
begin
update T_Users set Name=@Name,Email=@Email,Mobile=@Mobile,Updated_DateTime=Getdate(),Updated_By=@LogedinUser_Id where user_Id=@User_ID
update T_User_Login set Status=@Status,Updated_DateTime=getdate(),Updated_By=@LogedinUser_Id ,Password=iif(@Password is null,Password,@Password) where user_id=@User_ID

end

if(@QueryType='InsertLoginDetails')
begin
insert into T_User_Login(User_ID,User_Name,Password,Status,Created_DateTime,created_by)  values (@User_ID,@User_Name,@Password,@Status,getdate(),@LogedinUser_Id)
end

if(@QueryType='InsertUserRole')
begin
insert into T_User_Role(User_ID,User_Type_Id,Status,Created_DateTime,created_by)  values (@User_ID,@User_Type_Id,@Status,getdate(),@LogedinUser_Id)
end

if(@QueryType='DeleteUserRole')
begin
delete from T_User_Role where user_id=@User_ID
end


if(@QueryType='UniqueUserName')
begin

select  top 1 1 from T_User_Login where User_Name=@User_Name
end
if(@QueryType='UniqueMobile')
begin
if(@User_ID is null)
begin
select  top 1 1 from T_Users where Mobile=@Mobile
end
else
begin
select  top 1 1 from T_Users where Mobile=@Mobile and USER_ID!=@User_ID
end
end

if(@QueryType='UniqueEmail')
begin
if(@User_ID is null)
begin
select  top 1 1 from T_Users where Email=@Email
end
else
begin
select  top 1 1 from T_Users where Email=@Email and USER_ID!=@User_ID
end
end

end
