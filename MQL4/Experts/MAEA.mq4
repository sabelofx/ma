//+------------------------------------------------------------------+
//|                                                    fxmachine.mq4 |
//|                           Copyright (c) 2017, sabelofx@gmail.com |
//|                                               sabelofx@gmail.com |
//+------------------------------------------------------------------+
#property copyright "Copyright (c) 2017, sabelofx@gmail.com"
#property link      "sabelofx@gmail.com"
#property version   "1.00"
#property strict

//imports
#import "digitFactorLib.ex4"
double calcDigitFactor(string symbol);
#import "lotCalcLib.ex4"
double calculateLots(string symb,double pips,double risk,double digitFactor);
#import "totalTradesLib.ex4"
int totalTradesBySymbMagicCmt(string symb,int MagicNumber,string cmt,string type);
#import

//+------------------------------------------------------------------+
//| External Variables                                               |
//+------------------------------------------------------------------+

extern string
_____Trade_Identifiers_____="---------- Trade Identifiers ----------";
extern int
MagicNumber=666;
extern string
TicketComment="maea";

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+

int
ticket,
count,
total,
Slippage=5,
j;

double
LotSize,
TP,
SL,
MarketPrice,
BuyPrice,
SellPrice,
RiskPercent,
spread,
AllowedSpread;

string
curSymb;

static datetime Symb_Time15;
//+------------------------------------------------------------------+
//| Expert initialization function                                   |
//+------------------------------------------------------------------+
int OnInit()
  {
//---
   AllowedSpread=50.0;
   RiskPercent=1.0;

   Symb_Time15=iTime(Symbol(),PERIOD_M15,0);
//---
   return(INIT_SUCCEEDED);
  }
//+------------------------------------------------------------------+
//| Expert deinitialization function                                 |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
  {
//---
//---
  }
//+------------------------------------------------------------------+
//| Expert tick function                                             |
//+------------------------------------------------------------------+
void OnTick()
  {
//---
   Trade();
   BreakEven();
//---
  }
