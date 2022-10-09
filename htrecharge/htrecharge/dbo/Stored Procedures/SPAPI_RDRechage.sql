CREATE Procedure [dbo].[SPAPI_RDRechage]
	@QueryType varchar(100) = null,
	@Mem_Id int = null,
	@Amount decimal(12,2) = null,
	@Mobile varchar(20) = null,
	@refMobileNo bigint = null,
	@operatorcode varchar(20) = null,
	@IP varchar(50) = null,
	@recId int = null,
	@status varchar(500) = null,
	@Res_TRNID varchar(50) = null,
	@OpenBlancce decimal(12,2) = null,
	@log nvarchar(200) = null,
	@ClientRefNo varchar(50) = null,
	@statusmsg varchar(150) = null,
	@servicesubcategoryid int = 0
	
as
begin
Declare @Comments varchar(50)
	if(@QueryType='UpdateCallBackREc')
	
	begin
		if(@status='1')
			declare @recids int
		begin
		
			if isnull(@recId, 0) > 0
			
			begin
			if exists(select * from T_Recharegerec where Recid = @recId and TrnStatusCode='4' )
			begin
			exec SPIU_Commission_Distribution @recId
			end
			else if exists(select * from T_Recharegerec where Recid = @recId and TrnStatusCode='6' )
			begin
		
			exec SPIU_Commission_Distribution @recId
			end
			else if exists(select * from T_Recharegerec where Recid = @recId and TrnStatusCode='0' )
			begin
		
			exec SPIU_Commission_Distribution @recId
			end
				update T_Recharegerec set  OprId = @operatorcode, status = @statusmsg, statusdesc = 'Success', TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Success' where Recid = @recId
			
			end


			else if isnull(@ClientRefNo, '') <> '' 
			begin
			select @recids=Recid from T_Recharegerec where ClientRefNo = @ClientRefNo
			if exists(select * from T_Recharegerec where ClientRefNo = @ClientRefNo and TrnStatusCode='4')
			begin
			select @recId=Recid from T_Recharegerec where ClientRefNo = @ClientRefNo
			exec SPIU_Commission_Distribution @recId
			end
			else if exists(select * from T_Recharegerec where ClientRefNo = @ClientRefNo and TrnStatusCode='6' )
			begin
		    select @recId=Recid from T_Recharegerec where ClientRefNo = @ClientRefNo
			exec SPIU_Commission_Distribution @recId
			end
			else if exists(select * from T_Recharegerec where ClientRefNo = @ClientRefNo and TrnStatusCode='0' )
			begin
			select @recId=Recid from T_Recharegerec where ClientRefNo = @ClientRefNo
			exec SPIU_Commission_Distribution @recId
			end

			
				update T_Recharegerec set  OprId  = @operatorcode, status = @statusmsg, statusdesc = 'Success', TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Success' where ClientRefNo = @ClientRefNo
			
			
			end


			


			--exec SPIU_Commission_Distribution @recId
		end

		


		if(@status='5' or @status='2' or @status='3')
		begin
			if isnull(@recId, 0) > 0
			begin
				update T_Recharegerec set  OprId  = @operatorcode, status = @statusmsg, statusdesc = 'Failed', TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Failed' where Recid = @recId
			end
			else if isnull(@ClientRefNo, '') <> '' 
			begin
				update T_Recharegerec set  OprId  = @operatorcode, status = @statusmsg, statusdesc = 'Failed', TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Failed' where ClientRefNo = @ClientRefNo
			end

			select @Amount=amount,@Mem_Id=memcode from T_Recharegerec where  Recid=@recId
			if not exists (select top 1 1 from T_MainWallet where Mwt_servicerefid=@recId and Mwt_Credit=@Amount)
			begin
				select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
				insert into T_MainWallet (Mwt_memid,Mwt_servicerefid,Mwt_openingBalance, Mwt_Credit,Mwt_ClosingBalance,Mwt_datetime,Mwt_IP,Mwt_comment,Mwt_Debit)
				values (@Mem_Id,@recId,@OpenBlancce,@Amount,(@OpenBlancce+@Amount),getdate(),@IP,'REFUND',0.0)
			end
		end  
	end
	if(@QueryType='RequestLog')
	begin
		insert into t_api_logs(recid,request,request_Datetime,ClientRefNo) values (@recId,@log,getdate(),@ClientRefNo)
	end
	if(@QueryType='ResponseLog')
	begin
		update t_api_logs set Response=@log,Response_DateTime=getdate()  where recid= @recId
	end
	if(@QueryType='CallBackLog')
	begin
		if isnull(@recId, 0) > 0
		begin
			update t_api_logs set CalBack_Response=@log,CalBack_Response_DateTime=getdate()  where recid= @recId
		end
		else if isnull(@ClientRefNo, '') <> ''
		begin
			update t_api_logs set CalBack_Response=@log,CalBack_Response_DateTime=getdate()  where ClientRefNo = @ClientRefNo
		end
	end
	if(@QueryType='CheckMemberBalance')
	begin
		select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
		if(@OpenBlancce>=@Amount)
		begin
			select 1 as 'b'
		end
		else
		begin
			select -1 as 'B'
		end
	end
	if(@QueryType='RefundRDBalnace')
	begin
		select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
		insert into T_MainWallet (Mwt_memid,Mwt_servicerefid,Mwt_openingBalance, Mwt_Credit,Mwt_ClosingBalance,Mwt_datetime,Mwt_IP,Mwt_comment,Mwt_Debit)
		values (@Mem_Id,@recId,@OpenBlancce,@Amount,(@OpenBlancce+@Amount),getdate(),@IP,'REFUND',0.0)
	end
	if(@QueryType='DebitRDAmmount')
	begin
		select @OpenBlancce=Main_wallet From T_Member where Mem_ID=@Mem_Id
		if(@OpenBlancce>=@Amount)
		begin
		--declare @TxnComment nvarchar(max)
		--set @TxnComment = 'Prepaid Recharge and Operator Code is '+@operatorcode;

		
		select @Comments=MSTC.Category_Name from M_Service_Type_Sub_Category as mstsc
		left join M_Service_Type_Category as MSTC on MSTC.Service_Category_Id=mstsc.Service_Category_Id where mstsc.Service_Sub_Category_Id=@operatorcode


			insert into T_MainWallet (Mwt_memid,Mwt_servicerefid,Mwt_openingBalance, Mwt_Debit,Mwt_ClosingBalance,Mwt_datetime,Mwt_IP,Mwt_Credit,Mwt_comment)
			values (@Mem_Id,@recId,@OpenBlancce,@Amount,(@OpenBlancce-@Amount),getdate(),@IP,0.0,@Comments+'Payment')


			--exec SPIU_Commission_Distribution @recId
		end
		else
		begin
			select -1
		end
	end
	if(@QueryType='UpdateRechage')
	begin
		if(@status='1')
		begin
			if isnull(@recId, 0) > 0
			begin
				update T_Recharegerec set restime = getdate(), Res_TRNID = @Res_TRNID, status = 'Success', statusdesc =@statusmsg , TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Success' where Recid = @recId
			end
			else if isnull(@ClientRefNo, '') <> '' 
			begin
				update T_Recharegerec set restime = getdate(), Res_TRNID = @Res_TRNID, status = 'Success', statusdesc =@statusmsg, TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Success' where ClientRefNo = @ClientRefNo
			end
			exec SPIU_Commission_Distribution @recId
		end

		if(@status='4' or @status='6' or @status='0')
		begin
			if isnull(@recId, 0) > 0
			begin
				update T_Recharegerec set  restime = getdate(), Res_TRNID = @Res_TRNID, status ='Pending' , statusdesc =@statusmsg , TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Pending' where Recid = @recId
			end
			else if isnull(@ClientRefNo, '') <> '' 
			begin
				update T_Recharegerec set  restime = getdate(), Res_TRNID = @Res_TRNID, status ='Pending' , statusdesc =@statusmsg, TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Pending' where ClientRefNo = @ClientRefNo
			end
		end  

		if(@status='5' or @status='2' or @status='3')
		begin
			if isnull(@recId, 0) > 0
			begin
				update T_Recharegerec set  restime = getdate(), Res_TRNID = @Res_TRNID, status ='Failed' , statusdesc = @statusmsg, TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Failed' where Recid = @recId
			end
			else if isnull(@ClientRefNo, '') <> '' 
			begin
				update T_Recharegerec set  restime = getdate(), Res_TRNID = @Res_TRNID,  status ='Failed' , statusdesc = @statusmsg, TrnStatusCode = @status, TrnStatusMsg = @statusmsg, TrnStatus = 'Failed' where ClientRefNo = @ClientRefNo
			end
		end  
	end
	if(@QueryType='GetRechageID')
	begin
	declare @defaultAPIsourceid int

	select @defaultAPIsourceid=default_apisourceid from M_Service_Type_Sub_Category where Service_Sub_Category_Id=@servicesubcategoryid
		insert into T_recharegerec ( memcode,mobileno,operatorcode,amount,recmedium,reqtime,status,IP,Ref_MobileNo, ClientRefNo, Service_Sub_Category_Id,apisourceid)
		output inserted.Recid values  (@Mem_Id,@Mobile,@operatorcode,@Amount,'App',getdate(),'PENDING',@IP,@refMobileNo, @ClientRefNo, @servicesubcategoryid,@defaultAPIsourceid)
	end
	if(@QueryType='GetServiceCode')
	begin
		select  op.apsop_opcode from M_Service_Type_Sub_Category  SC
		inner join  M_apisource_opcode op on op.Apsop_servicesubcategoryid=sc.Service_Sub_Category_Id and op.Apsop_apisourceid=sc.default_apisourceid
		where sc.Service_Sub_Category_Id=@operatorcode
	end
end
