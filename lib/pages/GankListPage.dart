import 'package:flutter/material.dart';
import 'dart:async';
import '../data/GankModel.dart';
import '../utils/NetworkHandler.dart';
import 'DetailWebPage.dart';

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
