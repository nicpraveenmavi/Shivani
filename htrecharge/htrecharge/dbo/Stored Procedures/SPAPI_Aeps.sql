  
CREATE procedure [dbo].[SPAPI_Aeps]    
@QueryType varchar(200)=null,@Pan_Card varchar(30) =null,@Amount decimal(18,3)=null, @Mem_Id int =null,@APES_TXN_Id int =null,@status varchar(200)=null,@txn_mode varchar(20)=null  
    
as    
begin    
if(@QueryType='balancewebhook')    
begin    
    
select  m.Main_wallet from T_Member m    
left join T_Member_Info i on m.Mem_ID=i.Memid where i.Meminfo_KYC_pannumber=@Pan_Card    
end    
    
    
if(@QueryType='aepstransaction')    
begin    
select @Mem_Id=  m.Mem_ID from T_Member m inner join T_Member_Info i on m.Mem_ID=i.Memid where i.Meminfo_KYC_pannumber=@Pan_Card    
if(@Mem_Id is not null )    
begin    
insert into T_APES_Transection(apisourceid,Mem_Id,Pan_Card,Amount,Created_DateTime) output inserted.APES_TXN_Id values(5,@Mem_Id,@Pan_Card,@Amount,getdate())    
end    
else    
begin    
select -1    
end    
end    
    
if(@QueryType='aepsCallBack')    
begin    
update T_APES_Transection set Status=@status,Updated_DateTime=getdate() where APES_TXN_Id=@APES_TXN_Id    
if(@status='SUCCESS' and @txn_mode ='CR')    
begin    
-- add balnace in APES Wallet    
if not exists (select top 1 1 from T_aepswallet where APES_TXN_Id=@APES_TXN_Id)    
begin    
declare @agent_id int
select @Mem_Id=mem_id,@Amount=amount from T_APES_Transection where APES_TXN_Id=@APES_TXN_Id    
declare @Awt_openingBalance decimal(18,3)=null    
select @Awt_openingBalance=Aeps_Wallet from T_Member where Mem_ID=@Mem_Id    
insert into T_aepswallet (Awt_memid,Awt_openingBalance,Awt_Credit,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_comment,APES_TXN_Id)   
                 values (@Mem_Id,isnull(@Awt_openingBalance,0),@Amount,0,(isnull(@Awt_openingBalance,0)+@Amount),getdate(),'Ammount Added' ,@APES_TXN_Id)    
 select top 1 @agent_id = Awt_Id from T_aepswallet order by Awt_Id desc
  select @agent_id
end  
else  
begin  
select -1  
end  
end    
    
end    
end    
    
