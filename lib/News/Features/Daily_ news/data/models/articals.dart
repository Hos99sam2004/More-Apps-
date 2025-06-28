import 'package:apps/News/Features/Daily_%20news/domain/entites/Artical.dart' show ArticalEntity;

class ArticalsModel extends ArticalEntity{
  const ArticalsModel({
      int ? id,
      String ? author,
      String ? title,
      String ? description,
      String ? url,
      String ? urlToImage,
      String ? publishedAt,
      String ? content,
  });
  factory ArticalsModel.fromJson(Map<String, dynamic> json) {
    return ArticalsModel(
      id: json['id']??"",
      author: json['author']??"",
      title: json['title']??"",
      description: json['description']??"",
      url: json['url']??"",
      urlToImage: json['urlToImage']??"",
      publishedAt: json['publishedAt']??"",
      content: json['content']??"",
    );
  }
}