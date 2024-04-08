import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:neko_waifu/about.dart';
import 'package:neko_waifu/home_screen.dart';

class StartScreen extends StatefulWidget {
  const StartScreen({super.key});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
  final _database = FirebaseDatabase.instance.ref();
  var database;
  List wallpaperID = [];
  List urls = [];

  @override
  void initState() {
    super.initState();
    _activateListeners();
  }

  void _activateListeners() {
    _database.child('wallpapers').onValue.listen((event) {
      var snapshot = event.snapshot;
      Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
      database = data;
      snapshot.children.forEach((element) {
        wallpaperID.add(element.key);
      });

      for (int i = 0; i < wallpaperID.length; i++) {
        var url = data[wallpaperID[i]];
        if (url['nsfw'] == "FALSE") {
          urls.add(url['url'] as String);
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: <Widget>[
      const Center(
        child: Text("Start-Screen", style: TextStyle(fontSize: 35)),
      ),
      GestureDetector(
        onVerticalDragUpdate: (details) {
          int sensitivity = 8;
          if (details.delta.dy < -sensitivity) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => HomePage(
                          wallpaperID: wallpaperID,
                          urls: urls,
                          data: database,
                        )));
          } else if (details.delta.dy > sensitivity) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const About()));
          }
        },
      ),
    ]);
  }
}
