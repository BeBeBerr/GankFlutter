import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

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