import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:neko_waifu/start_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _database = FirebaseDatabase.instance.ref();
  var database;
  List wallpaperID = [];
  List urls = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();

    Timer(const Duration(seconds: 5), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => StartScreen(
                    wallpaperID: wallpaperID,
                    urls: urls,
                    data: database,
                  )));
    });
  }

  void _activateListeners() {
    _database.child('wallpapers').onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      database = data;
      snapshot.children.forEach((element) {
        var value = data[element.key];
        if (value['nsfw'] == "FALSE") {
          wallpaperID.add(element.key);
          urls.add(value['url']);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Lottie.asset(
          "assets/animation/cat_anime_flying.json",
          repeat: true,
          width: 150,
          height: 150,
        ),
      ),
      backgroundColor: const Color.fromRGBO(246, 220, 194, 100),
    );
  }
}
