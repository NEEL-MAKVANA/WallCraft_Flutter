import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:wallcraft/views/search.dart';

import 'Favorites.dart';
import 'Home.dart';
import 'MyWallpapers.dart';
import 'login_page.dart';

class MyWallpapersSplash extends StatefulWidget {
  @override
  _MyWallpapersSplash createState() => _MyWallpapersSplash();
}

class _MyWallpapersSplash extends State<MyWallpapersSplash>
    with TickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: (5)),
      vsync: this,
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          'assets/myWallpaper.json',
          controller: _controller,
          // height: MediaQuery.of(context).size.height * 0.5,
          // width: MediaQuery.of(context).size.width * 0.5,
          height: double.infinity,
          width: double.infinity,
          animate: true,
          onLoaded: (composition) {
            _controller
              ..duration = composition.duration
              ..forward().whenComplete(() => Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => MyWallpapers(
                )),
              ));
          },
        ),
      ),
    );
  }
}