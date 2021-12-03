import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:stock_trading_app/Screens/wrapper.dart';
import 'package:provider/provider.dart';
import 'package:stock_trading_app/services/auth.dart';
import 'models/user_model.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StreamProvider<Our_User?>.value(
      initialData: null,
      catchError: (User, Our_User) => null,
      value: AuthService().user,
      child: MaterialApp(
        title: 'Stock Trading App',
        home: Wrapper(),
      ),
    );
  }
}
