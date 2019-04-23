import 'dart:async';

import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  
  @override
  State<StatefulWidget> createState() {
    return _SplashScreenState();
  }
  
}

class _SplashScreenState extends State<SplashScreen> {

  startTime() async {
    var _duration = Duration(seconds: 2);
    return Timer(_duration, navigationPage);
  }

  void navigationPage() {
    Navigator.of(context).pushReplacementNamed('/Setup');
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Image.asset('images/logo-raccomail-bollo-big.png', scale: 5,),
      ),
    );
  }
}