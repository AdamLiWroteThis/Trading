//+------------------------------------------------------------------+
//|                                           Time_Vertical_Line.mq4 |
//|                                                                  |
//|                                                                  |
//+------------------------------------------------------------------+
#property show_inputs

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
//---- 
      datetime exitTime = Time[0]+4800+60;
      ObjectCreate("Time_Vertical_Line", OBJ_VLINE, 0, exitTime, 0);
      ObjectSet("Time_Vertical_Line", OBJPROP_WIDTH, 1);
      ObjectSet("Time_Vertical_Line", OBJPROP_COLOR, Magenta);
      ObjectSet("Time_Vertical_Line", OBJPROP_STYLE, STYLE_DASHDOT);      
      ObjectSet("Time_Vertical_Line", OBJPROP_BACK, true);
//----
   return(0);
  }
//+------------------------------------------------------------------+