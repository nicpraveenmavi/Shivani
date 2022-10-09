
-- =============================================
-- Author: 
-- Alter by: Saurabh Verma
-- Alter date: 12-Jan-2022
-- Description:	Update query in following sections
--				ServiceInsert ServiceUpdate GetServiceDetail ServiceLocationPhotoUpdate
-- Alter date: 16-Feb-2022
-- Description:	ServiceSubTypeCategoryMultiple Ids
-- =============================================

CREATE procedure [dbo].[SPSAPI_MobileApp]   ---  SPSAPI_MobileApp 'DebitCoinfromCoinWallet',9555409122,'by','123654'    
@QueryType varchar(500)=null,    
@Mobile bigint =null,    
@Referred_By varchar(50)=null,@OTP varchar(6)=null,@Mem_Code varchar(10)=null,@Login_Token varchar(255)=null,@Mem_ID int =null  ,  
@Service_subcat_id varchar(50)=null 
,@Service_Type_Id int =null,@Service_Category_Id int =null,    
@Meminfo_KYC_aadharno varchar(20)=null,@Meminfo_KYC_aadharcopy varchar(500)=null,@Meminfo_KYC_pannumber varchar(15)=null    
,@Meminfo_KYC_pancopy varchar(500)=null,@Meminfo_KYC_gstcopy varchar(500)=null,@Meminfo_gstin varchar(20)=null    
,@IP varchar(50)=null,    
@Meminfo_bank_beneficiaryname varchar(150)=null,@Meminfo_bank_accountnumber varchar(50)=null,@Meminfo_bank_ifsc varchar(50)=null,@Meminfo_bank_bankname varchar(255)=null    
,@Meminfo_profilepic varchar(250)=null    
,@Meminfo_designation varchar(150)=null    
,@Meminfo_address varchar(255)=null    
,@Meminfo_pincode int =null    
,@Meminfo_state varchar(150)=null     
,@Meminfo_whatsappnumber bigint =null    
,@Meminfo_emailid varchar(75)=null    
,@Meminfo_website varchar(255)=null    
,@Organizationname varchar(255)=null    
,@fblink varchar(500)=null    
,@twitterlink varchar(500)=null    
,@instagramlink varchar(500)=null    
,@linkedinlink varchar(500)=null    
,@youtubechannellink varchar(500)=null    
,@googlemaplink varchar(500)=null    
,@UPIQRcodeimage varchar(250)=null,@Name varchar(100)=null,@Meminfo_membertype varchar(50)=null,@App_Version decimal(10,1)=null,    
@Package_ID int =null,@Ammount decimal(12,2)=null,@Guid varchar(500)=null,@pwt_id int =null,    
@RequestBankTransfer varchar(2000)=null, @ResponseBankTransfer varchar(2000)=null,@BankTransfer_Status_code varchar(50)=null,@BankTransfer_Status varchar(150)=null    
,@pg_gateway varchar(50)=null,@pg_status varchar(255)=null,@pg_txnrefofgateway varchar(255) =null,@Pg_Id int =null,    
@GateWayPaymentResponse varchar(2000)=null,@Paytm_wallet_number bigint=null,@Response varchar(5000)=null,@Mode varchar(200)=null    
    
,@NeftChargeAmount decimal(12,2)=null,@IMPSChargeAmount decimal(12,2)=null,@AdminCharge decimal(12,2)=null,@TDSCharge decimal(12,2)=null,@wallet_chargeAmount  decimal(12,2)=null    
,@business_category int=null,@business_subcategory int=null  
,@service_cateid  int=null
			,@Booking_fee decimal(12,3)=null
			,@Specialisation1 varchar(500)=null
			,@Specialisation2 varchar(500)=null
			,@Specialisation3 varchar(500)=null
			,@Specialisation4	 varchar(500)=null
			,@Specialisation5 varchar(500)=null
			,@servicelocationphoto varchar(250)=null
			,@service_id int=null
			,@Latitude decimal(18, 16) = null
			,@Longitude decimal(18, 16) = null
			,@LocationAddress varchar(500)=null
			,@StrServiceCategoryId varchar(100)=null
			,@package_com_id varchar(100)=null
as    
begin    
    
    
if(@QueryType='paytmsurcharge')    
begin    
select m.*,i.Paytm_wallet_number from M_paytmsetting m    
left join T_Member_Info i on i.Memid=@Mem_ID    
end    
if(@QueryType='Adminfeetdsfee')    
begin    
select i.Meminfo_bank_accountnumber, convert(varchar(20), adminfee)+' %' as 'adminfee',convert(varchar(20),tdsfee)+' %' as  'tdsfee' from M_SystemSetting    
left join T_Member_Info as i on i.Memid=@Mem_ID    
end    
    
if(@QueryType='AddBalanceResponse')    
begin    
update T_PG set pg_gateway=@pg_gateway,pg_status=@pg_status,pg_txnrefofgateway=@pg_txnrefofgateway,pg_IP=@IP,Updated_DateTime=getdate()    
where Pg_Id=@Pg_Id    
end    
    
if(@QueryType='UpdateAddBalanceStatus')    
begin    
    
update T_PG set pg_status=@pg_status,pg_IP=@IP,GateWayPaymentResponse=@GateWayPaymentResponse ,Updated_DateTime=getdate()    
where Pg_Id=@Pg_Id    
    
if(@pg_status='01')  --- add balance in main wallet success    
begin    
if not exists (select top 1 1 from [T_MainWallet] where  Pg_Id=@Pg_Id)    
begin    
declare @OpenBlancce123 decimal(12,2)=null    
select @Mem_Id = pg_membertableid,@Ammount=pg_amount from T_PG where Pg_Id=@Pg_Id    
select @OpenBlancce123=Main_wallet From T_Member where Mem_ID=@Mem_Id    
    
 INSERT INTO [dbo].[T_MainWallet]    
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Credit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Mwt_Debit],pg_id)    
     VALUES(@Mem_Id,@OpenBlancce123,@Ammount,(@OpenBlancce123+@Ammount),getdate(),@IP,'Wallet Balance Added',0.0,@Pg_Id)    
end    
end    
end    
    
if(@QueryType='InitializeAddBalance')    
begin    
insert into T_PG(pg_membertableid,pg_date,pg_IP,pg_amount,Created_DateTime) output inserted.Pg_Id values(@Mem_ID,getdate(),@IP,@Ammount,getdate())    
end    
    
if(@QueryType='InitializeAddBalanceGatewayResponse')    
begin    
update T_PG set InitializeResponse=@Response,Updated_DateTime=getdate() where pg_id=@Pg_Id    
end    
    
if(@QueryType='TransferToBankCallBack')    
begin    
update [T_PayoutWallet] set BankTransfer_Callback_DateTime=getdate(),BankTransfer_Callback=@ResponseBankTransfer,BankTransfer_Status=@BankTransfer_Status,    
BankTransfer_Status_code=@BankTransfer_Status_code where pwt_id=@pwt_id    
    
---- refund    
    
declare @refund1 varchar(1)=null    
select @refund1=refund from M_PaytmBankTransfer_ResponseStatus where statusCode=@BankTransfer_Status_code    
if(isnull(@refund1,'Y')!='N')    
begin    
if not exists (select top 1 1 from [T_PayoutWallet] where pwt_id=@pwt_id and isnull(Refund,'N') ='Y')    
begin    
--- refund amount    
declare @OpenBlanccepay1 decimal(12,3)=null    
select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where pwt_id=@pwt_id    
select @OpenBlanccepay1=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay1,@Ammount,(@OpenBlanccepay1+@Ammount),getdate(),@IP,'Payout Refund',0.0,'Y')    
--------    
end    
end    
    
