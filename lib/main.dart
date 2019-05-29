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
  static const TAG = "FlutterDemoApp";
  static const channel = BasicMessageChannel<String>(
    'basic_message_channel',
    StringCodec(),
  );

  static const codec = StringCodec();

  @override
  void initState() {
    // Receive binary messages from native platforms
    _startReceivingMessagesFromNativePlatform();

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
            RaisedButton(
              onPressed: _sendBinaryMessageToNativePlatform,
              child: Text('Send Binary Message'),
            ),
            RaisedButton(
              onPressed: () =>
                  _sendMessageToNativePlatformWithData("Flutter is <3"),
              child: Text('Send Message with Data'),
            ),
            RaisedButton(
              onPressed: () => _sendMessageToNativePlatformWithStringCodec(
                  "Flutter is <3 <3"),
              child: Text('Send Message with BinaryMessages + String Codec'),
            ),
          ],
        ),
      ),
    );
  }

  void _startReceivingMessagesFromNativePlatform() {
    BinaryMessages.setMessageHandler(
      'native_to_flutter_binary_message',
      (ByteData message) async {
        final ReadBuffer readBuffer = ReadBuffer(message);
        final double x = readBuffer.getFloat64();
        final int y = readBuffer.getInt32();
        print('$TAG: Received $x and $y');
        return null;
      },
    );

    BinaryMessages.setMessageHandler(
      'flutter_to_native_binary_message',
      (ByteData message) async {
        print('$TAG: Received $message');
        return null;
      },
    );

    BinaryMessages.setMessageHandler(
      'basic_message_channel',
          (ByteData message) async {
        print('$TAG: Received $message');
        return null;
      },
    );

    BinaryMessages.setMessageHandler(
      'binary_messages_string_codec_channel',
          (ByteData message) async {
        print('$TAG: Received $message');
        return null;
      },
    );
  }

  void _sendBinaryMessageToNativePlatform() async {
    final WriteBuffer writeBuffer = WriteBuffer();
    writeBuffer.putFloat64(3.1415);
    writeBuffer.putInt32(12345678);
    final ByteData message = writeBuffer.done();
    await BinaryMessages.send('flutter_to_native_binary_message', message);
    print('$TAG: Message sent!');
  }

  void _sendMessageToNativePlatformWithData(String message) async {
    // Send messages to the platform
    final String reply = await channel.send(message);
    print("$TAG: $reply");
  }

  void _sendMessageToNativePlatformWithStringCodec(String message) async {
    // Send messages to the platform
    final String reply = codec.decodeMessage(
      await BinaryMessages.send(
        'binary_messages_string_codec_channel',
        codec.encodeMessage(message),
      ),
    );
    print(reply);
  }
}
