// ignore_for_file: prefer_const_constructors

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:beepo/provider.dart';
import 'package:beepo/story_download_provider.dart';
import 'package:beepo/story_upload_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'Screens/Auth/lock_screen.dart';
import 'Screens/Auth/onboarding.dart';
import 'bottom_nav.dart';
import 'package:http/http.dart' as http;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
      // name: "Beepo Project",
      // options: DefaultF
      // options: DefaultFirebaseOptions.currentPlatform,
      );
  NotificationController.initializeLocalNotifications();
  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );
  // AwesomeNotifications().initialize('', channels)
  await Hive.initFlutter();
  await Hive.openBox('beepo');
  runApp(MyApp());
}

class NotificationController {
  static ReceivedAction initialAction;

  ///  *********************************************
  ///     INITIALIZATIONS
  ///  *********************************************
  ///
  static Future<void> initializeLocalNotifications() async {
    await AwesomeNotifications().initialize(
         'resource://drawable/background',
        [
          NotificationChannel(
              channelKey: 'alerts',
              channelName: 'Alerts',
              channelDescription: 'Notification tests as alerts',
              playSound: true,
              onlyAlertOnce: true,
              groupAlertBehavior: GroupAlertBehavior.Children,
              importance: NotificationImportance.High,
              defaultPrivacy: NotificationPrivacy.Private,
              defaultColor: Colors.deepPurple,
              ledColor: Colors.deepPurple)
        ],
        debug: true);

    // Get initial notification action is optional
    initialAction = await AwesomeNotifications()
        .getInitialNotificationAction(removeFromActionEvents: false);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS LISTENER
  ///  *********************************************
  ///  Notifications events are only delivered after call this method
  static Future<void> startListeningNotificationEvents() async {
    AwesomeNotifications()
        .setListeners(onActionReceivedMethod: onActionReceivedMethod);
  }

  ///  *********************************************
  ///     NOTIFICATION EVENTS
  ///  *********************************************
  ///
  @pragma('vm:entry-point')
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {

    if(
    receivedAction.actionType == ActionType.SilentAction ||
        receivedAction.actionType == ActionType.SilentBackgroundAction
    ){
      // For background actions, you must hold the execution until the end
      print('Message sent via notification input: "${receivedAction.buttonKeyInput}"');
      await executeLongTaskInBackground();
    }
    else {
      MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
          '/notification-page',
              (route) =>
          (route.settings.name != '/notification-page') || route.isFirst,
          arguments: receivedAction);
    }
  }

  ///  *********************************************
  ///     REQUESTING NOTIFICATION PERMISSIONS
  ///  *********************************************
  ///
  static Future<bool> displayNotificationRationale() async {
    bool userAuthorized = false;
    BuildContext context = MyApp.navigatorKey.currentContext;
    await showDialog(
        context: context,
        builder: (BuildContext ctx) {
          return AlertDialog(
            title: Text('Get Notified!',
                style: Theme.of(context).textTheme.titleLarge),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Image.asset(
                        'assets/animated-bell.gif',
                        height: MediaQuery.of(context).size.height * 0.3,
                        fit: BoxFit.fitWidth,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                const Text(
                    'Allow Awesome Notifications to send you beautiful notifications!'),
              ],
            ),
            actions: [
              TextButton(
                  onPressed: () {
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Deny',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.red),
                  )),
              TextButton(
                  onPressed: () async {
                    userAuthorized = true;
                    Navigator.of(ctx).pop();
                  },
                  child: Text(
                    'Allow',
                    style: Theme.of(context)
                        .textTheme
                        .titleLarge
                        ?.copyWith(color: Colors.deepPurple),
                  )),
            ],
          );
        });
    return userAuthorized &&
        await AwesomeNotifications().requestPermissionToSendNotifications();
  }

  ///  *********************************************
  ///     BACKGROUND TASKS TEST
  ///  *********************************************
  static Future<void> executeLongTaskInBackground() async {
    print("starting long task");
    await Future.delayed(const Duration(seconds: 4));
    final url = Uri.parse("http://google.com");
    final re = await http.get(url);
    print(re.body);
    print("long task done");
  }

  ///  *********************************************
  ///     NOTIFICATION CREATION METHODS
  ///  *********************************************
  ///
  static Future<void> createNewNotification(String channel) async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: channel,
            title: 'Huston! The eagle has landed!',
            body:
            "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {'notificationId': '1234567890'}),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'REPLY',
              label: 'Reply Message',
              requireInputText: true,
              actionType: ActionType.SilentAction
          ),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ]);
  }

  static Future<void> scheduleNewNotification() async {
    bool isAllowed = await AwesomeNotifications().isNotificationAllowed();
    if (!isAllowed) isAllowed = await displayNotificationRationale();
    if (!isAllowed) return;

    await AwesomeNotifications().createNotification(
        content: NotificationContent(
            id: -1, // -1 is replaced by a random number
            channelKey: 'alerts',
            title: "Huston! The eagle has landed!",
            body:
            "A small step for a man, but a giant leap to Flutter's community!",
            bigPicture: 'https://storage.googleapis.com/cms-storage-bucket/d406c736e7c4c57f5f61.png',
            largeIcon: 'https://storage.googleapis.com/cms-storage-bucket/0dbfcc7a59cd1cf16282.png',
            //'asset://assets/images/balloons-in-sky.jpg',
            notificationLayout: NotificationLayout.BigPicture,
            payload: {
              'notificationId': '1234567890'
            }),
        actionButtons: [
          NotificationActionButton(key: 'REDIRECT', label: 'Redirect'),
          NotificationActionButton(
              key: 'DISMISS',
              label: 'Dismiss',
              actionType: ActionType.DismissAction,
              isDangerousOption: true)
        ],
        schedule: NotificationCalendar.fromDate(
            date: DateTime.now().add(const Duration(seconds: 10))));
  }

  static Future<void> resetBadgeCounter() async {
    await AwesomeNotifications().resetGlobalBadge();
  }

  static Future<void> cancelNotifications() async {
    await AwesomeNotifications().cancelAll();
  }
}
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  print("onBackgroundMessage: $message");
}
class MyApp extends StatefulWidget {
  const MyApp({Key key}) : super(key: key);

// The navigator key is necessary to navigate using static methods
  static final GlobalKey<NavigatorState> navigatorKey =
  GlobalKey<NavigatorState>();


  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override

  void initState() {
    NotificationController.startListeningNotificationEvents();
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print("onMessage: $message");
    });
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) async {
      print("onMessageOpenedApp: $message");
    });
      // if (message.data["navigation"] == "/your_route") {
      //   int _yourId = int.tryParse(message.data["id"]) ?? 0;
      //   Navigator.push(
      //       navigatorKey.currentState.context,
      //       MaterialPageRoute(
      //           builder: (context) => YourScreen(
      //             yourId:_yourId,
      //           )));
      // });
    super.initState();
  }
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