------refund    
    
    
end    
    
if(@QueryType='UpdateBankTransferStatusIns')    
begin    
	update T_PayoutWallet set 
		RequestBankTransfer = @RequestBankTransfer,
		ResponseBankTransfer = @ResponseBankTransfer,
		BankTransfer_Status_code = @BankTransfer_Status_code,
		BankTransfer_Status = @BankTransfer_Status
	where pwt_id=@pwt_id    
    
	declare @refund varchar(1) = null    
	--select @refund = refund from M_PaytmBankTransfer_ResponseStatus where statusCode = @BankTransfer_Status_code
	select @refund = refund from M_CashFreeResponses where statuscode = @BankTransfer_Status_code    
	
	if(isnull(@refund, 'Y') != 'N')    
	begin    
		if not exists (select top 1 1 from [T_PayoutWallet] where pwt_id = @pwt_id and isnull(Refund,'N') = 'Y')    
		begin    
			--- refund amount    
			declare @OpenBlanccepay decimal(12,3)=null    
			select @Mem_Id=pwt_memid, @Ammount=pwt_Debit From [T_PayoutWallet] where pwt_id=@pwt_id    
			select @OpenBlanccepay = Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay,@Ammount,(@OpenBlanccepay+@Ammount),getdate(),@IP,'Payout Refund',0.0,'Y')    
        
    
    
    set @Mem_Id=null set @Ammount=null        
    select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='AdminFees'    
     IF(@Mem_Id IS NOT NULL )    
     begin    
            select @OpenBlanccepay=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
                 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
             VALUES(@Mem_Id,@OpenBlanccepay,@Ammount,(@OpenBlanccepay+@Ammount),getdate(),@IP,'AdminFees Refund',0.0,'Y')    
         end    
    
      set @Mem_Id=null set @Ammount=null     
   select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='TDS'    
      
    IF(@Mem_Id IS NOT NULL )    
   BEGIN    
        select @OpenBlanccepay=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
          INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
           VALUES(@Mem_Id,@OpenBlanccepay,@Ammount,(@OpenBlanccepay+@Ammount),getdate(),@IP,'TDS Refund',0.0,'Y')    
  end    
    
     set @Mem_Id=null set @Ammount=null     
    select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='NEFTSurcharge'    
   IF(@Mem_Id IS NOT NULL)    
   BEGIN    
         select @OpenBlanccepay=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
              INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
           VALUES(@Mem_Id,@OpenBlanccepay,@Ammount,(@OpenBlanccepay+@Ammount),getdate(),@IP,'NEFTSurcharge Refund',0.0,'Y')    
  END    
    
    set @Mem_Id=null set @Ammount=null     
    select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='IMPSSurcharge'    
   IF(@Mem_Id IS NOT NULL )    
   BEGIN    
          select @OpenBlanccepay=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
              INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
              VALUES(@Mem_Id,@OpenBlanccepay,@Ammount,(@OpenBlanccepay+@Ammount),getdate(),@IP,'IMPSSurcharge Refund',0.0,'Y')     
  END    
--------    
end    
    
end    
    
    
    
    
end     
    
    
if(@QueryType='UpdateBankTransferStatusInsAeps')    
begin    
 update [T_aepswallet] set RequestBankTransfer=@RequestBankTransfer,ResponseBankTransfer=@ResponseBankTransfer,BankTransfer_Status_code=@BankTransfer_Status_code    
 ,BankTransfer_Status=@BankTransfer_Status where awt_id=@pwt_id    
    
declare @refund12 varchar(1)=null    
select @refund12=refund from M_PaytmBankTransfer_ResponseStatus where statusCode=@BankTransfer_Status_code    
    
if(isnull(@refund12,'Y')!='N')    
begin    
if not exists (select top 1 1 from [T_aepswallet] where awt_id=@pwt_id and isnull(Refund,'N') ='Y')    
begin    
--- refund amount    
declare @OpenBlanccepay12 decimal(12,3)=null    
select @Mem_Id=Awt_memid,@Ammount=Awt_Debit From [T_aepswallet] where Awt_Id=@pwt_id    
select @OpenBlanccepay12=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
    
 INSERT INTO [dbo].[T_aepswallet]    
           ([Awt_memid],[Awt_openingBalance],[awt_Credit],[Awt_ClosingBalance],[Awt_datetime],[Awt_IP],[Awt_comment],[Awt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay12,@Ammount,(@OpenBlanccepay12+@Ammount),getdate(),@IP,'Aeps Refund',0.0,'Y')    
        
    
     set @Mem_Id=null set @Ammount=null     
    select @Mem_Id=Awt_memid,@Ammount=Awt_Debit From [T_aepswallet] where Charges_pwt_id=@pwt_id AND Charges_Type='NEFTSurcharge'    
   IF(@Mem_Id IS NOT NULL)    
   BEGIN    
         select @OpenBlanccepay12=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
              INSERT INTO [dbo].[T_aepswallet]    
           ([Awt_memid],[Awt_openingBalance],[awt_Credit],[Awt_ClosingBalance],[Awt_datetime],[Awt_IP],[Awt_comment],[Awt_Debit],Refund)    
           VALUES(@Mem_Id,@OpenBlanccepay12,@Ammount,(@OpenBlanccepay12+@Ammount),getdate(),@IP,'NEFTSurcharge Refund',0.0,'Y')    
  END    
    
    set @Mem_Id=null set @Ammount=null     
    select @Mem_Id=Awt_memid,@Ammount=awt_Debit From [T_aepswallet] where Charges_pwt_id=@pwt_id AND Charges_Type='IMPSSurcharge'    
   IF(@Mem_Id IS NOT NULL )    
   BEGIN    
          select @OpenBlanccepay12=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
              INSERT INTO [dbo].[T_aepswallet]    
           ([awt_memid],[awt_openingBalance],[awt_Credit],[awt_ClosingBalance],[awt_datetime],[awt_IP],[awt_comment],[awt_Debit],Refund)    
              VALUES(@Mem_Id,@OpenBlanccepay12,@Ammount,(@OpenBlanccepay12+@Ammount),getdate(),@IP,'IMPSSurcharge Refund',0.0,'Y')     
  END    
--------    
end    
    
end    
    
    
    
    
end     
    
if(@QueryType='UpdatePaytmWalletStatusIns')    
begin    
update [T_PayoutWallet] set RequestBankTransfer=@RequestBankTransfer,ResponseBankTransfer=@ResponseBankTransfer,BankTransfer_Status_code=@BankTransfer_Status_code    
,BankTransfer_Status=@BankTransfer_Status where pwt_id=@pwt_id    
    
declare @refund11 varchar(1)=null    
select @refund11=refund from M_PaytmWalletTransfer_ResponseStatus   where statusCode=@BankTransfer_Status_code    
if(isnull(@refund11,'Y')!='N')    
begin    
if not exists (select top 1 1 from [T_PayoutWallet] where pwt_id=@pwt_id and isnull(Refund,'N') ='Y')    
begin    
--- refund amount    
declare @OpenBlanccepay11 decimal(12,3)=null    
select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where pwt_id=@pwt_id    
select @OpenBlanccepay11=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay11,@Ammount,(@OpenBlanccepay11+@Ammount),getdate(),@IP,'Payout Refund',0.0,'Y')    
  set @Mem_Id =null  set @Ammount=null    
  select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='AdminFees'    
  if(@Mem_Id is not null )    
  begin    
