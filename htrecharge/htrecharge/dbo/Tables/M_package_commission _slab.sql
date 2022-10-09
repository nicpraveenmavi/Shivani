CREATE TABLE [dbo].[M_package_commission _slab] (
    [steps_id]          INT             NOT NULL,
    [pkgcom_id]         INT             NULL,
    [mintramnt]         DECIMAL (18, 3) NULL,
    [maxtramnt]         DECIMAL (18, 3) NULL,
    [commtype]          INT             NULL,
    [commcharge]        INT             NULL,
    [commissionself]    DECIMAL (18, 3) NULL,
    [commissionupliner] DECIMAL (18, 3) NULL,
    [commission6level]  DECIMAL (18, 3) NULL,
    [lastupdatedate]    DATETIME        NULL,
    [IP]                VARCHAR (50)    NULL,
    CONSTRAINT [PK_M_package_commission _slab] PRIMARY KEY CLUSTERED ([steps_id] ASC)
);

