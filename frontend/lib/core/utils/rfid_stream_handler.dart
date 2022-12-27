import 'dart:async';

import 'package:web_socket_channel/io.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class RfidStreamHandler {
  static Stream<String>? rfIdStream;

  static Stream<String> getRfIdStream() {
    if (rfIdStream != null) {
      return rfIdStream!;
    }
    StreamController<String> streamController = StreamController<String>();

    void setupWebSocketConnection() {
      WebSocketChannel channel =
      IOWebSocketChannel.connect(Uri.parse("ws://localhost:8679"));
      channel.stream.listen((message) {
        streamController.sink.add(message);
      }, onDone: () async {
        await Future.delayed(const Duration(seconds: 5));
        setupWebSocketConnection();
      }, onError: (e) {});
    }

    setupWebSocketConnection();

    rfIdStream = streamController.stream.asBroadcastStream();
    return rfIdStream!;
  }
}