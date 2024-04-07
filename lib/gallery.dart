import 'package:csv/csv.dart';
import 'package:firebase_database/firebase_database.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class WallpaperGallery extends StatefulWidget {
  const WallpaperGallery({super.key});

  @override
  State<WallpaperGallery> createState() => _WallpaperGalleryState();
}

class _WallpaperGalleryState extends State<WallpaperGallery> {
  List<List<dynamic>> _data = [];
  final database = FirebaseDatabase.instance.ref();

  void _loadCSV() async {
    final rawData = await rootBundle.loadString('assets/wallpapers.csv');
    List<List<dynamic>> listData = const CsvToListConverter().convert(rawData);
    setState(() {
      _data = listData;
    });
  }

  void getWallpaper() async {
    _loadCSV();
    final dataMap = _data.asMap();

    for (int i = 1; i < dataMap.length; i++) {
      var id = dataMap[i]?[0].toString();
      final wallpapers = database.child('wallpapers/$id');

      wallpapers.set({
        'title': dataMap[i]?[4],
        'anime': dataMap[i]?[3],
        'url': dataMap[i]?[5],
        'nsfw': dataMap[i]?[1],
        'score': dataMap[i]?[2],
        'resolution': dataMap[i]?[6]
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton:
          ElevatedButton(onPressed: getWallpaper, child: const Text("get")),
    );
  }
}
