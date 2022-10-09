-- =============================================
-- Author: Saurabh Verma
-- Create date: 08-Dec-2021
-- Description:	
-- =============================================
CREATE PROCEDURE [dbo].[SPI_TransferCoinToPayout]
	@memberid bigint,
	@guid varchar(200),
	@ip varchar(20)
AS
BEGIN
	SET NOCOUNT ON;
	Declare @CoinConvertRate decimal(18,2), @TotalCoins decimal(18,2), @CoinValue decimal(18,2), 
				@OpeningBalCoin decimal(18,2), @ClosingBalCoin decimal(18,2), 
				@OpeningBalPO decimal(18,2), @ClosingBalPO decimal(18,2),
				@LastId bigint = 0
	Select @CoinConvertRate = IsNull(CoinConversionRate,0) From M_SystemSetting   

	Declare @CoinTableId bigint
	Select * Into #TempCoins From T_CoinWallet Where cwt_memid = @memberid And IsNull(IsRedeemed, 0) = 0 And IsNull(cwt_Credit, 0) > 0

	Select @CoinTableId = Min(cwt_id) From #TempCoins 
	While @CoinTableId Is Not Null
	Begin
		Set @OpeningBalCoin = 0
		Set @OpeningBalPO = 0
		Set @ClosingBalCoin = 0
		Set @ClosingBalPO = 0
		Set @TotalCoins = 0
		Set @CoinValue = 0

		Select @OpeningBalCoin = Coin_Wallet, @OpeningBalPO = Payout_Wallet From T_Member where Mem_ID = @memberid
		Set @OpeningBalCoin = IsNull(@OpeningBalCoin, 0)
		Set @OpeningBalPO = IsNull(@OpeningBalPO, 0)

		Select @TotalCoins = Sum(cwt_Credit) From T_CoinWallet Where cwt_id = @CoinTableId
		Set @CoinValue = @TotalCoins / @CoinConvertRate

		Set @ClosingBalPO = @OpeningBalPO + @CoinValue
		Insert Into T_PayoutWallet (
			pwt_memid, pwt_servicerefid, pwt_openingBalance, pwt_Credit, pwt_Debit, pwt_ClosingBalance, pwt_datetime, pwt_IP, pwt_comment, 
			GuidCode, IncomeByMemId, IncomeByLevelNo
		)
		Select 
			cwt_memid as pwt_memid, cwt_id as pwt_servicerefid, @OpeningBalPO as pwt_openingBalance, @CoinValue as pwt_Credit, 0 as pwt_Debit, 
			@ClosingBalPO as pwt_ClosingBalance, getdate() as pwt_datetime, @ip as pwt_IP, Convert(Varchar(10), @TotalCoins)+' coins transferred' pwt_comment, 
			@guid as GuidCode, IncomeByMemId, IncomeByLevelNo
		From T_CoinWallet Where cwt_id = @CoinTableId


		
		Set @ClosingBalCoin = @OpeningBalCoin - @TotalCoins
		Insert Into T_CoinWallet (
			cwt_memid, cwt_servicerefid, cwt_openingBalance, cwt_Credit, cwt_Debit, cwt_ClosingBalance, cwt_datetime, cwt_IP, cwt_comment, 
			Ref_No, BankID, GuidCode, IncomeByMemId, IncomeByLevelNo, IsRedeemed
		)
		Select 
			cwt_memid, cwt_servicerefid, @OpeningBalCoin as cwt_openingBalance, 0 as cwt_Credit, @TotalCoins as cwt_Debit, @ClosingBalCoin as cwt_ClosingBalance, 
			getdate() as cwt_datetime, @ip as cwt_IP, cwt_comment+' Redeem' as cwt_comment, @CoinTableId as Ref_No, BankID, @guid as GuidCode, IncomeByMemId, IncomeByLevelNo, 1 as IsRedeemed
		From T_CoinWallet Where cwt_id = @CoinTableId
		Set @LastId = (Select SCOPE_IDENTITY());

		Update T_CoinWallet Set IsRedeemed = 1 Where cwt_id = @CoinTableId
		
		Select @CoinTableId = Min(cwt_id) From #TempCoins Where cwt_id > @CoinTableId
	End

	Select @LastId

	Drop Table #TempCoins
END
