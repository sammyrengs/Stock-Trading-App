import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:stock_trading_app/models/user_model.dart';
import 'package:stock_trading_app/services/database.dart';

class SettingsForm extends StatefulWidget {
  const SettingsForm({Key? key}) : super(key: key);

  @override
  _SettingsFormState createState() => _SettingsFormState();
}

class _SettingsFormState extends State<SettingsForm> {

  final _formKey = GlobalKey<FormState>();
  String? _currentName = '';

  @override
  Widget build(BuildContext context) {

    var user = Provider.of<Our_User?>(context);
    var UID = user!.uid;
    final db = DatabaseService(uid: '${UID}');
    final _currentStocks = user.Stocks;

    return StreamBuilder<DocumentSnapshot>(
      stream: db.StockCollection.doc(UID).snapshots(),
      builder: (context, snapshots) {
        if(!snapshots.hasData){
          return CircularProgressIndicator();
        } else{
          return Form(
            key: _formKey,
            child: Column(
              children: <Widget> [
                Text('Update Your Username:',style: TextStyle(fontSize: 20)),
                SizedBox(height: 5),
                TextFormField(
                  initialValue: snapshots.data!['NAME'],
                  validator: (val) => val!.isEmpty ? 'Enter a name': null,
                  decoration: InputDecoration(
                    fillColor: Colors.white,
                    filled: true,
                    border: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.black)),
                    hintText: 'Name',
                    hintStyle: TextStyle(color: Colors.grey[800]),
                  ),
                  onChanged: (val) {
                    setState(() {
                      _currentName = val;
                      print(_currentName);
                    });
                  },
                ),
                SizedBox(height: 5),
                ElevatedButton(
                  style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey),),
                  child: Text('Update', style: TextStyle(color: Colors.white)),
                  onPressed: () async {
                    if(_formKey.currentState!.validate()){
                      await db.StockCollection.doc(UID).update({'NAME': _currentName ?? (user.name).toString() });
                      Navigator.of(context).pop();
                    }
                  },
                ),
              ],
            ),
          );
        }
      }
    );
  }
}
