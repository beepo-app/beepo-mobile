// ignore_for_file: prefer_const_constructors, unnecessary_this, avoid_print

import 'package:beepo/Utils/extensions.dart';
import 'package:beepo/Providers/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:onesignal_flutter/onesignal_flutter.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import 'Models/user_model.dart';
import 'Screens/Auth/lock_screen.dart';
import 'Screens/Auth/onboarding.dart';
import 'Screens/Messaging/calls/calll_notify.dart';
import 'Screens/moments/story_download_provider.dart';
import 'Screens/moments/story_upload_provider.dart';
import 'Service/xmtp.dart';
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

String playerId = '';

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

// The navigator key is necessary to navigate using static methods
  static final navigatorKey = GlobalKey<NavigatorState>();

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _debugLabelString = "";

  bool _enableConsentButton = true;

  oneSignalInAppMessagingTriggerExamples() async {
    /// Example addTrigger call for IAM
    /// This will add 1 trigger so if there are any IAM satisfying it, it
    /// will be shown to the user
    OneSignal.shared.addTrigger("trigger_1", "one");

    /// Example addTriggers call for IAM
    /// This will add 2 triggers so if there are any IAM satisfying these, they
    /// will be shown to the user
    Map<String, Object> triggers = <String, Object>{};
    triggers["trigger_2"] = "two";
    triggers["trigger_3"] = "three";
    OneSignal.shared.addTriggers(triggers);

    // Removes a trigger by its key so if any future IAM are pulled with
    // these triggers they will not be shown until the trigger is added back
    OneSignal.shared.removeTriggerForKey("trigger_2");

    // Get the value for a trigger by its key
    Object? triggerValue =
        await OneSignal.shared.getTriggerValueForKey("trigger_3");
    print("'trigger_3' key trigger value: ${triggerValue?.toString()}");

    // Create a list and bulk remove triggers based on keys supplied
    List<String> keys = ["trigger_1", "trigger_3"];
    OneSignal.shared.removeTriggersForKeys(keys);

    // Toggle pausing (displaying or not) of IAMs
    OneSignal.shared.pauseInAppMessages(false);
  }

  Future<void> outcomeAwaitExample() async {
    var outcomeEvent = await OneSignal.shared.sendOutcome("await_normal_1");
    print(outcomeEvent.jsonRepresentation());
  }

  oneSignalOutcomeEventsExamples() async {
    // Await example for sending outcomes
    outcomeAwaitExample();

    // Send a normal outcome and get a reply with the name of the outcome
    OneSignal.shared.sendOutcome("normal_1");
    OneSignal.shared.sendOutcome("normal_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send a unique outcome and get a reply with the name of the outcome
    OneSignal.shared.sendUniqueOutcome("unique_1");
    OneSignal.shared.sendUniqueOutcome("unique_2").then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });

    // Send an outcome with a value and get a reply with the name of the outcome
    OneSignal.shared.sendOutcomeWithValue("value_1", 3.2);
    OneSignal.shared.sendOutcomeWithValue("value_2", 3.9).then((outcomeEvent) {
      print(outcomeEvent.jsonRepresentation());
    });
  }

  final bool _requireConsent = true;
  Map userM = Hive.box('beepo').get('userData');

  void _handleGetDeviceState() async {
    print("Getting DeviceState");
    OneSignal.shared.getDeviceState().then((deviceState) {
      print("DeviceState: ${deviceState?.jsonRepresentation()}");
      this.setState(() {
        _debugLabelString =
            deviceState?.jsonRepresentation() ?? "Device state null";
        print('USER ID IS ${deviceState!.userId}');
        playerId = deviceState.userId!;
        FirebaseFirestore.instance
            .collection('OneSignal')
            .doc(userM['uid'])
            .set({
          'playerId': playerId,
        });
      });
    });
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    if (!mounted) return;

    OneSignal.shared.setLogLevel(OSLogLevel.verbose, OSLogLevel.none);
    OneSignal.shared.setRequiresUserPrivacyConsent(true);
    OneSignal.shared.consentGranted(true);

    await OneSignal.shared.setAppId('8f26effe-fda3-4034-a262-be12f4c5c47e');
    _handleGetDeviceState();

    OneSignal.shared.setExternalUserId(userM['uid']).then((results) {
      results.toString().log();
    }).catchError((error) {
      error.toString().log();
    });
    // Preferences.

    OneSignal.shared
        .setNotificationOpenedHandler((OSNotificationOpenedResult result) {
      print('NOTIFICATION OPENED HANDLER CALLED WITH: $result');
      setState(() {
        _debugLabelString =
            "Opened notification: \n${result.notification.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setInAppMessageClickedHandler((OSInAppMessageAction action) {
      setState(() {
        _debugLabelString =
            "In App Message Clicked: \n${action.jsonRepresentation().replaceAll("\\n", "\n")}";
      });
    });

    OneSignal.shared
        .setSubscriptionObserver((OSSubscriptionStateChanges changes) {
      print("SUBSCRIPTION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    OneSignal.shared.setPermissionObserver((OSPermissionStateChanges changes) {
      print("PERMISSION STATE CHANGED: ${changes.jsonRepresentation()}");
    });

    // OneSignal.shared.setEmailSubscriptionObserver(
    //     (OSEmailSubscriptionStateChanges changes) {
    //   print("EMAIL SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    // });

    // OneSignal.shared
    //     .setSMSSubscriptionObserver((OSSMSSubscriptionStateChanges changes) {
    //   print("SMS SUBSCRIPTION STATE CHANGED ${changes.jsonRepresentation()}");
    // });

    OneSignal.shared.setOnWillDisplayInAppMessageHandler((message) {
      print("ON WILL DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDisplayInAppMessageHandler((message) {
      print("ON DID DISPLAY IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnWillDismissInAppMessageHandler((message) {
      print("ON WILL DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.setOnDidDismissInAppMessageHandler((message) {
      print("ON DID DISMISS IN APP MESSAGE ${message.messageId}");
    });

    OneSignal.shared.promptUserForPushNotificationPermission().then((accepted) {
      print("Accepted permission: $accepted");
    });
    // iOS-only method to open launch URLs in Safari when set to false
    OneSignal.shared.setLaunchURLsInApp(false);

    bool requiresConsent = await OneSignal.shared.requiresUserPrivacyConsent();

    setState(() {
      _enableConsentButton = requiresConsent;
    });

    // Some examples of how to use In App Messaging public methods with OneSignal SDK
    oneSignalInAppMessagingTriggerExamples();

    OneSignal.shared.disablePush(false);

    // Some examples of how to use Outcome Events public methods with OneSignal SDK
    oneSignalOutcomeEventsExamples();

    bool userProvidedPrivacyConsent =
        await OneSignal.shared.userProvidedPrivacyConsent();
    print("USER PROVIDED PRIVACY CONSENT: $userProvidedPrivacyConsent");
  }

  var uuid = Uuid();

  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;

  Future<void> _firebaseMessagingBackgroundHandler(
      RemoteMessage message) async {
    await Firebase.initializeApp();
    print("Handling a background message: ${message.messageId}");

    Calls().receiveIncomingCall(
      uid: uuid.v4(),
      name: message.data['name'],
      model: UserModel(
        name: message.data['name'],
        uid: message.data['uid'],
        userName: message.data['userName'],
        image: message.data['image'],
        bitcoinWalletAddress: '',
        firebaseToken: '',
        hdWalletAddress: '',
        searchKeywords: [],
        stories: [],
      ),
      hasVideo: message.data['hasVideo'] == 'true' ? true : false,
      userName: message.data['userName'],
      image: message.data['image'],
      channel: message.data['channelName'],
    );
  }

  initFirebase(bool hasVideo) async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );
    print('User granted permission: ${settings.authorizationStatus}');
    await Firebase.initializeApp();

    _firebaseMessaging.getToken().then((token) {
      print('Device Token FCM: $token');
      FirebaseFirestore.instance.collection('FCMToken').doc(userM['uid']).set({
        'token': token,
      });
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print(
        'Message title: ${message.notification?.title}, body: ${message.notification?.body}, data: ${message.data}',
      );
      FirebaseFirestore.instance
          .collection('calls')
          .doc(userM['uid'])
          .collection('allCalls')
          .add({
        'name': message.data['name'],
        'image': message.data['image'],
        'callType': 'callReceived',
        'created': Timestamp.now(),
      });
      // _currentUuid = uuid.v4();
      Calls().receiveIncomingCall(
        uid: uuid.v4(),
        name: message.data['name'],
        model: UserModel(
          name: message.data['name'],
          uid: message.data['uid'],
          userName: message.data['userName'],
          image: message.data['image'],
          bitcoinWalletAddress: '',
          firebaseToken: '',
          hdWalletAddress: '',
          searchKeywords: [],
          stories: [],
        ),
        hasVideo: message.data['hasVideo'] == 'true' ? true : false,
        userName: message.data['userName'],
        image: message.data['image'],
        channel: message.data['channelName'],
      );
    }, onDone: () {
      Calls().endCall(uuid.v4());
    });
    // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  }

  @override
  void initState() {
    initPlatformState();
    initFirebase(true);
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
        ChangeNotifierProvider<XMTPProvider>(
          create: (_) => XMTPProvider(),
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
