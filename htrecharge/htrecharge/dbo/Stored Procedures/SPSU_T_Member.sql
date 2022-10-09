
CREATE procedure [dbo].[SPSU_T_Member]
@QueryType varchar(100)=null,@Mem_Id int =null,@Meminfo_emailid varchar(75)=null,@Status varchar(1)=null,@Meminfo_whatsappnumber bigint=null
,@Meminfo_designation varchar(150)=null,@Meminfo_membertype varchar(50)=null,@Meminfo_state varchar(150)=null
,@Meminfo_address varchar(255)=null,@Meminfo_pincode int =null,@Meminfo_website varchar(255)=null,@Organizationname varchar(255)=null,@IP varchar(100)=null,@kycStatus varchar(1)=null
as
begin
if(@QueryType='UpdateKYCStatus')
begin
update T_Member_Info set Meminfo_KYC_status=@kycStatus,Meminfo_lastupdateondate=getdate(),Meminfo_lastupdateIP=@IP where Memid=@Mem_Id
end


if(@QueryType='UpdateMember')
begin
update T_Member_Info  set Meminfo_emailid=@Meminfo_emailid,Meminfo_whatsappnumber=@Meminfo_whatsappnumber
,Meminfo_designation=@Meminfo_designation,Meminfo_membertype=@Meminfo_membertype,Meminfo_state=@Meminfo_state
,Meminfo_address=@Meminfo_address,Meminfo_pincode=@Meminfo_pincode,Meminfo_website=@Meminfo_website,Organizationname=@Organizationname

,Meminfo_lastupdateondate=getdate(),Meminfo_lastupdateIP=@IP
where Memid=@Mem_Id
end
if(@QueryType='GetMemberDetails')
begin
select 
m.Mem_ID,m.Mem_Code,m.Name,m.Mobile,m.Main_wallet,m.Payout_Wallet,m.Coin_Wallet,m.Referred_By,m.Created_On,
case when m.Mem_Status='Y' then 'Active'  when isnull(m.Mem_Status,'')!='Y' then 'Inactive' end 'Mem_Status'
,m.Updated_DateTime,m.Last_Login_DateTime,m.LogOutDateTime,
Meminfo_membertype,Meminfo_profilepic,Meminfo_designation,Meminfo_address,Meminfo_pincode,Meminfo_state
,Meminfo_whatsappnumber,Meminfo_emailid,Meminfo_website,Meminfo_gstin,Meminfo_KYC_aadharno,Meminfo_KYC_aadharcopy
,Meminfo_KYC_pannumber,Meminfo_KYC_pancopy,Meminfo_KYC_gstcopy,Meminfo_bank_beneficiaryname
,Meminfo_bank_accountnumber,Meminfo_bank_ifsc,Meminfo_bank_bankname,Meminfo_lastupdateondate,Meminfo_lastupdateIP
,Organizationname,fblink,twitterlink,instagramlink,linkedinlink,youtubechannellink,googlemaplink,UPIQRcodeimage,
case when mi.Meminfo_KYC_status='Y' then 'Active'  when isnull(mi.Meminfo_KYC_status,'')!='Y' then 'Inactive' end 'Meminfo_KYC_status',mi.Meminfo_KYC_status as 'KYCStatus'
From T_Member m
left join T_Member_Info as mi on mi.Memid=m.Mem_ID
 where Mem_ID=@Mem_Id
end

if(@QueryType='GetMemberDetailsForEdit')
begin
select 
m.Mem_ID,m.Mem_Code,m.Name,m.Mobile,m.Main_wallet,m.Payout_Wallet,m.Coin_Wallet,m.Referred_By,m.Created_On,
 isnull(m.Mem_Status,'N')   'Mem_Status'

,m.Updated_DateTime,m.Last_Login_DateTime,m.LogOutDateTime,
Meminfo_membertype,Meminfo_profilepic,Meminfo_designation,Meminfo_address,Meminfo_pincode,Meminfo_state
,Meminfo_whatsappnumber,Meminfo_emailid,Meminfo_website,Meminfo_gstin,Meminfo_KYC_aadharno,Meminfo_KYC_aadharcopy
,Meminfo_KYC_pannumber,Meminfo_KYC_pancopy,Meminfo_KYC_gstcopy,Meminfo_bank_beneficiaryname
,Meminfo_bank_accountnumber,Meminfo_bank_ifsc,Meminfo_bank_bankname,Meminfo_lastupdateondate,Meminfo_lastupdateIP
,Organizationname,fblink,twitterlink,instagramlink,linkedinlink,youtubechannellink,googlemaplink,UPIQRcodeimage,
case when mi.Meminfo_KYC_status='Y' then 'Active'  when isnull(mi.Meminfo_KYC_status,'')!='Y' then 'Inactive' end 'Meminfo_KYC_status'
From T_Member m
left join T_Member_Info as mi on mi.Memid=m.Mem_ID
 where Mem_ID=@Mem_Id
end
end
