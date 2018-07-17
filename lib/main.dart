import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'dart:async';


void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Gank',
      home: GankListPage(),
    );
  }
}

class GankListPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return GankListState();
  }
}

class GankListState extends State<GankListPage> {
  List<GankModel> dataList = [];
  var handler = NetworkHandler();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: new Text('Gank for iOS'),
      ),
      body: RefreshIndicator(
        child: ListView.builder(
          itemCount: dataList.length * 2,
          itemBuilder: (BuildContext context, int position) {
            if (position.isOdd) return Divider();
            int index = position ~/ 2;
            return getCellAt(index);
          },
        ),
        onRefresh: reloadData,
      )
    );
  }

  @override
  void initState() {
    super.initState();
    handler.requestGankInfo((List gankModelList) {
      setState(() {
        dataList = gankModelList;
      });
    });
  }

  Widget getCellAt(int i) {
    return GankCellWidget(
        dataList[i].description, dataList[i].author, dataList[i].url);
  }

  Future<Null> reloadData() async {
    await Future.delayed(Duration(milliseconds: 1), () {
      handler.requestGankInfo((List gankModelList) {
        setState(() {
          dataList = gankModelList;
          return null;
        });
      });
    });
  }
}

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

class GankCellWidget extends StatelessWidget {
  final String _description;
  final String _author;
  final String _url;

  GankCellWidget(this._description, this._author, this._url);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            new Text(
              _description,
              style: new TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
            ),
            new Text(
              '来自：' + _author,
              style: new TextStyle(fontSize: 14.0, color: Colors.grey),
            ),
          ],
        ),
      ),
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => new DetailWebPage(_url)));
      },
    );
  }
}

class DetailWebPage extends StatelessWidget {
  final String url;

  DetailWebPage(this.url);

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return new WebviewScaffold(
      appBar: new AppBar(
        title: new Text('详情'),
      ),
      url: this.url,
    );
  }
}
