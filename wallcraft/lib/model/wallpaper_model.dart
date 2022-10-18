class WallpaperModel{
  late String photographer;
  late String photographer_url;
  late int photographer_id;
  late String avg_color;
  late SrcModel src;

  WallpaperModel({required this.src, this.photographer_url = '', this.photographer_id = 0, this.photographer = '', this.avg_color = 'bgColor'});

  factory WallpaperModel.fromMap(Map<String, dynamic> jsonData){
    return WallpaperModel(
      src: SrcModel.fromMap(jsonData["src"]),
      photographer_url: jsonData["photographer_url"],
      photographer_id: jsonData["photographer_id"],
      photographer: jsonData["photographer"]
    );
  }

  String getPortrait(){
    print("Src Portrait: " + this.src.portrait);
    return this.src.portrait;
  }
}

class SrcModel{
  late String original;
  late String small;
  late String portrait;

  SrcModel({this.portrait = '', this.original = '', this.small = ''});

  factory SrcModel.fromMap(Map<String, dynamic> jsonData){
    return SrcModel(
      portrait: jsonData["portrait"],
      original: jsonData["original"],
      small: jsonData["small"],
    );
  }
}