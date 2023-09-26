//+------------------------------------------------------------------+
//|                EMA_Colors_with_BB_Indicator.mq4                 |
//|                       Copyright 2023, MUHAZA                    |
//|                    http://www.muhazastudio.com                  |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MUHAZA"
#property link      "http://www.muhazastudio.com"
#property version   "1.00" 
#property indicator_chart_window
#property indicator_buffers 16
#property indicator_color1 Red         // EMA 50 Red
#property indicator_color2 Lime        // EMA 60 Lime
#property indicator_color3 SpringGreen // EMA 70 SpringGreen
#property indicator_color4 clrNONE     // Upper Bollinger Band (Deviation 1)
#property indicator_color5 clrNONE     // Lower Bollinger Band (Deviation 1)
#property indicator_color6 clrNONE     // Upper Bollinger Band (Deviation 2)
#property indicator_color7 clrNONE     // Lower Bollinger Band (Deviation 2)
#property indicator_color8 clrNONE     // Upper Bollinger Band (Deviation 3)
#property indicator_color9 clrNONE     // Lower Bollinger Band (Deviation 3)
#property indicator_color10 Purple
#property indicator_color11 Green       
#property indicator_color12 Red 
#property indicator_color13 Green       
#property indicator_color14 Red   
   
#property indicator_style4 STYLE_DOT
#property indicator_style5 STYLE_DOT
#property indicator_style6 STYLE_DOT
#property indicator_style7 STYLE_DOT
#property indicator_style8 STYLE_DOT
#property indicator_style9 STYLE_DOT
#property indicator_style10 STYLE_DOT
#property indicator_style11 STYLE_DOT
#property indicator_style12 STYLE_DOT
#property indicator_style13 STYLE_DOT
#property indicator_style14 STYLE_DOT
#property indicator_style15 STYLE_DOT
#property indicator_style16 STYLE_DOT

#property indicator_width1 2
#property indicator_width2 2
#property indicator_width3 2
#property indicator_width4 1
#property indicator_width5 1
#property indicator_width6 1
#property indicator_width7 1
#property indicator_width8 1
#property indicator_width9 1
#property indicator_width10 3
#property indicator_width11 1
#property indicator_width12 1
#property indicator_width13 1
#property indicator_width14 1
#property indicator_width15 1
#property indicator_width16 1

extern int EMA_Period_50 = 50;
extern int EMA_Period_60 = 60;
extern int EMA_Period_70 = 70;
extern int EMA_Period_250 = 250;

extern int BB_Period = 15;
extern int BB_Period2 = 50; // New Bollinger Band Period

extern int BB_Shift1 = 1; // Shift for the first Bollinger Band
extern int BB_Shift2 = 0; // Shift for the second Bollinger Band

extern double BB_Deviation1_BB20 = 2.0;
extern double BB_Deviation2_BB20 = 2.3;
extern double BB_Deviation3_BB20 = 2.6;
extern double BB_Deviation4_BB50 = 0.9;
extern double BB_Deviation5_BB50 = 2.0;

extern int EMA_Shift_50 = 1; // Shift for EMA 50
extern int EMA_Shift_60 = 1; // Shift for EMA 60
extern int EMA_Shift_70 = 1; // Shift for EMA 70
extern int EMA_Shift_250 = 1; // Shift for EMA 250

extern bool EnableAlerts = true; // User control for alerts

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
double ExtMapBuffer9[];
double ExtMapBuffer10[]; // EMA 250
double ExtMapBuffer11[]; // New Bollinger Upper Band
double ExtMapBuffer12[]; // New Bollinger Lower Band
double ExtMapBuffer13[]; // New Bollinger Upper Band
double ExtMapBuffer14[]; // New Bollinger Lower Band
double ExtMapBuffer15[]; // New Bollinger Upper Band
double ExtMapBuffer16[]; // New Bollinger Lower Band

datetime lastAlertTime = 0;

