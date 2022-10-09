﻿CREATE TABLE [dbo].[T_DmtService] (
    [dmt_srv_id]           BIGINT          IDENTITY (1, 1) NOT NULL,
    [mem_id]               INT             NOT NULL,
    [srv_type]             VARCHAR (50)    NULL,
    [srv_date]             DATETIME        NULL,
    [sender_mobile_no]     VARCHAR (20)    NULL,
    [sender_name]          VARCHAR (100)   NULL,
    [sender_transferlimit] DECIMAL (18, 2) NULL,
    [sender_used]          DECIMAL (18, 2) NULL,
    [sender_remain]        DECIMAL (18, 2) NULL,
    [bene_id]              VARCHAR (10)    NULL,
    [bene_name]            VARCHAR (100)   NULL,
    [bene_mobile]          VARCHAR (20)    NULL,
    [bene_bank_id]         INT             NULL,
    [bene_bank_name]       VARCHAR (100)   NULL,
    [bene_bank_acno]       VARCHAR (20)    NULL,
    [bene_bank_ifsc]       VARCHAR (20)    NULL,
    [srv_amount]           DECIMAL (18, 2) NULL,
    [srv_charge]           DECIMAL (18, 2) NULL,
    [srv_totamt]           DECIMAL (18, 2) NULL,
    [srf_ref_no]           VARCHAR (20)    NULL,
    [srv_status]           VARCHAR (10)    NULL,
    [srv_status_desc]      VARCHAR (500)   NULL,
    [srv_resp_date]        DATETIME        NULL,
    [srv_resp_json]        VARCHAR (MAX)   NULL,
    [srv_resp_ref_no]      VARCHAR (20)    NULL,
    [srv_resp_trn_no]      VARCHAR (20)    NULL,
    [ipaddress]            VARCHAR (20)    NULL,
    [dmt_totalcharge]      FLOAT (53)      NULL,
    [dmt_charge]           FLOAT (53)      NULL,
    [dmt_gst]              FLOAT (53)      NULL,
    [dmt_apbd]             FLOAT (53)      NULL,
    [dmt_atds]             FLOAT (53)      NULL,
    CONSTRAINT [PK_T_DmtService] PRIMARY KEY CLUSTERED ([dmt_srv_id] ASC)
);