select @OpenBlanccepay11=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay11,@Ammount,(@OpenBlanccepay11+@Ammount),getdate(),@IP,'AdminFees Refund',0.0,'Y')    
  end    
  set @Mem_Id =null  set @Ammount=null    
   select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='TDS'    
   if(@Mem_Id is not null )    
  begin    
         select @OpenBlanccepay11=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
             INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
             VALUES(@Mem_Id,@OpenBlanccepay11,@Ammount,(@OpenBlanccepay11+@Ammount),getdate(),@IP,'TDS Refund',0.0,'Y')    
  end    
     
 set @Mem_Id =null  set @Ammount=null    
   select @Mem_Id=pwt_memid,@Ammount=pwt_Debit From [T_PayoutWallet] where Charges_pwt_id=@pwt_id AND Charges_Type='WalletSurcharge'    
   IF(@Mem_Id IS NOT NULL )    
   BEGIN    
select @OpenBlanccepay11=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Debit],Refund)    
     VALUES(@Mem_Id,@OpenBlanccepay11,@Ammount,(@OpenBlanccepay11+@Ammount),getdate(),@IP,'WalletSurcharge Refund',0.0,'Y')    
  END    
      
--------    
end    
    
end    
end    
    
    
    
    
    
if(@QueryType='GetMemberBankDetailsfortransfer')    
begin    
    
select Meminfo_KYC_status,Meminfo_bank_accountnumber,Meminfo_bank_ifsc,Paytm_wallet_number from T_Member_Info where Memid=@Mem_ID    
end    
-- Modified by Sachin    
    
    
Declare @AdminFee decimal(12,2)=null,@TDSFee decimal(12,2)=null    
if(@QueryType='DebitAmountfromWallet')    
begin    
declare  @OpenBlanccepayout decimal(12,3)=null     
    
select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
if(@OpenBlanccepayout>=@Ammount)    
begin    
    
if(@Mode='WALLET')    
begin    
     
 select @NeftChargeAmount= neft_charge,@IMPSChargeAmount=imps_charge,@wallet_chargeAmount=wallet_charge from [M_PaytmSetting]     
 select @AdminCharge=adminfee,@TDSCharge=tdsfee from M_SystemSetting     
 set @AdminFee= (@Ammount*@AdminCharge/100)    
 set @TDSFee= (@Ammount*@TDSCharge/100)    
 set @Ammount=(@Ammount-@wallet_chargeAmount-@AdminFee-@TDSFee)    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],GuidCode)    
   VALUES(@Mem_Id,@OpenBlanccepayout,@Ammount,(@OpenBlanccepayout-@Ammount),getdate(),@IP,'Payout',0.0,@Guid)    
         select @pwt_id=pwt_id from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid   
       
   select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@AdminFee,(@OpenBlanccepayout-@AdminFee),getdate(),@IP,'Admin Fees',0.0,@pwt_id,'AdminFees')    
     
    
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@TDSFee,(@OpenBlanccepayout-@TDSFee),getdate(),@IP,'TDS',0.0,@pwt_id,'TDS')    
       
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@wallet_chargeAmount,(@OpenBlanccepayout-@wallet_chargeAmount),getdate(),@IP,'Wallet Surcharge',0.0,@pwt_id,'WalletSurcharge')    
       
end    
if(@Mode='NEFT')    
begin    
---declare @Ammount decimal(12,2)=10, @NeftChargeAmount decimal(12,2)=null,@IMPSChargeAmount decimal(12,2)=null,@AdminCharge decimal(12,2)=null,@TDSCharge decimal(12,2)=null,@wallet_chargeAmount  decimal(12,2)=null    
 select @NeftChargeAmount= neft_charge,@IMPSChargeAmount=imps_charge,@wallet_chargeAmount=wallet_charge from [M_PaytmSetting]     
 select @AdminCharge=adminfee,@TDSCharge=tdsfee from M_SystemSetting    
--select  @NeftChargeAmount ,@IMPSChargeAmount ,@AdminChargeAmount ,@TDSChargeAmount ,@wallet_chargeAmount      
--set @Ammount=(@Ammount-@NeftChargeAmount)    
     
 set @AdminFee= (@Ammount*@AdminCharge/100)    
 set @TDSFee= (@Ammount*@TDSCharge/100)    
 set @Ammount=(@Ammount-@NeftChargeAmount-@AdminFee-@TDSFee)    
    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],GuidCode)    
   VALUES(@Mem_Id,@OpenBlanccepayout,@Ammount,(@OpenBlanccepayout-@Ammount),getdate(),@IP,'Payout',0.0,@Guid)    
         select @pwt_id=pwt_id from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid      
       
   select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@AdminFee,(@OpenBlanccepayout-@AdminFee),getdate(),@IP,'Admin Fees',0.0,@pwt_id,'AdminFees')    
     
    
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@TDSFee,(@OpenBlanccepayout-@TDSFee),getdate(),@IP,'TDS',0.0,@pwt_id,'TDS')    
       
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@NeftChargeAmount,(@OpenBlanccepayout-@NeftChargeAmount),getdate(),@IP,'NEFT Surcharge',0.0,@pwt_id,'NEFTSurcharge')    
     
     
 end   ---neft end    
if(@Mode='IMPS')    
begin    
    
 select @NeftChargeAmount= neft_charge,@IMPSChargeAmount=imps_charge,@wallet_chargeAmount=wallet_charge from [M_PaytmSetting]     
 select @AdminCharge=adminfee,@TDSCharge=tdsfee from M_SystemSetting     
 set @AdminFee= (@Ammount*@AdminCharge/100)    
 set @TDSFee= (@Ammount*@TDSCharge/100)    
 set @Ammount=(@Ammount-@IMPSChargeAmount-@AdminFee-@TDSFee)    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],GuidCode)    
   VALUES(@Mem_Id,@OpenBlanccepayout,@Ammount,(@OpenBlanccepayout-@Ammount),getdate(),@IP,'Payout',0.0,@Guid)    
         select @pwt_id=pwt_id from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid      
       
   select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@AdminFee,(@OpenBlanccepayout-@AdminFee),getdate(),@IP,'Admin Fees',0.0,@pwt_id,'AdminFees')    
     
    
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@TDSFee,(@OpenBlanccepayout-@TDSFee),getdate(),@IP,'TDS',0.0,@pwt_id,'TDS')    
       
 select @OpenBlanccepayout=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayout,@IMPSChargeAmount,(@OpenBlanccepayout-@IMPSChargeAmount),getdate(),@IP,'IMPS Surcharge',0.0,@pwt_id,'IMPSSurcharge')    
     
     
 end   ---IMPS end    
    
  end    ---debit end here    
  else    
  begin    
  select -1    
  end    
    
     
end    
    
--------------------------------------------------    
if(@QueryType='DebitAmountfromAeps')    
begin    
declare  @OpenBlanceAeps decimal(12,3)=null     
select @OpenBlanceAeps=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
select @NeftChargeAmount= neft_charge,@IMPSChargeAmount=imps_charge,@wallet_chargeAmount=wallet_charge from [M_PaytmSetting]     
    
if(@OpenBlanceAeps>=@Ammount)    
begin    
    
if(@Mode='NEFT')    
begin    
    
 set @Ammount=(@Ammount-@NeftChargeAmount)    
    
 INSERT INTO [dbo].[T_aepswallet]    
           (Awt_memid,Awt_openingBalance,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_IP,Awt_comment,Awt_Credit,GuidCode)    
   VALUES(@Mem_Id,@OpenBlanceAeps,@Ammount,(@OpenBlanceAeps-@Ammount),getdate(),@IP,'Aeps',0.0,@Guid)    
         select @pwt_id=Awt_Id from [T_aepswallet] where Awt_memid=@Mem_ID and GuidCode=@Guid      
       
      
 SELECT @OpenBlanceAeps=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_aepswallet]    
           (Awt_memid,Awt_openingBalance,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_IP,Awt_comment,Awt_Credit,Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanceAeps,@NeftChargeAmount,(@OpenBlanceAeps-@NeftChargeAmount),getdate(),@IP,'NEFT Surcharge',0.0,@pwt_id,'NEFTSurcharge')    
     
     
 end   ---neft end    
