-- =============================================
-- Author:		<Author,,Name>
-- Create date: <Create Date,,>
-- Description:	<Description,,>
-- =============================================
CREATE PROCEDURE [dbo].[SPG_RDBankCodes]
	@bankcode varchar(10)
AS
BEGIN
	SET NOCOUNT ON;
	Select bankid, bankcode, bankname, ifsc From M_RDBankCode Where bankcode = Case When IsNull(@bankcode, '') = '' Then bankcode Else @bankcode End
END
