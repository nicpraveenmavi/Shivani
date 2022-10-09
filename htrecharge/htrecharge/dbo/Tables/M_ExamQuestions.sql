CREATE TABLE [dbo].[M_ExamQuestions] (
    [Question_Id]            BIGINT         IDENTITY (1, 1) NOT NULL,
    [ExamSet_Id]             INT            NULL,
    [Question_Text]          NVARCHAR (MAX) NULL,
    [Question_Image_VirPath] VARCHAR (MAX)  NULL,
    [Option_1]               NVARCHAR (MAX) NULL,
    [Option_2]               NVARCHAR (MAX) NULL,
    [Option_3]               NVARCHAR (MAX) NULL,
    [Option_4]               NVARCHAR (MAX) NULL,
    [Option_1_Image_VirPath] VARCHAR (MAX)  NULL,
    [Option_2_Image_VirPath] VARCHAR (MAX)  NULL,
    [Option_3_Image_VirPath] VARCHAR (MAX)  NULL,
    [Option_4_Image_VirPath] VARCHAR (MAX)  NULL,
    [HasMultipleRightAns]    BIT            NULL,
    [Is_Option_1_Right]      BIT            NULL,
    [Is_Option_2_Right]      BIT            NULL,
    [Is_Option_3_Right]      BIT            NULL,
    [Is_Option_4_Right]      BIT            NULL,
    [User_Id]                INT            NULL,
    [EntryDate]              DATETIME       NULL,
    [UpdateDate]             DATETIME       NULL,
    CONSTRAINT [PK_M_ExamQuestions] PRIMARY KEY CLUSTERED ([Question_Id] ASC),
    CONSTRAINT [FK_M_ExamQuestions_M_ExamSet] FOREIGN KEY ([ExamSet_Id]) REFERENCES [dbo].[M_ExamSet] ([ExamSet_Id])
);


GO
-- =============================================
-- Author: Saurabh
-- Create date: 22-Feb-2022
-- Description:	This trigger is used to Update Question table Id in Image Path
-- =============================================
CREATE TRIGGER [dbo].[trgi_Question]
   ON  [dbo].[M_ExamQuestions] 
   AFTER INSERT,UPDATE
AS 
BEGIN
	SET NOCOUNT ON;
	declare @Question_Id bigint
    
	select @Question_Id = Question_Id from inserted;

	update M_ExamQuestions set 
		Question_Image_VirPath = replace(isnull(Question_Image_VirPath, ''), 'QUESID', convert(varchar(10), @Question_Id)),
		Option_1_Image_VirPath = replace(isnull(Option_1_Image_VirPath, ''), 'QUESID', convert(varchar(10), @Question_Id)),
		Option_2_Image_VirPath = replace(isnull(Option_2_Image_VirPath, ''), 'QUESID', convert(varchar(10), @Question_Id)),
		Option_3_Image_VirPath = replace(isnull(Option_3_Image_VirPath, ''), 'QUESID', convert(varchar(10), @Question_Id)),
		Option_4_Image_VirPath = replace(isnull(Option_4_Image_VirPath, ''), 'QUESID', convert(varchar(10), @Question_Id))
	where Question_Id = @Question_Id
END
