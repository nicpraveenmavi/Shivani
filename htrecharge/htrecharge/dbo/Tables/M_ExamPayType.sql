CREATE TABLE [dbo].[M_ExamPayType] (
    [ExamPay_TypeId]   INT          IDENTITY (1, 1) NOT NULL,
    [ExamPay_TypeName] VARCHAR (50) NULL,
    [User_Id]          INT          NULL,
    [EntryDate]        DATETIME     NULL,
    [UpdateDate]       DATETIME     NULL,
    CONSTRAINT [PK_M_ExamPayType] PRIMARY KEY CLUSTERED ([ExamPay_TypeId] ASC)
);

