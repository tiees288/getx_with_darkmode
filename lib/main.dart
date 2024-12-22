import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getx_flutter_ui/module/chat_with_support/chat_with_support_binding.dart';
import 'package:getx_flutter_ui/module/chat_with_support/chat_with_support_page.dart';
import 'package:getx_flutter_ui/module/liveness_camera/liveness_camera_binding.dart';
import 'package:getx_flutter_ui/module/liveness_camera/liveness_camera_page.dart';
import 'package:getx_flutter_ui/service/socket_service.dart';

// Controller for managing theme mode
class ThemeController extends GetxController {
  Rx<ThemeMode> themeMode = ThemeMode.light.obs;

  void toggleTheme() {
    themeMode.value =
        themeMode.value == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
  }
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final ThemeController themeController = Get.put(ThemeController());

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return GetMaterialApp(
        title: 'Flutter Demo',
        theme: lightTheme,
        initialBinding: BindingsBuilder(() {
          Get.lazyPut(
            () => SocketService(),
          );
        }),
        getPages: [
          GetPage(
            name: '/',
            page: () => HomeScreen(),
          ),
          GetPage(
            name: '/chat',
            page: () => ChatWithSupportPage(),
            transition: Transition.native,
            binding: ChatWithSupportBinding(),
          ),
          GetPage(
            name: '/liveness_camera',
            binding: LivenessCameraBinding(),
            page: () => LivenessCameraPage(),
            transition: Transition.native,
          ),
        ],
        darkTheme: darkTheme,
        themeMode: themeController.themeMode.value,
        home: HomeScreen(),
      );
    });
  }
}

final extraColorLight = ExtraColors(
  blackPink: Colors.pink,
  whitePink: Colors.white,
);

final extraColorDark = ExtraColors(
  blackPink: Colors.purple,
  whitePink: Colors.white,
);

// Light Theme
final ThemeData lightTheme = ThemeData(
  brightness: Brightness.light,
  primaryColor: Colors.blue,
  scaffoldBackgroundColor: Colors.white,
  extensions: <ThemeExtension<dynamic>>[
    extraColorLight,
  ],
  colorScheme: const ColorScheme.light(
    primary: Colors.blue,
    secondary: Colors.amber,
    surface: Colors.white,
  ),
);

// Dark Theme
final ThemeData darkTheme = ThemeData(
  brightness: Brightness.dark,
  primaryColor: Colors.blueGrey,
  scaffoldBackgroundColor: Colors.black,
  extensions: <ThemeExtension<dynamic>>[
    extraColorDark,
  ],
  colorScheme: const ColorScheme.dark(
    primary: Colors.blueGrey,
    secondary: Colors.amberAccent,
    surface: Colors.black,
  ),
);

class HomeScreen extends StatelessWidget {
  final ThemeController themeController = Get.find<ThemeController>();

  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Theme Mode Example'),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode),
            onPressed: () {
              themeController.toggleTheme();
            },
          ),
        ],
      ),
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Current Theme Mode: ${Get.theme.brightness}'),
            const Text(
              'Toggle Theme Mode',
              textAlign: TextAlign.center,
            ),
            Text(
              'Text with CustomColor called BlackPink',
              style: TextStyle(
                color: Theme.of(context).extension<ExtraColors>()?.blackPink,
              ),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/chat');
              },
              child: const Text('Chat with Support'),
            ),
            ElevatedButton(
              onPressed: () {
                Get.toNamed('/liveness_camera');
              },
              child: const Text('Camera'),
            ),
          ],
        ),
      ),
    );
  }
}

class ExtraColors extends ThemeExtension<ExtraColors> {
  final Color? blackPink;
  final Color? whitePink;

  ExtraColors({
    this.blackPink,
    this.whitePink,
  });

  @override
  ExtraColors copyWith({Color? blackPink}) {
    return ExtraColors(
        blackPink: blackPink ?? this.blackPink,
        whitePink: whitePink ?? whitePink);
  }

  @override
  ExtraColors lerp(ThemeExtension<ExtraColors>? other, double t) {
    if (other is! ExtraColors) {
      return this;
    }
    return ExtraColors(
      blackPink: Color.lerp(blackPink, other.blackPink, t),
      whitePink: Color.lerp(whitePink, other.whitePink, t),
    );
  }
}
