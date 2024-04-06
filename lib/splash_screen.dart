import 'dart:async';

import 'package:flutter/material.dart';
import 'package:neko_waifu/main.dart';
import 'package:lottie/lottie.dart';

class SplashScreen extends StatefulWidget {
  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();

    Timer(Duration(seconds: 10), () {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => MyHomePage(title: "Neko Waifu",)));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/animation/neko_loading.json",
          repeat: true,
          width: 150,
          height: 150,
        ),
      ),
      // body: Container(
      //   color: Color.fromRGBO(246, 220, 194, 100),
      // ),
      
    );
  }
}
