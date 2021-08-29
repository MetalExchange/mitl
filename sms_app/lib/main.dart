import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';
import 'dart:async';
// ignore: unused_import
import 'smsIdentifier.dart';

var time = const Duration(seconds: 15);

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SMS receiver ',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'SMS receiver'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final Telephony telephony = Telephony.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Timer.periodic(time, (timer) => _getSms());
          telephony.listenIncomingSms(
              onNewMessage: (SmsMessage message) {
                print('Automatic checker new message: ');
                print(message.body);
              },
              listenInBackground: false);
        },
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

_getSms() async {
  List<SmsMessage> _messages = await Telephony.instance.getInboxSms(
      columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
      filter: SmsFilter.where(SmsColumn.ADDRESS)
          .like('%CC%')
          .or(SmsColumn.ADDRESS)
          .like('%SHAIZI'));

  for (var msg in _messages) {
    print(msg.address);

    msg.address = msg.address!.toLowerCase();

    if (msg.address!.contains('cc')) {
    } else if (msg.address!.contains('shaizi')) {
      if (_shaizilocalSmsChecker(msg.body)) {
        shaiziMessageParsing tryMessage = new shaiziMessageParsing(msg.body!);
      }
    }
  }
}

// messgae checker
bool _shaizilocalSmsChecker(String? message) {
  int msgScore = 0;

  if (message == null) {
    return false;
  }

  message = message.toLowerCase();
  message = message.replaceAll(" ", "");

  if (message.contains('only')) {
    msgScore += 10;
  }
  if (message.contains('info')) {
    msgScore += 20;
  }
  if (message.contains('onlyinfo')) {
    msgScore += 30;
  }
  if (message.contains('rates')) {
    msgScore += 10;
  }
  if (message.contains('gst')) {
    msgScore += 10;
  }
  if (message.contains('extra')) {
    msgScore += 10;
  }
  if (message.contains('gstextra')) {
    msgScore += 30;
  }
  if (message.contains('historical')) {
    msgScore += 20;
  }
  if (message.contains('price')) {
    msgScore += 10;
  }
  if (message.contains('historicalprice')) {
    msgScore += 40;
  }
  if (message.contains('zn')) {
    msgScore += 5;
  }
  if (message.contains('pb')) {
    msgScore += 5;
  }
  if (message.contains('sn')) {
    msgScore += 5;
  }
  if (message.contains('cu')) {
    msgScore += 5;
  }
  if (message.contains('al')) {
    msgScore += 5;
  }
  if (message.contains('+')) {
    msgScore += 20;
  }
  if (message.contains('(')) {
    msgScore += 10;
  }
  if (message.contains(')')) {
    msgScore += 10;
  }
  if (message.contains('gd')) {
    msgScore -= 10;
  }
  if (message.contains(':')) {
    msgScore -= 10;
  }
  if (message.contains('eur')) {
    msgScore -= 10;
  }
  if (message.contains('crd')) {
    msgScore -= 10;
  }
  if (message.contains('si')) {
    msgScore -= 10;
  }
  if (message.contains('/')) {
    msgScore -= 10;
  }
  if (message.contains('-')) {
    msgScore -= 10;
  }
  if (msgScore >= 180) {
    return true;
  } else {
    return false;
  }
}
