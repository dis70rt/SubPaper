import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';

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
              child: Card(
                elevation: 30,
                shadowColor: Colors.black,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: CachedNetworkImage(
                      imageUrl: widget.urls[index],
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => Lottie.asset(
                              "assets/animation/cat_paw_loading.json",
                              repeat: true,
                              width: 150),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    )
                    // Image(image:  Image.network(widget.urls[index]).image)),
                    ),
              )),
        ))
      ]),
      backgroundColor: Colors.pink.shade100,
    );
  }
}
