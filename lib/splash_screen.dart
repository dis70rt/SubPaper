import 'dart:async';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:lottie/lottie.dart';
import 'package:neko_waifu/home_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  final _database = FirebaseDatabase.instance.ref();
  bool toSwitchScreen = false;
  var database;
  List wallpaperID = [];
  List urls = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();

    Timer(const Duration(seconds: 8), () {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => HomePage(
                    wallpaperID: wallpaperID,
                    urls: urls,
                    data: database,
                  )));
    });
  }

  void _activateListeners() {
    _database
        .child('MobileWallpapers')
        .orderByChild('score')
        .onValue
        .listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      database = data;
      for (var element in snapshot.children) {
        var value = data[element.key];
        wallpaperID.add(element.key);
        urls.add(value['url']);
      }

      urls = urls.reversed.toList();
      wallpaperID = wallpaperID.reversed.toList();
    });
  }

  // void _activateListeners() async {
  //   final rawData = await rootBundle.loadString("assets/MobileWallpapers.csv");
  //   List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);

  //   for (int i = 0; i < listData.length; i++) {
  //     String id = listData[i][0];
  //     final _database = FirebaseDatabase.instance.ref("MobileWallpapers/$id");
  //      await _database.set({
  //       "score": listData[i][1],
  //       "title": listData[i][2],
  //       "url": listData[i][3]});
  //   }

  // _database.child('MobileWallpapers').onValue.listen((event) {
  //   var snapshot = event.snapshot;
  //   Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //   database = data;
  //   snapshot.children.forEach((element) {
  //     var value = data[element.key];
  //     if (value['nsfw'] == "FALSE") {
  //       wallpaperID.add(element.key);
  //       urls.add(value['url']);
  //     }
  //   });

  //   urls = urls.reversed.toList();
  //   wallpaperID = wallpaperID.reversed.toList();
  // });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 246, 220, 194),
        body: Stack(children: <Widget>[
      Center(
          child: Lottie.asset(
        "assets/animation/Splash_Screen.json",
        width: MediaQuery.of(context).size.width,
      )),
      Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: EdgeInsets.all(50),
          child: Container(
            child: const Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                Text("S U B P A P E R",
                    style: TextStyle(
                      fontFamily: "Quartzo",
                      fontSize: 30,
                      color: Colors.white,
                    )),
                Text("Style that won't taper",
                    style: TextStyle(
                      fontFamily: "Salmond",
                      fontSize: 12,
                      color: Color.fromRGBO(255, 255, 255, 125),
                    ))
              ],
            ),
          ),
        ),
      )
    ]));
  }
}
