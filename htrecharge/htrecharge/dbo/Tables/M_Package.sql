CREATE TABLE [dbo].[M_Package] (
    [Package_ID]                   INT             IDENTITY (1, 1) NOT NULL,
    [Package_Name]                 VARCHAR (255)   NULL,
    [Package_Price]                NUMERIC (18, 2) NULL,
    [Status]                       VARCHAR (1)     NULL,
    [Created_By]                   INT             NULL,
    [Created_DateTime]             DATETIME        NULL,
    [Updated_By]                   INT             NULL,
    [Updated_DateTime]             DATETIME        NULL,
    [Package_For]                  VARCHAR (30)    NULL,
    [Validfor]                     INT             NULL,
    [package_desc]                 VARCHAR (2000)  NULL,
    [uplinecommper]                DECIMAL (18, 2) NULL,
    [nextuplinelevelcommper]       DECIMAL (18, 2) NULL,
    [uplinelevelupto]              INT             NULL,
    [pkg_price_wo_gst]             DECIMAL (18, 2) NULL,
    [uplinecommper_inact]          DECIMAL (18, 2) NULL,
    [nextuplinelevelcommper_inact] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_M_Package] PRIMARY KEY CLUSTERED ([Package_ID] ASC)
);

