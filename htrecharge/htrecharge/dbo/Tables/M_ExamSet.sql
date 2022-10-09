CREATE TABLE [dbo].[M_ExamSet] (
    [ExamSet_Id]              INT            IDENTITY (1, 1) NOT NULL,
    [Service_Sub_Category_Id] INT            NULL,
    [ExamSet_Name]            NVARCHAR (MAX) NULL,
    [ExamLang_Id]             INT            NULL,
    [ExamPay_TypeId]          INT            NULL,
    [Noof_Question]           INT            NULL,
    [Time_Duration_Minute]    INT            NULL,
    [User_Id]                 INT            NULL,
    [EntryDate]               DATETIME       NULL,
    [UpdateDate]              DATETIME       NULL,
    CONSTRAINT [PK_M_ExamSet] PRIMARY KEY CLUSTERED ([ExamSet_Id] ASC),
    CONSTRAINT [FK_M_ExamSet_M_ExamLanguage] FOREIGN KEY ([ExamLang_Id]) REFERENCES [dbo].[M_ExamLanguage] ([ExamLang_Id]),
    CONSTRAINT [FK_M_ExamSet_M_ExamPayType] FOREIGN KEY ([ExamPay_TypeId]) REFERENCES [dbo].[M_ExamPayType] ([ExamPay_TypeId]),
    CONSTRAINT [FK_M_ExamSet_M_Service_Type_Sub_Category] FOREIGN KEY ([Service_Sub_Category_Id]) REFERENCES [dbo].[M_Service_Type_Sub_Category] ([Service_Sub_Category_Id])
);

