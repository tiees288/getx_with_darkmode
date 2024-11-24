import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_with_darkmode/service/socket_service.dart';

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
  void onReady() {
    super.onReady();

    socketService.listenToSocket('chat message', (data) {
      messages.add(ChatMessageModel(message: data, sender: 'support'));
    });
  }

  sendAMessage(String message) {
    messages.add(ChatMessageModel(message: message, sender: 'user'));
    socketService.broadcastToSocket('chat message', [message]);
    chatTextEditingController.clear();
    scrollController.jumpTo(scrollController.position.maxScrollExtent);
  }
}
