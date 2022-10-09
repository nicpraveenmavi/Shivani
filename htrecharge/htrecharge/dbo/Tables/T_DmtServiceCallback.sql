CREATE TABLE [dbo].[T_DmtServiceCallback] (
    [auto_id]      BIGINT        IDENTITY (1, 1) NOT NULL,
    [dmt_srv_id]   BIGINT        NULL,
    [callbacktime] DATETIME      NULL,
    [clientrefno]  VARCHAR (50)  NULL,
    [status]       VARCHAR (50)  NULL,
    [statusmsg]    VARCHAR (500) NULL,
    [trnid]        VARCHAR (50)  NULL,
    [bankrefno]    VARCHAR (50)  NULL,
    [ttc]          FLOAT (53)    NULL,
    [tc]           FLOAT (53)    NULL,
    [tcg]          FLOAT (53)    NULL,
    [apbd]         FLOAT (53)    NULL,
    [atds]         FLOAT (53)    NULL,
    [gt]           FLOAT (53)    NULL,
    [ip]           VARCHAR (20)  NULL,
    CONSTRAINT [PK_T_DmtServiceCallback] PRIMARY KEY CLUSTERED ([auto_id] ASC)
);


GO
CREATE TRIGGER [dbo].[Trgi_DmtCallback] ON [dbo].[T_DmtServiceCallback]
FOR INSERT 
AS
BEGIN
	declare @id bigint, @dmt_srv_id bigint, @srf_ref_no varchar(50), @status int, @srv_status varchar(500), @statusmsg varchar(500),
			@dmt_totalcharge float, @dmt_charge float, @dmt_gst float, @dmt_apbd float, @dmt_atds float, @srv_resp_ref_no varchar(50), 
			@srv_resp_trn_no varchar(50)
	
	select @id = auto_id, @srf_ref_no = ClientRefNo, @status = status, @statusmsg = statusmsg, @srv_resp_ref_no = bankrefno, 
		@dmt_totalcharge = ttc, @dmt_charge = tc, @dmt_gst = tcg, @dmt_apbd = apbd, @dmt_atds = atds, @srv_resp_trn_no = trnid
	from inserted;

	select @dmt_srv_id = dmt_srv_id from T_DmtService where srf_ref_no = @srf_ref_no

	update T_DmtServiceCallback set dmt_srv_id = @dmt_srv_id where auto_id = @id and dmt_srv_id is null


	set @srv_status = case when @status = 1 then 'Success' else 'Failed' end
	set @statusmsg = case @statusmsg when 'Success' then 'Money Transferred' when 'Failed' then 'Money Transfer Failed' else @statusmsg end
	
	update T_DmtService set 
			srv_status = @srv_status, srv_status_desc = @statusmsg, srv_resp_ref_no = @srv_resp_ref_no, srv_resp_trn_no = @srv_resp_trn_no,
			dmt_totalcharge = @dmt_totalcharge, dmt_charge = @dmt_charge, dmt_gst = @dmt_gst, dmt_apbd = @dmt_apbd, dmt_atds = @dmt_atds
	where dmt_srv_id = @dmt_srv_id

END
