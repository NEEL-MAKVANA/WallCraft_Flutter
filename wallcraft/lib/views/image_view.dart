import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:material_dialogs/material_dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'dart:io' show File, Platform;
import 'dart:io' as IO;
import 'package:http/http.dart' as http;

import 'package:share_plus/share_plus.dart';
// import 'package:wallpaper_manager/wallpaper_manager.dart';
// import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'dart:async';

import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
// import 'package:wallpaper_manager/wallpaper_manager.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:wallpaper_manager_flutter/wallpaper_manager_flutter.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'Favorites.dart';
import 'favourite_splash.dart';

class ImageView extends StatefulWidget {
  final String imgUrl;
  final String photographer;
  final String bgColor;
  late final String color;
  bool isfavourite;
  Color iconColor = Colors.white;

  ImageView(
      {required this.imgUrl,
      required this.photographer,
      required this.bgColor,
      this.iconColor = Colors.white,
      this.isfavourite = false});

  @override
  State<ImageView> createState() => _ImageViewState();

  CollectionReference favourites =
      FirebaseFirestore.instance.collection('Favourites');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  String? UserId() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  Color getColor(String color) {
    if (Color(int.parse(color)).computeLuminance() > 0.5)
      return Colors.black;
    else
      return Colors.white;
  }

  Future<void> removeFavourites(context) async {
    await favourites
        .where("uid", isEqualTo: UserId())
        .where("portrait", isEqualTo: imgUrl)
        .get()
        .then((value) {
      value.docs.forEach((element) {
        favourites.doc(element.id).delete().then((value) {
          print("Success!");
        });
      });
    });

    // await Navigator.pushAndRemoveUntil(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) =>
    //           Favorites()), // this mymainpage is your page to refresh
    //       (Route<dynamic> route) => false,
    // );

    if(this.isfavourite == true){
      Navigator.pop(context);
      Navigator.pop(context);
      Navigator.push<void>(
        context,
        MaterialPageRoute<void>(
          builder: (BuildContext context) =>  Favorites(),
        ),
      );
    }
  }

  Future<void> addFavourites() async {
    // int i = 0;
    // favourites
    //     .where("portrait", isEqualTo : imgUrl)
    //     .get()
    //     .then((QuerySnapshot querySnapshot) {
    //   querySnapshot.docs.forEach((element) {
    //     i++;
    //   });
    //   print("i is $i");
    // });
    //
    // if(i == 0){
    //   print("i is $i");
    //   return favourites
    //       .doc()
    //       .set({
    //     'portrait': imgUrl,
    //     'uid': UserId(),
    //     'avg_color': bgColor, // John Doe
    //     'photographer': photographer, // Stokes and Sons// 42
    //   }, SetOptions(merge: false),)
    //       .then((value) => print("User Added"))
    //       .catchError((error) => print("Failed to add user: $error"));
    // }

    return favourites
        .add({
          'portrait': imgUrl,
          'uid': UserId(),
          'avg_color': bgColor, // John Doe
          'photographer': photographer, // Stokes and Sons// 42
        })
        .then((value) => print("Added to favourites"))
        .catchError((error) => print("Failed to add to favourites: $error"));
  }

  Future<void> shareWallpaper(final String urlImage) async {
    final url = Uri.parse(urlImage);
    final response = await http.get(url);
    final bytes = response.bodyBytes;

    final temp = await getTemporaryDirectory();
    final path = '${temp.path}/image.jpg';
    File(path).writeAsBytesSync(bytes);

    await Share.shareFiles([path], text: urlImage);
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
    widget.iconColor = widget.getColor(widget.color);

    if (widget.isfavourite == true) {
      widget.iconColor = Colors.red;
    }
    super.initState();
  }

  //new added 1:

  // final imageurl =
  //     'https://unsplash.com/photos/AnBzL_yOWBc/download?force=true&w=2400';

