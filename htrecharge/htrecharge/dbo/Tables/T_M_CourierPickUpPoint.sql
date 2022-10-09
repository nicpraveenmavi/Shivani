CREATE TABLE [dbo].[T_M_CourierPickUpPoint] (
    [PickupPointId] BIGINT        IDENTITY (1, 1) NOT NULL,
    [ContactPerson] VARCHAR (100) NULL,
    [ContactNo]     VARCHAR (20)  NULL,
    [FullAddress]   VARCHAR (MAX) NULL,
    [PinCode]       VARCHAR (10)  NULL,
    [Gstin]         VARCHAR (20)  NULL,
    [MemId]         BIGINT        NULL,
    [EntryDate]     DATETIME      NULL,
    [UpdateDate]    DATETIME      NULL,
    CONSTRAINT [PK_T_M_CourierPickUpPoint] PRIMARY KEY CLUSTERED ([PickupPointId] ASC)
);

