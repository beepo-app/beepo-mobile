// ignore_for_file: prefer_const_constructors

import 'package:beepo/provider.dart';
import 'package:beepo/story_download_provider.dart';
import 'package:beepo/story_upload_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Screens/Auth/lock_screen.dart';
import 'Screens/Auth/onboarding.dart';
import 'bottom_nav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    // name: "Beepo Project",
    // options: DefaultF
    // options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('beepo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Hive.box('beepo').get('isLogged', defaultValue: false);
    bool isLocked = Hive.box('beepo').get('isLocked', defaultValue: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatNotifier()),
        ChangeNotifierProvider<StoryUploadProvider>(
          create: (_) => StoryUploadProvider.initialize(),
        ),
        ChangeNotifierProvider<StoryDownloadProvider>(
          create: (_) => StoryDownloadProvider.initialize(),
        ),
      ],
      builder: (context, _) => GetMaterialApp(
        title: 'Beepo',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(primarySwatch: Colors.blue),
        home: isLoggedIn
            ? isLocked
            ? LockScreen()
            : BottomNavHome()
            : Onboarding(),
      ),
    );
  }
}
