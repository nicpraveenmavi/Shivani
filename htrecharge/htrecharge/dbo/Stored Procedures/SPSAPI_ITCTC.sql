CREATE procedure [dbo].[SPSAPI_ITCTC]
@QueryType varchar(150)=null,@mobile varchar(10)=null,@mem_Id int =null,@Main_wallet decimal(12,2)=null,@Amount decimal(12,2)=null
,@Order_Id varchar(200) =null,@IP varchar(200)=null
as
begin
if(@QueryType='InitiateLoginVerification')
begin

select  Main_wallet From T_Member where Mobile=@mobile
end
if(@QueryType='ManageBalance')
begin
if  exists (select top 1 1 from T_Member where Mobile=@mobile)
begin
select @mem_Id=Mem_ID,@Main_wallet=Main_wallet  from T_Member where Mobile=@mobile
if(@Main_wallet>=@Amount)
begin
insert into T_Recharegerec(memcode,mobileno,amount,reqtime,IP,Res_TRNID) output inserted.Recid values (@mem_Id,@mobile,@Amount,getdate(),@IP,@Order_Id)
INSERT INTO [dbo].[T_MainWallet]
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Debit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Mwt_Credit])
     VALUES(@Mem_Id,@Main_wallet,@Amount,(@Main_wallet-@Amount),getdate(),@IP,'IRCTC',0.0)

end
else
begin
select -2   --- insuffcient balance in your main wallet
end

end
else
begin
select -1 -- invalid user name or password
end
end


end
