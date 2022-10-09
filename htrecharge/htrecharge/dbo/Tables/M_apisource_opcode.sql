CREATE TABLE [dbo].[M_apisource_opcode] (
    [Apsop_id]                   INT             IDENTITY (1, 1) NOT NULL,
    [Apsop_apisourceid]          INT             NULL,
    [Apsop_servicesubcategoryid] INT             NULL,
    [Apsop_opcode]               VARCHAR (50)    NULL,
    [Apsop_commtype]             INT             NULL,
    [Apsop_commcharge]           INT             NULL,
    [Apsop_commvalue]            VARCHAR (50)    NULL,
    [Apsop_minamount]            DECIMAL (12, 2) NULL,
    [Apsop_maxamount]            DECIMAL (12, 2) NULL,
    [Apsop_lastupdatedon]        DATETIME        NULL,
    [Apsop_updatedby]            INT             NULL,
    [Apsop_ip]                   VARCHAR (50)    NULL,
    CONSTRAINT [PK_M_apisource_opcode] PRIMARY KEY CLUSTERED ([Apsop_id] ASC)
);

