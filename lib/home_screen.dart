import 'dart:ui';
import 'dart:io';
import 'dart:math';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';


class HomePage extends StatefulWidget {
  final List wallpaperID;
  final List urls;

  const HomePage({
    super.key,
    required this.wallpaperID,
    required this.urls,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final database = FirebaseDatabase.instance.ref();
  List wallpaperID = [];
  @override
  void initState() {
    super.initState();
    wallpaperID = widget.wallpaperID;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // appBar: const PreferredSize(
        //     preferredSize: Size.fromHeight(100),
        //     child: CustomScrollView(slivers: [
        // SliverAppBar(
        //   title: Center(
        //     child: Text(
        //       "Wall-dit",
        //       style: TextStyle(fontFamily: "Amcap",
        //       fontSize: 20,
        //       color: Colors.white)),
        //   ),
        //   expandedHeight: 200,
        //   stretch: true,
        //   elevation: 12,
        //   floating: true,
        //   pinned: true,
        //   backgroundColor: Colors.blue,

        // ),
        //     ])),
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (_, __) => [
            SliverAppBar(
              backgroundColor: const Color.fromRGBO(0, 0, 0, 100),
              expandedHeight: 300,
              flexibleSpace: FlexibleSpaceBar(
                background: Stack(
                  children: <Widget>[
                    Image.network("https://wallpapercave.com/wp/wp1822356.jpg",
                        fit: BoxFit.fill),
                    ClipRRect(
                      // Clip it cleanly.
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                        child: Container(
                          color: Colors.grey.withOpacity(0.1),
                          alignment: Alignment.center,
                          child: Container(
                            child: Stack(
                              children: <Widget>[
                                Positioned(
                                  top: 70,
                                  left: 50,
                                  child: Card(
                                    color: Colors.transparent,
                                    elevation: 10.0,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15.0)),
                                    child: Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(60),
                                        image: const DecorationImage(
                                            image: AssetImage(
                                                "assets/images/saikat.png"),
                                            fit: BoxFit.fill),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  top: 75,
                                  left: 130,
                                  child: Container(
                                    child: const Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text("Developed By",
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                            )),
                                        Text("Saikat Das",
                                            style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.white,
                                              fontWeight: FontWeight.normal,
                                            )),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              elevation: 30,
              floating: true,
              pinned: true,
            )
          ],
          body: MasonryGridView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: wallpaperID.length,
              gridDelegate:
                  const SliverSimpleGridDelegateWithFixedCrossAxisCount(
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
                    onDoubleTap: () {
                      updateScore(index);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: CachedNetworkImage(
                            memCacheWidth:
                                (150 * MediaQuery.of(context).devicePixelRatio)
                                    .round(),
                            fadeInDuration: const Duration(seconds: 1),
                            imageUrl: widget.urls[index],
                            placeholder: (context, url) => Padding(
                                padding: const EdgeInsets.all(30),
                                child: Lottie.asset(
                                    "assets/animation/loading.json",
                                    width: 150,
                                    height: 150)),
                            errorWidget: (context, url, error) {
                              // removeURL(index);
                              return const Icon(Icons.error_outline_outlined);
                            }),
                      ),
                    ),
                  )),
        ),
        backgroundColor: const Color.fromRGBO(24, 24, 24, 1));
  }

  void removeURL(int index) {
    DatabaseReference reference =
        FirebaseDatabase.instance.ref().child("wallpapers");
    reference.child(wallpaperID[index]).remove();
    print("Successfully Removed");
  }

  void updateScore(int index) async {
    String id = wallpaperID[index];
    var score = await database.child('MobileWallpapers/$id/score').get();
    int newScore = score.value as int;
    await database.update({"MobileWallpapers/$id/score": newScore + 50});
  }
}

// class onDoubleTapLike extends StatefulWidget {
//   final int score;
//   final String id;
//   const onDoubleTapLike({super.key, required this.score, required this.id});

//   @override
//   State<onDoubleTapLike> createState() => _onDoubleTapLikeState();
// }

// class _onDoubleTapLikeState extends State<onDoubleTapLike> {
//   final database = FirebaseDatabase.instance.ref("MobileWallpapers");
//   @override
//   void initState() {
//     super.initState();
//     String id = widget.id;
//     database.update({"$id/score": widget.score + 10});
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Center(
//       child: Lottie.asset("assets/animation/like.json"),
//     );
//   }
// }

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

  Future<void> downloadImage(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      // Download image
      final response = await Dio().get<List<int>>(url,
      options: Options(responseType: ResponseType.bytes), // Set the response type to `bytes`.
);

      // Get temporary directory
      final dir = await getTemporaryDirectory();

      // Create an image name
      var random = Random();
      var filename = '${dir.path}/SubPaper_${random.nextInt(100)}.png';

      // Save to filesystem
      final file = File(filename);
      await file.writeAsBytes(response.data as List<int>);

      // Ask the user to save it
      final params = SaveFileDialogParams(sourceFilePath: file.path);
      final finalPath = await FlutterFileDialog.saveFile(params: params);

      if (finalPath != null) {
        message = 'Image saved to disk';
      }
    } catch (e) {
      message = e.toString();
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: const Color(0xFFe91e63),
      ));
    }
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
                padding: const EdgeInsets.all(60),
                alignment: Alignment.center,
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: CachedNetworkImage(
                    imageUrl: widget.url,
                    progressIndicatorBuilder:
                        (context, url, downloadProgress) => Lottie.asset(
                            "assets/animation/loading.json",
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
                  downloadImage(context, widget.url);
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
