CREATE TABLE [dbo].[M_ExamLanguage] (
    [ExamLang_Id]   INT          IDENTITY (1, 1) NOT NULL,
    [ExamLang_Name] VARCHAR (50) NULL,
    [User_Id]       INT          NULL,
    [EntryDate]     DATETIME     NULL,
    [UpdateDate]    DATETIME     NULL,
    CONSTRAINT [PK_M_ExamLanguage] PRIMARY KEY CLUSTERED ([ExamLang_Id] ASC)
);

