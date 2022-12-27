import 'package:beepo/provider.dart';
// import '../../../AndroidStudioProjects/beepo_mobile/lib/bottom_nav.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Screens/Auth/lock_screen.dart';
import 'Screens/Auth/onboarding.dart';
import 'bottom_nav.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    name: "Beepo Project",
    // options: DefaultF
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await Hive.initFlutter();
  await Hive.openBox('beepo');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // const MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isLoggedIn = Hive.box('beepo').get('isLogged', defaultValue: false);
    bool isLocked = Hive.box('beepo').get('isLocked', defaultValue: false);

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ChatNotifier()),
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
