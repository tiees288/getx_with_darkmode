import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter_ui/module/liveness_camera/liveness_camera_controller.dart';

class LivenessCameraPage extends StatelessWidget {
  LivenessCameraPage({super.key});

  final _controller = Get.find<LivenessCameraController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Liveness Camera'),
      ),
      body: const Center(
        child: Text('Liveness Camera Page'),
      ),
    );
  }
}
