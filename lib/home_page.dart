import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Stack(
        children: <Widget>[
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              " ABOUT",
              style: TextStyle(
                  fontFamily: "Teko",
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: Color.fromRGBO(3, 6, 55, 0.3)),
            ),
          ),

          Column(children: <Widget>[
            // Align(
            //   alignment: Alignment.center,
            //   child: Image.asset(
            //     "assets/images/neko_waifu.png",
            //     width: 300,
            //   ),
            // ),
            // const Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       "Swipe UP! to Explore Wallpapers",
            //     )),
          ])
        ],
      ),
      backgroundColor: Color.fromRGBO(246, 220, 194, 100),
    );
  }
}