if(@Mode='IMPS')    
begin    
    
 set @Ammount = (@Ammount-@IMPSChargeAmount)    
 INSERT INTO [dbo].[T_aepswallet]    
           (Awt_memid,Awt_openingBalance,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_IP,Awt_comment,Awt_Credit,GuidCode)    
   VALUES(@Mem_Id,@OpenBlanceAeps,@Ammount,(@OpenBlanceAeps-@Ammount),getdate(),@IP,'Aeps',0.0,@Guid)    
         select @pwt_id=Awt_Id from [T_aepswallet] where Awt_memid=@Mem_ID and GuidCode=@Guid      
       
       
 select @OpenBlanceAeps=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_aepswallet]    
           (Awt_memid,Awt_openingBalance,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_IP,Awt_comment,Awt_Credit,Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanceAeps,@IMPSChargeAmount,(@OpenBlanceAeps-@IMPSChargeAmount),getdate(),@IP,'IMPS Surcharge',0.0,@pwt_id,'IMPSSurcharge')    
     
     
 end   ---IMPS end    
    
  end    ---debit end here    
  else    
  begin    
  select -1    
  end    
    
     
end    
----------------------------------------    
    
--------------------------------------------------    
if(@QueryType='DebitAmountfromPayoutWallet')    
begin    
    
declare  @OpenBlanccepayoutWallet decimal(12,3)=null     
select @OpenBlanccepayoutWallet=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    
if(@OpenBlanccepayoutWallet>=@Ammount)    
begin    
    
    
 select @AdminCharge=adminfee,@TDSCharge=tdsfee from M_SystemSetting     
 set @AdminFee= (@Ammount*@AdminCharge/100)    
 set @TDSFee= (@Ammount*@TDSCharge/100)    
 set @Ammount=(@Ammount-@AdminFee-@TDSFee)    
    
declare  @OpenBlanccemainWallet decimal(12,2)=null    
select @OpenBlanccemainWallet=Main_wallet From T_Member where Mem_ID=@Mem_Id    
    
 INSERT INTO [dbo].[T_PayoutWallet]    
  ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],GuidCode)    
   VALUES(@Mem_Id,@OpenBlanccepayoutWallet,@Ammount,(@OpenBlanccepayoutWallet-@Ammount),getdate(),@IP,'Payout',0.0,@Guid)    
         select @pwt_id=pwt_id from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid      
       
   select @OpenBlanccepayoutWallet=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayoutWallet,@AdminFee,(@OpenBlanccepayoutWallet-@AdminFee),getdate(),@IP,'Admin Fees',0.0,@pwt_id,'AdminFees')    
     
    
 select @OpenBlanccepayoutWallet=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Debit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[pwt_Credit],Charges_pwt_id,Charges_Type )    
   VALUES(@Mem_Id,@OpenBlanccepayoutWallet,@TDSFee,(@OpenBlanccepayoutWallet-@TDSFee),getdate(),@IP,'TDS',0.0,@pwt_id,'TDS')    
       
    
 INSERT INTO [dbo].[T_MainWallet]    
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Credit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Ref_No],[Mwt_Debit])    
     VALUES(@Mem_Id,@OpenBlanccemainWallet,@Ammount,(@OpenBlanccemainWallet+@Ammount),getdate(),@IP,'Balance Add by Payout','Balance Add by Payout',0.0)    
    
    ---WALLET end    
    
  end    ---debit end here    
  else    
  begin    
  select -1    
  end    
    
     
end    
----------------------------------------    
    
--------------------------------------------------    
if(@QueryType='DebitAmountfromAepsWallet')    
begin    
    
declare  @OpenBlancceAepsWallet decimal(12,3)=null     
select @OpenBlancceAepsWallet=Aeps_Wallet From T_Member where Mem_ID=@Mem_Id    
    
if(@OpenBlancceAepsWallet>=@Ammount)    
begin    
    
declare  @OpenBlancce_mainWallet decimal(12,2)=null    
select @OpenBlancce_mainWallet=Main_wallet From T_Member where Mem_ID=@Mem_Id    
    
 INSERT INTO [dbo].[T_aepswallet]    
           (Awt_memid,Awt_openingBalance,Awt_Debit,Awt_ClosingBalance,Awt_datetime,Awt_IP,Awt_comment,Awt_Credit,GuidCode)    
   VALUES(@Mem_Id,@OpenBlancceAepsWallet,@Ammount,(@OpenBlancceAepsWallet-@Ammount),getdate(),@IP,'Aeps',0.0,@Guid)    
         select @pwt_id=Awt_Id from [T_aepswallet] where Awt_memid=@Mem_ID and GuidCode=@Guid      
       
    
 INSERT INTO [dbo].[T_MainWallet]    
        ([Mwt_memid],[Mwt_openingBalance],[Mwt_Credit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Ref_No],[Mwt_Debit])    
    VALUES(@Mem_Id,@OpenBlancce_mainWallet,@Ammount,(@OpenBlancce_mainWallet+@Ammount),getdate(),@IP,'Balance Add by Aeps','Balance Add by Aeps',0.0)    
    
    ---WALLET end    
    
  end    ---debit end here    
  else    
  begin    
  select -1    
  end    
    
     
end    
----------------------------------------    
--------------------------------------------------    
if(@QueryType='DebitCoinfromCoinWallet')    
begin    
    
declare @OpenBlancceCoinWallet decimal(12,3)=null     
declare @CoinConversionRate int    
select  @OpenBlancceCoinWallet=Coin_Wallet From T_Member where Mem_ID=@Mem_Id    
    
if(@OpenBlancceCoinWallet>=@Ammount)    
begin    
    
 select @CoinConversionRate = ISNuLL(CoinConversionRate,0) from M_SystemSetting     
    
declare  @OpenBlanccepayputWallet decimal(12,2)=null    
select @OpenBlanccepayputWallet=Payout_Wallet From T_Member where Mem_ID=@Mem_Id    
    
 INSERT INTO [dbo].[T_CoinWallet]    
           ([cwt_memid],[cwt_openingBalance],[cwt_Debit],[cwt_ClosingBalance],[cwt_datetime],[cwt_IP],[cwt_comment],[cwt_Credit],GuidCode)    
   VALUES(@Mem_Id,@OpenBlancceCoinWallet,@Ammount,(@OpenBlancceCoinWallet-@Ammount),getdate(),@IP,'Redeem Coins',0.0,@Guid)    
         select @pwt_id=pwt_id from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid      
       
    set @Ammount=(@Ammount*@CoinConversionRate/100)    
    
 INSERT INTO [dbo].[T_PayoutWallet]    
           ([pwt_memid],[pwt_openingBalance],[pwt_Credit],[pwt_ClosingBalance],[pwt_datetime],[pwt_IP],[pwt_comment],[Ref_No],[pwt_Debit],GuidCode)    
     VALUES(@Mem_Id,@OpenBlanccepayputWallet,@Ammount,(@OpenBlanccepayputWallet+@Ammount),getdate(),@IP,'Balance Add by Coin','Balance Add by Coin',0.0,@Guid)    
    
    ---WALLET end    
    
  end    ---debit end here    
  else    
  begin    
  select -1    
  end    
    
     
end    
----------------------------------------    
    
if(@QueryType='GetOrderidPaytmCheckSum')    
begin    
select pwt_id, convert(decimal(12,2), pwt_Debit) as 'pwt_Debit' from [T_PayoutWallet] where pwt_memid=@Mem_ID and GuidCode=@Guid    
end    
    
