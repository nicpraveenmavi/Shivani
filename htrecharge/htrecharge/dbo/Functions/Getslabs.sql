CREATE FUNCTION [dbo].[Getslabs](@type nvarchar(max),@Commision nvarchar(max))
RETURNS INT
AS
BEGIN
    if(@type='%' and @Commision='Credit')
    BEGIN
        RETURN 2;
    END
  ELSE if(@type='%' and @Commision='Debit')
    BEGIN
        RETURN 3;
    END
	 ELSE if(@type='Rs.' and @Commision='Debit')
    BEGIN
        RETURN 4;
    END
	 ELSE if(@type='Rs.' and @Commision='Credit')
    BEGIN
        RETURN 5;
    END
        RETURN 1;
    
END
