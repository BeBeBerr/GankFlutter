import 'dart:convert';
import 'dart:io';
import '../data/GankModel.dart';

class NetworkHandler {
  void requestGankInfo(void callback(List gankModelList)) async {
    var httpClient = new HttpClient();
    var request = await httpClient
        .getUrl(Uri.parse('http://gank.io/api/random/data/iOS/20'));
    var response = await request.close();
    var jsonStr = await response.transform(new Utf8Decoder()).join();
    Map<String, dynamic> dataMap = json.decode(jsonStr);
    List gankList = dataMap['results'];
    List<GankModel> gankModelList = [];

    gankList.forEach((e) => gankModelList.add(new GankModel.fromJson(e)));

    callback(gankModelList);
  }
}