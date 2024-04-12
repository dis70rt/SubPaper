import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:neko_waifu/dependency_injection.dart';
import 'package:neko_waifu/home_screen.dart';
import 'firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';

final _database = FirebaseDatabase.instance.ref();
List wallpaperID = [];
List urls = [];

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  _activateListeners();
  await Future.delayed(const Duration(seconds: 6));
  FlutterNativeSplash.remove();

  runApp(const MyApp());
  DependencyInjection.init();
}

void _activateListeners() {
  _database
      .child('MobileWallpapers')
      .orderByChild('score')
      .onValue
      .listen((event) {
    var snapshot = event.snapshot;
    Map<dynamic, dynamic> data = snapshot.value as Map<dynamic, dynamic>;
    for (var element in snapshot.children) {
      var value = data[element.key];
      wallpaperID.add(element.key);
      urls.add(value['url']);
    }

    urls = urls.reversed.toList();
    wallpaperID = wallpaperID.reversed.toList();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'S U B P A P E R',
      theme: ThemeData(
        useMaterial3: true,
      ),
      home: HomePage(
        urls: urls,
        wallpaperID: wallpaperID,
      ),
    );
  }
}