if(@QueryType='GetAepsOrderidPaytmCheckSum')    
begin    
select Awt_Id as pwt_id, convert(decimal(12,2), Awt_Debit) as 'pwt_Debit' from [T_aepswallet] where awt_memid=@Mem_ID and GuidCode=@Guid    
end    
    
if(@QueryType='CreditMainWallet')    
begin    
declare  @OpenBlancce1 decimal(12,2)=null    
select @OpenBlancce1=Main_wallet From T_Member where Mem_ID=@Mem_Id    
 INSERT INTO [dbo].[T_MainWallet]    
           ([Mwt_memid],[Mwt_openingBalance],[Mwt_Credit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Ref_No],[Mwt_Debit])    
     VALUES(@Mem_Id,@OpenBlancce1,@Ammount,(@OpenBlancce1+@Ammount),getdate(),@IP,'Balance Add by mobile App','Balance Add by mobile App',0.0)    
end    
if(@QueryType='BindState')    
begin    
select  State_Id as 'Value',State_Name as 'Text' From M_State order by State_Name     
end    
if(@QueryType='PuchagePackage')    
begin
	begin tran     
		begin try
			declare @Validfor int =null,@Package_Price numeric(18,2)=null,@OpenBlancce decimal(12,2)=null

			select @Validfor = Validfor, @Package_Price=Package_Price from M_Package where Package_ID=@Package_ID
			select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id

			if(@OpenBlancce>=@Package_Price)
			begin
				Declare @purdate datetime = getdate();
				insert into [T_Package] (Pp_Package_Id,Mem_Id,Purchage_date,Created_DateTime,Expiry_Date,IP) values (@Package_ID,@Mem_ID,@purdate,@purdate, DATEADD(day, @Validfor, @purdate),@IP)

				INSERT INTO [dbo].[T_MainWallet] ([Mwt_memid],[Mwt_openingBalance],[Mwt_Debit],[Mwt_ClosingBalance],[Mwt_datetime],[Mwt_IP],[Mwt_comment],[Mwt_Credit])
					VALUES(@Mem_Id,@OpenBlancce,@Package_Price,(@OpenBlancce-@Package_Price),@purdate,@IP,'Purchage Package',0.0)
					
				--Code add by Saurabh (Sp Infocom), On 12-Nov-2021
				--Release Membership Purchase Commission as per Slab
					Exec [dbo].[SPIU_MemberShip_Pur_Comm] @Mem_Id, @purdate, @IP
			end
			else
			begin
				select -1
			end
		commit tran
	end try -- try end
	begin catch --print  'Error'
		ROLLBACK TRAN
	end  catch -- end Catch
end    
    
    
if(@QueryType='Package')    
begin    
select  Package_ID,Package_Name,Package_Price,Validfor,Package_For,package_desc,    
    
case when t.Pp_id is not null then '1'    
     when t.Pp_id is  null then '2' end 'pstatus',    
   
  case when  convert(date,t.Expiry_Date,103)>=convert(date,getdate(),103) then convert(varchar(30), DATEDIFF(day,getdate(),t.Expiry_Date)) +' Days Left'     
     when convert(date,t.Expiry_Date,103)<convert(date,getdate(),103) then 'Package Expired' end 'pmsg'    
 From M_Package as m    
left join T_Package as t on t.Pp_Package_Id=m.Package_ID and t.Mem_Id=@Mem_ID    
  where Status='Y'    
end    
    
    
if(@QueryType='GetAppVersion')    
begin    
select  App_Version From M_SystemSetting     
end    
    
    
if(@QueryType='UpdateAppVersion')    
begin    
update  M_SystemSetting  set App_Version=@App_Version    
end    
    
if(@QueryType='GetMemberProfile')    
begin    
--select m.Mem_ID, m.Name,mi.Organizationname,mi.Meminfo_designation,mi.Meminfo_address,mi.Meminfo_pincode,mi.Meminfo_state,mi.Meminfo_whatsappnumber,    
--mi.Meminfo_emailid,mi.Meminfo_website,mi.Meminfo_gstin,mi.fblink,mi.twitterlink,mi.instagramlink, mi.linkedinlink, mi.youtubechannellink,mi.googlemaplink,mi.Meminfo_membertype,    
--mi.UPIQRcodeimage,mi.Meminfo_profilepic, m.Mobile, isnull( mi.Meminfo_KYC_status,'Y') 'Meminfo_KYC_status' ,m.Referred_By,    
--isnull(mi.Email_Verified,'N') 'Email_Verified',isnull(m.Mobile_Verified,'N') 'Mobile_Verified',m.Mem_Code,    
--mi.Meminfo_bank_beneficiaryname,mi.Meminfo_bank_accountnumber,mi.Meminfo_bank_ifsc,mi.Meminfo_bank_bankname,mi.Paytm_wallet_number,    
--mi.Meminfo_KYC_pannumber,mi.Meminfo_KYC_pancopy,        CONVERT(varchar(50),DecryptByPassphrase ('Survis',mi.Meminfo_KYC_aadharno)) as 'Meminfo_KYC_aadharno',    
--mi.Meminfo_KYC_aadharcopy,mi.Meminfo_KYC_gstcopy    
-- From T_Member as m    
--left join T_Member_Info as mi on mi.Memid=m.Mem_ID  

  CREATE TABLE #pakage (Pp_Package_Id INT,Mem_ID int) 
Insert Into #pakage
select top 1 a.Pp_Package_Id,a.Mem_Id from T_Package a Inner Join M_Package b On a.Pp_Package_Id = b.Package_ID where Mem_Id=@Mem_ID And b.Package_For = 'Customer' order by a.Purchage_date desc

   select m.Mem_ID, m.Name,mi.Organizationname,mi.Meminfo_designation,mi.Meminfo_address,mi.Meminfo_pincode,mi.Meminfo_state,mi.Meminfo_whatsappnumber,    
mi.Meminfo_emailid,mi.Meminfo_website,mi.Meminfo_gstin,mi.fblink,mi.twitterlink,mi.instagramlink, mi.linkedinlink, mi.youtubechannellink,mi.googlemaplink,mi.Meminfo_membertype,    
mi.UPIQRcodeimage,mi.Meminfo_profilepic, m.Mobile, isnull( mi.Meminfo_KYC_status,'Y') 'Meminfo_KYC_status' ,m.Referred_By,    
isnull(mi.Email_Verified,'N') 'Email_Verified',isnull(m.Mobile_Verified,'N') 'Mobile_Verified',m.Mem_Code,    
mi.Meminfo_bank_beneficiaryname,mi.Meminfo_bank_accountnumber,mi.Meminfo_bank_ifsc,mi.Meminfo_bank_bankname,mi.Paytm_wallet_number,    
mi.Meminfo_KYC_pannumber,mi.Meminfo_KYC_pancopy,        CONVERT(varchar(50),DecryptByPassphrase ('Survis',mi.Meminfo_KYC_aadharno)) as 'Meminfo_KYC_aadharno',    
mi.Meminfo_KYC_aadharcopy,mi.Meminfo_KYC_gstcopy,isnull(tp.Pp_Package_Id, 0) as Pp_Package_Id,mp.Package_Name 
 From T_Member as m 
left join T_Member_Info as mi on mi.Memid=m.Mem_ID 
--left join T_Package as tp on tp.Mem_Id=m.Mem_ID
left join #pakage as tp on tp.Mem_ID=m.Mem_ID
left join M_Package as mp on mp.Package_ID=tp.Pp_Package_Id

where m.Mem_ID=@Mem_ID  --and mp.Package_For='Customer'
 Drop Table #pakage
  
