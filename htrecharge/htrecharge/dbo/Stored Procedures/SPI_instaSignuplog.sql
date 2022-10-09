CREATE proc [dbo].[SPI_instaSignuplog]
@type varchar(50),
@statuscode varchar(50)='',
@actcode varchar(50)='',
@status varchar(50)='',
@data varchar(50)='',
@aadhaar varchar(50)='',
@otpReferenceID varchar(50)='',
@hash varchar(50)='',
@timestamp varchar(50)='',
@ipay_uuid varchar(50)='',

@orderid varchar(50)='',
@environment varchar(50)='',
@mobile varchar(10)='',
@email varchar(50)='',
@pan  varchar(15)='',
@Userid varchar(50)='',
@Adhaar varchar(15)='',
@longitute varchar(50)='',
@latitude varchar(50)='',
@uniqueid varchar(50)='',
@outletId  varchar(50)='',
@name  varchar(50)='',
@dateOfBirth varchar(50)='',
@gender varchar(15)='',
@pincode varchar(50)='',
@districtName varchar(50)='',
@address varchar(500)='',
@state varchar(50)='',
@profilePic varchar(500)=''
as
begin
if(@type='Insert')
begin
insert into tbl_signup_Log(Req_mobile,Req_email,Req_pan,Userid,Req_Adhaar,Req_longitute,Req_latitude,uniqueid) values(@mobile,@email,@pan,@Userid,@Adhaar,@longitute,@latitude,@uniqueid)
end
else if(@type='Update')
begin 
update tbl_signup_Log set Res_statuscode=@statuscode,Res_actcode=@actcode,Res_status=@status,Res_data=@data,Res_aadhaar=@aadhaar,Res_otpReferenceID=@otpReferenceID,Res_hash=@hash,Res_timestamp=@timestamp,Res_ipay_uuid=@ipay_uuid,Res_orderid=@orderid,Res_environment=@environment where uniqueid=@uniqueid

end


if(@type='Getuserdetails')
begin
select Res_hash,Res_otpReferenceID from tbl_signup_Log where Userid=@Userid
end

if(@type='ProfileUpdate')
begin
update tbl_signup_Log set Res_statuscode=@statuscode,Res_actcode=@actcode,Res_status=@status,Res_data=@data,
outletId=@outletId,name=@name,dateOfBirth=@dateOfBirth,gender=@gender,pincode=@pincode,state=@state,
districtName=@districtName,address=@address,profilePic=@profilePic

where Res_otpReferenceID=@otpReferenceID

select * from tbl_signup_Log where Res_otpReferenceID=@otpReferenceID

end

end	
