import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class HomePage extends StatefulWidget {
  final List wallpaperID;
  final List urls;
  final data;

  const HomePage(
      {super.key,
      required this.wallpaperID,
      required this.urls,
      required this.data});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List wallpaperID = [];
  @override
  void initState() {
    super.initState();
    wallpaperID = widget.wallpaperID;
  }

  // void _activateListeners() {
  //   _database.child('wallpapers').onValue.listen((event) {
  //     var snapshot = event.snapshot;
  //     Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
  //     snapshot.children.forEach((element) {
  //       wallpaperID.add(element.key);
  //     });
  //     for (int i = 0; i < wallpaperID.length; i++) {
  //       var url = data[wallpaperID[i]];
  //       urls.add(url['url'] as String);
  //     }
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: <Widget>[
      Expanded(
        child: MasonryGridView.builder(
            itemCount: wallpaperID.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.all(10),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Material(
                      elevation: 30,
                      child: Image(image:  Image.network(widget.urls[index]).image)),
                  ),
                )),
      )
    ]),
    backgroundColor: Colors.pink.shade100,
    );
  }

  // Image getWallpaper(List urls, int index) {
  //   var data = widget.data[wallpaperID[index]];
  //   List resolution = data['resolution'].split("x");
  //   try {
  //     int width = int.parse(resolution[0]);
  //     int height = int.parse(resolution[1]);

  //     Image image = Image(
  //       image: Image.network(
  //         urls[index],
  //         width: width as double,
  //         cacheWidth: width ~/ 5,
  //         height: height as double,
  //         cacheHeight: height ~/ 5,
  //       ).image,
  //     );
  //     print("Successful !!!!");
  //     return image;
  //   } on Exception catch (_) {
  //     Image image = Image(
  //       image: Image.network(
  //         urls[index],
  //       ).image,
  //     );
  //     return image;
  //   }
  // }
}
