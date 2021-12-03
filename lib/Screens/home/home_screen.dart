import 'package:flutter/material.dart';
import 'package:stock_trading_app/Screens/home/settings_form.dart';
import 'package:stock_trading_app/Screens/stock%20screens/top_stocks_page.dart';
import 'package:stock_trading_app/services/auth.dart';
import 'package:stock_trading_app/services/database.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_trading_app/models/user_model.dart';
import 'package:stock_trading_app/Screens/stock screens/my_stocks.dart';

class Home extends StatelessWidget {

  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '${UID}');

    void SettingsPanel(){
      showModalBottomSheet(context: context, builder: (context){
        return Container(
          padding: EdgeInsets.all(20),
          child: Column(
              children: <Widget> [
                SettingsForm(),
              ],
          ),
        );
      });
    }

    return Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        title: Text('Home Screen'),
        backgroundColor: Colors.black87,
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Sign Out', style: TextStyle(color: Colors.white)),
            onPressed: () async {
              await _auth.SignOut();
            },
          )
        ],
      ),
      body: Container(
          padding: EdgeInsets.all(20),
          child: StreamBuilder<DocumentSnapshot>(
            stream: db.StockCollection.doc(UID).snapshots(),
            builder: (context,snapshots){
              if(!snapshots.hasData){
                return CircularProgressIndicator();
              } else{
                if(snapshots.data != null){
                  String username = snapshots.data!['NAME'];
                  return Text('Welcome ${username}', style: TextStyle(color: Colors.white, fontSize: 50));
                }
                else {
                  return Text('Welcome ', style: TextStyle(color: Colors.white, fontSize: 50));
                }
              }
            }
          )
      ),
      floatingActionButton: Column(
        children: <Widget> [
          SizedBox(height: 300),
          Center(
            child: FloatingActionButton.extended(
              heroTag: Text('button1'),
              backgroundColor: Colors.white,
              label: Text('Top Stocks', style: TextStyle(color: Colors.black87),),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => StockScreen(),
                ),
              ),
              icon: Icon(Icons.auto_graph, color: Colors.black87,),
            ),
          ),
          SizedBox(height: 40),
          Center(
            child: FloatingActionButton.extended(
              heroTag: Text('button2'),
              backgroundColor: Colors.white,
              label: Text('My Stocks', style: TextStyle(color: Colors.black87),),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyStockScreen(),
                ),
              ),
              icon: Icon(Icons.auto_graph, color: Colors.black87,),
            ),
          ),
          SizedBox(height: 40),
          FloatingActionButton.extended(
            heroTag: Text('button3'),
            backgroundColor: Colors.white,
            icon: Icon(Icons.settings, color: Colors.black87),
            label: Text('Settings', style: TextStyle(color: Colors.black87),),
            onPressed : () => SettingsPanel(),
          ),
        ],
      )
      , // This trailing comma makes auto-formatting nicer for build methods.
    );

  }
}