  Future<void> _setwallpaper(location, String imageurl) async {
    var file = await DefaultCacheManager().getSingleFile(imageurl);
    try {
      WallpaperManagerFlutter().setwallpaperfromFile(file, location);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Wallpaper updated'),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error Setting Wallpaper'),
        ),
      );
      print(e);
    }
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
                child: widget.imgUrl != '' ?Image.network(
                  widget.imgUrl,
                  fit: BoxFit.cover,
                ):
                Image(image: AssetImage('assets/wallLoad.gif')),
            ),
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
                              widget.shareWallpaper(widget.imgUrl);
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
                              Dialogs.materialDialog(
                                  color: Colors.white,
                                  msg:
                                      'Do you want to download the wallpaper ?',
                                  title: 'Download',
                                  // animation: 'assets/cong_example.json',
                                  lottieBuilder: Lottie.asset(
                                    'assets/lottie_download.json',
                                    fit: BoxFit.contain,
                                  ),
                                  context: context,
                                  actions: [
                                    IconsButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                      },
                                      text: 'Cancel',
                                      iconData: Icons.cancel,
                                      color: Colors.red,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                    IconsButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        _save();
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          SnackBar(
                                            action: SnackBarAction(
                                              label: '',
                                              onPressed: () {
                                                // Code to execute.
                                              },
                                            ),
                                            content: const Text(
                                                'Wallpaper Downloaded Successfully.'),
                                            duration: const Duration(
                                                milliseconds: 2500),
                                            // width: 280.0, // Width of the SnackBar.
                                            // padding: const EdgeInsets.symmetric(
                                            //   horizontal: 8.0, // Inner padding for SnackBar content.
                                            // ),
                                            behavior: SnackBarBehavior.floating,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                          ),
                                        );
                                      },
                                      text: 'Yes',
                                      iconData: Icons.done,
                                      color: Colors.green,
                                      textStyle: TextStyle(color: Colors.white),
                                      iconColor: Colors.white,
                                    ),
                                  ]);
                            }),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(13.0),
                        child: IconButton(
                            icon: Icon(
                              Icons.favorite,
                              size: 50.0,
                              semanticLabel:
                                  'Text to announce in accessibility modes',
                              // color: widget.getColor(widget.color)
                              color: widget.iconColor,
                            ),
                            onPressed: () {
                              setState(() {
                                if (widget.iconColor != Colors.red) {
                                  widget.addFavourites();
                                  widget.iconColor = Colors.red;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      action: SnackBarAction(
                                        label: '',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                      content: const Text(
                                          'Wallpaper added to favourites.'),
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      // width: 280.0, // Width of the SnackBar.
                                      // padding: const EdgeInsets.symmetric(
                                      //   horizontal: 8.0, // Inner padding for SnackBar content.
                                      // ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  );
                                } else {
                                  widget.removeFavourites(context);
                                  widget.iconColor =
                                      widget.getColor(widget.color);

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      action: SnackBarAction(
                                        label: '',
                                        onPressed: () {
                                          // Code to execute.
                                        },
                                      ),
                                      content: const Text(
                                          'Wallpaper Removed from favourites.'),
                                      duration:
                                          const Duration(milliseconds: 2500),
                                      // width: 280.0, // Width of the SnackBar.
                                      // padding: const EdgeInsets.symmetric(
                                      //   horizontal: 8.0, // Inner padding for SnackBar content.
                                      // ),
                                      behavior: SnackBarBehavior.floating,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                    ),
                                  );
                                }
                              });
                              print("Favourite");
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
                              // _setwallpaper(WallpaperManagerFlutter.HOME_SCREEN, widget.imgUrl);
                              showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                  top: Radius.circular(30),
                                )),
                                context: context,
                                builder: (BuildContext context) {
                                  return SizedBox(
                                      height: 250,
                                      child: SizedBox(
                                        height: 200.0,
                                        child: Column(
                                          children: [
                                            const SizedBox(
                                              height: 30,
                                            ),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                // primary: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                                backgroundColor:
                                                    Colors.blue,
                                                // side: BorderSide(width:3, color:Colors.brown), //border width and color
                                                minimumSize:
                                                    const Size(200, 40), // NEW
                                              ), // <-- ElevatedButton
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _setwallpaper(
                                                    WallpaperManagerFlutter
                                                        .HOME_SCREEN,
                                                    widget.imgUrl);
                                              },
                                              icon: Icon(
                                                Icons.home_outlined,
                                                size: 30.0,
                                              ),
                                              label: Text('Set As Home Screen'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ElevatedButton.icon(
                                              style: ElevatedButton.styleFrom(
                                                // primary: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                                backgroundColor:
                                                    Colors.blue,
                                                // side: BorderSide(width:3, color:Colors.brown), //border width and color
                                                minimumSize:
                                                    const Size(200, 40), // NEW
                                              ), // <-- ElevatedButton
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _setwallpaper(
                                                    WallpaperManagerFlutter
                                                        .LOCK_SCREEN,
                                                    widget.imgUrl);
                                              },
                                              icon: Icon(
                                                Icons.lock_outline,
                                                size: 30.0,
                                              ),
                                              label: Text('Set As Lock Screen'),
                                            ),
                                            const SizedBox(
                                              height: 20,
                                            ),
                                            ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                // primary: Colors.blue,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          12), // <-- Radius
                                                ),
                                                backgroundColor:
                                                    Colors.blue,
                                                // side: BorderSide(width:3, color:Colors.brown), //border width and color
                                                minimumSize:
                                                    const Size(200, 40), // NEW
                                              ),
                                              onPressed: () {
                                                Navigator.pop(context);
                                                _setwallpaper(
                                                    WallpaperManagerFlutter
                                                        .BOTH_SCREENS,
                                                    widget.imgUrl);
                                              },
                                              child: const Text(
                                                'Set As Both Screen',
                                                // style: TextStyle(fontSize: 24),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ));
                                },
                              );
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
    // Navigator.pop(context);
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
