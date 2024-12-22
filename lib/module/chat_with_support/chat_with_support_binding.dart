import 'package:get/get.dart';
import 'package:getx_flutter_ui/module/chat_with_support/chat_with_support_controller.dart';

class ChatWithSupportBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(
      () => ChatWithSupportController(),
    );
  }
}
