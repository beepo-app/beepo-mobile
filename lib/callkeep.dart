// import 'dart:async';
//
// import 'package:firebase_core/firebase_core.dart';
// import 'package:firebase_messaging/firebase_messaging.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_callkit_incoming/entities/android_params.dart';
// import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
// import 'package:flutter_callkit_incoming/entities/ios_params.dart';
// import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
// // import 'package:flutter_callkit_incoming_example/app_router.dart';
// // import 'package:flutter_callkit_incoming_example/navigation_service.dart';
// import 'package:uuid/uuid.dart';
//
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   print("Handling a background message: ${message.messageId}");
//   showCallkitIncoming(Uuid().v4());
// }
//
// Future<void> showCallkitIncoming(String uuid) async {
//   final params = CallKitParams(
//     id: uuid,
//     nameCaller: 'Hien Nguyen',
//     appName: 'Callkit',
//     avatar: 'https://i.pravatar.cc/100',
//     handle: '0123456789',
//     type: 0,
//     duration: 30000,
//     textAccept: 'Accept',
//     textDecline: 'Decline',
//     textMissedCall: 'Missed call',
//     textCallback: 'Call back',
//     extra: <String, dynamic>{'userId': '1a2b3c4d'},
//     headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
//     android: const AndroidParams(
//       isCustomNotification: true,
//       isShowLogo: false,
//       isShowCallback: true,
//       isShowMissedCallNotification: true,
//       ringtonePath: 'system_ringtone_default',
//       backgroundColor: '#0955fa',
//       backgroundUrl: 'assets/test.png',
//       actionColor: '#4CAF50',
//     ),
//     ios: IOSParams(
//       iconName: 'CallKitLogo',
//       handleType: '',
//       supportsVideo: true,
//       maximumCallGroups: 2,
//       maximumCallsPerCallGroup: 1,
//       audioSessionMode: 'default',
//       audioSessionActive: true,
//       audioSessionPreferredSampleRate: 44100.0,
//       audioSessionPreferredIOBufferDuration: 0.005,
//       supportsDTMF: true,
//       supportsHolding: true,
//       supportsGrouping: false,
//       supportsUngrouping: false,
//       ringtonePath: 'system_ringtone_default',
//     ),
//   );
//   await FlutterCallkitIncoming.showCallkitIncoming(params);
// }
//
// void main() {
//   WidgetsFlutterBinding.ensureInitialized();
//   runApp(MyApp());
// }
//
// class MyApp extends StatefulWidget {
//   @override
//   _MyAppState createState() => _MyAppState();
// }
//
// class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
//    Uuid _uuid;
//   String _currentUuid;
//
//   FirebaseMessaging _firebaseMessaging;
//
//   @override
//   void initState() {
//     super.initState();
//     _uuid = Uuid();
//     initFirebase();
//     WidgetsBinding.instance.addObserver(this);
//     //Check call when open app from terminated
//     checkAndNavigationCallingPage();
//   }
//
//   getCurrentCall() async {
//     //check current call from pushkit if possible
//     var calls = await FlutterCallkitIncoming.activeCalls();
//     if (calls is List) {
//       if (calls.isNotEmpty) {
//         print('DATA: $calls');
//         _currentUuid = calls[0]['id'];
//         return calls[0];
//       } else {
//         _currentUuid = "";
//         return null;
//       }
//     }
//   }
//
//   checkAndNavigationCallingPage() async {
//     var currentCall = await getCurrentCall();
//     if (currentCall != null) {
//       // NavigationService.instance
//       //     .pushNamedIfNotCurrent(AppRoute.callingPage, args: currentCall);
//     }
//   }
//
//   @override
//   Future<void> didChangeAppLifecycleState(AppLifecycleState state) async {
//     print(state);
//     if (state == AppLifecycleState.resumed) {
//       //Check call when open app from background
//       checkAndNavigationCallingPage();
//     }
//   }
//
//   @override
//   void dispose() {
//     WidgetsBinding.instance.removeObserver(this);
//     super.dispose();
//   }
//
//   initFirebase() async {
//     await Firebase.initializeApp();
//     _firebaseMessaging = FirebaseMessaging.instance;
//     FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
//     FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
//       print(
//           'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}');
//       _currentUuid = _uuid.v4();
//       showCallkitIncoming(_currentUuid);
//     });
//     _firebaseMessaging.getToken().then((token) {
//       print('Device Token FCM: $token');
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       theme: ThemeData.light(),
//       onGenerateRoute: AppRoute.generateRoute,
//       initialRoute: AppRoute.homePage,
//       navigatorKey: NavigationService.instance.navigationKey,
//       navigatorObservers: <NavigatorObserver>[
//         NavigationService.instance.routeObserver
//       ],
//     );
//   }
//
//   Future<void> getDevicePushTokenVoIP() async {
//     var devicePushTokenVoIP =
//     await FlutterCallkitIncoming.getDevicePushTokenVoIP();
//     print(devicePushTokenVoIP);
//   }
// }


// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:story_view/story_view.dart';

class Test extends StatelessWidget {
  final StoryController controller = StoryController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Delicious Ghanaian Meals"),
      ),
      body: Container(
        margin: EdgeInsets.all(
          8,
        ),
        child: ListView(
          children: <Widget>[
            Container(
              height: 300,
              child: StoryView(
                controller: controller,
                storyItems: [
                  StoryItem.text(
                    title:
                    "Hello world!\nHave a look at some great Ghanaian delicacies. I'm sorry if your mouth waters. \n\nTap!",
                    backgroundColor: Colors.orange,
                    roundedTop: true,
                  ),
                  // StoryItem.inlineImage(
                  //   NetworkImage(
                  //       "https://image.ibb.co/gCZFbx/Banku-and-tilapia.jpg"),
                  //   caption: Text(
                  //     "Banku & Tilapia. The food to keep you charged whole day.\n#1 Local food.",
                  //     style: TextStyle(
                  //       color: Colors.white,
                  //       backgroundColor: Colors.black54,
                  //       fontSize: 17,
                  //     ),
                  //   ),
                  // ),
                  StoryItem.inlineImage(
                    url:
                    "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
                    controller: controller,
                    caption: Text(
                      "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  StoryItem.inlineImage(
                    url:
                    "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
                    controller: controller,
                    caption: Text(
                      "Hektas, sektas and skatad",
                      style: TextStyle(
                        color: Colors.white,
                        backgroundColor: Colors.black54,
                        fontSize: 17,
                      ),
                    ),
                  )
                ],
                onStoryShow: (s) {
                  print("Showing a story");
                },
                onComplete: () {
                  print("Completed a cycle");
                },
                progressPosition: ProgressPosition.bottom,
                repeat: false,
                inline: true,
              ),
            ),
            Material(
              child: InkWell(
                onTap: () {
                  Navigator.of(context).push(
                      MaterialPageRoute(builder: (context) => More()));
                },
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.black54,
                      borderRadius:
                      BorderRadius.vertical(bottom: Radius.circular(8))),
                  padding: EdgeInsets.symmetric(vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.arrow_forward,
                        color: Colors.white,
                      ),
                      SizedBox(
                        width: 16,
                      ),
                      Text(
                        "View more stories",
                        style: TextStyle(fontSize: 16, color: Colors.white),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class More extends StatefulWidget {
  @override
  _MoreState createState() => _MoreState();
}

class _MoreState extends State<More> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
      ),
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
            "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
    );
  }
}