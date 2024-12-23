import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class LivenessCameraController extends GetxController {
  final RxBool isCameraReady = false.obs;
  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  late CameraController cameraController;

  final options = FaceDetectorOptions();
  late FaceDetector faceDetector = FaceDetector(options: options);

  @override
  void onInit() async {
    cameras.value = await availableCameras();
    if (cameras.isNotEmpty) {
      final frontCam = cameras.firstWhere(
        (camera) => camera.lensDirection == CameraLensDirection.front,
      );
      cameraController = CameraController(
        frontCam,
        ResolutionPreset.high,
        enableAudio: false,
      );
    }
    faceDetector = FaceDetector(options: options);
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
    cameraController.startImageStream((image) async {
      // Do something with the image
      final imageBytes = image.planes[0].bytes;
      final inputImage = InputImage.fromBytes(
        bytes: imageBytes,
        metadata: InputImageMetadata(
          size: Size(
            image.width.toDouble(),
            image.height.toDouble(),
          ),
          rotation: InputImageRotation.rotation0deg,
          format: image.format.raw,
          bytesPerRow: image.planes[0].bytesPerRow,
        ),
      );

      final faces = await faceDetector.processImage(inputImage);

      for (Face face in faces) {
        final lEyes = face.leftEyeOpenProbability;
        final rEyes = face.rightEyeOpenProbability;

        if (lEyes != null && rEyes != null) {
          if (lEyes < 0.1 || rEyes < 0.1) {
            debugPrint('Eyes are closed');
          } else {
            debugPrint('Eyes are open');
          }
        }
      }
    });
  }
}
