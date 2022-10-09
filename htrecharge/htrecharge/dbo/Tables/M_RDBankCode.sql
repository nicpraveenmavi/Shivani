CREATE TABLE [dbo].[M_RDBankCode] (
    [autoid]       BIGINT        IDENTITY (1, 1) NOT NULL,
    [bankid]       BIGINT        NULL,
    [bankcode]     VARCHAR (10)  NULL,
    [bankname]     VARCHAR (300) NULL,
    [ifsc]         VARCHAR (20)  NULL,
    [isimps]       INT           NULL,
    [isneft]       INT           NULL,
    [isacverify]   INT           NULL,
    [displayorder] INT           NULL,
    [astatus]      INT           NULL,
    CONSTRAINT [PK_M_RDBankCode] PRIMARY KEY CLUSTERED ([autoid] ASC)
);

