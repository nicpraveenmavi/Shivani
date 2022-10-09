CREATE TABLE [dbo].[M_CourierStatus] (
    [AutoId]     INT          IDENTITY (1, 1) NOT NULL,
    [StatusCode] VARCHAR (10) NULL,
    [StatusText] VARCHAR (50) NULL,
    CONSTRAINT [PK_M_CourierStatus] PRIMARY KEY CLUSTERED ([AutoId] ASC)
);

