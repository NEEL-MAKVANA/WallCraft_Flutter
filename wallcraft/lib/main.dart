import 'package:flutter/material.dart';

import 'views/Home.dart';

void main() {
  runApp(const WallCraft());
}

class WallCraft extends StatelessWidget {
  const WallCraft({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Wallyfy',
      theme: ThemeData(
        primaryColor: Colors.white,
      ),
      home: Home(),
    );
  }
}



