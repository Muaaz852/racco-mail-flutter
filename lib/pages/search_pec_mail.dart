import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class SearchPECMailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: Color.fromRGBO(30, 52, 70, 1),
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios),
          onPressed: () => Navigator.pop(context, false),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.search),
            SizedBox(
              width: 10.0,
            ),
            Text(
              'Cerca PEC Mail',
            ),
          ],
        ),
      ),
      body: WebviewScaffold(
        url: 'https://www.raccomail.it/app/cercapec.html',
        hidden: false,
        withJavascript: true,
      ),
    );
  }
}