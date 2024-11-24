import 'package:flutter/material.dart';
import 'package:get/get.dart';
import "package:socket_io_client/socket_io_client.dart" as io;

class SocketService extends GetxService {
  late io.Socket socket;

  @override
  void onInit() async {
    super.onInit();
    await _initIO();
  }

  @override
  void onClose() {
    super.onClose();
    socket.disconnect();
  }

  // Listen to the socket
  void listenToSocket(String eventName, Function(String) callback) {
    socket.on(eventName, (data) {
      callback(data);
    });
  }

  void broadcastToSocket(String eventName, List<dynamic> args) {
    socket.emit(eventName, args);
  }

  Future<SocketService> _initIO() async {
    socket = io.io(
      'http://localhost:3000',
      io.OptionBuilder().setTransports(['websocket']).setExtraHeaders(
        {"authorization": '123456'},
      ).build(),
    );

    socket.onConnect((_) {
      debugPrint('connect Done');
      socket.emit('chat message', 'Flutter Connected.');
    });

    socket.onError((error) {
      debugPrint('error $error');
    });

    socket.on('disconnect', (_) {
      debugPrint('disconnected');
    });

    return this;
  }
}
