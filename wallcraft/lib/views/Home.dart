import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:wallcraft/data/data.dart';
import 'package:wallcraft/model/wallpaper_model.dart';
import 'package:wallcraft/views/category.dart';
import 'package:wallcraft/views/search.dart';
import 'package:wallcraft/widgets/widget.dart';

import '../model/categories_model.dart';
import 'package:http/http.dart' as http;

import 'image_view.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  // ScrollController _scrollController = new ScrollController();

  TextEditingController searchController = new TextEditingController();

  getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=15"),
        headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    jsonData["photos"].forEach((element) {
      // print(element);
      SrcModel srcModel = new SrcModel();
      WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperModel.avg_color = element["avg_color"];
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {
    getTrendingWallpapers();
    categories = getCategories();
    super.initState();

    // _scrollController.addListener(() {
    //   print(_scrollController.position.pixels);
    //   if(_scrollController.position.pixels == _scrollController.position.maxScrollExtent){
    //     getTrendingWallpapers();
    //     print("max scroll");
    //   }
    // });
  }

  // @override
  // void dispose() {
  //   // TODO: implement dispose
  //   _scrollController.dispose();
  //   super.dispose();
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: brandName(),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(20),
                border: Border(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: searchController,
                      decoration: InputDecoration(
                        // focusedBorder: OutlineInputBorder(
                        //   borderSide: BorderSide(color: Colors.black),
                        //   borderRadius: BorderRadius.circular(24),
                        // ),s

                        hintText: "search wallpaper",
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (contextr) => Search(
                                    searchQuery: searchController.text,
                                  )));
                    },
                    child: Container(child: Icon(Icons.search)),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 16,
            ),
            Container(
              height: 80,
              child: ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 24),
                itemCount: categories.length,
                shrinkWrap: true,
                scrollDirection: Axis.horizontal,
                itemBuilder: (context, index) {
                  return CategoriesTile(
                    title: categories[index].categoriesName,
                    imgUrl: categories[index].imgUrl,
                  );
                },
              ),
            ),
            SizedBox(
              height: 16,
            ),
            // Container(
            //   height: MediaQuery.of(context).size.height,
            //   child: ListView.builder(
            //     // padding: EdgeInsets.symmetric(horizontal: 24),
            //     controller: _scrollController,
            //     itemCount: wallpapers.length,
            //     shrinkWrap: true,
            //     scrollDirection: Axis.vertical,
            //     itemBuilder: (context, index) {
            //       return WallpapersList(wallpapers: wallpapers, context: context);
            //     },
            //   ),
            // ),
            WallpapersList(wallpapers: wallpapers, context: context),
            SizedBox(
              height: 16,
            ),
          ]),
        ),
      ),
    );
  }
}

class CategoriesTile extends StatelessWidget {
  late String imgUrl, title;
  CategoriesTile({this.title = "", this.imgUrl = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(
            builder: (context) => Categorie(
              categorieName: title.toLowerCase(),
            )
        ));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  imgUrl,
                  height: 50,
                  width: 100,
                  fit: BoxFit.cover,
                )),
            Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.black26,
                borderRadius: BorderRadius.circular(8),
              ),
              height: 50,
              width: 100,
//we reached at 47 minutes
              child: Text(
                title,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
