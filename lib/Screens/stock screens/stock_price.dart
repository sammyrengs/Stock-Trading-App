import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'dart:convert';
import 'dart:async';
import 'package:stock_trading_app/shared/loading.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class StockPrice extends StatefulWidget {
  final symb;
  final comp;
  const StockPrice({required this.symb, required this.comp, Key? key}) : super(key: key);

  @override
  _StockPriceState createState() => _StockPriceState();
}

class _StockPriceState extends State<StockPrice> {

  bool loading = true;
  final channel = WebSocketChannel.connect(Uri.parse('wss://ws.finnhub.io?token=APIKEY'));
  late Stream myStream;


  @override
  void initState(){
    myStream = channel.stream.asBroadcastStream();
    super.initState();
    Future.delayed(Duration(seconds: 1), () {
      setState(() {
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    channel.sink.add(jsonEncode({'type':'subscribe', 'symbol': widget.symb}));
    myStream.listen((data) {
      print(data);
    });
    return loading? Loading() : Scaffold(
        backgroundColor: Colors.black87,
        appBar: AppBar(
          title: Center(child: Text('Stock Price'),),
          backgroundColor: Colors.black87,
        ),
      body: StreamBuilder(
        stream: myStream,
        builder: (context,snapshot){
          if(snapshot.hasData){
            var data1 = snapshot.data!.toString();
            Map <String , dynamic> data2 = json.decode(data1);
            if(data2['type'] == 'ping'){
              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget> [
                    SizedBox(height: 50,),
                    Text(widget.symb, style: TextStyle(color: Colors.white, fontSize: 70),),
                    SizedBox(height: 10,),
                    Text(widget.comp, style: TextStyle(color: Colors.white, fontSize: 36),),
                    SizedBox(height: 90,),
                    Container(
                        color: Colors.black,
                        child: Center(
                          child: SpinKitFadingCircle(
                            color: Colors.white,
                            size: 50,
                          ),
                        )
                    ),
                  ],
                ),
              );
            } else{
              return Container(
                alignment: Alignment.center,
                child: Column(
                  children: <Widget> [
                    SizedBox(height: 50,),
                    Text(widget.symb, style: TextStyle(color: Colors.white, fontSize: 70),),
                    SizedBox(height: 10,),
                    Text(widget.comp, style: TextStyle(color: Colors.white, fontSize: 36),),
                    SizedBox(height: 90,),
                    Text('${(data2['data'][0]['p']).toString()}', style: TextStyle(color: Colors.white, fontSize: 70, backgroundColor: Colors.grey[600]),),
                  ],
                ),
              );
            }
          } else{
            return Loading();
          }
        },
      ),
    );
  }
  void dispose(){
    channel.sink.close();
    super.dispose();
  }
}
