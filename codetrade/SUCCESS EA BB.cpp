// Bollinger Bands Expert Advisor

extern int Period_BB = 20;
extern double Deviation_BB = 2.0;
extern double LotSize = 0.1;
extern int StopLoss = 100;
extern int TakeProfit = 200;

void OnTick()
{
    if (IsNewCandle())
    {
        double upperBand = iBands(Symbol(), 0, Period_BB, Deviation_BB, 0, PRICE_CLOSE, MODE_UPPER, 0);
        double lowerBand = iBands(Symbol(), 0, Period_BB, Deviation_BB, 0, PRICE_CLOSE, MODE_LOWER, 0);
        double closePrice = Close[0];

        // Buy order
        if (closePrice > upperBand && !OpenOrderAvailable(OP_BUY))
        {
            double takeProfitPriceBuy = Ask + TakeProfit * Point;
            double stopLossPriceBuy = closePrice - StopLoss * Point;
            ExecuteOrder(OP_BUY, Ask, stopLossPriceBuy, takeProfitPriceBuy);
        }

        // Sell order
        if (closePrice < lowerBand && !OpenOrderAvailable(OP_SELL))
        {
            double takeProfitPriceSell = Bid - TakeProfit * Point;
            double stopLossPriceSell = closePrice + StopLoss * Point;
            ExecuteOrder(OP_SELL, Bid, stopLossPriceSell, takeProfitPriceSell);
        }
    }
}

void ExecuteOrder(int orderType, double entryPrice, double stopLossPrice, double takeProfitPrice)
{
    double lotSize = LotSize;
    int slippage = 3;
    int magicNumber = (orderType == OP_BUY) ? 1234 : 5678;

    int ticket = OrderSend(Symbol(), orderType, lotSize, entryPrice, slippage, stopLossPrice, takeProfitPrice, "", magicNumber);
    if (ticket <= 0)
    {
        Print("OrderSend error: ", GetLastError());
    }
}

bool IsNewCandle()
{
    static datetime lastTime = 0;
    datetime currentTime = Time[0];

    if (lastTime != currentTime)
    {
        lastTime = currentTime;
        return true;
    }

    return false;
}

bool OpenOrderAvailable(int orderType)
{
    for (int i = 0; i < OrdersTotal(); i++)
    {
        if (OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
        {
            if (OrderSymbol() == Symbol() && OrderMagicNumber() == (orderType == OP_BUY ? 1234 : 5678) && OrderType() == orderType)
            {
                return true; // An open buy or sell order already exists
            }
        }
    }
    return false; // No open buy or sell orders found
}
