import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:io' as IO;
// import 'package:wallpaper_manager/wallpaper_manager.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String photographer;
  final String bgColor;
  late final String color;
  ImageView(
      {required this.imgUrl,
      required this.photographer,
      required this.bgColor});

  @override
  State<ImageView> createState() => _ImageViewState();

  Color getColor(String color) {
    if (Color(int.parse(color)).computeLuminance() > 0.5)
      return Colors.black;
    else
      return Colors.white;
  }

  // Future<void> setWallpaperFromFile() async {
  //   String url = "https://images.unsplash.com/photo-1542435503-956c469947f6";
  //   int location = WallpaperManager.HOME_SCREEN;
  //   String result;
  //
  //   try {
  //     var file = await DefaultCacheManager().getSingleFile(url);
  //     final String result = await WallpaperManager.setWallpaperFromFile(file.path, location);
  //   } on PlatformException {
  //     result = 'Failed to get wallpaper.';
  //   }
  // }
}

class _ImageViewState extends State<ImageView> {
  @override
  void initState() {
    // TODO: implement initState
    print("bgColor : " + widget.bgColor);
    widget.color = widget.bgColor.replaceAll('#', '0xff');
    super.initState();
  }

  var filePath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Hero(
            tag: widget.imgUrl,
            child: Container(
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                child: Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                )),
          ),
          Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            alignment: Alignment.bottomCenter,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                // GestureDetector(
                //   onTap: () {
                //     _save();
                //   },
                //   child: Stack(
                //     children: [
                //       Container(
                //         width: MediaQuery.of(context).size.width / 2,
                //         height: 50,
                //         color: Color(0xff1C1B1B).withOpacity(0.8),
                //       ),
                //       Container(
                //         width: MediaQuery.of(context).size.width / 2,
                //         height: 50,
                //         padding:
                //             EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                //         decoration: BoxDecoration(
                //             border: Border.all(
                //               color: Colors.white54,
                //               width: 1,
                //             ),
                //             borderRadius: BorderRadius.circular(30),
                //             gradient: LinearGradient(colors: [
                //               Color(0x36ffffff),
                //               Color(0x0fffffff),
                //             ])),
                //         child: Column(
                //           children: [
                //             Text("Set Wallpaper",
                //                 style: TextStyle(
                //                     fontSize: 16, color: Colors.white70)),
                //             Text(
                //               "Image Will Be Saved In Gallery",
                //               style: TextStyle(
                //                   fontSize: 10, color: Colors.white70),
                //             ),
                //           ],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // SizedBox(
                //   height: 16,
                // ),
                // Text(
                //   "Cancel",
                //   style: TextStyle(
                //     color: Colors.white,
                //   ),
                // ),
                // SizedBox(
                //   height: 50,
                // )

                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.spaceAround,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.share,
                              color: widget.getColor(widget.color),
                              size: 50.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onPressed: () {
                              print("Share");
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.download,
                              color: widget.getColor(widget.color),
                              size: 50.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onPressed: () {
                              _save();
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                            icon: Icon(Icons.favorite,
                                size: 50.0,
                                semanticLabel:
                                    'Text to announce in accessibility modes',
                                color: widget.getColor(widget.color)),
                            onPressed: () {
                              _save();
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.wallpaper,
                              color: widget.getColor(widget.color),
                              size: 50.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                            ),
                            onPressed: () {
                              print("Wallpaper");
                              // widget.setWallpaperFromFile;
                            }),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                // Container(
                //   child: Text(widget.photographer, style: TextStyle(color: Colors.white70),),
                // ),
                // Container(
                //   child: Text(widget.bgColor.toString(), style: TextStyle(color: Colors.white),),
                // )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    if (IO.Platform.isAndroid) {
      await _askPermission();
    }
    var response = await Dio()
        .get(widget.imgUrl, options: Options(responseType: ResponseType.bytes));
    final result =
        await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async {
    if (IO.Platform.isIOS) {
      Map<Permission, PermissionStatus> permissions =
          await [Permission.photos].request();
    } else {
      PermissionStatus permission = await Permission.storage.status;

      // if (permission.isDenied == true) {
      //   // Either the permission was already granted before or the user just granted it.
      //
      //   print("Image save permission not granted");
      // }
      // else{
      //   // Either the permission was already granted before or the user just granted it.
      //
      //   print("Image save permission is granted");
      // }
      // if (permission.isGranted) {
      //   print("Image save permission is granted");
      // }
    }
  }
}