void DeleteObjects()
{
   for (int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string objName = ObjectName(i);
      if (StringFind(objName, "BullishArrow") != -1 || StringFind(objName, "BearishArrow") != -1)
      {
         ObjectDelete(objName);
      }
   }
}

string GetTimeframeString(int timeframe)
{
   string timeframeString = "";
   switch (timeframe)
   {
      case PERIOD_M1:      timeframeString = "M1"; break;
      case PERIOD_M5:      timeframeString = "M5"; break;
      case PERIOD_M15:     timeframeString = "M15"; break;
      case PERIOD_M30:     timeframeString = "M30"; break;
      case PERIOD_H1:      timeframeString = "H1"; break;
      case PERIOD_H4:      timeframeString = "H4"; break;
      case PERIOD_D1:      timeframeString = "D1"; break;
      case PERIOD_W1:      timeframeString = "W1"; break;
      case PERIOD_MN1:     timeframeString = "MN1"; break;
      default:             timeframeString = "Unknown"; break;
   }
   return timeframeString;
}

int OnInit()
{
   SetIndexBuffer(0, ExtMapBuffer1, INDICATOR_DATA);
   SetIndexBuffer(1, ExtMapBuffer2, INDICATOR_DATA);
   SetIndexBuffer(2, ExtMapBuffer3, INDICATOR_DATA);
   SetIndexBuffer(3, ExtMapBuffer4, INDICATOR_DATA);
   SetIndexBuffer(4, ExtMapBuffer5, INDICATOR_DATA);
   SetIndexBuffer(5, ExtMapBuffer6, INDICATOR_DATA);
   SetIndexBuffer(6, ExtMapBuffer7, INDICATOR_DATA);
   SetIndexBuffer(7, ExtMapBuffer8, INDICATOR_DATA);
   SetIndexBuffer(8, ExtMapBuffer9, INDICATOR_DATA);
   SetIndexBuffer(9, ExtMapBuffer10, INDICATOR_DATA); // EMA 250
   SetIndexBuffer(10, ExtMapBuffer11, INDICATOR_DATA); // New Bollinger Upper Band
   SetIndexBuffer(11, ExtMapBuffer12, INDICATOR_DATA); // New Bollinger Lower Band
   SetIndexBuffer(12, ExtMapBuffer13, INDICATOR_DATA); // New Bollinger Upper Band
   SetIndexBuffer(13, ExtMapBuffer14, INDICATOR_DATA); // New Bollinger Lower Band
   SetIndexBuffer(14, ExtMapBuffer15, INDICATOR_DATA); // New Bollinger Upper Band
   SetIndexBuffer(15, ExtMapBuffer16, INDICATOR_DATA); // New Bollinger Lower Band

   IndicatorShortName("EMA Colors with Bollinger Bands");
   //---
   return (INIT_SUCCEEDED);
}

void OnDeinit(const int reason)
{
   DeleteObjects();
}

