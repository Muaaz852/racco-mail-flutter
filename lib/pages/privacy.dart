import 'package:flutter/material.dart';

import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class PrivacyPage extends StatelessWidget {
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
        title: Text(
          'PRIVACY',
          style: TextStyle(color: Colors.red),
        ),
      ),
      body: WebviewScaffold(
        url: 'https://www.raccomail.it/app/privacy.html',
        hidden: false,
        withJavascript: true,
      ),
    );
  }
}
