CREATE TABLE [dbo].[T_Package] (
    [Pp_id]            INT          IDENTITY (1, 1) NOT NULL,
    [Pp_Package_Id]    INT          NULL,
    [Mem_Id]           INT          NULL,
    [Purchage_date]    DATETIME     NULL,
    [Expiry_Date]      DATETIME     NULL,
    [IP]               VARCHAR (50) NULL,
    [Created_By]       INT          NULL,
    [Created_DateTime] DATETIME     NULL,
    [Updated_By]       INT          NULL,
    [Updated_DateTime] DATETIME     NULL,
    CONSTRAINT [PK_T_Package] PRIMARY KEY CLUSTERED ([Pp_id] ASC)
);

