import 'dart:async';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Utils/styles.dart';

class VideoCall extends StatefulWidget {
  final String channelName;
  final ClientRole role;
  final String name;

  const VideoCall({Key key, this.channelName, this.role, @required this.name}) : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  RtcEngine _engine;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add('please provide app id');
      });
      return;
    }
    _engine = await RtcEngine.create(APP_ID);
    await _engine.enableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    _addAgoraEventHandler();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1000);
    await _engine.setVideoEncoderConfiguration(configuration);
    // await getToken();
    await _engine.joinChannel(Token, widget.channelName, null, 0);
  }
  String baseUrl = ''; //Add the link to your deployed server here
  int uid = 0;
  String token;

  // Future<void> getToken() async {
  //   final response = await http.get(
  //     Uri.parse(baseUrl + '/rtc/' + widget.channelName + '/publisher/uid/' + uid.toString()
  //       // To add expiry time uncomment the below given line with the time in seconds
  //       // + '?expiry=45'
  //     ),
  //   );
  //
  //   if (response.statusCode == 200) {
  //     setState(() {
  //       token = response.body;
  //       token = jsonDecode(token)['rtcToken'];
  //     });
  //   } else {
  //     print('Failed to fetch the token');
  //   }
  // }
  void _addAgoraEventHandler() {
    _engine.setEventHandler(
      RtcEngineEventHandler(error: (code) {
        setState(() {
          final info = 'Error: $code';
          _infoStrings.add(info);
        });
      }, joinChannelSuccess: (channel, uid, elapsed) async {
        // await NotificationController.createNewNotification(channel);

        setState(() {
          final info = 'Join Channel: $channel, uid: $uid';
          _infoStrings.add(info);
        });
      }, leaveChannel: (stats) {
        setState(() {
          _infoStrings.add('leave channel');
          _users.clear();
        });
      }, userJoined: (uid, elapsed) {
        setState(() {
          final info = 'User joined: $uid';
          _infoStrings.add(info);
          _users.add(uid);
        });
      }, userOffline: (uid, elapsed) {
        setState(() {
          final info = 'User Offline: $uid';
          _infoStrings.add(info);
          _users.remove(uid);
        });
      }, firstRemoteVideoFrame: (uid, width, height, elapsed) {
        setState(() {
          final info = 'First remote Video: $uid ${width}x $height';
          _infoStrings.add(info);
        });
      },
        tokenPrivilegeWillExpire: (token) async {
          // await getToken();
          await _engine.renewToken(token);
        }
      ),
    );
  }

  Widget _viewRows() {
    final List<StatefulWidget> list = [];
    if (widget.role == ClientRole.Broadcaster) {
      list.add(const rtc_local_view.SurfaceView());
    }
    for (var uid in _users) {
      list.add(rtc_remote_view.SurfaceView(
        uid: uid,
        channelId: widget.channelName,
      ));
    }
    final views = list;
    return Column(
      children:
          List.generate(views.length, (index) => Expanded(child: views[index])),
    );
  }

  Widget _toolbar() {
    if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                muted = !muted;
              });
              _engine.muteLocalAudioStream(muted);
            },
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15),
          ),
          RawMaterialButton(
            onPressed: () {
              _engine.switchCamera();
            },
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20,
            ),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12),
          )
        ],
      ),
    );
  }

  Widget _panel() {
    return Visibility(
        visible: viewPanel,
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 48),
          alignment: Alignment.bottomCenter,
          child: FractionallySizedBox(
            heightFactor: 0.5,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 48),
              child: ListView.builder(
                  reverse: true,
                  itemCount: _infoStrings.length,
                  itemBuilder: (context, index) {
                    if (_infoStrings.isEmpty) {
                      return const Text("null");
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 3, horizontal: 10),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 2, horizontal: 5),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(5),
                              ),
                              child: Text(
                                _infoStrings[index],
                                style: const TextStyle(color: Colors.blueGrey),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
            ),
          ),
        ));
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();
    _engine.destroy();
    super.dispose();
  }
  Map userM = Hive.box('beepo').get('userData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title:  Text(widget.name),
        centerTitle: true,
        backgroundColor: secondaryColor,
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                viewPanel = !viewPanel;
              });
            },
            icon: const Icon(Icons.info_outline),
          )
        ],
      ),
      backgroundColor: Colors.black,
      body: Center(
        child: Stack(
          children: [
            _viewRows(),
            _panel(),
            _toolbar(),
          ],
        ),
      ),
    );
  }
}
