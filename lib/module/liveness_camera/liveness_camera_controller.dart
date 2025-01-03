import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

class LivenessCameraController extends GetxController {
  final RxBool isCameraReady = false.obs;
  final RxBool isProcessing = false.obs;

  // Variable check state complete
  final RxBool isFaceInFrame = false.obs;
  final RxBool isBlinkEye = false.obs;
  final RxBool isSmile = false.obs;

  final RxList<CameraDescription> cameras = <CameraDescription>[].obs;
  late CameraController cameraController;
  final _orientations = {
    DeviceOrientation.portraitUp: 0,
    DeviceOrientation.landscapeLeft: 90,
    DeviceOrientation.portraitDown: 180,
    DeviceOrientation.landscapeRight: 270,
  };

  final options = FaceDetectorOptions(
    enableContours: true,
    enableLandmarks: true,
    enableClassification: true,
    enableTracking: true,
    performanceMode: FaceDetectorMode.accurate,
  );
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
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.nv21
            : ImageFormatGroup.bgra8888,
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
    faceDetector.close();
  }

  void subScribeToCamera() {
    cameraController.startImageStream((image) async {
      _processImage(image);
      if (isFaceInFrame.value && isBlinkEye.value && isSmile.value) {
        cameraController.stopImageStream();
        Get.back();
      }
    });
  }

  void _processImage(CameraImage image) async {
    if (isProcessing.value) return;
    isProcessing.value = true;
    // Do something with the image
    final inputImage = _inputImageFromCameraImage(image);

    if (inputImage == null) {
      isProcessing.value = false;
      return;
    }
    final faces = await faceDetector.processImage(inputImage);
    debugPrint('faces: ${faces.length}');
    for (Face face in faces) {
      final leftEye = face.leftEyeOpenProbability;
      final rightEye = face.rightEyeOpenProbability;
      final smile = face.smilingProbability;

      final bool isBlinkDetectEye = leftEye != null &&
          rightEye != null &&
          leftEye < 0.5 &&
          rightEye < 0.5;
      final bool isDetectSmile = smile != null && smile > 0.5;

      final boundary = face.boundingBox;

      // Check is face boundary is in a draw frame
      if (!(boundary.left < -75 ||
          boundary.left > 75 ||
          boundary.top < -50 ||
          boundary.top > 350)) {
        isFaceInFrame.value = true;
        if (isBlinkDetectEye) {
          isBlinkEye.value = true;
        }
        if (isDetectSmile) {
          isSmile.value = true;
        }
      } else {
        isFaceInFrame.value = false;
      }
    }
    isProcessing.value = false;
  }

  InputImage? _inputImageFromCameraImage(CameraImage image) {
    if (cameras.isEmpty) return null;

    // get image rotation
    // it is used in android to convert the InputImage from Dart to Java: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/android/src/main/java/com/google_mlkit_commons/InputImageConverter.java
    // `rotation` is not used in iOS to convert the InputImage from Dart to Obj-C: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/google_mlkit_commons/ios/Classes/MLKVisionImage%2BFlutterPlugin.m
    // in both platforms `rotation` and `camera.lensDirection` can be used to compensate `x` and `y` coordinates on a canvas: https://github.com/flutter-ml/google_ml_kit_flutter/blob/master/packages/example/lib/vision_detector_views/painters/coordinates_translator.dart
    final camera = cameras.firstWhere(
      (camera) =>
          camera.lensDirection == cameraController.description.lensDirection,
    );
    final sensorOrientation = camera.sensorOrientation;
    // print(
    //     'lensDirection: ${camera.lensDirection}, sensorOrientation: $sensorOrientation, ${_controller?.value.deviceOrientation} ${_controller?.value.lockedCaptureOrientation} ${_controller?.value.isCaptureOrientationLocked}');
    InputImageRotation? rotation;
    if (Platform.isIOS) {
      rotation = InputImageRotationValue.fromRawValue(sensorOrientation);
    } else if (Platform.isAndroid) {
      var rotationCompensation =
          _orientations[cameraController.value.deviceOrientation];
      if (rotationCompensation == null) return null;
      if (camera.lensDirection == CameraLensDirection.front) {
        // front-facing
        rotationCompensation = (sensorOrientation + rotationCompensation) % 360;
      } else {
        // back-facing
        rotationCompensation =
            (sensorOrientation - rotationCompensation + 360) % 360;
      }
      rotation = InputImageRotationValue.fromRawValue(rotationCompensation);
      // print('rotationCompensation: $rotationCompensation');
    }
    if (rotation == null) return null;
    // print('final rotation: $rotation');

    // get image format
    final format = InputImageFormatValue.fromRawValue(image.format.raw);
    debugPrint('FaceDetector: format: $format');
    // validate format depending on platform
    // only supported formats:
    // * nv21 for Android
    // * bgra8888 for iOS
    if (format == null ||
        (Platform.isAndroid && format != InputImageFormat.nv21) ||
        (Platform.isIOS && format != InputImageFormat.bgra8888)) return null;

    // since format is constraint to nv21 or bgra8888, both only have one plane
    debugPrint('plane: ${image.planes.length}');
    // if (image.planes.length != 1) return null;
    final plane = image.planes.first;
    // final WriteBuffer allBytes = WriteBuffer();
    // for (final Plane plane in image.planes) {
    //   allBytes.putUint8List(plane.bytes);
    // }
    // compose InputImage using bytes
    return InputImage.fromBytes(
      bytes: plane.bytes,
      metadata: InputImageMetadata(
        size: Size(image.width.toDouble(), image.height.toDouble()),
        rotation: rotation, // used only in Android
        format: format, // used only in iOS
        bytesPerRow: plane.bytesPerRow, // used only in iOS
      ),
    );
  }
}
