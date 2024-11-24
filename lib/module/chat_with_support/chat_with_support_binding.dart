import 'package:get/get.dart';
import 'package:getx_with_darkmode/module/chat_with_support/chat_with_support_controller.dart';

class ChatWithSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatWithSupportController(),
    );
  }
}
