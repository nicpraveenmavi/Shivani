
 CREATE Procedure [dbo].[SPI_OTTRecharge]


@mem_id int,
@mobile_no nvarchar(max)=null,
@plan_id nvarchar(max)=null,
@operator_code nvarchar(max)=null,
@customer_email nvarchar(max)=null,
@RechargeAmount decimal(18,2)=null,
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
 if(@QueryType='Subscribe_OTTLog')
 begin
 --select * from T_Recharegerec
 declare @subcategoryid int,@Recid int
 	select @subcategoryid=Apsop_servicesubcategoryid from M_apisource_opcode where Apsop_opcode=@operator_code

	insert into T_Recharegerec values(@mem_id,'',@mobile_no,@operator_code,@RechargeAmount,'APP',@RequestDate,@RequestDate,@status,@Message_Desc,0,@IP,@partner_request_id,@mobile_no,NULL,NULL,NULL,0,'','','','','',0,'','','',@subcategoryid)

	select @Recid=Recid from T_Recharegerec where memcode=@mem_id and mobileno=@mobile_no and  amount=@RechargeAmount  and Res_TRNID=@partner_request_id

 --select * from T_OTTRecharge_log
 insert into T_OTTRecharge_log values(@mem_id,@mobile_no,@srv_type,@plan_id,@PlanName,@operator_code,@customer_email,@End_point,@RechargeAmount,@partner_request_id ,@RequestDate,NULL, @Request_API,@Status, @Message_Desc,@Recid,@duration)
 	--Debit Txn Amt
	declare @OpeningBal decimal(18,2) ,@ClosingBal decimal(18,2), @TxnComment varchar(100)
	set @OpeningBal = IsNull((select Main_wallet From T_Member where Mem_ID = @mem_id), 0)
	set @ClosingBal = (@OpeningBal - @RechargeAmount)
	

	set @TxnComment = 'OTT Recharge and Operator Code is '+@operator_code;
	
	insert into T_MainWallet (
		Mwt_memid, Mwt_servicerefid, Mwt_openingBalance, Mwt_Credit, Mwt_Debit, Mwt_ClosingBalance, Mwt_datetime, Mwt_IP, Mwt_comment, Ref_No, BankID, Pg_Id
	) values (
		@mem_id, 0, @OpeningBal, 0, @RechargeAmount, @ClosingBal, @RequestDate, @ip, @TxnComment, @partner_request_id, 0, 0
	)
--select * from T_OTTRecharge_log
--select * from tbl_OTT_Subscription_Log
end


 end
