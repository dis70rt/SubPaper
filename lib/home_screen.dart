import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_file_dialog/flutter_file_dialog.dart';
import 'package:share_extend/share_extend.dart';

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
        body: NestedScrollView(
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          headerSliverBuilder: (_, __) => [
            const SliverAppBar(
              // collapsedHeight: 56,
              backgroundColor: Color.fromRGBO(10, 10, 10, 1),
              expandedHeight: 100,
              flexibleSpace: Padding(
                padding: EdgeInsets.only(top: 30),
                child: SizedBox(
                  height: 100,
                  width: 100,
                  child: SliverAppBarTitle())
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
                            builder: (context) => FullDisplayImage(
                                  url: widget.urls[index],
                                  id: widget.wallpaperID[index],
                                ));
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
    // print("Successfully Removed");
  }

  void updateScore(int index) async {
    String id = wallpaperID[index];
    var score = await database.child('MobileWallpapers/$id/score').get();
    int newScore = score.value as int;
    await database.update({"MobileWallpapers/$id/score": newScore + 50});
  }
}

class FullDisplayImage extends StatefulWidget {
  final String url;
  final String id;
  const FullDisplayImage({super.key, required this.url, required this.id});

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

  Future<void> downloadImage(
      BuildContext context, String url, String id) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    late String message;

    try {
      final response = await Dio().get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );

      final dir = await getTemporaryDirectory();
      var filename = '${dir.path}/SubPaper_$id.png';

      final file = File(filename);
      await file.writeAsBytes(response.data as List<int>);

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

  Future<void> setWallpaper(BuildContext context, String url) async {
    final scaffoldMessenger = ScaffoldMessenger.of(context);
    try {
      var file = await DefaultCacheManager().getSingleFile(url);
      final bool result = await WallpaperManager.setWallpaperFromFile(
          file.path, WallpaperManager.HOME_SCREEN);

      if (result) {
        scaffoldMessenger.showSnackBar(const SnackBar(
          content: Text(
            "Wallpaper Set Successfully",
            style: TextStyle(
              fontSize: 12,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ));
        SystemChannels.platform.invokeMethod('SystemNavigator.pop');
      }
    } catch (e) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        content: Text(
          "Failed to set Wallpaper",
          style: TextStyle(
            fontSize: 12,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
      child: Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            // color: const Color(0x121212),
            child: GNav(
              tabMargin: const EdgeInsets.all(15),
              backgroundColor: const Color.fromARGB(206, 41, 41, 41),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
              // tabBorder: Border.all(color: const Color.fromRGBO(18, 18, 18, 1), width: 1),
              padding: const EdgeInsets.all(13),
              gap: 8,
              selectedIndex: 1,
              tabs: [
                GButton(
                  icon: Icons.download,
                  text: "Download",
                  onPressed: () =>
                      downloadImage(context, widget.url, widget.id),
                ),
                GButton(
                  icon: Icons.wallpaper,
                  text: "Set as Wallpaper",
                  onPressed: () => setWallpaper(context, widget.url),
                ),
                GButton(
                  icon: Icons.share,
                  text: "Share",
                  onPressed: () async {
                    File image =
                        await DefaultCacheManager().getSingleFile(widget.url);
                    ShareExtend.share(image.path, "image");
                  },
                )
              ],
            ),
          ),
        ),
        body: GestureDetector(
          child: Container(
            padding: const EdgeInsets.all(60),
            alignment: Alignment.center,
            color: Colors.transparent,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: widget.url,
                progressIndicatorBuilder: (context, url, downloadProgress) =>
                    Lottie.asset("assets/animation/loading.json",
                        repeat: true, width: 150),
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
    );
  }
}

class SliverAppBarTitle extends StatelessWidget {
  const SliverAppBarTitle({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              Text("S U B P A P E R",
                  style: TextStyle(
                    // fontFamily: "Teko",
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
              SizedBox(height: 5),
              Text("D E V E L O P E D   B Y   S A I K A T",
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white,
                    fontWeight: FontWeight.normal,
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
