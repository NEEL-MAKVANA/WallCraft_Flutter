import 'package:flutter/material.dart';

import '../model/wallpaper_model.dart';
import '../views/image_view.dart';

Widget brandName() {
  return RichText(
    text: TextSpan(
      style: TextStyle(fontSize: 17, fontWeight: FontWeight.w500),
      children: const <TextSpan>[
        TextSpan(text: 'Wall', style: TextStyle(color: Colors.black87)),
        TextSpan(text: 'Craft', style: TextStyle(color: Colors.blue)),
      ],
    ),
  );
}

Widget WallpapersList({required List<WallpaperModel> wallpapers, context}) {
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
        return GridTile(
            child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ImageView(
                          imgUrl: wallpapers.src.portrait,
                        )));
          },
          child: Hero(
            tag: wallpapers.src.portrait ,
            child: Container(
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.network(
                      wallpapers.src.portrait,
                      fit: BoxFit.cover,
                    ))),
          ),
        ));
      }).toList(),
    ),
  );
}
