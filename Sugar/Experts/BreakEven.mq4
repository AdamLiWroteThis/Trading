//+------------------------------------------------------------------+
//|                                                    BreakEven.mq4 |
//|                        Copyright 2015, MetaQuotes Software Corp. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2015, MetaQuotes Software Corp."
#property link      "https://www.mql5.com"
#property version   "1.00"
#property strict

//---- input parameters
extern double StopLossPips=21.0;             // Break even pips for risk free order
extern double BreakEvenTriggerPips=33.0;     // Pips to trigger setting for risk free break even order 

int nTimes = 0;

//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   nTimes=(int)MathPow(10,Digits);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
   
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
class CFix { } ExtFix;
void OnTick()
  {
//---
   // Total open order lots without risk
   int i = 0, ticket = 0;
   double BreakEvenPrice = 0.0, BreakEvenTriggerPrice = 0.0;
   for(i=0; i<OrdersTotal(); i++) 
   {
      if(!OrderSelect(i,SELECT_BY_POS)) continue;
      if (OrderStopLoss()!=0) 
      {
         if(OrderType() == OP_BUY)  // long
         {
            if(OrderOpenPrice() > OrderStopLoss())  // initial risk order
            {
               BreakEvenTriggerPrice = OrderOpenPrice() + BreakEvenTriggerPips/nTimes;
               if(Close[0] >= BreakEvenTriggerPrice)
               {
                  //--- modify order and exit
                  BreakEvenPrice = OrderStopLoss() + BreakEvenTriggerPips/nTimes;
                  ticket=OrderModify(OrderTicket(),OrderOpenPrice(),BreakEvenPrice,OrderTakeProfit(),0,Lime);
                  if(ticket<0) Print("OrderModify failed with error #",GetLastError());
                  return;
               }
            }
         }
         if(OrderType() == OP_SELL)  // short
         {
            if(OrderOpenPrice() < OrderStopLoss())  // initial risk order
            {
               BreakEvenTriggerPrice = OrderOpenPrice() - BreakEvenTriggerPips/nTimes;
               if(Close[0] <= BreakEvenTriggerPrice)
               {
                  //--- modify order and exit
                  BreakEvenPrice = OrderStopLoss() - BreakEvenTriggerPips/nTimes;
                  ticket=OrderModify(OrderTicket(),OrderOpenPrice(),BreakEvenPrice,OrderTakeProfit(),0,Lime);
                  if(ticket<0) Print("OrderModify failed with error #",GetLastError());
                  return;
               }
            }
         }
      }
   }
  }
//+------------------------------------------------------------------+
