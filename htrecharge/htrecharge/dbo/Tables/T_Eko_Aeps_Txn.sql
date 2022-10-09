﻿CREATE TABLE [dbo].[T_Eko_Aeps_Txn] (
    [autoid]             BIGINT        IDENTITY (1, 1) NOT NULL,
    [mem_id]             INT           NULL,
    [onboarduserid]      BIGINT        NOT NULL,
    [status]             INT           NULL,
    [response_status_id] INT           NULL,
    [response_type_id]   INT           NULL,
    [message]            VARCHAR (300) NULL,
    [tx_status]          INT           NULL,
    [transaction_date]   VARCHAR (30)  NULL,
    [reason]             VARCHAR (300) NULL,
    [amount]             VARCHAR (20)  NULL,
    [merchant_code]      VARCHAR (150) NULL,
    [tds]                VARCHAR (20)  NULL,
    [shop]               VARCHAR (150) NULL,
    [sender_name]        VARCHAR (150) NULL,
    [tid]                VARCHAR (150) NULL,
    [auth_code]          VARCHAR (150) NULL,
    [balance]            VARCHAR (20)  NULL,
    [shop_address_line1] VARCHAR (150) NULL,
    [user_code]          VARCHAR (50)  NULL,
    [merchantname]       VARCHAR (150) NULL,
    [stan]               VARCHAR (150) NULL,
    [aadhaar]            VARCHAR (50)  NULL,
    [customer_balance]   VARCHAR (20)  NULL,
    [transaction_time]   VARCHAR (20)  NULL,
    [commission]         VARCHAR (20)  NULL,
    [bank_ref_num]       VARCHAR (30)  NULL,
    [terminal_id]        VARCHAR (30)  NULL,
    [entrylogdate]       DATETIME      NULL,
    [ipaddress]          VARCHAR (20)  NULL,
    CONSTRAINT [PK_T_Eko_Aeps_Txn] PRIMARY KEY CLUSTERED ([autoid] ASC)
);

