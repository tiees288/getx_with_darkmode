import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter_ui/service/socket_service.dart';

class ChatMessageModel {
  final String message;
  final String sender;
  ChatMessageModel({
    required this.message,
    required this.sender,
  });
}

class ChatWithSupportController extends GetxController {
  final SocketService socketService = Get.find<SocketService>();
  final RxList<ChatMessageModel> messages = <ChatMessageModel>[].obs;
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final chatTextEditingController = TextEditingController();
  final ScrollController scrollController = ScrollController();
  @override
  void onReady() async {
    super.onReady();

    socketService.listenToSocket('chat message', (data) {
      messages.add(ChatMessageModel(message: data, sender: 'support'));
    });

    await Future.delayed(const Duration(milliseconds: 500), () {
      for (int i = 0; i < 300; i++) {
        messages.add(ChatMessageModel(
            message: 'Hello, How can I help you?', sender: 'support'));
      }
    });

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      scrollController.jumpTo(scrollController.position.maxScrollExtent);
    });
  }

  sendAMessage(String message) {
    messages.add(ChatMessageModel(message: message, sender: 'user'));
    socketService.broadcastToSocket('chat message', [message]);
    chatTextEditingController.clear();
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
