CREATE TABLE [dbo].[M_apisouce_opcode_slab] (
    [steps_id]       BIGINT          IDENTITY (1, 1) NOT NULL,
    [Apsop_id]       INT             NULL,
    [mintramnt]      DECIMAL (18, 3) NULL,
    [maxtramnt]      DECIMAL (18, 3) NULL,
    [commtype]       INT             NULL,
    [commcharge]     INT             NULL,
    [commission]     DECIMAL (18, 3) NULL,
    [lastupdatedate] DATETIME        NULL,
    [IP]             VARCHAR (50)    NULL,
    CONSTRAINT [PK_M_package_commission_slab] PRIMARY KEY CLUSTERED ([steps_id] ASC)
);

