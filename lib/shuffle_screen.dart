import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neko_waifu/home_screen.dart';
// import 'package:neko_waifu/main.dart';

class ShuffleScreen extends StatefulWidget {
  final List wallpaperID;
  final List urls;

  const ShuffleScreen({
    super.key,
    required this.wallpaperID,
    required this.urls,
  });

  @override
  State<ShuffleScreen> createState() => _ShuffleScreenState();
}

class _ShuffleScreenState extends State<ShuffleScreen> {
  @override
  void initState() {
    super.initState();

    widget.wallpaperID.shuffle();
    widget.urls.shuffle();

    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(
          builder: ((context) => HomePage(
                urls: widget.urls,
                wallpaperID: widget.wallpaperID,
              ))));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(child: Lottie.asset("assets/animation/shuffle_dice.json")),
    );
  }
}
