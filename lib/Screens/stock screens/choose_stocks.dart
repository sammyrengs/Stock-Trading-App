import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_trading_app/models/user_model.dart';
import 'top_stocks.dart';
import 'package:stock_trading_app/shared/loading.dart';
import 'package:stock_trading_app/services/database.dart';

class ChooseStocksPage extends StatefulWidget {
  final ss;
  const ChooseStocksPage({required this.ss, Key? key}) : super(key: key);

  @override
  _ChooseStocksPageState createState() => _ChooseStocksPageState();
}

class _ChooseStocksPageState extends State<ChooseStocksPage> {

  bool loading = true;

  void initState(){
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  String searchstr = '';
  List <Stock> allStocks = Stock.getAll();
  List <String> selectedStocks = [];

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '${UID}');
    selectedStocks = widget.ss;

    return loading? Loading() : Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Center(child: Text('Choose Stocks'),),
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
                  final isSelected = selectedStocks.contains(stock.symbol);
                  return buildRow(stock.symbol, stock.company, isSelected, selectStock);
                } else {
                  return Container();
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 30),
            color: Colors.grey[900],
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                shape: StadiumBorder(),
                minimumSize: Size.fromHeight(40),
                primary: Colors.black87,
              ),
              child: Text('Select Stocks', style: TextStyle(fontSize: 20)),
              onPressed: () async {
                await db.StockCollection.doc(UID).update({'MY STOCKS': selectedStocks });
                Navigator.pop(context, selectedStocks);
              },
            ),
          ),
        ],
      ),
    );
  }

  void selectStock(String s){
    final isSelected = selectedStocks.contains(s);
    setState(() {
      isSelected? selectedStocks.remove(s) : selectedStocks.add(s);
    });
  }

  Widget buildRow(String first, String second, bool isSelected, ValueChanged<String> onSelectedStock){
    return ListTile(
      contentPadding: EdgeInsets.all(4),
      onTap: () => onSelectedStock(first),
      title: Column(
        children: <Widget> [
          Text(first, style: TextStyle(fontSize: 30, color: isSelected? Colors.blue: Colors.white),),
          SizedBox(height: 5,),
          Text(second, style: TextStyle(fontSize: 20, color: isSelected? Colors.blue: Colors.white70),),
        ],
      ),
      trailing: isSelected? Icon(Icons.check, color: Colors.blue, size: 25):null,
    );
  }
}