int OnCalculate(const int rates_total,
                const int prev_calculated,
                const datetime &time[],
                const double &open[],
                const double &high[],
                const double &low[],
                const double &close[],
                const long &tick_volume[],
                const long &volume[],
                const int &spread[])
{
   string symbol = Symbol();
   string timeframe = GetTimeframeString(Period());

   // Calculation of the new Bollinger Bands with period 250
   for (int i = 1; i < rates_total; i++)
   {
      ExtMapBuffer1[i] = iMA(symbol, 0, EMA_Period_50, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_50);
      ExtMapBuffer2[i] = iMA(symbol, 0, EMA_Period_60, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_60);
      ExtMapBuffer3[i] = iMA(symbol, 0, EMA_Period_70, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_70);
      ExtMapBuffer10[i] = iMA(symbol, 0, EMA_Period_250, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_250);

      double bbMiddle = iMA(symbol, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i);
      double bbDeviation1 = iStdDev(symbol, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation1_BB20;
      double bbDeviation2 = iStdDev(symbol, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation2_BB20;
      double bbDeviation3 = iStdDev(symbol, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation3_BB20;

      ExtMapBuffer4[i] = bbMiddle + bbDeviation1;
      ExtMapBuffer5[i] = bbMiddle - bbDeviation1;
      ExtMapBuffer6[i] = bbMiddle + bbDeviation2;
      ExtMapBuffer7[i] = bbMiddle - bbDeviation2;
      ExtMapBuffer8[i] = bbMiddle + bbDeviation3;
      ExtMapBuffer9[i] = bbMiddle - bbDeviation3;

      // Calculation of the new Bollinger Bands with period 50 and shift BB_Shift2
      double bbMiddle2 = iMA(symbol, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i);
      double bbDeviation4 = iStdDev(symbol, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation4_BB50;
      double bbDeviation5 = iStdDev(symbol, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation5_BB50;

      ExtMapBuffer11[i] = bbMiddle2 + bbDeviation4; // New upper Bollinger Band
      ExtMapBuffer12[i] = bbMiddle2 - bbDeviation4; // New lower Bollinger Band
      ExtMapBuffer13[i] = bbMiddle2 + bbDeviation5; // New upper Bollinger Band
      ExtMapBuffer14[i] = bbMiddle2 - bbDeviation5; // New lower Bollinger Band

      // Check for crossover below the bottom Bollinger Band and plot red arrow down
      if (close[i] < ExtMapBuffer9[i] && close[i - 1] >= ExtMapBuffer9[i - 1])
      {
         ObjectSet("BearishArrow" + IntegerToString(i), OBJPROP_COLOR, Red);

         // Add text to the right side of the arrow
         ObjectCreate("BearishText" + IntegerToString(i), OBJ_TEXT, 0, Time[i + 1], High[i] + 10 * Point);
         ObjectSet("BearishText" + IntegerToString(i), OBJPROP_ALIGN, TA_RIGHT);
         ObjectSetText("BearishText" + IntegerToString(i), "------RideBear------", 10, "Arial Black", Red);

         // Alert for "BEAR RIDE" if the feature is enabled and within 24 hours
         if (EnableAlerts && (TimeCurrent() - lastAlertTime >= 24 * 60 * 60))
         {
            string bearishAlertMessage = "BEAR RIDE(SELL!): " + symbol + " " + timeframe + " - Candle crossed below the bottom Bollinger Band ";
            Alert(bearishAlertMessage);
            lastAlertTime = TimeCurrent();
         }
      }
      else
      {
         ObjectDelete("BearishArrow" + IntegerToString(i));
         ObjectDelete("BearishText" + IntegerToString(i));
      }

      // Check for crossover above the top Bollinger Band and plot green arrow up
      if (close[i] > ExtMapBuffer8[i] && close[i - 1] <= ExtMapBuffer8[i - 1])
      {
         ObjectSet("BullishArrow" + IntegerToString(i), OBJPROP_COLOR, Lime);

         // Add text to the right side of the arrow
         ObjectCreate("BullishText" + IntegerToString(i), OBJ_TEXT, 0, Time[i + 1], Low[i] - 10 * Point);
         ObjectSet("BullishText" + IntegerToString(i), OBJPROP_ALIGN, TA_RIGHT);
         ObjectSetText("BullishText" + IntegerToString(i), "------RideBull------", 10, "Arial Black", Green);

         // Alert for "BULL RIDE" if the feature is enabled and within 24 hours
         if (EnableAlerts && (TimeCurrent() - lastAlertTime >= 24 * 60 * 60))
         {
            string bullishAlertMessage = "BULL RIDE(BUY!): " + symbol + " " + timeframe + " - Candle crossed above the top Bollinger Band";
            Alert(bullishAlertMessage);
            lastAlertTime = TimeCurrent();
         }
      }
      else
      {
         ObjectDelete("BullishArrow" + IntegerToString(i));
         ObjectDelete("BullishText" + IntegerToString(i));
      }
   }

   return (rates_total);
}