//+------------------------------------------------------------------+
//| Trade function                                                   |
//+------------------------------------------------------------------+
void Trade()
  {
   for(j=0;j<SymbolsTotal(false);j++)
     {
      curSymb=SymbolName(j,false);
      // Only continue if this is beginning of the 15 min bar
      if(Symb_Time15!=iTime(curSymb,PERIOD_M15,0))
         Symb_Time15=iTime(curSymb,PERIOD_M15,0);
      else
         continue;

      if(calcDigitFactor(curSymb)==0.0) continue;

      spread=MarketInfo(curSymb,MODE_SPREAD);

      if(spread*calcDigitFactor(curSymb)>AllowedSpread*calcDigitFactor(curSymb)) continue;

      if(totalTradesBySymbMagicCmt(curSymb,MagicNumber,TicketComment,"ALL")>0) continue;

      total=0;
      for(count=0; count<20; count++)
         if(iLow(curSymb,PERIOD_M15,count)<iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,count))
            total++;
      if(total>1) continue;

      total=0;
      for(count=0; count<20; count++)
         if(iHigh(curSymb,PERIOD_M15,count)>iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,count))
            total++;
      if(total>1) continue;

      if(iMA(curSymb,PERIOD_H4,200,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H4,50,0,MODE_EMA,PRICE_CLOSE,0) && 
         iMA(curSymb,PERIOD_H4,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H4,13,0,MODE_EMA,PRICE_CLOSE,0) && 
         iMA(curSymb,PERIOD_H4,13,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H4,5,0,MODE_EMA,PRICE_CLOSE,0)) // Buy
        {
         if(iMA(curSymb,PERIOD_H1,200,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H1,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_H1,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H1,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_H1,13,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_H1,5,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,200,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M30,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,13,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M30,5,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,200,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M15,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,13,0,MODE_EMA,PRICE_CLOSE,0)<iMA(curSymb,PERIOD_M15,5,0,MODE_EMA,PRICE_CLOSE,0))
           {
            MarketPrice=MarketInfo(curSymb,MODE_ASK);
            SL=iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0);
            TP=NormalizeDouble(MarketPrice+2*(MarketPrice-SL),(int)MarketInfo(curSymb,MODE_DIGITS));
            LotSize=calculateLots(curSymb,MarketPrice-SL,RiskPercent,calcDigitFactor(curSymb));

            RefreshRates();
            ticket=OrderSend(curSymb,OP_BUY,LotSize,MarketPrice,Slippage,SL,TP,TicketComment,MagicNumber,0,clrNONE);
           }
        }
      if(iMA(curSymb,PERIOD_H4,200,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H4,50,0,MODE_EMA,PRICE_CLOSE,0) && 
         iMA(curSymb,PERIOD_H4,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H4,13,0,MODE_EMA,PRICE_CLOSE,0) && 
         iMA(curSymb,PERIOD_H4,13,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H4,5,0,MODE_EMA,PRICE_CLOSE,0)) // Sell
        {
         if(iMA(curSymb,PERIOD_H1,200,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H1,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_H1,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H1,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_H1,13,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_H1,5,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,200,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M30,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M30,13,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M30,5,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,200,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,50,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M15,13,0,MODE_EMA,PRICE_CLOSE,0) && 
            iMA(curSymb,PERIOD_M15,13,0,MODE_EMA,PRICE_CLOSE,0)>iMA(curSymb,PERIOD_M15,5,0,MODE_EMA,PRICE_CLOSE,0))
           {
            MarketPrice=MarketInfo(curSymb,MODE_BID);
            SL=iMA(curSymb,PERIOD_M30,50,0,MODE_EMA,PRICE_CLOSE,0);
            TP=NormalizeDouble(MarketPrice-2*(SL-MarketPrice),(int)MarketInfo(curSymb,MODE_DIGITS));
            LotSize=calculateLots(curSymb,SL-MarketPrice,RiskPercent,calcDigitFactor(curSymb));

            RefreshRates();
            ticket=OrderSend(curSymb,OP_SELL,LotSize,MarketPrice,Slippage,SL,TP,TicketComment,MagicNumber,0,clrNONE);
           }
        }
     }
  }
//+------------------------------------------------------------------+
//| Trail function                                                   |
//+------------------------------------------------------------------+
void BreakEven()
  {
   for(count=0;count<OrdersTotal();count++)
     {
      if(OrderSelect(count,SELECT_BY_POS,MODE_TRADES)==true)
        {
         if((OrderType()==OP_SELL || OrderType()==OP_BUY) && OrderMagicNumber()==MagicNumber && OrderComment()==TicketComment)
           {
            switch(OrderType())
              {
               case OP_BUY  :
                  MarketPrice=MarketInfo(OrderSymbol(),MODE_BID);
                  BuyPrice=OrderOpenPrice();
                  if((MarketPrice>BuyPrice) && (MarketPrice-BuyPrice>OrderTakeProfit()-MarketPrice))
                    {
                     SL=BuyPrice+20.0*calcDigitFactor(OrderSymbol());
                     if(BuyPrice>OrderStopLoss())
                        if(OrderModify(OrderTicket(),OrderOpenPrice(),SL,OrderTakeProfit(),OrderExpiration(),clrNONE)==false)
                           GetLastError();
                    }
               case OP_SELL :
                  MarketPrice=MarketInfo(OrderSymbol(),MODE_ASK);
                  SellPrice=OrderOpenPrice();
                  if((MarketPrice<SellPrice) && (SellPrice-MarketPrice>MarketPrice-OrderTakeProfit()))
                    {
                     SL=SellPrice-20.0*calcDigitFactor(OrderSymbol());
                     if(SellPrice<OrderStopLoss())
                        if(OrderModify(OrderTicket(),OrderOpenPrice(),SL,OrderTakeProfit(),OrderExpiration(),clrNONE)==false)
                           GetLastError();
                    }
              }
           }
        }
     }
  }
//+------------------------------------------------------------------+
