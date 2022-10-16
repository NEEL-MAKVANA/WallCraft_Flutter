import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:wallcraft/views/loading_splash.dart';
import 'package:wallcraft/views/login_page.dart';
import 'package:wallcraft/views/splash_screen.dart';

import 'controller/auth_controller.dart';
import 'views/Home.dart';

// void main() {
//   runApp(const WallCraft());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp().then((value) => Get.put(AuthController()));
  runApp(const WallCraft());
}

class WallCraft extends StatelessWidget {
  const WallCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallCraft',
      theme: ThemeData(
        primaryColor: Colors.blue,
      ),
      // home: SplashScreen(),
      // home: LoginPage(),
      home: Loading(),
    );
  }
}




