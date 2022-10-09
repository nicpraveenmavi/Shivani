CREATE TABLE [dbo].[M_package_commission] (
    [pkgcom_id]                   INT          IDENTITY (1, 1) NOT NULL,
    [Packageid]                   INT          NULL,
    [pkgcom_servicesubcategoryid] INT          NULL,
    [pkgcom_commtype]             INT          NULL,
    [pkgcom_commcharge]           INT          NULL,
    [pkgcom_commvalueforself]     VARCHAR (50) NULL,
    [pkgcom_commvalueforupliner]  VARCHAR (50) NULL,
    [pkgcom_commvaluefor6level]   NCHAR (10)   NULL,
    [pkgcom_lastupdatedon]        DATETIME     NULL,
    [pkgcom_updatedby]            DATETIME     NULL,
    [pkgcom_ip]                   VARCHAR (50) NULL,
    CONSTRAINT [PK_M_package_commission] PRIMARY KEY CLUSTERED ([pkgcom_id] ASC)
);

