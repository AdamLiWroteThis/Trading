//+------------------------------------------------------------------+
//|                                                      cn_MACD.mq4 |
//|                                 Copyright ?2005, www.17relax.com |
//|                                           http://www.17relax.com |
//+------------------------------------------------------------------+
#property copyright "www.17relax.com"
#property link      "http://www.17relax.com"

#property indicator_separate_window
#property indicator_buffers 4
#property indicator_color1 White
#property indicator_color2 Yellow
#property indicator_color3 Magenta
#property indicator_color4 Lime
//---- input parameters
extern int       FastEMA=12;
extern int       SlowEMA=26;
extern int       SignalSMA=9;
//---- buffers
double ExtMapBuffer1[];
double ExtMapBuffer2[];
double ExtMapBuffer3[];
double ExtMapBuffer4[];
//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//---- indicators
   SetIndexStyle(0,DRAW_LINE);
   SetIndexBuffer(0,ExtMapBuffer1);
   SetIndexStyle(1,DRAW_LINE);
   SetIndexBuffer(1,ExtMapBuffer2);
   SetIndexStyle(2,DRAW_HISTOGRAM);
   SetIndexBuffer(2,ExtMapBuffer3);
   SetIndexStyle(3,DRAW_HISTOGRAM);
   SetIndexBuffer(3,ExtMapBuffer4);
//----

//---- name for DataWindow and indicator subwindow label
   IndicatorShortName("MACD("+FastEMA+","+SlowEMA+","+SignalSMA+")");
   SetIndexLabel(0,"DIFF");
   SetIndexLabel(1,"DEA");
   SetIndexLabel(2,"MACD");
//---- initialization done

   return(0);
  }
//+------------------------------------------------------------------+
//| Custor indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
  {
//---- 
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
  {
   int    counted_bars=IndicatorCounted();
//---- 
   int limit;
//---- check for possible errors
   if(counted_bars<0) return(-1);
//---- last counted bar will be recounted
   if(counted_bars>0) counted_bars--;
   limit=Bars-counted_bars;
//---- DIF counted in the 1-st buffer
   for(int i=0; i<limit; i++)
      ExtMapBuffer1[i]=iMA(NULL,0,FastEMA,0,MODE_EMA,PRICE_CLOSE,i)-iMA(NULL,0,SlowEMA,0,MODE_EMA,PRICE_CLOSE,i);
//---- MACD line counted in the 2-nd buffer
   for(i=0; i<limit; i++)
      ExtMapBuffer2[i]=iMAOnArray(ExtMapBuffer1,Bars,SignalSMA,0,MODE_EMA,i);
//---- BAR line counted in the 3,4 buffer
   for(i=0; i<limit; i++)
   {
      if(ExtMapBuffer1[i] > ExtMapBuffer2[i]) 
      {
          ExtMapBuffer3[i] = 2*(ExtMapBuffer1[i]-ExtMapBuffer2[i]); 
          ExtMapBuffer4[i] = 0;
      }
      else
      {
          ExtMapBuffer4[i] = 2*(ExtMapBuffer1[i]-ExtMapBuffer2[i]); 
          ExtMapBuffer3[i] = 0;
      }
   }      

   
//----
   return(0);
  }
//+------------------------------------------------------------------+