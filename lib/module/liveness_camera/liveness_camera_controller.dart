import 'package:camera/camera.dart';
import 'package:get/get.dart';

class LivenessCameraController extends GetxController {
  final RxBool isCameraReady = false.obs;
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  late CameraController cameraController;

  @override
  void onInit() async {
    cameras.value = await availableCameras();
    if (cameras.isNotEmpty) {
      cameraController = CameraController(
        cameras.first,
        ResolutionPreset.max,
      );
    }
    super.onInit();
  }

  @override
  void onReady() async {
    super.onReady();
    await cameraController.initialize();
    isCameraReady.value = cameraController.value.isInitialized;
    subScribeToCamera();
  }

  @override
  void onClose() {
    super.onClose();
    cameraController.dispose();
  }

  void subScribeToCamera() {
    cameraController.startImageStream((image) {
      // Do something with the image
      print(image);
    });
  }
}