end    
    
    
if(@QueryType='UpdateMemberProfilePic')    
begin    
update T_Member_Info   set    
Meminfo_profilepic=iif(@Meminfo_profilepic is null,Meminfo_profilepic,@Meminfo_profilepic),    
Meminfo_lastupdateIP=@ip,Meminfo_lastupdateondate=getdate() where Memid=@mem_Id    
    
end    
    
    
if(@QueryType='UpdateMemberProfile')    
begin    
update T_Member_Info   set    
Meminfo_profilepic=iif(@Meminfo_profilepic is null,Meminfo_profilepic,@Meminfo_profilepic),    
Meminfo_designation=iif(@Meminfo_designation is null,Meminfo_designation,@Meminfo_designation),    
Meminfo_address=iif(@Meminfo_address  is null,Meminfo_address,@Meminfo_address),    
Meminfo_pincode=iif(@Meminfo_pincode  is null,Meminfo_pincode,@Meminfo_pincode),    
Meminfo_state=iif(@Meminfo_state is null,Meminfo_state,@Meminfo_state),    
Meminfo_whatsappnumber=iif(@Meminfo_whatsappnumber is null,Meminfo_whatsappnumber,@Meminfo_whatsappnumber),    
Meminfo_emailid=iif(@Meminfo_emailid is null,Meminfo_emailid,@Meminfo_emailid),    
Meminfo_website=iif(@Meminfo_website is null,Meminfo_website,@Meminfo_website),    
Organizationname=iif(@Organizationname is null,Organizationname,@Organizationname),    
fblink=iif(@fblink is null,fblink,@fblink),    
twitterlink=iif(@twitterlink is null,twitterlink,@twitterlink),    
instagramlink=iif(@instagramlink is null,instagramlink,@instagramlink),    
linkedinlink=iif(@linkedinlink is null,linkedinlink,@linkedinlink),    
youtubechannellink=iif(@youtubechannellink is null,youtubechannellink,@youtubechannellink),    
googlemaplink=iif(@googlemaplink is null,googlemaplink,@googlemaplink),    
UPIQRcodeimage=iif(@UPIQRcodeimage is null,UPIQRcodeimage,@UPIQRcodeimage),    
Meminfo_membertype=iif(@Meminfo_membertype is null,Meminfo_membertype,@Meminfo_membertype),    
Meminfo_lastupdateIP=@ip,Meminfo_lastupdateondate=getdate(),  
business_category = @business_category, business_subcategory = @business_subcategory  
where Memid=@mem_Id    
update T_Member set Name=iif(@Name is null,Name,@Name),Updated_DateTime=getdate() where  Mem_ID=@mem_Id    
end    
    
    
if(@QueryType='KYCAadharDAta')    
begin    
update T_Member_Info  set     
Meminfo_KYC_aadharno=iif(@Meminfo_KYC_aadharno is null,Meminfo_KYC_aadharno, EncryptByPassPhrase('Survis',@Meminfo_KYC_aadharno) )      
,Meminfo_KYC_aadharcopy=iif(@Meminfo_KYC_aadharcopy is null,Meminfo_KYC_aadharcopy,@Meminfo_KYC_aadharcopy )    
,Meminfo_KYC_pannumber=iif(@Meminfo_KYC_pannumber is null,Meminfo_KYC_pannumber,@Meminfo_KYC_pannumber )    
,Meminfo_KYC_pancopy=iif(@Meminfo_KYC_pancopy is null,Meminfo_KYC_pancopy,@Meminfo_KYC_pancopy )    
,Meminfo_KYC_gstcopy=iif(@Meminfo_KYC_gstcopy is null,Meminfo_KYC_gstcopy,@Meminfo_KYC_gstcopy )    
,Meminfo_gstin=iif(@Meminfo_gstin  is null,Meminfo_gstin,@Meminfo_gstin )    
    
,Meminfo_lastupdateIP=@ip,Meminfo_lastupdateondate=getdate()    
where Memid=@mem_Id    
end    
    
if(@QueryType='KYCBAnkDAta')    
begin    
update T_Member_Info  set     
    
Meminfo_lastupdateIP=@ip,Meminfo_lastupdateondate=getdate(),    
Meminfo_bank_beneficiaryname=iif(@Meminfo_bank_beneficiaryname is null,Meminfo_bank_beneficiaryname,@Meminfo_bank_beneficiaryname)    
,Meminfo_bank_accountnumber=iif(@Meminfo_bank_accountnumber is null,Meminfo_bank_accountnumber,@Meminfo_bank_accountnumber)    
,Meminfo_bank_ifsc=iif(@Meminfo_bank_ifsc is null,Meminfo_bank_ifsc,@Meminfo_bank_ifsc)    
,Meminfo_bank_bankname=iif(@Meminfo_bank_bankname is null,Meminfo_bank_bankname,@Meminfo_bank_bankname)    
,Paytm_wallet_number=iif(@Paytm_wallet_number is null,Paytm_wallet_number,@Paytm_wallet_number)    
where Memid=@mem_Id    
end    
    
    
if(@QueryType='MainWallet')    
begin    
select Mwt_id as 'id' ,Mwt_memid as 'memid',Mwt_servicerefid as 'servicerefid' ,Mwt_openingBalance as 'openingBalance',Mwt_Credit as 'Credit',Mwt_Debit as 'Debit',Mwt_ClosingBalance as 'ClosingBalance'    
,Mwt_datetime as 'datetime',Mwt_IP as 'IP',Mwt_comment as 'comment',Ref_No,BankID     
From T_MainWallet where Mwt_memid=@Mem_ID
end    
    
if(@QueryType='CoinWallet')    
begin    
select cwt_id as 'id' ,cwt_memid as 'memid',cwt_servicerefid as 'servicerefid' ,cwt_openingBalance as 'openingBalance',cwt_Credit as 'Credit',cwt_Debit as 'Debit',cwt_ClosingBalance as 'ClosingBalance'    
,cwt_datetime as 'datetime',cwt_IP as 'IP',cwt_comment as 'comment',Ref_No,BankID     
From T_CoinWallet where cwt_memid=@Mem_ID    
end    
    
if(@QueryType='PayoutWallet')    
begin    
    
select pwt_id as 'id' ,pwt_memid as 'memid',pwt_servicerefid as 'servicerefid' ,pwt_openingBalance as 'openingBalance',pwt_Credit as 'Credit',pwt_Debit as 'Debit',pwt_ClosingBalance as 'ClosingBalance'    
,pwt_datetime as 'datetime',pwt_IP as 'IP',pwt_comment as 'comment',Ref_No,BankID     
From T_PayoutWallet where pwt_memid=@Mem_ID    
    
end    
    
if(@QueryType='AepsWallet')    
begin    
select Awt_id as 'id' ,Awt_memid as 'memid',Awt_servicerefid as 'servicerefid' ,Awt_openingBalance as 'openingBalance',Awt_Credit as 'Credit',Awt_Debit as 'Debit'    
,Awt_ClosingBalance as 'ClosingBalance'    
,Awt_datetime as 'datetime',Awt_IP as 'IP',Awt_comment as 'comment','' as 'Ref_No','' as  'BankID'     
From T_aepswallet where Awt_memid=@Mem_ID    
end    
    
if(@QueryType='RechageReport')    
begin    
--select *From T_Recharegerec where memcode=@Mem_ID    
select TR.*,MSTSC.Sub_Category_Name From T_Recharegerec as TR
Left join M_Service_Type_Sub_Category as MSTSC on MSTSC.Service_Sub_Category_Id =TR.Service_Sub_Category_Id
where TR.memcode=@Mem_ID  


end    
    
