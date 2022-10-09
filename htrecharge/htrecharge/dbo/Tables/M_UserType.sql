CREATE TABLE [dbo].[M_UserType] (
    [User_Type_Id] BIGINT        IDENTITY (1, 1) NOT NULL,
    [User_Type]    VARCHAR (150) NULL,
    CONSTRAINT [PK_UserType] PRIMARY KEY CLUSTERED ([User_Type_Id] ASC)
);

