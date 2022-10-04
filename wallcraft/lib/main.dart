import 'package:flutter/material.dart';
import 'package:wallcraft/views/splash_screen.dart';

import 'views/Home.dart';

void main() {
  runApp(const WallCraft());
}

class WallCraft extends StatelessWidget {
  const WallCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'WallCraft',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: SplashScreen(),
    );
  }
}



