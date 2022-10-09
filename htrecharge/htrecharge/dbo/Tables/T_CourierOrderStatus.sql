CREATE TABLE [dbo].[T_CourierOrderStatus] (
    [AutoId]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [Order_Id]              BIGINT        NOT NULL,
    [Our_Order_Id]          VARCHAR (20)  NULL,
    [Api_Tracking_Id]       VARCHAR (20)  NULL,
    [CurrentStatusType]     VARCHAR (10)  NULL,
    [CurrentStatusText]     VARCHAR (50)  NULL,
    [CurrentStatusDesc]     VARCHAR (500) NULL,
    [CurrentStatusLocation] VARCHAR (300) NULL,
    [CurrentStatusTime]     VARCHAR (50)  NULL,
    [ReceivedBy]            VARCHAR (150) NULL,
    [EntryTime]             DATETIME      NULL,
    CONSTRAINT [PK_T_CourierOrderStatus] PRIMARY KEY CLUSTERED ([AutoId] ASC),
    CONSTRAINT [FK_T_CourierOrderStatus_T_CourierOrder] FOREIGN KEY ([Order_Id]) REFERENCES [dbo].[T_CourierOrder] ([Order_Id])
);

