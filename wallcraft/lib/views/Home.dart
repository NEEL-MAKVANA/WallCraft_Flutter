import 'package:flutter/material.dart';
import 'package:wallcraft/data/data.dart';
import 'package:wallcraft/widgets/widget.dart';

import '../model/categories_model.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<CategoriesModel> categories = [];
  @override
  void initState() {
    categories = getCategories();
    super.initState();
  }

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
      body: Container(
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: Color(0xfff5f8fd),
                borderRadius: BorderRadius.circular(20),
                border: Border(),
              ),
              padding: EdgeInsets.symmetric(horizontal: 24),
              margin: EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: const [
                  Expanded(
                    child: TextField(
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
                  Icon(Icons.search),
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
            )
          ],
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
    return Container(
      margin: EdgeInsets.only(right: 4),
      child: Stack(
        children: [

             ClipRRect(
               borderRadius: BorderRadius.circular(8),
                 child: Image.network(imgUrl,height: 50,width: 100,fit: BoxFit.cover
                   ,)),

          Container(
            alignment: Alignment.center,
            color: Colors.black26,
            height: 50,
            width: 100,
//we reached at 47 minutes
            child: Text(title,style: TextStyle(color: Colors.white,fontWeight: FontWeight.w500,fontSize: 15),),
          ),
        ],
      ),
    );
  }
}
