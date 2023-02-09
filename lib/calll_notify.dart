import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/calls.dart';
import 'package:flutter/material.dart';
import 'package:flutter_callkit_incoming/entities/android_params.dart';
import 'package:flutter_callkit_incoming/entities/call_event.dart';
import 'package:flutter_callkit_incoming/entities/call_kit_params.dart';
import 'package:flutter_callkit_incoming/entities/ios_params.dart';
import 'package:flutter_callkit_incoming/flutter_callkit_incoming.dart';

class Calls {
  startCall({String uid, String name, String userName}) async {
    // this._currentUuid = _uuid.v4();
    CallKitParams params = CallKitParams(
        id: uid,
        nameCaller: name,
        handle: userName,
        type: 1,
        extra: <String, dynamic>{'userId': '1a2b3c4d'},
        ios: IOSParams(handleType: 'generic'),
    );
    await FlutterCallkitIncoming.startCall(params);
  }

  endCall(String uid) async {
    await FlutterCallkitIncoming.endCall(uid);
  }

  receiveIncomingCall(
      {String uid, String name, UserModel model, bool hasVideo, String userName, String image, BuildContext context,}) async {
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
      textCallback: 'Call back',
      duration: 30000,
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
      headers: <String, dynamic>{'apiKey': 'Abc@123!', 'platform': 'flutter'},
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
          missedCallNotificationChannelName: "Missed Call"),
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

    FlutterCallkitIncoming.onEvent.listen((CallEvent event) {
      switch (event.event) {
        case Event.ACTION_CALL_INCOMING: ()async{
          await FlutterCallkitIncoming.showCallkitIncoming(callKitParams);
        };
          // TODO: received an incoming call
          break;
        case Event.ACTION_CALL_START: (){
           Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => VideoCall(
                name: model,
                isVideo: hasVideo,
                channelName: 'peace',
                role: ClientRole.Audience,
              )));
        };
          // TODO: started an outgoing call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_ACCEPT:

            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => VideoCall(
                      name: model,
                      isVideo: hasVideo,
                      channelName: 'peace',
                      role: ClientRole.Audience,
                    )));

          // TODO: accepted an incoming call
          // TODO: show screen calling in Flutter
          break;
        case Event.ACTION_CALL_DECLINE: showMissedCall(uid: uid, name: name);
          // TODO: declined an incoming call
          break;
        case Event.ACTION_CALL_ENDED: endCall(uid);
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
      textCallback: 'Call back',
      extra: <String, dynamic>{'userId': '1a2b3c4d'},
    );
    await FlutterCallkitIncoming.showMissCallNotification(params);
  }
}
