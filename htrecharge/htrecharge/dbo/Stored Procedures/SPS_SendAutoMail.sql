
CREATE procedure [dbo].[SPS_SendAutoMail]
@QueryType varchar(250)=null
as
begin
if(@QueryType='MemberBalance')
begin
select top 1  m.Name,m.Coin_Wallet,m.Main_wallet,m.Payout_Wallet,mi.Meminfo_emailid From T_Member as m
inner join T_Member_Info as mi on mi.Memid=m.Mem_ID
end
end



