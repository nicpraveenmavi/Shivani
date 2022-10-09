CREATE procedure [dbo].[SPI_MemberWallet]
@QueryType varchar(50)=null
,@Wallet_Type int =null
,@Tra_Type int =null
,@Mem_Id int =null
,@Ammount decimal(12,2)=null
,@Bank_Id int =null
,@Ref_No varchar(100)=null
,@Remark varchar(100)=null
,@IP varchar(100)=null
,@OpenBlancce decimal(12,2)=null

as
begin

if(@QueryType='Insert')
begin

if(@Wallet_Type=1)
begin

if(@Tra_Type=1)
begin
select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
 INSERT INTO [dbo].[T_MainWallet]
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Credit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Ref_No],[BankID],[Mwt_Debit])
     VALUES(@Mem_Id,@OpenBlancce,@Ammount,(@OpenBlancce+@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id,0.0)
   end 
   if(@Tra_Type=2)
begin

select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
if(@OpenBlancce>=@Ammount)
begin
 INSERT INTO [dbo].[T_MainWallet]
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Debit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Ref_No],[BankID],[Mwt_Credit])
     VALUES(@Mem_Id,@OpenBlancce,@Ammount,(@OpenBlancce-@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id,0.0)
	 end
	 else
	 begin
	 select -1
	 end
   end     
end

----------- pay out wallet
if(@Wallet_Type=2)
begin

if(@Tra_Type=1)
begin
select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_Id
 INSERT INTO [dbo].[T_PayoutWallet]
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[Ref_No],[BankID],[pwt_Debit])
     VALUES(@Mem_Id,@OpenBlancce,@Ammount,(@OpenBlancce+@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id,0.0)
   end 
   if(@Tra_Type=2)
begin
select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_Id
if(@OpenBlancce>=@Ammount)
begin
 INSERT INTO [dbo].[T_PayoutWallet]
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[Ref_No],[BankID],[pwt_Credit])
     VALUES(@Mem_Id,@OpenBlancce,@Ammount,(@OpenBlancce-@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id,0.0)
	 end
	 else
	 begin
	 select -1
	 end
   end     
end

----------

----------- coin wallet
if(@Wallet_Type=3)
begin

if(@Tra_Type=1)
begin
select @OpenBlancce=Coin_Wallet From T_Member where Mem_ID=@Mem_Id
 INSERT INTO [dbo].[T_CoinWallet]
           ([cwt_memid],[cwt_openingBalance],[cwt_Credit],[cwt_ClosingBalance],[cwt_datetime],[cwt_IP],[cwt_comment],[Ref_No],[BankID],[cwt_Debit])
     VALUES(@Mem_Id,@OpenBlancce,@Ammount,(@OpenBlancce+@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id,0.0)
   end 
   if(@Tra_Type=2)
begin
select @OpenBlancce=Coin_Wallet From T_Member where Mem_ID=@Mem_Id
if(@OpenBlancce>=@Ammount)
begin
 INSERT INTO [dbo].[T_CoinWallet]
           ([cwt_memid],[cwt_openingBalance],[cwt_Credit],[cwt_Debit],[cwt_ClosingBalance],[cwt_datetime],[cwt_IP],[cwt_comment],[Ref_No],[BankID])
     VALUES(@Mem_Id,@OpenBlancce,0.0, @Ammount,(@OpenBlancce-@Ammount),getdate(),@IP,@Remark,@Ref_No,@Bank_Id)
	 end
	 else
	 begin
	 select -1
	 end
   end     
end

----------

end

if(@QueryType='GetMemWalletBlance')
begin

select Main_wallet,Payout_Wallet,Coin_Wallet From T_Member  where Mem_ID=@Mem_Id
end

if(@QueryType='BindBAnk')
begin
select  Bankid as 'Value', BankName as 'Text' From M_Bank order by BankName
end

if(@QueryType='BindMember')
begin
select  Mem_ID as 'Value', isnull(Name,'')+' ( '+Mem_Code+' )' as 'Text' From T_Member where Mem_Status='Y' order by Name 
end


end
