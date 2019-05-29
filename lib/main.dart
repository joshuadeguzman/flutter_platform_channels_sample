import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Platform Channels',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Platform Channels'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // Receive binary messages from native platforms
    _startReceivingBinaryMessages();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Demo'),
          ],
        ),
      ),
    );
  }

  void _startReceivingBinaryMessages() {
    BinaryMessages.setMessageHandler('native_to_flutter_binary_message',
        (ByteData message) async {
      final ReadBuffer readBuffer = ReadBuffer(message);
      final double x = readBuffer.getFloat64();
      final int y = readBuffer.getInt32();
      print('Received $x & $y');
      return null;
    });
  }
}
