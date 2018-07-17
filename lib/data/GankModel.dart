
class GankModel {
  String description;
  String author;
  String url;

  GankModel.fromJson(Map<String, dynamic> dataMap) {
    this.description = dataMap['desc'];
    this.author = dataMap['who'];
    this.url = dataMap['url'];
  }
}