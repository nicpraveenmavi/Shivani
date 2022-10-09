CREATE TABLE [dbo].[M_SystemSetting] (
    [Id]                    INT             IDENTITY (1, 1) NOT NULL,
    [systemname]            VARCHAR (100)   NULL,
    [systemstatus]          VARCHAR (100)   CONSTRAINT [DF_M_SystemSetting_systemstatus] DEFAULT ('Running') NULL,
    [systemalertemail]      VARCHAR (50)    NULL,
    [App_Version]           DECIMAL (10, 1) NULL,
    [Maintenance_Message]   VARCHAR (2000)  NULL,
    [adminfee]              INT             NULL,
    [tdsfee]                INT             NULL,
    [CoinConversionRate]    INT             NULL,
    [CourierSerCharge]      DECIMAL (18, 2) NULL,
    [TaxPerOnCourierCharge] DECIMAL (18, 2) NULL,
    CONSTRAINT [PK_M_SystemSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

