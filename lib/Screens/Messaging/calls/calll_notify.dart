// ignore_for_file: avoid_print

import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/calls/calls.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';
import 'package:get/get.dart' as note;
import 'package:hive/hive.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import '../../../Utils/styles.dart';

class Calls {
  final stopWatchTimer = StopWatchTimer(mode: StopWatchMode.countUp);
  int time = 0;
  Map userM = Hive.box('beepo').get('userData');

  startCall({
    String uid,
    String name,
    String userName,
    UserModel model,
    bool hasVideo,
    String channel,
  }) async {
    // this._currentUuid = _uuid.v4();
    CallKitParams params = CallKitParams(
      id: uid,
      nameCaller: name,
      handle: userName,
      type: 1,
      extra: <String, dynamic>{'userId': uid},
      ios: IOSParams(handleType: 'generic'),
    );
    await FlutterCallkitIncoming.startCall(params);
    FlutterCallkitIncoming.onEvent.listen((CallEvent event) {
      switch (event.event) {
        case Event.ACTION_CALL_START:
          () {
            while (event.event != Event.ACTION_CALL_ACCEPT) {
              Timer(const Duration(seconds: 30), () {
                endCall(uid);
                showMissedCall();
                note.Get.back();
              });
            }
          };
          break;
        case Event.ACTION_CALL_ACCEPT:
          () {
            //   note.Get.to(VideoCall(
            //     name: model,
            //     isVideo: hasVideo,
            //     channelName: channel,
            //     role: ClientRole.Broadcaster,
            //     // time: time,
            //   ));
            //   stopWatchTimer.rawTime.listen((event) {
            //     time = event;
            //     print(event);
            //   });
          };

          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_DECLINE:(){
          endCall(uid);
          showMissedCall(uid: uid, name: name);

        };
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED:
          () {
            stopWatchTimer.onStopTimer();
            FirebaseFirestore.instance
                .collection('calls')
                .doc(userM['uid'])
                .collection('allCalls')
                .add({
              'name': name,
              'image': model.image,
              'callType': 'startCall',
              'created': Timestamp.now(),
            });
          };
          // TODO: ended an incoming/outgoing call
          break;

        case Event.ACTION_CALL_TIMEOUT:
          () {
            showMissedCall(uid: uid, name: name);
            note.Get.back();
          };
          // TODO: missed an incoming call
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_INCOMING:
          // TODO: Handle this case.
          break;
      }
    });
  }

  endCall(String uid) async {
    await FlutterCallkitIncoming.endCall(uid);
    note.Get.back();
  }

  receiveIncomingCall({
    String uid,
    String name,
    UserModel model,
    bool hasVideo,
    String userName,
    String image,
    String channel,
  }) async {
    // this._currentUuid = _uuid.v4();
    CallKitParams callKitParams = CallKitParams(
      id: uid,
      nameCaller: name,
      appName: 'Beepo',
      avatar: image,
      handle: userName,
      type: 0,
      textAccept: 'Accept',
      textDecline: 'Decline',
      textMissedCall: 'Missed call',
      // textCallback: 'Call back',
      duration: 30000,
      extra: <String, dynamic>{'userId': uid},
      // headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
      android: const AndroidParams(
        isCustomNotification: true,
        isShowLogo: true,
        isShowCallback: true,
        isShowMissedCallNotification: true,
        ringtonePath: 'default',
        backgroundColor: '#FF9C34',
        backgroundUrl: 'https://beepoapp.net/images/landing/01.png',
        actionColor: '#4CAF50',
        incomingCallNotificationChannelName: "Incoming Call",
        missedCallNotificationChannelName: "Missed Call",
      ),
      ios: IOSParams(
        iconName: 'CallKitLogo',
        handleType: 'generic',
        supportsVideo: true,
        maximumCallGroups: 2,
        maximumCallsPerCallGroup: 1,
        audioSessionMode: 'default',
        audioSessionActive: true,
        audioSessionPreferredSampleRate: 44100.0,
        audioSessionPreferredIOBufferDuration: 0.005,
        supportsDTMF: true,
        supportsHolding: true,
        supportsGrouping: false,
        supportsUngrouping: false,
        ringtonePath: 'system_ringtone_default',
      ),
    );
    await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);

    FlutterCallkitIncoming.onEvent.listen((CallEvent event) {
      switch (event.event) {
        case Event.ACTION_CALL_INCOMING:
          () {
            print('$name Call incoming');
            FirebaseFirestore.instance
                .collection('calls')
                .doc(userM['uid'])
                .collection('allCalls')
                .add({
              'name': name,
              'image': model.image,
              'callType': 'callReceived',
              'created': Timestamp.now(),
            });
          };
          // TODO: received an incoming call
          break;
        case Event.ACTION_CALL_START:
          () {
            FirebaseFirestore.instance
                .collection('calls')
                .doc(userM['uid'])
                .collection('allCalls')
                .add({
              'name': name,
              'image': model.image,
              'callType': 'callReceived',
              'created': Timestamp.now(),
            });
            note.Get.to(VideoCall(
              name: model,
              isVideo: hasVideo,
              channelName: channel,
              role: ClientRole.Broadcaster,
              // time: time,
            ));

          };
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_ACCEPT:
          note.Get.to(VideoCall(
            name: model,
            isVideo: hasVideo,
            channelName: channel,
            role: ClientRole.Broadcaster,
            // time: time,
          ));
          //   stopWatchTimer.onStartTimer();
          // };
          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_DECLINE:
          () {
            FirebaseFirestore.instance
                .collection('calls')
                .doc(userM['uid'])
                .collection('allCalls')
                .add({
              'name': name,
              'image': model.image,
              'callType': 'callReceived',
              'created': Timestamp.now(),
            });
          };

          // showMissedCall(uid: uid, name: name);
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED:() {
          note.Get.back();
          FirebaseFirestore.instance
              .collection('calls')
              .doc(userM['uid'])
              .collection('allCalls')
              .add({
            'name': name,
            'image': model.image,
            'callType': 'callReceived',
          });
        };
          // TODO: ended an incoming/outgoing call
          break;

        case Event.ACTION_CALL_TIMEOUT:
          // TODO: missed an incoming call
          break;
        case Event.ACTION_CALL_CALLBACK:
          // TODO: only Android - click action `Call back` from missed call notification
          break;
        case Event.ACTION_CALL_TOGGLE_HOLD:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_MUTE:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_DMTF:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_GROUP:
          // TODO: only iOS
          break;
        case Event.ACTION_CALL_TOGGLE_AUDIO_SESSION:
          // TODO: only iOS
          break;
        case Event.ACTION_DID_UPDATE_DEVICE_PUSH_TOKEN_VOIP:
          // TODO: only iOS
          break;
      }
    });
  }

  showMissedCall({String uid, String name}) async {
    // this._currentUuid = _uuid.v4();
    CallKitParams params = CallKitParams(
      id: uid,
      nameCaller: name,
      handle: '0123456789',
      type: 1,
      textMissedCall: 'Missed call',
      // textCallback: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
    );
    await FlutterCallkitIncoming.showMissCallNotification(params);
  }
}
