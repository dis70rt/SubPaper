import 'dart:ui';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
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
  bool isImageLoaded = true;
  @override
  void initState() {
    super.initState();
    wallpaperID = widget.wallpaperID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(children: <Widget>[
        MasonryGridView.builder(
            itemCount: wallpaperID.length,
            gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2),
            itemBuilder: (context, index) => GestureDetector(
                  onTap: () {
                    setState(() {
                      showCupertinoModalPopup(
                          context: context,
                          builder: (context) =>
                              FullDisplayImage(url: widget.urls[index]));
                    });
                  },
                  child: Stack(
                    children: <Widget>[
                      Padding(
                          padding: const EdgeInsets.all(5),
                          child: Card(
                            elevation: 30,
                            shadowColor: Colors.black,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: ShaderMask(
                                  shaderCallback: (bounds) =>
                                      const LinearGradient(
                                    colors: [Colors.black, Colors.transparent],
                                    begin: Alignment.bottomCenter,
                                    end: Alignment.topCenter,
                                  ).createShader(bounds),
                                  blendMode: BlendMode.multiply,
                                  child: Stack(
                                    children: <Widget>[
                                      CachedNetworkImage(
                                          fadeInDuration:
                                              const Duration(seconds: 1),
                                          imageUrl: widget.urls[index],
                                          progressIndicatorBuilder: (context,
                                                  url, downloadProgress) =>
                                              Lottie.asset(
                                                  "assets/animation/cat_paw_loading.json",
                                                  repeat: true,
                                                  width: 0),
                                          errorWidget: (context, url, error) {
                                            removeURL(index);
                                            return Container(color: Colors.black);
                                          }
                                              // const Icon(Icons.error_outline))
                                  )],
                                  ),
                                )),
                          )),
                    ],
                  ),
                )),
      ]),
      backgroundColor: const Color.fromRGBO(255, 219, 231, 100),
    );
  }

  void removeURL(int index) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("wallpapers");
    reference.child(wallpaperID[index]).remove();
    print("Successfully Removed");
  }
}

class FullDisplayImage extends StatefulWidget {
  final String url;
  const FullDisplayImage({super.key, required this.url});

  @override
  State<FullDisplayImage> createState() => _FullDisplayImageState();
}

class _FullDisplayImageState extends State<FullDisplayImage> {
  @override
  initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.initState();
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual);
    super.dispose();
  }

  String progressValue = '';

  Future<void> downloadImage() async {
    // Dio dio = Dio();

    // try {
    //   var pathInStorage = await getApplicationDocumentsDirectory();
    //   await dio.download(
    //     widget.url,
    //     '${pathInStorage.path}/sampleimage.jpg',
    //     onReceiveProgress: (count, total) {
    //       // it'll get the current and total progress value
    //       setState(() {
    //         progressValue =
    //             'Downloading: ${((count / total) * 100).toStringAsFixed(0)}%';

    //         if (count == total) {
    //           progressValue = 'Downloading Completed';
    //         }
    //       });
    //     },
    //   );
    // } catch (e) {
    //   print(e.toString());
    // }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Stack(
        children: <Widget>[
          Scaffold(
            body: GestureDetector(
              child: Container(
                padding: const EdgeInsets.all(70),
                alignment: Alignment.center,
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Lottie.asset(
                            "assets/animation/cat_paw_loading.json",
                            repeat: true,
                            width: 150),
                    errorWidget: (context, url, error) => Container(),
                  ),
                ),
              ),
              onTap: () {
                Navigator.pop(context);
              },
            ),
            backgroundColor: Colors.transparent,
          ),
          Container(
            alignment: Alignment.bottomCenter,
            padding: const EdgeInsets.all(30),
            child: ElevatedButton(
                onPressed: () async {
                  downloadImage();
                },
                child: const Text(
                  "DOWNLOAD",
                  style: TextStyle(
                    fontFamily: "Salmond",
                    fontWeight: FontWeight.w900,
                    fontSize: 12,
                  ),
                )),
          )
        ],
      ),
    );
  }
}
