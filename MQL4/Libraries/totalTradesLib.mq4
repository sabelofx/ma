//+------------------------------------------------------------------+
//|                                               totalTradesLib.mq4 |
//|                           Copyright (c) 2017, sabelofx@gmail.com |
//|                                               sabelofx@gmail.com |
//+------------------------------------------------------------------+
#property library
#property copyright "Copyright (c) 2017, sabelofx@gmail.com"
#property link      "sabelofx@gmail.com"
#property version   "1.00"
#property strict

//+------------------------------------------------------------------+
//| Global Variables                                                 |
//+------------------------------------------------------------------+

int total,count;
//+------------------------------------------------------------------+
//| Function to get the number of Running trades base on symbol      |
//+------------------------------------------------------------------+
int totalTradesBySymb(string symb) export
  {
   total=0;
   for(count=0;count<OrdersTotal();count++)
      if(OrderSelect(count,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderType()<=OP_SELLSTOP && OrderSymbol()==symb)
            total++;
            
   return(total);
  }
//+-------------------------------------------------------------------------------+
//| Function to get the number of Running trades base on symbol and magic number  |
//+-------------------------------------------------------------------------------+
int totalTradesBySymbMagic(string symb,int MagicNumber) export
  {
   total=0;
   for(count=0;count<OrdersTotal();count++)
      if(OrderSelect(count,SELECT_BY_POS,MODE_TRADES)==true)
         if(OrderType()<=OP_SELLSTOP && OrderSymbol()==symb && OrderMagicNumber()==MagicNumber)
            total++;
            
   return(total);
  }
//+----------------------------------------------------------------------------------------+
//| Function to get the number of Running trades base on symbol, magic number and comment  |
//+----------------------------------------------------------------------------------------+
int totalTradesBySymbMagicCmt(string symb,int MagicNumber,string cmt,string type) export
  {
   total=0;
   for(count=0;count<OrdersTotal();count++)
     {
      if(type=="ALL")
         if(OrderSelect(count,SELECT_BY_POS,MODE_TRADES)==true)
            if(OrderType()<=OP_SELLSTOP && OrderSymbol()==symb && OrderMagicNumber()==MagicNumber && OrderComment()==cmt)
               total++;
               
      else if(type=="PENDING")
         if(OrderSelect(count,SELECT_BY_POS,MODE_TRADES)==true)
            if((OrderType()==OP_SELLSTOP || OrderType()==OP_BUYSTOP) && OrderSymbol()==symb && OrderMagicNumber()==MagicNumber && OrderComment()==cmt)
               total++;
     }
   return(total);
  }
//+------------------------------------------------------------------+
