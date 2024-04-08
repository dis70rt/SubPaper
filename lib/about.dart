import 'package:flutter/material.dart';

class About extends StatefulWidget {
  const About({super.key});

  @override
  State<About> createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Text(
          "About-Screen",
          style: TextStyle(fontSize: 35),
        ),
      ),
      backgroundColor: Colors.orange,
    );
  }
}
