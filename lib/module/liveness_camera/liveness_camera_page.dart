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
        // leading: const SizedBox(),
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
              ? Stack(
                  children: [
                    CameraPreview(
                      _controller.cameraController,
                    ),
                    _buildFaceOverlay(),
                  ],
                )
              : const Center(
                  child: CircularProgressIndicator(),
                ))),
    );
  }

  _buildFaceOverlay() {
    return Container(
      width: MediaQuery.of(context).size.width,
      height: MediaQuery.of(context).size.height,
      child: CustomPaint(
        painter: FacePainter(),
      ),
    );
  }
}

class FacePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw a face Shape on the screen
    final paint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4.0;
    final path = Path();
    // จุดเริ่มต้น (บนสุดตรงกลาง)
    path.moveTo(size.width * 0.10, 200);

    path.quadraticBezierTo(size.width * 0.5, -50, size.width * 0.9, 200);
    path.lineTo(size.width * 0.9, size.height * 0.5);
    path.quadraticBezierTo(size.width * 0.5, size.height * 0.9,
        size.width * 0.1, size.height * 0.5);
    path.lineTo(size.width * 0.1, 200);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
