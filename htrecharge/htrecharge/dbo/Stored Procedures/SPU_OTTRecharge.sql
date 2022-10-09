
CREATE Procedure [dbo].[SPU_OTTRecharge]


@mem_id int,
@mobile_no nvarchar(max)=null,
@plan_id nvarchar(max)=null,
@operator_code nvarchar(max)=null,
@customer_email nvarchar(max)=null,
@RechargeAmount int=null,
@partner_request_id nvarchar(max)=null,
@QueryType	nvarchar(100)=null,
@ResponseDate datetime=null,
@RequestDate datetime=null,
@completeResponse  nvarchar(max)=null,
@Status  nvarchar(max)=null,
@End_point nvarchar(max)=null,
@Request_API nvarchar(max)=null,
@Message_Desc nvarchar(max)=null,
@Con nvarchar(max)=null,
@srv_type nvarchar(max)=null,
@ReqTime datetime=null,
@ResTime datetime=null,
@ip nvarchar(max)=null,
@PlanName nvarchar(100)=null,
@duration datetime=null
as
 begin
 

if(@QueryType='Update_OTTLog')
begin
--select * from tbl_OTT_Subscription_Log
insert into tbl_OTT_Subscription_Log values(@mem_id,@mobile_no,@srv_type,@plan_id,@PlanName,@operator_code,@customer_email,@RechargeAmount,@partner_request_id ,@RequestDate,@Status ,@End_point,@Request_API,@completeResponse,@ReqTime,@ResTime, @Message_Desc,@duration)

 --declare @subcategoryid varchar(50),@Recid int
 --	select @subcategoryid=Apsop_servicesubcategoryid from M_apisource_opcode where Apsop_opcode=@operator_code
 --insert into T_Recharegerec (
	--	memcode, mobileno, operatorcode, amount, recmedium, reqtime, status, statusdesc, promo_id, IP,   Res_TRNID,StatusCode, ClientRefNo, Service_Sub_Category_Id
	--) values (
	--	@mem_id, @mobile_no, @operator_code, @RechargeAmount, 'APP', @reqtime, @status, @Message_Desc,0, @IP, @partner_request_id, 0,@partner_request_id,@subcategoryid
		
	--)


	update T_Recharegerec set status=@status where Res_TRNID=@partner_request_id


update T_OTTRecharge_log set Status=@Status,Message_Desc=@Message_Desc, API_Request=@Request_API where partner_request_id=@partner_request_id

--Rollback txn amount

if(@Status='Failed')
begin
--Credit Txn Amt
      declare @OpeningBal decimal(18,2) ,@ClosingBal decimal(18,2),@TxnComment varchar(100)
		set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @mem_id), 0)
		set @ClosingBal = (@OpeningBal + @RechargeAmount)
		set @TxnComment = 'OTT Recharge and Operator Code is '+@operator_code;
		insert into T_MainWallet (
			Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
		) values (
			@mem_id,0, @OpeningBal, @RechargeAmount, 0, @ClosingBal, @RequestDate, @ip, @TxnComment,  @partner_request_id, 0, 0
		)
--if upper(@Status) = 'SUCCESS'
--	begin
--		--exec [dbo].[SPI_OTTRecharge] @mem_id, @partner_request_id, @RequestDate, @ip
--			exec [dbo].[SPI_OTTRecharge] @mem_id, @mobile_no, @plan_id, @operator_code
--	end
end


if(@Status= 'SUCCESS')
	begin
		--exec [dbo].[SPI_OTTRecharge] @mem_id, @partner_request_id, @RequestDate, @ip
			exec [dbo].[SPIU_Commission_Distribution] @mem_id,@ip
	end	
		


end
 end
