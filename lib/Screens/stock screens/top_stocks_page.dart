import 'package:flutter/material.dart';
import 'package:stock_trading_app/Screens/stock%20screens/stock_price.dart';
import 'package:stock_trading_app/Screens/stock%20screens/top_stocks.dart';
import 'dart:async';
import 'package:stock_trading_app/shared/loading.dart';


class StockScreen extends StatefulWidget {
  const StockScreen({Key? key}) : super(key: key);
  @override
  State <StockScreen> createState() => _StockScreenState();
}

class _StockScreenState extends State<StockScreen> {

  bool loading = true;

  @override
  void initState(){

     super.initState();
     Future.delayed(Duration(seconds: 1), () {
       setState(() {
         loading = false;
       });
     });
   }

  String searchstr = '';
  List <Stock> allStocks = Stock.getAll();

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(child: Text('Top Stocks'),),
        backgroundColor: Colors.black87,
      ),
      body: Column(
        children: <Widget> [
          Container(
            color: Colors.grey[900],
            padding: EdgeInsets.all(5),
            child: TextField(
              cursorColor: Colors.white,
              style: TextStyle(color: Colors.white),
              onChanged: (value){
                setState((){
                  searchstr = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                labelText: 'Search',
                labelStyle: TextStyle(color: Colors.white),
                prefixIcon: Icon(Icons.search, color: Colors.white,),
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(6),
                itemCount: allStocks.length,
                itemBuilder: (context,index) {
                  final stock = allStocks[index];
                  if (stock.company.toLowerCase().contains(searchstr) || stock.symbol.toLowerCase().contains(searchstr)){
                    return buildRow(stock.symbol, stock.company);
                  }
                  else {
                    return Container();
                  }
                },
              )
          ),
        ],
      ),
    );
  }
  Widget buildRow(String first, String second){
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StockPrice(symb: first,comp: second),
        ),
      ),
      title: Column(
        children: <Widget> [
          Text(first, style: TextStyle(fontSize: 30, color: Colors.white),),
          SizedBox(height: 5,),
          Text(second, style: TextStyle(fontSize: 20, color: Colors.white70),),
        ],
      ),
    );
  }
}
