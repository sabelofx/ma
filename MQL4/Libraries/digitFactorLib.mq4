//+------------------------------------------------------------------+
//|                                               digitFactorLib.mq4 |
//|                           Copyright (c) 2017, sabelofx@gmail.com |
//|                                               sabelofx@gmail.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright (c) 2017, sabelofx@gmail.com"
#property link      "sabelofx@gmail.com"
#property version   "1.00"
#property strict

double p2p=0.0; // Point to Pips
//+------------------------------------------------------------------+
//| Function to Calculate the Digit Factor                           |
//+------------------------------------------------------------------+
double calcDigitFactor(string smb) export
  {
   if(MarketInfo(smb,MODE_DIGITS)==2 || MarketInfo(smb,MODE_DIGITS)==4)
      p2p=MarketInfo(smb,MODE_POINT)*0.1;
   else if(MarketInfo(smb,MODE_DIGITS)==3 || MarketInfo(smb,MODE_DIGITS)==5)
      p2p=MarketInfo(smb,MODE_POINT);
   else if(MarketInfo(smb,MODE_DIGITS)==6)
      p2p=MarketInfo(smb,MODE_POINT)*10;
   else if(MarketInfo(smb,MODE_DIGITS)==7)
      p2p=MarketInfo(smb,MODE_POINT)*100;

   if(StringFind(smb,"XAU",0)>-1)
      p2p=p2p*10;

   return p2p;
  }
//+------------------------------------------------------------------+
