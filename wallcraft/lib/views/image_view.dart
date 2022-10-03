import 'package:dio/dio.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'dart:io' show Platform;
import 'dart:io' as IO;

class ImageView extends StatefulWidget {
  final String imgUrl;
  ImageView({required this.imgUrl});

  @override
  State<ImageView> createState() => _ImageViewState();
}

class _ImageViewState extends State<ImageView> {

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

            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [

                GestureDetector(
                  onTap:(){
                    _save();
                  },
                  child: Stack(

                    children: [
                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: 50,
                        color: Color(0xff1C1B1B).withOpacity(0.8),
                      ),

                      Container(
                        width: MediaQuery.of(context).size.width/2,
                        height: 50,
                        padding: EdgeInsets.symmetric(horizontal: 8,vertical: 8),
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.white54,
                              width: 1,
                            ),
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(
                                colors: [
                                  Color(0x36ffffff),
                                  Color(0x0fffffff),
                                ]
                            )
                        ),
                        child: Column(
                          children: [
                            Text(
                                "Set Wallpaper",
                                style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white70
                                )
                            ),
                            Text("Image Will Be Saved In Gallery",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.white70
                              ),),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Text(
                  "Cancel",
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  height: 50,
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  _save() async {
    if(IO.Platform.isAndroid){
      await _askPermission();
    }
    var response = await Dio().get(
      widget.imgUrl,
      options: Options(responseType: ResponseType.bytes));
    final result = await ImageGallerySaver.saveImage(Uint8List.fromList(response.data));
    print(result);
    Navigator.pop(context);
  }

  _askPermission() async{
    if(IO.Platform.isIOS){
      Map<Permission, PermissionStatus> permissions = await[ Permission.photos].request();
    }else{
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
