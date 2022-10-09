CREATE procedure [dbo].[SPR_MemberWallet]  -- [SPR_MemberWallet] 'WalletReport',3
@QueryType varchar(50)=null 
,@Wallet_Type int =null
,@Tra_Type int =null
,@Mem_Id int =null
,@Ref_No varchar(100)=null,@From VArchar(50)=null,@To varchar(50)=null
as
begin
if(@QueryType='WalletReport')
begin

if(@Wallet_Type=1)
begin
select tm.name,tm.Mem_Code,w.Mwt_servicerefid as 'Serviceid',w.Mwt_openingBalance 'OpeningBalance',w.Mwt_ClosingBalance as 'ClosingBalance'
 ,w.Mwt_Credit as 'Credit',w.Mwt_Debit as 'Debit',w.Mwt_comment as 'Comment',w.Ref_No,mb.BankName,w.Mwt_IP as 'IP',w.Mwt_datetime as 'Transection_Date'
  from T_MainWallet as w
inner join T_Member as TM on tm.Mem_ID=w.Mwt_memid
left join M_Bank as MB on mb.Bankid=w.BankID
where (tm.Mem_ID=@Mem_Id or @Mem_Id  is null )  and
( convert(date, w.Mwt_datetime,103) >= convert(date, @From,103) or convert(date,w.Mwt_datetime,103)=CONVERT(date,getdate(),103) )
 and (convert(date,w.Mwt_datetime,103)<= convert(date, @To,103) or convert(date,w.Mwt_datetime,103)=CONVERT(date,getdate(),103) )
 order by Mwt_id 

end

if(@Wallet_Type=2)
begin
select tm.name,tm.Mem_Code,w.pwt_servicerefid as 'Serviceid',w.pwt_openingBalance 'OpeningBalance',w.pwt_ClosingBalance as 'ClosingBalance'
 ,w.pwt_Credit as 'Credit',w.pwt_Debit as 'Debit',w.pwt_comment as 'Comment',w.Ref_No,mb.BankName,w.pwt_IP as 'IP',w.pwt_datetime as 'Transection_Date'
  from  T_PayoutWallet as w
inner join T_Member as TM on tm.Mem_ID=w.pwt_memid
left join M_Bank as MB on mb.Bankid=w.BankID
where (tm.Mem_ID=@Mem_Id or @Mem_Id  is null )  and 
( convert(date, w.pwt_datetime,103) >= convert(date, @From,103) or convert(date,w.pwt_datetime,103)=CONVERT(date,getdate(),103) )
 and (convert(date,w.pwt_datetime,103)<= convert(date, @To,103) or convert(date,w.pwt_datetime,103)=CONVERT(date,getdate(),103) )
 order by pwt_id 

end


if(@Wallet_Type=3)
begin
select tm.name,tm.Mem_Code,w.cwt_servicerefid as 'Serviceid',w.cwt_openingBalance 'OpeningBalance',w.cwt_ClosingBalance as 'ClosingBalance'
 ,w.cwt_Credit as 'Credit',w.cwt_Debit as 'Debit',w.cwt_comment as 'Comment',w.Ref_No,mb.BankName,w.cwt_IP as 'IP',w.cwt_datetime as 'Transection_Date'
  from  T_CoinWallet as w
inner join T_Member as TM on tm.Mem_ID=w.cwt_memid
left join M_Bank as MB on mb.Bankid=w.BankID
where (tm.Mem_ID=@Mem_Id or @Mem_Id  is null ) 
 and 
( convert(date, w.cwt_datetime,103) >= convert(date, @From,103) or convert(date,w.cwt_datetime,103)=CONVERT(date,getdate(),103) )
 and (convert(date,w.cwt_datetime,103)<= convert(date, @To,103) or convert(date,w.cwt_datetime,103)=CONVERT(date,getdate(),103) )
 order by cwt_id 

end
end

end
