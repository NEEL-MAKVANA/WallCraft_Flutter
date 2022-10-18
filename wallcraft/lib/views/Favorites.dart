import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';

class Favorites extends StatefulWidget {
  @override
  State<Favorites> createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  // TextEditingController searchController = new TextEditingController();

  List<WallpaperModel> wallpapers = [];

  // getSearchWallpapers(String query) async {
  //   var response = await http.get(
  //       Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=15"),
  //       headers: {"Authorization": apiKey});
  //
  //   // print(response.body.toString());
  //
  //   Map<String, dynamic> jsonData = jsonDecode(response.body);
  //   jsonData["photos"].forEach((element) {
  //     // print(element);
  //     SrcModel srcModel = new SrcModel();
  //     WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
  //     wallpaperModel = WallpaperModel.fromMap(element);
  //     wallpaperModel.avg_color = element["avg_color"];
  //     wallpapers.add(wallpaperModel);
  //   });
  //
  //   setState(() {});
  // }

  CollectionReference favourites =
      FirebaseFirestore.instance.collection('Favourites');
  final FirebaseAuth auth = FirebaseAuth.instance;
  final FirebaseFirestore store = FirebaseFirestore.instance;

  String? UserId() {
    final User? user = auth.currentUser;
    final uid = user?.uid;
    return uid;
  }

  Future<void> getFavouriteWallpaper() async {
    // favourites
    //     .where("uid", isEqualTo : UserId())
    //     .get().then((value){
    //   value.docs.forEach((element) {
    //     print(element['portrait']);
    //     SrcModel src = new SrcModel(portrait: element['portrait']);
    //     WallpaperModel wallpaperModel = new WallpaperModel(src: src, photographer: element['photographer'], avg_color: element['avg_color']);
    //     wallpapers.add(wallpaperModel);
    //   });
    // });

    final snapshot = await favourites.where("uid", isEqualTo: UserId()).get();
    print("snapshot: ${snapshot.size}");
    for (int i = 0; i < snapshot.size; i++) {
      SrcModel src = new SrcModel();
      WallpaperModel wallpaperModel =
      new WallpaperModel(src: src, avg_color: '#000000');
      wallpapers.add(wallpaperModel);
    }
    setState(() {});

    try {
      final result = await InternetAddress.lookup('example.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {

      }
    } on SocketException catch (_) {
      // final snapshot = await favourites.where("uid", isEqualTo: UserId()).get();
      // print("snapshot: ${snapshot.size}");
      // for (int i = 0; i < snapshot.size; i++) {
      //   SrcModel src = new SrcModel();
      //   WallpaperModel wallpaperModel =
      //       new WallpaperModel(src: src, avg_color: '#000000');
      //   wallpapers.add(wallpaperModel);
      // }
      // setState(() {});
      return;
    }

    var i=0;
    favourites
        .where("uid", isEqualTo: UserId())
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((element) {
        print(element['portrait']);
        SrcModel src = new SrcModel(portrait: element['portrait']);
        WallpaperModel wallpaperModel = new WallpaperModel(
            src: src,
            photographer: element['photographer'],
            avg_color: element['avg_color']);
        wallpapers[i] = wallpaperModel;
        i++;
        setState(() {});
      });
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    print("inside init method");
    wallpapers = [];
    getFavouriteWallpaper();
    super.initState();
    this.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
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
              WallpapersList(
                  wallpapers: wallpapers, context: context, isfavourite: true),
              SizedBox(
                height: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
