import 'package:flutter/material.dart';
import 'pages/GankListPage.dart';


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
