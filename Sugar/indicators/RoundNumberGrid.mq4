//+------------------------------------------------------------------+
//|                                              RoundNumberGrid.mq4 |
//|                                                          4xcoder |
//|                                              4xcoder@4xcoder.com |
//+------------------------------------------------------------------+
#property copyright "4xcoder"
#property link      "4xcoder@4xcoder.com"

#property indicator_chart_window
//---- input parameters
extern int       HGrid_Weeks=10;          // Period over which to calc High/Low of gird
extern int       HGrid_Pips=1000;         // Size of grid in Pips (100.0)
extern color     HLine=Lavender;          // Color of grid
extern color     HLine2=Lavender;         // Every 100 pips, change grid color to this.
extern bool      Enable=true;             // true -> disabled & false -> enabled



// Recommends settings:
// 1 minute - HGrid_Pips=10, TimeGrid = 10
// 5, 15 minutes - HGrid_Pips=20, TimeGrid= PERIOD_H1 (60)
// 30, 60 minutes - HGrid_Pips=20, TimeGrid = PERIOD_H4 (240) or 2 hours (120)
// 4 hour - HGrid_Pips=50, TimeGrid = PERIOD_D1 (1440) or 12 hours (720)
// 1 day - HGrid_Pips=50, TimeGrid = PERIOD_W1 (10800).


bool firstTime = true;
datetime lastTime = 0;
//+------------------------------------------------------------------+
//| Custom indicator iteration function                              |
//+------------------------------------------------------------------+
int start()
{
   //----
   if (!Enable) return(0);
   if ( true /*lastTime == 0 || CurTime() - lastTime > 5*/ ) {
      firstTime = false;
      lastTime = CurTime();
      
      if ( HGrid_Weeks > 0 && HGrid_Pips > 0 ) {
         double weekH = iHigh( NULL, PERIOD_W1, 0 );
         double weekL = iLow( NULL, PERIOD_W1, 0 );
         
         for ( int i = 1; i < HGrid_Weeks; i++ ) {
            weekH = MathMax( weekH, iHigh( NULL, PERIOD_W1, i ) );
            weekL = MathMin( weekL, iLow( NULL, PERIOD_W1, i ) );
         }
      
         double pipRange = HGrid_Pips * Point;
         double topPips = (weekH + pipRange) - MathMod( weekH, pipRange );
         double botPips = weekL - MathMod( weekL, pipRange );
      
         for ( double p = botPips; p <= topPips; p += pipRange ) {
            string gridname = "grid_" + DoubleToStr( p, Digits );
            ObjectCreate( gridname, OBJ_HLINE, 0, 0, p );
            
            double pp = p / Point;
            int pInt = MathRound( pp );
            int mod = 100;
            if ( (pInt % mod) == 0 )
               ObjectSet( gridname, OBJPROP_COLOR, HLine2 );
            else
               ObjectSet( gridname, OBJPROP_COLOR, HLine );
            ObjectSet( gridname, OBJPROP_STYLE, STYLE_DASHDOT );
            ObjectSet( gridname, OBJPROP_PRICE1, p );
            ObjectSet( gridname, OBJPROP_BACK, true );
         }
      }      
   }
   //----
   return(0);
}
 

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int init()
{
//---- indicators
   firstTime = true;
//----
   return(0);
}
//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
int deinit()
{
//----
   for ( int i = ObjectsTotal() - 1; i >= 0; i-- ) {
      string name = ObjectName( i );
      if ( StringFind( name, "grid_" ) >= 0 ) 
         ObjectDelete( name );
   }
//----
   return(0);
}
//+------------------------------------------------------------------+