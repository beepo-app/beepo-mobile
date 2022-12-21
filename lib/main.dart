import 'package:beepo/Screens/Auth/lock_screen.dart';
import 'package:beepo/Screens/Auth/onboarding.dart';
import 'package:beepo/bottom_nav.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   options: DefaultFirebaseOptions.currentPlatform,
  // );
  await Hive.initFlutter();
  await Hive.openBox('beepo');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Hive.box('beepo').get('isLogged', defaultValue: false);
    bool isLocked = Hive.box('beepo').get('isLocked', defaultValue: false);

    return GetMaterialApp(
      title: 'Beepo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(primarySwatch: Colors.blue),
      home: isLoggedIn
          ? isLocked
              ? const LockScreen()
              : BottomNavHome()
          : const Onboarding(),
    );
  }
}
