import 'dart:ui';
import 'dart:io';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:flutter_wallpaper_manager/flutter_wallpaper_manager.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:lottie/lottie.dart';
import 'package:neko_waifu/shuffle_screen.dart';
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
            SliverAppBar(
              leading: InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => ShuffleScreen(
                          wallpaperID: widget.wallpaperID, urls: widget.urls)));
                },
                child: const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Icon(Icons.shuffle, color: Colors.white)),
              ),
              backgroundColor: const Color.fromRGBO(10, 10, 10, 1),
              expandedHeight: 120,
              collapsedHeight: 70,
              flexibleSpace: const Padding(
                  padding: EdgeInsets.only(top: 30),
                  child: SizedBox(
                      height: 100, width: 100, child: SliverAppBarTitle())),
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
        behavior: SnackBarBehavior.floating,
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
      child: Scaffold(
        bottomNavigationBar: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(30)),
          child: Padding(
            padding: const EdgeInsets.only(bottom: 20),
            child: GNav(
              tabMargin: const EdgeInsets.all(15),
              backgroundColor: const Color.fromARGB(206, 41, 41, 41),
              color: Colors.white,
              activeColor: Colors.white,
              tabBackgroundColor: const Color.fromRGBO(18, 18, 18, 1),
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
                    onPressed: () => showDialog(
                        context: context,
                        builder: (_) => SetWallPaperDialog(
                            context: context, url: widget.url))),
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


class SetWallPaperDialog extends StatefulWidget {
  final BuildContext context;
  final String url;

  const SetWallPaperDialog(
      {super.key, required this.context, required this.url});

  @override
  State<SetWallPaperDialog> createState() => _SetWallPaperDialogState();
}

Future<void> setWallpaper(
    BuildContext context, String url, int location) async {
  final scaffoldMessenger = ScaffoldMessenger.of(context);
  try {
    var file = await DefaultCacheManager().getSingleFile(url);
    final bool result = await WallpaperManager.setWallpaperFromFile(
        file.path, location);

    if (result) {
      scaffoldMessenger.showSnackBar(const SnackBar(
        behavior: SnackBarBehavior.floating,
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
      behavior: SnackBarBehavior.floating,
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

class _SetWallPaperDialogState extends State<SetWallPaperDialog> {
  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
      child: SimpleDialog(
        alignment: Alignment.center,
        surfaceTintColor: Colors.transparent,

        insetPadding: const EdgeInsets.symmetric(horizontal: 60),
        // titlePadding: const EdgeInsets.all(5),
        elevation: 30,
        backgroundColor: const Color.fromRGBO(28, 28, 28, 1),
        title: const Center(
            child: Text(
          "Set As Wallpaper",
          style: TextStyle(
              color: Colors.white, fontSize: 15, fontWeight: FontWeight.normal),
        )),
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  width: 160,
                  color: const Color.fromRGBO(18, 18, 18, 1),
                  child: SimpleDialogOption(
                    onPressed: () => setWallpaper(
                          context, widget.url, WallpaperManager.HOME_SCREEN),
                    child: const Text(
                      "Home Screen",
                      textAlign: TextAlign.center,
                      style: TextStyle(letterSpacing: 2, color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  width: 160,
                  color: const Color.fromRGBO(18, 18, 18, 1),
                  child: SimpleDialogOption(
                    onPressed: () => setWallpaper(
                          widget.context, widget.url, WallpaperManager.LOCK_SCREEN),
                    child: const Text(
                      "Lock Screen",
                      textAlign: TextAlign.center,
                      style: TextStyle(letterSpacing: 2, color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Center(
              child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(25)),
                child: Container(
                  width: 160,
                  color: const Color.fromRGBO(18, 18, 18, 1),
                  child: SimpleDialogOption(
                    onPressed: () => setWallpaper(
                          context, widget.url, WallpaperManager.BOTH_SCREEN),
                    child: const Text(
                      "Both Screen",
                      
                      textAlign: TextAlign.center,
                      style: TextStyle(letterSpacing: 2, color: Colors.white, fontSize: 12),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
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
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            SizedBox(height: 15),
            Center(
              child: Text("S U B P A P E R",
                  style: TextStyle(
                    // fontFamily: "Teko",
                    fontSize: 30,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  )),
            ),
            SizedBox(height: 20),
            Text("D E V E L O P E D   B Y   S A I K A T",
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                  fontWeight: FontWeight.normal,
                )),
          ],
        ),
      ),
    );
  }
}
