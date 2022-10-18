// import 'dart:js';

// import 'dart:js';

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controller/auth_controller.dart';
import '../model/wallpaper_model.dart';
import '../views/image_view.dart';

Widget brandName(double w, double h) {
  print("width: $w");
  return Container(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          width: w * 0.00,
        ),
        RichText(
          text: TextSpan(
            style: TextStyle(
              fontSize: 23,
              fontWeight: FontWeight.w500,
            ),
            children: const <TextSpan>[
              TextSpan(text: 'Wall', style: TextStyle(color: Colors.black87)),
              TextSpan(text: 'Craft', style: TextStyle(color: Colors.blue)),
            ],
          ),
        ),

        // SizedBox(
        //   width: w*0.173,
        // ),

        Container(
          child: IconButton(
            color: Colors.blue,
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              // Navigator.pop(context);
              AuthController.instance.logOut();
            },
          ),
        ),
      ],
    ),
  );
}

Widget WallpapersList(
    {required List<WallpaperModel> wallpapers,
    context,
    bool isfavourite = false}) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 16),
    child: GridView.count(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      crossAxisCount: 2,
      childAspectRatio: 0.6,
      mainAxisSpacing: 6.0,
      crossAxisSpacing: 6.0,
      children: wallpapers.map((wallpapers) {
        // print(wallpapers.src.portrait);
        return GridTile(
            child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageView(
                          imgUrl: wallpapers.src.portrait,
                          photographer: wallpapers.photographer,
                          bgColor: wallpapers.avg_color.toString(),
                          isfavourite: isfavourite,
                        )));
          },
          child: Hero(
            tag: wallpapers.src.portrait,
            child: Container(
                child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: wallpapers.getPortrait() != ''
                  ? Image.network(
                      wallpapers.src.portrait,
                      fit: BoxFit.cover,
                    )
                  : Image(image: AssetImage('assets/wallLoad.gif')),
            )),
          ),
        ));
      }).toList(),
    ),
  );
}
