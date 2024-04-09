import 'package:flutter/material.dart';
import 'package:neko_waifu/about.dart';
import 'package:neko_waifu/home_screen.dart';

class StartScreen extends StatefulWidget {
  final List wallpaperID;
  final List urls;
  final data;

  const StartScreen(
      {super.key,
      required this.wallpaperID,
      required this.urls,
      required this.data});

  @override
  State<StartScreen> createState() => _StartScreenState();
}

class _StartScreenState extends State<StartScreen> {
 
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
                          wallpaperID: widget.wallpaperID,
                          urls: widget.urls,
                          data: widget.data,
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
