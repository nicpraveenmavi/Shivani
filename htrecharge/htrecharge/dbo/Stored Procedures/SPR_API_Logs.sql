
CREATE procedure [dbo].[SPR_API_Logs]
@QueryType varchar(100)=null,@Mem_Id int =null,
@From VArchar(50)=null,@To varchar(50)=null
as
begin
if(@QueryType='APILog')
begin
select isnull(m.Name,'')+' ('+m.Mem_Code+' )' as 'Name', l.* From t_api_logs as l
inner join T_Recharegerec as r on l.Recid=r.Recid
inner join T_Member as m on m.Mem_ID=r.memcode
where (m.Mem_ID=@Mem_Id or @Mem_Id  is null ) 
and
( convert(date, l.Request_DateTime,103) >= convert(date, @From,103)  ) --or convert(date,l.Request_DateTime,103)=CONVERT(date,getdate(),103) )
 and (convert(date,l.Request_DateTime,103)<= convert(date, @To,103) ) -- or convert(date,l.Request_DateTime,103)=CONVERT(date,getdate(),103) )
 order by l.API_Log_Id
end


if(@QueryType='RechargeReport')
begin
select isnull(m.Name,'')+' ('+m.Mem_Code+' )' as 'Name', r.* From T_Recharegerec r 
inner join T_Member as m on m.Mem_ID=r.memcode
where (m.Mem_ID=@Mem_Id or @Mem_Id  is null ) 
and
( convert(date, r.reqtime,103) >= convert(date, @From,103) ) 
 and (convert(date,r.reqtime,103)<= convert(date, @To,103)) 
 order by r.Recid
end
if(@QueryType='MemberReport')
begin
select  Name,Mem_ID,Mem_Code,Mobile,Main_wallet,Payout_Wallet ,Coin_Wallet ,Referred_By ,Created_On ,Aeps_Wallet,
case when Mem_Status='Y' then 'Active'  when Mem_Status!='Y' then 'Inactive' end 'Mem_Status'
 From T_Member 
 where (Mem_ID=@Mem_Id or @Mem_Id  is null ) 
and
( convert(date, Created_On,103) >= convert(date, @From,103) or @From is null  ) 
 and (convert(date,Created_On,103)<= convert(date, @To,103) or  @To is null)  
 order by Mem_ID

end


if(@QueryType='RechargeReportUpdate')
begin
--select * from T_Recharegerec where Recid=85
--select * from T_Member
--select * from T_MainWallet where Mwt_servicerefid=85


update T_Recharegerec set Status=@From,statusdesc=@To where Recid=@Mem_Id


if(@From='Failed')
begin

declare @OpenBlancce decimal(12,2) = null,@Amount decimal(12,2) = null,@userid varchar(50)=null,@recId int,@IP varchar(50)=null,@autoid int,@mwtserviceid int

select @userid=Mwt_memid,@mwtserviceid=Mwt_servicerefid,@Amount=Mwt_debit  from T_MainWallet where Mwt_servicerefid=@Mem_Id



--select @userid=memcode from T_Recharegerec where Recid=@Mem_Id
select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id

		insert into T_MainWallet (Mwt_memid,Mwt_servicerefid,Mwt_openingBalance, Mwt_Credit,Mwt_ClosingBalance,Mwt_datetime,Mwt_IP,Mwt_comment,Mwt_Debit)
		values (@userid,@Mem_Id,@OpenBlancce,@Amount,(@OpenBlancce+@Amount),getdate(),@IP,'REFUND',0.0)
end
else if(@From='Success')
begin
exec SPIU_Commission_Distribution @Mem_Id
end



--select  Name,Mem_ID,Mem_Code,Mobile,Main_wallet,Payout_Wallet ,Coin_Wallet ,Referred_By ,Created_On ,Aeps_Wallet,
--case when Mem_Status='Y' then 'Active'  when Mem_Status!='Y' then 'Inactive' end 'Mem_Status'
-- From T_Member 
-- where (Mem_ID=@Mem_Id or @Mem_Id  is null ) 
--and
--( convert(date, Created_On,103) >= convert(date, @From,103) or @From is null  ) 
-- and (convert(date,Created_On,103)<= convert(date, @To,103) or  @To is null)  
-- order by Mem_ID

end


end
