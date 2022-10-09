CREATE TABLE [dbo].[M_PaytmSetting] (
    [Id]            INT NOT NULL,
    [neft_charge]   INT NULL,
    [imps_charge]   INT NULL,
    [wallet_charge] INT NULL,
    CONSTRAINT [PK_M_PaytmSetting] PRIMARY KEY CLUSTERED ([Id] ASC)
);

