
CREATE procedure [dbo].[SPS_Client_Member_DashBoard]
@QueryType varchar(200)=null,@Mem_Id int =null
as
begin
if(@QueryType='GetMemberDashBoard')
begin

select  m.Mem_ID, m.name,
case when isnull(mi.Meminfo_KYC_status,'N')='N' then 'Inactive'
 when isnull(mi.Meminfo_KYC_status,'N')='Y' then 'Active'
end Meminfo_KYC_status,
case when isnull(m.Mem_Status,'N')='N' then 'Inactive'
 when isnull(m.Mem_Status,'N')='Y' then 'Active'
end Mem_Statusm
,m.Mobile,m.Main_wallet,m.Payout_Wallet,m.Coin_Wallet,mi.Meminfo_membertype
,isnull(m.Aeps_Wallet,0.0) as 'Aeps_Wallet',mi.Meminfo_KYC_pannumber,mi.Meminfo_profilepic,m.Mem_Code
 from T_Member as m 
left join T_Member_Info as mi on mi.Memid=m.Mem_ID
where m.Mem_ID=@Mem_Id

end
end
