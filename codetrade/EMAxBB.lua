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
#property indicator_color1 Chartreuse         // EMA 50 Green
#property indicator_color2 Lime              // EMA 60 Blue
#property indicator_color3 SpringGreen                // EMA 70 Red
#property indicator_color4 clrNONE            // Upper Bollinger Band (Deviation 1)
#property indicator_color5 clrNONE            // Lower Bollinger Band (Deviation 1)
#property indicator_color6 clrNONE            // Upper Bollinger Band (Deviation 2)
#property indicator_color7 clrNONE            // Lower Bollinger Band (Deviation 2)
#property indicator_color8 clrNONE            // Upper Bollinger Band (Deviation 3)
#property indicator_color9 clrNONE            // Lower Bollinger Band (Deviation 3)
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
extern int EMA_Period_250 = 220;

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
extern int EMA_Shift_250 = 1; // Shift for EMA 2500

double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
double ExtMapBuffer5[];
double ExtMapBuffer6[];
double ExtMapBuffer7[];
double ExtMapBuffer8[];
double ExtMapBuffer9[];
double ExtMapBuffer10[];
double ExtMapBuffer11[]; // New Bollinger Upper Band
double ExtMapBuffer12[]; // New Bollinger Lower Band
double ExtMapBuffer13[]; // New Bollinger Upper Band
double ExtMapBuffer14[]; // New Bollinger Lower Band
double ExtMapBuffer15[]; // New Bollinger Upper Band
double ExtMapBuffer16[]; // New Bollinger Lower Band

void DeleteObjects()
{
   for (int i = ObjectsTotal() - 1; i >= 0; i--)
   {
      string objName = ObjectName(i);
      if (StringFind(objName, "BullishArrow") != -1 || StringFind(objName, "BearishArrow") != -1 ||
          StringFind(objName, "BullishText") != -1 || StringFind(objName, "BearishText") != -1)
      {
         ObjectDelete(objName);
      }
   }
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
   SetIndexBuffer(9, ExtMapBuffer10, INDICATOR_DATA);
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

   // Calculation of the new Bollinger Bands with period 225
   for (int i = 1; i < rates_total; i++)
   {
      ExtMapBuffer1[i] = iMA(NULL, 0, EMA_Period_50, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_50);
      ExtMapBuffer2[i] = iMA(NULL, 0, EMA_Period_60, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_60);
      ExtMapBuffer3[i] = iMA(NULL, 0, EMA_Period_70, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_70);
      ExtMapBuffer4[i] = iMA(NULL, 0, EMA_Period_250, 0, MODE_EMA, PRICE_CLOSE, i + EMA_Shift_250);

      double bbMiddle = iMA(NULL, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i);
      double bbDeviation1 = iStdDev(NULL, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation1_BB20;
      double bbDeviation2 = iStdDev(NULL, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation2_BB20;
      double bbDeviation3 = iStdDev(NULL, 0, BB_Period, BB_Shift1, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation3_BB20;

      ExtMapBuffer4[i] = bbMiddle + bbDeviation1;
      ExtMapBuffer5[i] = bbMiddle - bbDeviation1;
      ExtMapBuffer6[i] = bbMiddle + bbDeviation2;
      ExtMapBuffer7[i] = bbMiddle - bbDeviation2;
      ExtMapBuffer8[i] = bbMiddle + bbDeviation3;
      ExtMapBuffer9[i] = bbMiddle - bbDeviation3;

      // Calculation of the new Bollinger Bands with period 225 and shift BB_Shift2
      double bbMiddle2 = iMA(NULL, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i);
      double bbDeviation4 = iStdDev(NULL, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation4_BB50;
      double bbDeviation5 = iStdDev(NULL, 0, BB_Period2, BB_Shift2, MODE_SMA, PRICE_CLOSE, i) * BB_Deviation5_BB50;

      ExtMapBuffer11[i] = bbMiddle2 + bbDeviation4; // New upper Bollinger Band
      ExtMapBuffer12[i] = bbMiddle2 - bbDeviation4; // New lower Bollinger Band
      ExtMapBuffer13[i] = bbMiddle2 + bbDeviation5; // New upper Bollinger Band
      ExtMapBuffer14[i] = bbMiddle2 - bbDeviation5; // New lower Bollinger Band
      
      double ema250 = iMA(NULL, 0, EMA_Period_250, 0, MODE_EMA, PRICE_CLOSE, i);
      ExtMapBuffer10[i] = ema250;

      // Check for crossover above the top Bollinger Band and plot green arrow up
      if (close[i] > ExtMapBuffer8[i] && close[i - 1] <= ExtMapBuffer8[i - 1])
      {
         ObjectSet("BullishArrow" + IntegerToString(i), OBJPROP_COLOR, Lime);

         // Add text to the right side of the arrow
         ObjectCreate("BullishText" + IntegerToString(i), OBJ_TEXT, 0, Time[i + 1], Low[i] - 10 * Point);
         ObjectSet("BullishText" + IntegerToString(i), OBJPROP_ALIGN, TA_RIGHT);
         ObjectSetText("BullishText" + IntegerToString(i), "------RideBull------", 10, "Arial Black", Green);
      }
      else
      {
         ObjectDelete("BullishArrow" + IntegerToString(i));
         ObjectDelete("BullishText" + IntegerToString(i));
      }

      // Check for crossover below the bottom Bollinger Band and plot red arrow down
      if (close[i] < ExtMapBuffer9[i] && close[i - 1] >= ExtMapBuffer9[i - 1])
      {
         ObjectSet("BearishArrow" + IntegerToString(i), OBJPROP_COLOR, Red);

         // Add text to the right side of the arrow
         ObjectCreate("BearishText" + IntegerToString(i), OBJ_TEXT, 0, Time[i + 1], High[i] + 10 * Point);
         ObjectSet("BearishText" + IntegerToString(i), OBJPROP_ALIGN, TA_RIGHT);
         ObjectSetText("BearishText" + IntegerToString(i), "------RideBear------", 10, "Arial Black", Red);
      }
      else
      {
         ObjectDelete("BearishArrow" + IntegerToString(i));
         ObjectDelete("BearishText" + IntegerToString(i));
      }
   }

   return (rates_total);
}
