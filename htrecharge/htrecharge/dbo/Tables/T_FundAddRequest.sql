CREATE TABLE [dbo].[T_FundAddRequest] (
    [auto_id]         BIGINT          IDENTITY (1, 1) NOT NULL,
    [mem_id]          INT             NOT NULL,
    [dep_mode]        VARCHAR (50)    NULL,
    [txn_ref_no]      VARCHAR (50)    NULL,
    [txn_remark]      VARCHAR (200)   NULL,
    [dep_amt]         DECIMAL (18, 2) NULL,
    [req_ip]          VARCHAR (20)    NULL,
    [req_date]        DATETIME        NULL,
    [req_status]      VARCHAR (10)    NULL,
    [status_remark]   VARCHAR (200)   NULL,
    [status_upd_date] DATETIME        NULL,
    [status_upd_by]   VARCHAR (50)    NULL,
    [status_upd_ip]   VARCHAR (20)    NULL,
    [req_status_id]   INT             DEFAULT ((0)) NULL,
    CONSTRAINT [PK_T_FundAddRequest] PRIMARY KEY CLUSTERED ([auto_id] ASC)
);

