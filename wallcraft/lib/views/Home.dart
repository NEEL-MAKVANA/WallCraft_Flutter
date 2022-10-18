import 'dart:convert';
import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:wallcraft/data/data.dart';
import 'package:wallcraft/model/wallpaper_model.dart';
import 'package:wallcraft/views/Favorites.dart';
import 'package:wallcraft/views/category.dart';
import 'package:wallcraft/views/search.dart';
import 'package:wallcraft/widgets/widget.dart';

import '../controller/auth_controller.dart';
import '../model/categories_model.dart';
import 'package:http/http.dart' as http;
import 'ImageUpload.dart';
import 'MyWallpapers.dart';
import 'MyWallpapersSplash.dart';
import 'Search_splash.dart';
import 'favourite_splash.dart';
import 'image_view.dart';
import 'my_drawer_header.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class Home extends StatefulWidget {
  // const Home({Key? key}) : super(key: key);

  late int random_num;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  var currentPage = DrawerSections.Home;

  List<CategoriesModel> categories = [];
  List<WallpaperModel> wallpapers = [];

  // ScrollController _scrollController = new ScrollController();

  TextEditingController searchController = new TextEditingController();

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

  getTrendingWallpapers() async {
    var response = await http.get(
        Uri.parse("https://api.pexels.com/v1/curated?per_page=80&page=${widget.random_num}"),
        headers: {"Authorization": apiKey});

    // print(response.body.toString());

    Map<String, dynamic> jsonData = jsonDecode(response.body);
    // wallpapers.clear();
    var i=0;
    jsonData["photos"].forEach((element) {
      // print(element);
      SrcModel srcModel = new SrcModel();
      // srcModel.portrait = 'https://images.pexels.com/photos/1853043/pexels-photo-1853043.jpeg?auto=compress&cs=tinysrgb&fit=crop&h=1200&w=800';
      WallpaperModel wallpaperModel = new WallpaperModel(src: srcModel);
      wallpaperModel = WallpaperModel.fromMap(element);
      wallpaperModel.avg_color = element["avg_color"];
      // wallpapers.add(wallpaperModel);
      wallpapers[i] = wallpaperModel;
      i++;
    });

    final ListResult result = await FirebaseStorage.instance
        .ref()
        .child('uploaded_wallpapers')
        // .child(FirebaseAuth.instance.currentUser?.uid as String)
        .list();
    final List<Reference> allFiles = result.items;
    // print(allFiles.length);

    await Future.forEach<Reference>(allFiles, (file) async {
      final String fileUrl = await file.getDownloadURL();

      SrcModel src = new SrcModel(portrait: fileUrl);
      WallpaperModel wallpaperModel =
          new WallpaperModel(src: src, avg_color: '#000000');
      wallpapers.add(wallpaperModel);
    });

    setState(() {});
  }

  @override
  void initState() {

    // var intValue = Random().nextInt(10); // Value is >= 0 and < 10.
    widget.random_num = Random().nextInt(100)+1;
    print("pixel page number: ${widget.random_num}");
    initializeWallpapers();
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
        title: brandName(MediaQuery.of(context).size.width,
            MediaQuery.of(context).size.height),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0.0,
        iconTheme: IconThemeData(
          color: Colors.blue,
        ),
      ),

      //drawer :

      drawer: Drawer(
        child: SingleChildScrollView(
          child: Container(
            child: Column(
              children: [
                MyHeaderDrawer(),
                MyDrawerList(),
              ],
            ),
          ),
        ),
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
                              // builder: (contextr) => Search(
                              //       searchQuery: searchController.text,
                              //     )));
                              builder: (contextr) => SearchSplash(
                                    text: searchController.text,
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
      floatingActionButton: ImageUpload(),

      // bottomNavigationBar: BottomNavigationBar(
      //   type: BottomNavigationBarType.fixed, // Fixed
      //   backgroundColor: Colors.blue, // <-- This works for fixed
      //   selectedItemColor: Colors.greenAccent,
      //   unselectedItemColor: Colors.white,
      //   onTap: (value) {
      //     // Respond to item press.
      //     setState(() => _currentIndex = value);
      //
      //   },
      //   items: [
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.menu),
      //       label: 'menu',
      //     ),
      //     BottomNavigationBarItem(
      //       icon: Icon(Icons.favorite),
      //       label: 'favourite',
      //
      //     ),
      //
      //   ],
      // ),
      // floatingActionButton:
      // FloatingActionButton(child: Icon(Icons.add,), onPressed: () {}),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }

  //new data added::

  Widget MyDrawerList() {
    return Container(
      padding: EdgeInsets.only(
        top: 15,
      ),
      child: Column(
        // shows the list of menu drawer
        children: [
          menuItem(1, "Home", Icons.home,
              currentPage == DrawerSections.Home ? true : false),
          menuItem(2, "Favorites", Icons.favorite,
              currentPage == DrawerSections.Favourites ? true : false),
          menuItem(3, "My Wallpapers", Icons.image,
              currentPage == DrawerSections.MyWallpapers ? true : false),
          Divider(),
          menuItem(4, "Contacts", Icons.people_alt_outlined,
              currentPage == DrawerSections.Contacts ? true : false),
          menuItem(5, "About Us", Icons.info,
              currentPage == DrawerSections.aboutUs ? true : false),
          Divider(),
          menuItem(6, "Privacy policy", Icons.privacy_tip_outlined,
              currentPage == DrawerSections.privacy_policy ? true : false),
          menuItem(7, "Send feedback", Icons.feedback_outlined,
              currentPage == DrawerSections.send_feedback ? true : false),
          Divider(),
          menuItem(8, "Logout", Icons.logout,
              currentPage == DrawerSections.logout ? true : false),
        ],
      ),
    );
  }

  Widget menuItem(int id, String title, IconData icon, bool selected) {
    return Material(
      color: selected ? Colors.grey[300] : Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
          setState(() {
            if (id == 1) {
              currentPage = DrawerSections.Home;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => Home()),
              );
            } else if (id == 2) {
              currentPage = DrawerSections.Favourites;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FavouriteSplash()),
              );
            } else if (id == 3) {
              currentPage = DrawerSections.MyWallpapers;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => MyWallpapersSplash()),
              );
            } else if (id == 4) {
              currentPage = DrawerSections.Contacts;
            } else if (id == 5) {
              currentPage = DrawerSections.aboutUs;
            } else if (id == 6) {
              currentPage = DrawerSections.privacy_policy;
            } else if (id == 7) {
              currentPage = DrawerSections.send_feedback;
            } else if (id == 8) {
              currentPage = DrawerSections.logout;
              AuthController.instance.logOut();
            }
          });
        },
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Row(
            children: [
              Expanded(
                child: Icon(
                  icon,
                  size: 20,
                  color: Colors.blue,
                ),
              ),
              Expanded(
                flex: 3,
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum DrawerSections {
  Home,
  Favourites,
  MyWallpapers,
  Contacts,
  aboutUs,
  privacy_policy,
  send_feedback,
  logout
}

class CategoriesTile extends StatelessWidget {
  late String imgUrl, title;
  CategoriesTile({this.title = "", this.imgUrl = ""});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Categorie(
                      categorieName: title.toLowerCase(),
                    )));
      },
      child: Container(
        margin: EdgeInsets.only(right: 4),
        child: Stack(
          children: [
            ClipRRect(
                borderRadius: BorderRadius.circular(8),
                // child: Image.network(
                //   imgUrl,
                //   height: 50,
                //   width: 100,
                //   fit: BoxFit.cover,
                // )
                child: Image(
                    image: AssetImage(imgUrl),
                    height: 50,
                    width: 100,
                    fit: BoxFit.cover,
                ),
            ),
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

//drawerlist code:
