import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter_ui/module/liveness_camera/liveness_camera_controller.dart';
import 'package:camera/camera.dart';

class LivenessCameraPage extends StatefulWidget {
  LivenessCameraPage({super.key});

  @override
  State<LivenessCameraPage> createState() => _LivenessCameraPageState();
}

class _LivenessCameraPageState extends State<LivenessCameraPage>
    with WidgetsBindingObserver {
  final _controller = Get.find<LivenessCameraController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: const SizedBox(),
        centerTitle: true,
        title: const Text('Please blink your eyes'),
      ),
      body: Container(
          decoration: const BoxDecoration(
            color: Colors.black,
          ),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Obx(() => _controller.isCameraReady.value
              ? CameraPreview(
                  _controller.cameraController,
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }
}