if(@QueryType='UpdateRefBy')    
begin    
if  exists (select top 1 1 from T_Member where Mem_ID=@Mem_ID and Referred_By='S100002720')    
begin    
   update T_Member set Referred_By=@Referred_By,Updated_DateTime=getdate(),Updated_By=@Mem_ID where Mem_ID=@Mem_ID    
    
	declare @Referred_By_mem_ID int =null,@S_m_tree varchar(2000)=null,@m_tree varchar(2000)=null    
	select  @Referred_By_mem_ID=mem_Id from T_Member where Mem_Code=@Referred_By    
    
	declare @level int =null    
	select @level = (convert( int, isnull(level,'0'))+1) from  T_Member_Genealogy  where mem_id=@Referred_By_mem_ID    
	select @S_m_tree=m_tree from T_Member_Genealogy where mem_id=@Referred_By_mem_ID    
	if(@S_m_tree is not null )    
	begin    
		--set @m_tree= convert(varchar(30), @Referred_By)+','+  @S_m_tree --Code commented by Saurabh, On 29-Nov-2021
		--set @m_tree = @S_m_tree +','+convert(varchar(30), @Mem_ID) --Add by Saurabh, On 29-Nov-2021
		set @m_tree = @S_m_tree+convert(varchar(30), @Mem_ID)+',' --Add by Saurabh, On 03-Dec-2021
	end    
	else    
	begin    
		--set @m_tree=@Referred_By
		set @m_tree = @Referred_By_mem_ID
	end    
	update T_Member_Genealogy set sponsor_id=@Referred_By_mem_ID,sponsor_code=@Referred_By, m_tree=@m_tree,Level=@level where mem_id=@Mem_ID    
end    
   
end    
if(@QueryType='Banner')    
begin    
select App_Banner_Id,App_Banner_Image from M_Banner     
end    
    
if(@QueryType='ServiceType')    
begin    
select Service_Type_Id, Service_Name  from M_Sevice_Type where  status='Y'    
end    
if(@QueryType='ServiceTypeCategory')    
begin    
select Service_Category_Id, Category_Name,icon,weblink  from M_Service_Type_Category where  Service_Type_Id=@Service_Type_Id and status='Y'    
    
end    
    
if(@QueryType='ServiceSubTypeCategory')    
begin    
select Service_Sub_Category_Id, Sub_Category_Name,icon,field1,field2,field3,field4,field5 from M_Service_Type_Sub_Category where  Service_Category_Id=@Service_Category_Id and status='Y'    
end  
if(@QueryType='ServiceTypeCategoryByMultiServiceCategoryId')    
begin    
select Service_Category_Id, Category_Name,icon,weblink  from M_Service_Type_Category
where  Service_Category_Id in (select convert(int, item) from dbo.fnSplitString(@StrServiceCategoryId,',')) and status='Y'    
end    
if(@QueryType='ValidateToken')    
begin    
select top 1 1  from T_Member where Token=@Login_Token     
end    
if(@QueryType='DashBoard')    
begin    
select m.* ,mi.Meminfo_emailid,mi.Meminfo_profilepic from T_Member m     
left join T_Member_Info as mi on mi.Memid=m.Mem_ID    
where Mem_ID=@Mem_ID     
end    
if(@QueryType='Logout')    
begin    
update T_Member set Token=null,LogOutDateTime=getdate() where Mobile=@Mobile     
end    
if(@QueryType='UpdateLoginToken')    
begin    
update T_Member set Token=@Login_Token,Last_Login_DateTime=getdate(),Mobile_Verified='Y' where Mobile=@Mobile     
end    
if(@QueryType='OTPAuth')    
begin    
    
select Mem_ID, OTP ,DATEDIFF(minute, OTP_EntryDateTime, getdate()) AS 'Diff' , '15' as 'OTP_Valid_Time_Condition'  from T_Member where Mobile=@mobile and OTP=@OTP    
end    
    
if(@QueryType='Singin')    
begin    
if not exists (select top 1 1 from T_Member where Mobile=@mobile)    
begin    
    
select @Mem_Code='S'+ convert(varchar(10), convert(numeric(9,0),rand() * 899999999) + 100000000)    
if  exists (select top 1 1 from T_Member where Mem_Code=@Mem_Code)    
begin    
select @Mem_Code='S'+ convert(varchar(10), convert(numeric(9,0),rand() * 899999999) + 100000000)    
end    
    
if(@Referred_By is not null or @Referred_By!='')    
begin    
insert into T_member (Mobile,Created_On,Mem_Code,OTP,OTP_EntryDateTime,Referred_By,Mem_Status)  values (@Mobile,getdate(),@Mem_Code,@OTP,getdate(),  @Referred_By,'Y')    
end    
else    
begin    
insert into T_member (Mobile,Created_On,Mem_Code,OTP,OTP_EntryDateTime,Mem_Status)  values (@Mobile,getdate(),@Mem_Code,@OTP,getdate(),'Y')    
end    
select  Mem_ID From T_Member where Mobile=@Mobile    
end    
    
else    
begin    
update T_member set otp=@OTP,OTP_EntryDateTime=getdate() where Mobile=@Mobile    
 select Mem_ID from  T_member where  Mobile=@Mobile    
end    
    
