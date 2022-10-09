CREATE PROCEDURE [dbo].[SPIU_Commission_Distribution]  -- SPIU_Commission_Distribution 2
	@Recid int = null,
	@Mem_Id int = null,
	@Amount decimal(12,2) = null,
	@OperatorCode varchar(50) = null,
	@IP varchar(100) = null --- Service sub cat id
as
begin
	if  exists (select top 1 1 from  T_Recharegerec where Recid=@Recid and get_disc is null and Mem_disc is null and Org_disc is null )
	begin 
	begin tran 
	begin try
		select @Mem_Id = memcode, @Amount = Amount, @OperatorCode = OperatorCode from T_Recharegerec where Recid=@Recid
		select  @Mem_Id as 'Mem_Id' ,@Amount as 'Ammount',@OperatorCode as 'Operator_code'
		declare @Member_pp_Package_Id int= null
		select  @Member_pp_Package_Id = Pp_Package_Id From T_Package where Mem_Id=@Mem_Id

		declare @pkgcom_commtype int =null  --- if value 2  =% or value 1= Flat
			,@pkgcom_commcharge int =null  -- if value 1= Credit (dena ha) or value 2 (debit) Lena ha
			,@pkgcom_commvalueforself varchar(50)=null,@pkgcom_commvalueforupliner varchar(50)=null,@pkgcom_commvaluefor6level varchar(50)=null
		
		select @pkgcom_commtype=pkgcom_commtype,@pkgcom_commcharge=pkgcom_commcharge
			,@pkgcom_commvalueforself=pkgcom_commvalueforself,@pkgcom_commvalueforupliner=pkgcom_commvalueforupliner,@pkgcom_commvaluefor6level=pkgcom_commvaluefor6level
		From M_package_commission  where Packageid=@Member_pp_Package_Id
			and pkgcom_servicesubcategoryid in (select  ib.Service_Sub_Category_Id  From M_Apisource_opcode ia inner join M_Service_Type_Sub_Category ib on ia.Apsop_servicesubcategoryid = ib.Service_Sub_Category_Id where ia.Apsop_opcode = @OperatorCode)
		 --and pkgcom_servicesubcategoryid=@OperatorCode
 
		select  @pkgcom_commtype '@pkgcom_commtype' ,@pkgcom_commcharge '@pkgcom_commcharge',@pkgcom_commvalueforself '@pkgcom_commvalueforself',
			@pkgcom_commvalueforupliner '@pkgcom_commvalueforupliner',@pkgcom_commvaluefor6level '@pkgcom_commvaluefor6level'

		declare @Immediate_sponsored_Mem_Id int =null,@Mem_ID1 int =null,@Mem_ID2 int =null,@Mem_ID3 int =null,@Mem_ID4 int =null,@Mem_ID5 int =null ,@Mem_ID6 int =null

		select @Immediate_sponsored_Mem_Id=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code  where t.Mem_ID=@Mem_Id

		select @Mem_ID1=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Immediate_sponsored_Mem_Id 
		select @Mem_ID2=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Mem_ID1  
		select @Mem_ID3=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Mem_ID2  
		select @Mem_ID4=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Mem_ID3  
		select @Mem_ID5=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Mem_ID4 
		select @Mem_ID6=st.Mem_ID From T_Member as t  inner join T_Member as St on t.Referred_By=st.Mem_Code   where t.Mem_ID=@Mem_ID5

		select @Immediate_sponsored_Mem_Id '@Immediate_sponsored_Mem_Id',@Mem_ID1 '@Mem_ID1',@Mem_ID2 '@Mem_ID2' ,@Mem_ID3 '@Mem_ID3',@Mem_ID4 '@Mem_ID4' ,@Mem_ID5 '@Mem_ID5',@Mem_ID6 '@Mem_ID6'

		declare  @CommissionAmmountSelf decimal(18,3) =null,@CommissionAmmountUpliner decimal(18,3) =null,@CommissionAmmountOther6 decimal(18,3) =null

		set @CommissionAmmountSelf= @amount*isnull(@pkgcom_commvalueforself,0)/100   set @CommissionAmmountUpliner= @amount*isnull(@pkgcom_commvalueforupliner,0)/100
		set @CommissionAmmountOther6= @amount*isnull(@pkgcom_commvaluefor6level,0)/100
		select @CommissionAmmountSelf '@CommissionAmmountSelf',@CommissionAmmountUpliner '@CommissionAmmountUpliner',@CommissionAmmountOther6 '@CommissionAmmountOther6'

		declare @OpenBlancce decimal(12,3) =null,@Mem_disc decimal(12,3)=null 

		if(@Mem_Id is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_Id
			
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_Id,@Recid,@OpenBlancce,@CommissionAmmountSelf,0.0,(@OpenBlancce+@CommissionAmmountSelf),getdate(),@IP,'Recharge Commission', 0, 0)
			set  @Mem_disc=@CommissionAmmountSelf
		end

		if(@Immediate_sponsored_Mem_Id is not null )
		begin	  
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Immediate_sponsored_Mem_Id
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Immediate_sponsored_Mem_Id,@Recid,@OpenBlancce,@CommissionAmmountUpliner,0.0,(@OpenBlancce+@CommissionAmmountUpliner),getdate(),@IP,'Recharge Commission', @Mem_Id, 1)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountUpliner,0.0)
		end

		if(@Mem_ID1 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID1
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID1,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 2)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end
		if(@Mem_ID2 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID2
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID2,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 3)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end
		if(@Mem_ID3 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID3
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID3,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 4)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end
		if(@Mem_ID4 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID4
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID4,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 5)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end
		if(@Mem_ID5 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID5
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID5,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 6)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end
		if(@Mem_ID6 is not null )
		begin
			set @OpenBlancce  =null
			select @OpenBlancce=Payout_Wallet From T_Member where Mem_ID=@Mem_ID6
			insert into T_PayoutWallet(pwt_memid,pwt_servicerefid,pwt_openingBalance,pwt_Credit,pwt_Debit,pwt_ClosingBalance,pwt_datetime,pwt_IP,pwt_comment, IncomeByMemId, IncomeByLevelNo)
			values (@Mem_ID6,@Recid,@OpenBlancce,@CommissionAmmountOther6,0.0,(@OpenBlancce+@CommissionAmmountOther6),getdate(),@IP,'Recharge Commission', @Mem_Id, 7)
			set  @Mem_disc=isnull(@Mem_disc,0.0)+isnull(@CommissionAmmountOther6,0.0)
		end

		---- declare   @i int =1 ,@j int =0 select @i/@j
		declare @apsop_commtype int =null, -- 2 =% and 1= flat
			@apsop_commcharge int =null --- 1 credit 2 debit
			,@apsop_commvalue varchar(50) =null  , @get_disc decimal(12,3)=null
  
		select  @apsop_commtype=mapi.apsop_commtype,@apsop_commcharge=mapi.apsop_commcharge,@apsop_commvalue=mapi.apsop_commvalue From M_Apisource_opcode as mapi
			inner join M_Service_Type_Sub_Category as s on s.Service_Sub_Category_Id=mapi.Apsop_servicesubcategoryid and s.default_apisourceid=mapi.Apsop_apisourceid
		--where s.Service_Sub_Category_Id= @OperatorCode
		where mapi.Apsop_opcode = @OperatorCode
		set @get_disc=@Amount*ISNULL(@apsop_commvalue,0)/100
		select @apsop_commtype '@apsop_commtype',@apsop_commcharge '@apsop_commcharge',@apsop_commvalue '@apsop_commvalue',@get_disc '@get_disc',@Mem_disc '@Mem_disc'
		update T_Recharegerec set get_disc=@get_disc,Mem_disc=@Mem_disc,Org_disc=(@get_disc-@Mem_disc) where Recid=@Recid
	commit tran
	end try -- try end
	begin catch
		print  'Error'
	ROLLBACK TRAN
	end catch -- end Catch
	end --------- Check unique commisstion distribution
end
