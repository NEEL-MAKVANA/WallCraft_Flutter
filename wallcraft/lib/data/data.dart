import 'package:wallcraft/model/categories_model.dart';

String apiKey = "563492ad6f9170000100000105203463523e4323b2c2d8152bdf71b6";

List<CategoriesModel> getCategories() {
  List<CategoriesModel> categories = [];
  CategoriesModel categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
  "assets/dark.jpg";

  categorieModel.categoriesName = "Dark";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
  "assets/colorful.jpg";

  categorieModel.categoriesName = "Color";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
      "assets/street_art.jpg";

  categorieModel.categoriesName = "Street Art";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
      "assets/wild_life.jpg";

  categorieModel.categoriesName = "Wild Life";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
      "assets/nature.jpg";

  categorieModel.categoriesName = "Nature";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //





  categorieModel.imgUrl =
      "assets/city.jpg";

  categorieModel.categoriesName = "City";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //


  categorieModel.imgUrl =
      "assets/bike.jpg";

  categorieModel.categoriesName = "Bikes";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  //

  categorieModel.imgUrl =
      "assets/cars.jpg";

  categorieModel.categoriesName = "Cars";

  categories.add(categorieModel);

  categorieModel = new CategoriesModel();

  return categories;
}
