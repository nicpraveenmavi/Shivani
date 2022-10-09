CREATE TABLE [dbo].[M_Banner] (
    [App_Banner_Id]             INT           IDENTITY (1, 1) NOT NULL,
    [App_Banner_Position]       VARCHAR (100) NULL,
    [App_Banner_Image]          VARCHAR (255) NULL,
    [App_Banner_Createdon]      DATETIME      NULL,
    [App_Banner_LastModifiedon] DATETIME      NULL,
    [App_Banner_By]             INT           NULL,
    [App_Banner_IP]             VARCHAR (100) NULL,
    CONSTRAINT [PK_M_Banner] PRIMARY KEY CLUSTERED ([App_Banner_Id] ASC)
);

