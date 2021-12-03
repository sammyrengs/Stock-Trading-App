import 'package:flutter/material.dart';
import 'package:stock_trading_app/services/auth.dart';
import 'package:stock_trading_app/shared/loading.dart';

class Register extends StatefulWidget {
  final Function toggleView;
  Register({Key? key, required this.toggleView}) : super(key: key);

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _FormKey = GlobalKey<FormState>();
  bool loading = false;

  //text field states
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.black87,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        title: Center(child: Text('Register'),),
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.person, color: Colors.white),
            label: Text('Sign In', style: TextStyle(color: Colors.white)),
            onPressed: () {
              widget.toggleView();
            },
          )
        ],
      ),
      body: Container(
        padding: EdgeInsets.all(40),
        child: ListView(
          children: <Widget> [
            Form(
              key: _FormKey,
              child: Column(
                children: <Widget> [
                  SizedBox(height: 110,),
                  //email
                  TextFormField(
                    validator: (val) => val!.isEmpty ? 'Enter an email': null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      hintText: 'Email-Id',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                    onChanged: (val) {
                      setState(() {
                        email = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  //password
                  TextFormField(
                    validator: (val) => val!.length < 6 ? 'Enter a password with 6+ chars': null,
                    decoration: InputDecoration(
                      fillColor: Colors.white,
                      filled: true,
                      border: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      focusedBorder: OutlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                      hintText: 'Password',
                      hintStyle: TextStyle(color: Colors.grey[800]),
                    ),
                    obscureText: true,
                    onChanged: (val) {
                      setState(() {
                        password = val;
                      });
                    },
                  ),
                  SizedBox(height: 20,),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.grey),),
                    child: Text('Register', style: TextStyle(color: Colors.white)),
                    onPressed: () async {
                      if(_FormKey.currentState!.validate()){
                        setState(() => loading = true);
                        dynamic result = await _auth.registerWithEmailAndPassword(email, password);
                        if(result is String){
                          setState(() {
                            error = result.substring(result.indexOf("]")+1);
                            loading = false;
                          });
                        }
                      }
                    },
                  ),
                  SizedBox(height: 15),
                  Text(error, style: TextStyle(color: Colors.white, fontSize: 12)),
                ],
              ),
            ),
            SizedBox(height: 40,),
            Text(
              'Create an account and register to view stock data!',
              style: TextStyle(color:Colors.white, fontSize: 40),
            ),
          ],
        ),
      ),
    );
  }
}
