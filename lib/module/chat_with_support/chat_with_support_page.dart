import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_with_darkmode/module/chat_with_support/chat_with_support_controller.dart';

class ChatWithSupportPage extends StatelessWidget {
  ChatWithSupportPage({super.key});
  final ChatWithSupportController controller =
      Get.find<ChatWithSupportController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Chat with Support'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                ),
                child: Obx(
                  () => SizeChangedLayoutNotifier(
                    child: Scrollbar(
                      controller: controller.scrollController,
                      child: ListView.builder(
                          physics: const BouncingScrollPhysics(),
                          controller: controller.scrollController,
                          shrinkWrap: true,
                          itemCount: controller.messages.length,
                          itemBuilder: (context, index) {
                            return Container(
                              padding: const EdgeInsets.all(15),
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    controller.messages[index].sender ==
                                            'support'
                                        ? MainAxisAlignment.start
                                        : MainAxisAlignment.end,
                                children: [
                                  Container(
                                      constraints: const BoxConstraints(
                                        minWidth: 50,
                                        maxWidth: 200,
                                      ),
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color:
                                            controller.messages[index].sender ==
                                                    'support'
                                                ? Colors.white
                                                : Colors.green,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Text(
                                          controller.messages[index].message)),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ),
              ),
            ),
            Form(
              key: controller.formKey,
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      // Hide keyboard when click outside
                      onTapOutside: (event) {
                        FocusScope.of(context).requestFocus(FocusNode());
                      },
                      onFieldSubmitted: controller.sendAMessage,
                      controller: controller.chatTextEditingController,
                      decoration: InputDecoration(
                        hintText: 'Type your message',
                        contentPadding: const EdgeInsets.symmetric(
                          vertical: 10,
                          horizontal: 20,
                        ),
                        //  border bottom
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Colors.grey.shade300),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () => controller.sendAMessage(
                      controller.chatTextEditingController.text,
                    ),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.send,
                        color: Colors.white,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
