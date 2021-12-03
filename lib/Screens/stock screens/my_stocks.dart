import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import 'package:stock_trading_app/Screens/stock%20screens/stock_price.dart';
import 'package:stock_trading_app/Screens/stock%20screens/top_stocks.dart';
import 'package:flutter/material.dart';
import 'package:stock_trading_app/models/user_model.dart';
import 'package:stock_trading_app/services/database.dart';
import 'package:stock_trading_app/shared/loading.dart';
import 'choose_stocks.dart';

class MyStockScreen extends StatefulWidget {
  const MyStockScreen({Key? key}) : super(key: key);

  @override
  _MyStockScreenState createState() => _MyStockScreenState();
}

class _MyStockScreenState extends State<MyStockScreen> {

  bool loading = true;
  List <String> myStockSymbols = [];
  List <Stock> myStocks = [];
  String searchstr = '';

  @override
  void initState(){
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '${UID}');


    return loading? Loading() : Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
          title: Center(child: Text('My Stocks'),),
          backgroundColor: Colors.black87,
        ),
      body: StreamBuilder<DocumentSnapshot>(
        stream: db.StockCollection.doc(UID).snapshots(),
        builder: (context, snapshots) {
          if(!snapshots.hasData){
            return Loading();
          } else {
            if(snapshots.data != null){
              final stsymb = snapshots.data!['MY STOCKS'].cast<String>();
              myStockSymbols = [];
              myStocks = [];
              stsymb.forEach((String symb){
                  myStockSymbols.add(symb);
                  String? comp = Stock.getComp(symb);
                  myStocks.add(Stock(symbol: symb, company: comp));
              }
              );
            }
            return Column(
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
                      itemCount: myStocks.length,
                      itemBuilder: (context,index) {
                        final stock = myStocks[index];
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
            );
          }
        }
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: Text('button1'),
        backgroundColor: Colors.white,
        label: Text('Add Stocks', style: TextStyle(color: Colors.black87),),
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ChooseStocksPage(ss: myStockSymbols),
          ),
        ),
        icon: Icon(Icons.add, color: Colors.black87,),
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
