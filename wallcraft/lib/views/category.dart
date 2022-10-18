import 'dart:convert';
import 'ImageUpload.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../data/data.dart';
import '../model/wallpaper_model.dart';
import '../widgets/widget.dart';

class Categorie extends StatefulWidget {
  final String categorieName;
  Categorie({required this.categorieName});

  @override
  State<Categorie> createState() => _CategorieState();
}

class _CategorieState extends State<Categorie> {
  TextEditingController searchController = new TextEditingController();

  List<WallpaperModel> wallpapers = [];


  void initializeWallpapers(){
    for(int i=0; i<80; i++){
      SrcModel srcModel = new SrcModel();
      // https://miro.medium.com/max/1080/0*DqHGYPBA-ANwsma2.gif
      // srcModel.portrait = 'assets/wallLoad.gif';
      WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
      // wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperModel.avg_color = "#ffffff";
      wallpapers.add(wallpaperModel);
    }
  }

  getSearchWallpapers(String query) async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/search?query=$query&per_page=80"),
        headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    var i=0;
    jsonData["photos"].forEach((element) {
      // print(element);
      SrcModel srcModel = new SrcModel();
      WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperModel.avg_color = element["avg_color"];
      // wallpapers.add(wallpaperModel);
      wallpapers[i] = wallpaperModel;
      i++;
    });

    setState(() {});
  }

  @override
  void initState() {
    // TODO: implement initState
    initializeWallpapers();
    getSearchWallpapers(widget.categorieName);
    super.initState();
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