end

	if(@QueryType='ServiceInsert')
	begin
		If Not Exists (Select service_id From [T_Service] Where service_memid = @Mem_Id)
		Begin
			INSERT INTO [dbo].[T_Service] (
				service_memid, service_cateid, Booking_fee, Specialisation1, Specialisation2, Specialisation3, 
				Specialisation4, Specialisation5, servicelocationphoto, Creationdate, [IP], Latitude, Longitude, LocationAddress
			) VALUES (
				@Mem_Id, @service_cateid, @Booking_fee, @Specialisation1, @Specialisation2, @Specialisation3, 
				@Specialisation4, @Specialisation5, @servicelocationphoto, getdate(), @IP, @Latitude, @Longitude, @LocationAddress
			)  
	
			set @service_id = (Select SCOPE_IDENTITY());
		End
		Else
		Begin
			set @service_id = -1;
		End
		select @service_id
	end
	if(@QueryType='ServiceUpdate')    
	begin    
		UPDATE [dbo].[T_Service] SET
			service_cateid = @service_cateid, 
			Booking_fee = @Booking_fee,
			Specialisation1 = @Specialisation1,
			Specialisation2 = @Specialisation2,
			Specialisation3 = @Specialisation3,
			Specialisation4 = @Specialisation4,
			Specialisation5 = @Specialisation5,
			servicelocationphoto = isnull(@servicelocationphoto, servicelocationphoto),
			[IP] = @IP,
			Latitude = @Latitude, 
			Longitude = @Longitude,
			LocationAddress = @LocationAddress
		where service_memid = @Mem_Id and service_id = service_id 
	end  
	if(@QueryType='GetServiceDetail')    
	begin
		SELECT a.*, b.Service_Type_Id FROM [dbo].[T_Service] a
		Inner Join M_Service_Type_Category b On a.service_cateid = b.Service_Category_Id
		where 1 = 1 
		and service_id = case when isnull(@service_id, 0) = 0 then service_id else @service_id end
		and service_memid = case when isnull(@Mem_Id, 0) = 0 then service_memid else @Mem_Id end
	end  

	if(@QueryType='ServiceLocationPhotoUpdate')    
	begin    
		update [T_Service] set
			servicelocationphoto = isnull(@servicelocationphoto, servicelocationphoto), IP = @ip
		where service_id = @service_id    
	end  

	if(@QueryType='GetUserCommision')    
	begin

		--Select mpc.Packageid,mp.Package_Name From M_package_commission as mpc
  --      left join M_Package as mp on mp.Package_ID=mpc.Packageid  Where mp.Package_For='Customer' 
		--and mpc.Packageid In (Select top 1 Pp_Package_Id From T_Package Where Mem_Id = @Mem_Id order by Expiry_Date desc)
		--and mpc.pkgcom_servicesubcategoryid = case when isnull(@Service_Category_Id,0) = 0 then mpc.pkgcom_servicesubcategoryid else @Service_Category_Id end
		Select mpc.Packageid,mp.Package_Name From M_package_commission as mpc
        left join M_Package as mp on mp.Package_ID=mpc.Packageid  Where  
		mpc.Packageid In
		(Select top 1 TP.Pp_Package_Id From T_Package as TP left join M_Package as MP on MP.Package_ID=TP.Pp_Package_Id 
		where TP.Mem_Id=@Mem_Id and Package_For='Customer' order by Purchage_date desc)

		and mpc.pkgcom_servicesubcategoryid = case when isnull(@Service_Category_Id,0) = 0 then mpc.pkgcom_servicesubcategoryid else @Service_Category_Id end

	end

	if(@QueryType='commisionchart')    
	begin    
 --         select mpc.pkgcom_id,mpc.pkgcom_servicesubcategoryid,mstsc.Sub_Category_Name,mstsc.icon,
 

	--case when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then 'Rs.'+cast(mpc.pkgcom_commvalueforself as nvarchar(10))    
 --    when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then cast(mpc.pkgcom_commvalueforself as nvarchar(10))+'%' 
	--  when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then ' '
	--  when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then ' '
	--  end 'Commision',
 
 --case when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then ''    
 --    when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then  ''
	--  when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then 'Rs.'+cast(mpc.pkgcom_commvalueforself as nvarchar(10))
	--  when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then cast(mpc.pkgcom_commvalueforself as nvarchar(10))+'%'
	--  end 'Charges'
 
 
 -- from M_package_commission mpc
 --         inner join M_Service_Type_Sub_Category mstsc on mstsc.Service_Sub_Category_Id=mpc.pkgcom_servicesubcategoryid
	--	   where mpc.Packageid=@Package_ID 
	--	and mpc.pkgcom_servicesubcategoryid = case when isnull(@Service_Category_Id,0) = 0 then mpc.pkgcom_servicesubcategoryid else @Service_Category_Id end
	

 select mstsc.Service_Category_Id,MSTC.Category_Name, mpc.pkgcom_id,mpc.pkgcom_servicesubcategoryid,mstsc.Sub_Category_Name,mstsc.icon,

 case when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then 'Rs.'+cast(mpc.pkgcom_commvalueforself as nvarchar(10))    
     when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then cast(mpc.pkgcom_commvalueforself as nvarchar(10))+'%' 
	  when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then ' '
	  when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then ' '
	  end 'Commision',
 
 case when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then ''    
     when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='1' then  ''
	  when cast(mpc.pkgcom_commtype as nvarchar(max))='1' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then 'Rs.'+cast(mpc.pkgcom_commvalueforself as nvarchar(10))
	  when cast(mpc.pkgcom_commtype as nvarchar(max))='2' and cast(mpc.pkgcom_commcharge as nvarchar(max))='2' then cast(mpc.pkgcom_commvalueforself as nvarchar(10))+'%'
	  end 'Charges'
 
 
  from M_package_commission mpc
          inner join M_Service_Type_Sub_Category mstsc on mstsc.Service_Sub_Category_Id=mpc.pkgcom_servicesubcategoryid
		  left join M_Service_Type_Category as MSTC on MSTC.Service_Category_Id=mstsc.Service_Category_Id
		   where mpc.Packageid=1 
		and mpc.pkgcom_servicesubcategoryid = case when isnull(@Service_Category_Id,0) = 0 then mpc.pkgcom_servicesubcategoryid else @Service_Category_Id end

	
	
	end

	if(@QueryType='commisionslab')    
	begin    
		--select mpcs.mintramnt,mpcs.maxtramnt,Replace(REPLACE(mpcs.commtype,'2',cast(commcharge as nvarchar(10))+'%'),'1','Rs.'+cast(commcharge as nvarchar(10))) as commision, Replace(REPLACE(mpcs.commtype,'2',cast(commissionself as nvarchar(10))+'%'),'1','Rs.'+cast(commissionself as nvarchar(10))) as charges From [M_package_commission _slab]as mpcs
	select mpcs.commtype,commcharge, mpcs.mintramnt,mpcs.maxtramnt,
	
	
	case when cast(mpcs.commtype as nvarchar(max))='1' and cast(commcharge as nvarchar(max))='1' then 'Rs.'+cast(commissionself as nvarchar(10))    
     when cast(mpcs.commtype as nvarchar(max))='2' and cast(commcharge as nvarchar(max))='1' then cast(commissionself as nvarchar(10))+'%' 
	  when cast(mpcs.commtype as nvarchar(max))='1' and cast(commcharge as nvarchar(max))='2' then ' '
	  when cast(mpcs.commtype as nvarchar(max))='2' and cast(commcharge as nvarchar(max))='2' then ' '
	  end 'Commision' ,

	  case when cast(mpcs.commtype as nvarchar(max))='1' and cast(commcharge as nvarchar(max))='1' then ''    
     when cast(mpcs.commtype as nvarchar(max))='2' and cast(commcharge as nvarchar(max))='1' then  ''
	  when cast(mpcs.commtype as nvarchar(max))='1' and cast(commcharge as nvarchar(max))='2' then 'Rs.'+cast(commissionself as nvarchar(10))
	  when cast(mpcs.commtype as nvarchar(max))='2' and cast(commcharge as nvarchar(max))='2' then cast(commissionself as nvarchar(10))+'%'
	  end 'Charges' 



   From [M_package_commission _slab]as mpcs where mpcs.pkgcom_id=@package_com_id
	
	end
	if(@QueryType='GetCategoryName')
	begin
	select distinct mstsc.Service_Category_Id,MSTC.Category_Name
  from M_package_commission mpc
          inner join M_Service_Type_Sub_Category mstsc on mstsc.Service_Sub_Category_Id=mpc.pkgcom_servicesubcategoryid
		  left join M_Service_Type_Category as MSTC on MSTC.Service_Category_Id=mstsc.Service_Category_Id
		   where mpc.Packageid=1 
		and mpc.pkgcom_servicesubcategoryid = case when isnull(@Service_Category_Id,0) = 0 then mpc.pkgcom_servicesubcategoryid else @Service_Category_Id end

	end

	if(@QueryType='Getopcode')
	begin
	select Apsop_opcode,Sub_Category_Name,icon from M_Service_Type_Sub_Category as MSTSC
	left join M_apisource_opcode as MAO on MAO.Apsop_servicesubcategoryid=MSTSC.Service_Sub_Category_Id
	where MSTSC. Service_Sub_Category_Id=@Service_Category_Id
	
	end

	if(@QueryType='GetService_Category_Id')
	begin
		Select Service_Category_Id
          From M_Service_Type_Sub_Category Where Service_Sub_Category_Id = @Service_subcat_id 
	end


	if(@QueryType='Getopeningbalace')
	begin
	 select Main_wallet From T_Member where Mem_ID = @Mem_ID
	
	end

		if(@QueryType='Getclosingbalace')
	begin
	 select Main_wallet From T_Member where Mem_ID = @Mem_ID
	
	end

	if(@QueryType='GetCommision')
	begin
	Declare @recid int
	select @recid=Recid from T_OTTRecharge_log where partner_request_id=@Referred_By and mem_id=@Mem_ID

	select pwt_Credit from T_PayoutWallet where pwt_servicerefid=@recid
	
	end
end    



