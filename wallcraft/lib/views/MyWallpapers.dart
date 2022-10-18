import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';
import 'ImageUpload.dart';

class MyWallpapers extends StatefulWidget {
  MyWallpapers({Key? key}) : super(key: key);

  // List<Map<String, dynamic>> files = [];

  @override
  State<MyWallpapers> createState() => _MyWallpapersState();
}

class _MyWallpapersState extends State<MyWallpapers> {

  List<WallpaperModel> wallpapers = [];

  @override
  void initState() {
    // TODO: implement initState
    // wallpapers = [];
    fetchImages(FirebaseAuth.instance.currentUser?.uid as String);
    print("inside my wall init method");
    super.initState();
    setState(() {});
  }

  Future<void> fetchImages(String uniqueUserId) async {
    // List<Map<String, dynamic>> files = [];

    try {
      final result = await InternetAddress.lookup('example.com');
      if(result.isNotEmpty && result[0].rawAddress.isNotEmpty){

      }
    } on SocketException catch (_) {
      SrcModel src = new SrcModel();
      WallpaperModel wallpaperModel = new WallpaperModel(src: src, avg_color: '#000000');
      wallpapers.add(wallpaperModel);
      setState(() {});
      return;
    }

    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('uploaded_wallpapers')
        // .child(uniqueUserId)
        .list();
    final List<Reference> allFiles = result.items;
    print(allFiles.length);

    for(int i=0; i<allFiles.length; i++){
      var str = allFiles[i].fullPath.split('@');
      if(str[str.length-1] == uniqueUserId){
        SrcModel src = new SrcModel();
        WallpaperModel wallpaperModel = new WallpaperModel(src: src, avg_color: '#000000');
        wallpapers.add(wallpaperModel);
      }
      // print(src.portrait);
    }
    setState(() {});
    var i=0;
    await Future.forEach<Reference>(allFiles, (file) async {
      print(file.fullPath);
      var str = file.fullPath.split('@');
      if(str[str.length-1] == uniqueUserId){
        final String fileUrl = await file.getDownloadURL();

        // SrcModel src = new SrcModel(portrait: fileUrl);
        // WallpaperModel wallpaperModel = new WallpaperModel(src: src, avg_color: '#000000');
        // wallpapers.add(wallpaperModel);
        // print(src.portrait);
        wallpapers[i].src.portrait = fileUrl;
        i++;
      }

    });
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(MediaQuery.of(context).size.width, MediaQuery.of(context).size.height),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(color: Colors.blue),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(
                height: 16,
              ),
              WallpapersList(wallpapers: wallpapers, context: context),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: ImageUpload(),
    );
  }
}
