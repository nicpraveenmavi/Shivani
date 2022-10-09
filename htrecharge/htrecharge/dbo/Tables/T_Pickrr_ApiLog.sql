CREATE TABLE [dbo].[T_Pickrr_ApiLog] (
    [autoid]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [endpoint]     VARCHAR (50)  NULL,
    [mem_id]       INT           NULL,
    [apirequest]   VARCHAR (MAX) NULL,
    [apiresponse]  VARCHAR (MAX) NULL,
    [entrydate]    DATETIME      NULL,
    [requesttime]  DATETIME      NULL,
    [responsetime] DATETIME      NULL,
    [ipaddress]    VARCHAR (50)  NULL,
    CONSTRAINT [PK_T_Pickrr_ApiLog] PRIMARY KEY CLUSTERED ([autoid] ASC)
);

