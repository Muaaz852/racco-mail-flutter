import 'package:flutter/material.dart';

import './pages/splash_screen.dart';
import './pages/setup.dart';
import './pages/settings.dart';
import './pages/privacy.dart';
import './pages/info.dart';
import './pages/search_pec_mail.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Racco Mail',
      theme: ThemeData(
        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
        scaffoldBackgroundColor: Colors.white,
      ),
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      routes: {
        '/Setup': (BuildContext context) => SetupPage(),
        '/Settings': (BuildContext context) => SettingsPage(),
        '/Privacy': (BuildContext context) => PrivacyPage(),
        '/Info': (BuildContext context) => InfoPage(),
        '/SearchPECMail': (BuildContext context) => SearchPECMailPage(),
      },
      onUnknownRoute: (RouteSettings routeSettings) {
        return MaterialPageRoute(
          builder: (BuildContext context) => SetupPage(),
        );
      },
    );
  }
}
