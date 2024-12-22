import 'package:get/get.dart';
import 'package:getx_flutter_ui/module/liveness_camera/liveness_camera_controller.dart';

class LivenessCameraBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LivenessCameraController());
  }
}
