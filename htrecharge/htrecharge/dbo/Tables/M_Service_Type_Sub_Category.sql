CREATE TABLE [dbo].[M_Service_Type_Sub_Category] (
    [Service_Sub_Category_Id] INT           IDENTITY (1, 1) NOT NULL,
    [Service_Category_Id]     INT           NOT NULL,
    [Sub_Category_Name]       VARCHAR (150) NOT NULL,
    [Created_DateTime]        DATETIME      NULL,
    [Status]                  VARCHAR (1)   NULL,
    [Updated_By]              INT           NULL,
    [Updated_DateTime]        DATETIME      NULL,
    [default_apisourceid]     INT           NULL,
    [icon]                    VARCHAR (255) NULL,
    [Field1]                  VARCHAR (50)  NULL,
    [Field2]                  VARCHAR (50)  NULL,
    [Field3]                  VARCHAR (50)  NULL,
    [Field4]                  VARCHAR (50)  NULL,
    [Field5]                  VARCHAR (50)  NULL,
    CONSTRAINT [PK_M_Service_Type_Sub_Category] PRIMARY KEY CLUSTERED ([Service_Sub_Category_Id] ASC)
);

