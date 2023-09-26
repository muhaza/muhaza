//+------------------------------------------------------------------+
//|                      Bollinger Bands EA                         |
//|                       Copyright 2023, MUHAZA                    |
//|                    http://www.muhazastudio.com                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MUHAZA"
#property link      "http://www.muhazastudio.com"
#property version   "1.00" 
#property strict

extern int BB_Period = 15;
extern int BB_Shift = 1;
extern double BB_Deviation = 2.0;

extern int StopLoss = 250;
extern int TakeProfit = 500;
extern int TrailingStop = 50;

extern int MagicNumber = 12345;

// Input properties
extern double LotSize = 0.01;
extern int MaxOpenOrders = 3;
extern bool EnableAlerts = true; // Allow user to enable/disable alerts

void OnTick()
{
   int total = OrdersTotal();
   int openOrders = 0;

   for (int i = total - 1; i >= 0; i--)
   {
      if (!OrderSelect(i, SELECT_BY_POS, MODE_TRADES))
      {
         Print("Error selecting order ", i);
         continue;
      }

      if (OrderMagicNumber() == MagicNumber)
      {
         openOrders++;
         if (openOrders >= MaxOpenOrders)
         {
            return; // Maximum open orders reached, exit the OnTick function
         }
      }
   }

   int ticket = OrderSend(Symbol(), OP_BUY, LotSize, Ask, 3, 0, 0, "Bollinger Buy", MagicNumber);
   if (ticket > 0)
   {
      // Buy order opened successfully. Ticket: ", ticket);

      // Send an email notification if email settings are properly configured and alerts are enabled
      if (EnableAlerts)
      {
         string alertMsg = "Buy order opened successfully. Ticket: " + IntegerToString(ticket);
         SendMail("Bollinger EA Alert", alertMsg);
      }

      double stopLossLevel = Ask - StopLoss * Point;
      double takeProfitLevel = Ask + TakeProfit * Point;
      int slippage = 3;
      
      ticket = OrderSend(Symbol(), OP_SELL, LotSize, Bid, slippage, stopLossLevel, takeProfitLevel, "Bollinger Sell", MagicNumber);
      if (ticket > 0)
      {
         // Sell order opened successfully. Ticket: ", ticket);

         // Send an email notification if email settings are properly configured and alerts are enabled
         if (EnableAlerts)
         {
            string alertMsg = "Sell order opened successfully. Ticket: " + IntegerToString(ticket);
            SendMail("Bollinger EA Alert", alertMsg);
         }
      }
      else
      {
         Print("Error opening sell order. Error code: ", GetLastError());
      }
   }
   else
   {
      Print("Error opening buy order. Error code: ", GetLastError());
   }
}
