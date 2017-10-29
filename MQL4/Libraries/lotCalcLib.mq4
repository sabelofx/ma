//+------------------------------------------------------------------+
//|                                                   lotCalcLib.mq4 |
//|                           Copyright (c) 2017, sabelofx@gmail.com |
//|                                               sabelofx@gmail.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright (c) 2017, sabelofx@gmail.com"
#property link      "sabelofx@gmail.com"
#property version   "1.00"
#property strict
//+------------------------------------------------------------------+
//| Function to Calculate Lot size                                   |
//+------------------------------------------------------------------+
double calculateLots(string symb,double pips,double risk,double digitFactor) export
  {
   double comm=0.0, Lots;
   int lotNorm;

   if(MarketInfo(symb,MODE_LOTSTEP)==0.01)
      lotNorm=2;
   else
      lotNorm=1;

   Lots=(((risk*AccountBalance()*0.01)-comm)*digitFactor)/(pips*MarketInfo(symb,MODE_TICKVALUE));

   if(Lots<MarketInfo(symb,MODE_MINLOT))
      Lots=MarketInfo(symb,MODE_MINLOT);
   if(Lots>MarketInfo(symb,MODE_MAXLOT))
      Lots=MarketInfo(symb,MODE_MAXLOT);

   return NormalizeDouble(Lots, lotNorm);
  }
//+------------------------------------------------------------------+
