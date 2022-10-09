CREATE TABLE [dbo].[M_Service_Type_Category] (
    [Service_Category_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Service_Type_Id]     INT           NOT NULL,
    [Category_Name]       VARCHAR (150) NOT NULL,
    [Icon]                VARCHAR (255) NULL,
    [Created_DateTime]    DATETIME      NULL,
    [Status]              VARCHAR (1)   NULL,
    [Updated_By]          INT           NULL,
    [Updated_DateTime]    DATETIME      NULL,
    [Weblink]             VARCHAR (200) NULL,
    CONSTRAINT [PK_M_Service_Type_Category] PRIMARY KEY CLUSTERED ([Service_Category_Id] ASC)
);

