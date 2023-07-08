// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:agora_rtc_engine/rtc_engine.dart';
import 'package:agora_rtc_engine/rtc_local_view.dart' as rtc_local_view;
import 'package:agora_rtc_engine/rtc_remote_view.dart' as rtc_remote_view;
import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:hive/hive.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../../Constants/app_constants.dart';
import '../../../Models/user_model.dart';
import '../../../Providers/provider.dart';
import '../../../Utils/styles.dart';
import 'calll_notify.dart';

List<Widget> callLog = [];

class VideoCall extends StatefulWidget {
  final String channelName;
  final ClientRole role;
  final UserModel name;
  final bool isVideo;

  const VideoCall(
      {Key? key,
      required this.name,
      required this.isVideo,
      required this.channelName,
      required this.role})
      : super(key: key);

  @override
  State<VideoCall> createState() => _VideoCallState();
}

class _VideoCallState extends State<VideoCall>
    with SingleTickerProviderStateMixin {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;
  bool viewPanel = false;
  late RtcEngine _engine;

  late AnimationController _controller;

  /// The alignment of the card as it is dragged or being animated.
  ///
  /// While the card is being dragged, this value is set to the values computed
  /// in the GestureDetector onPanUpdate callback. If the animation is running,
  /// this value is set to the value of the [_animation].
  Alignment _dragAlignment = Alignment.bottomCenter;

  late Animation<Alignment> _animation;

  bool get isFreelyDragged => _dragAlignment.y < 0;
  late Offset panPosition;

  /// Calculates and runs a [SpringSimulation].
  void _runAnimation(Offset pixelsPerSecond, Size size) {
    _animation = _controller.drive(
      AlignmentTween(
        begin: _dragAlignment,
        end: isFreelyDragged ? Alignment.topCenter : Alignment.bottomCenter,
      ),
    );

    // Calculate the velocity relative to the unit interval, [0,1],
    // used by the animation controller.
    final unitsPerSecondX = pixelsPerSecond.dx / size.width;
    final unitsPerSecondY = pixelsPerSecond.dy / size.height;
    final unitsPerSecond = Offset(unitsPerSecondX, unitsPerSecondY);
    final unitVelocity = unitsPerSecond.distance;

    const spring = SpringDescription(
      mass: 50,
      stiffness: 1,
      damping: 1,
    );

    final simulation = SpringSimulation(spring, 0, 1, -unitVelocity);

    _controller.animateWith(simulation);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      if (context.watch<ChatNotifier>().enableScreenShot == true) {
        Provider.of<ChatNotifier>(context, listen: false).secureScreen();
      }
    });
    initialize();
    _controller = AnimationController(vsync: this);

    _controller.addListener(() {
      setState(() {
        _dragAlignment = _animation.value;
      });
    });
  }

  String token =
      "007eJxTYFD27/L7sPmSvUwwd1V0nMN54RkLFS72h7gVP/hg9LRzlogCg5GlialJilGyWZqBoYmJaVpSUpJZSpKBpWliSmqyoamZx7xbyQ2BjAyVQgUsjAwQCOJzMngkJmc75qWn5jAwAACOWSAN";

  Future<void> initialize() async {
    if (APP_ID.isEmpty) {
      setState(() {
        _infoStrings.add('please provide app id');
      });
      return;
    }
    _engine = await RtcEngine.create(APP_ID);
    widget.isVideo == true
        ? await _engine.enableVideo()
        : _engine.disableVideo();
    await _engine.setChannelProfile(ChannelProfile.LiveBroadcasting);
    await _engine.setClientRole(widget.role);
    _addAgoraEventHandler();
    VideoEncoderConfiguration configuration = VideoEncoderConfiguration();
    configuration.dimensions = const VideoDimensions(width: 1920, height: 1000);
    await _engine.setVideoEncoderConfiguration(configuration);
    await getToken();
    await _engine.joinChannel(token, widget.channelName, null, 0);
  }

  String baseUrl =
      'https://core.api.beepoapp.net'; //Add the link to your deployed server here
  int uid = 0;

  Future<void> getToken() async {
    final response = await http.get(
      Uri.parse(baseUrl +
              '/rtc/' +
              widget.channelName +
              '/publisher/uid/' +
              uid.toString()
          // To add expiry time uncomment the below given line with the time in seconds
          // + '?expiry=45'
          ),
    );

    if (response.statusCode == 200) {
      if (mounted) {
        setState(() {
          token = response.body;
          token = jsonDecode(token)['rtcToken'];
        });
      }
    } else {
      print('Failed to fetch the token');
    }
  }

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
      }, tokenPrivilegeWillExpire: (token) async {
        await getToken();
        await _engine.renewToken(token);
      }),
    );
  }

  Widget _viewRows() {
    final size = MediaQuery.of(context).size;
    final width = isFreelyDragged ? 100.0 : size.width;
    final height = isFreelyDragged ? 100.0 : size.height / 2;
    final underHeight = isFreelyDragged ? size.height : size.height / 2;

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
    if (widget.isVideo == true) {
      if (views.length == 1) {
        return Padding(
          padding: const EdgeInsets.all(8.0) + const EdgeInsets.only(top: 3),
          child: AnimatedContainer(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
            ),
            // color: Colors.amber,
            duration: const Duration(milliseconds: 50),
            child: views[0],
            clipBehavior: Clip.hardEdge,
          ),
        );
      } else if (views.length == 2) {
        return Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.all(8.0) + const EdgeInsets.only(top: 3),
              child: AnimatedContainer(
                width: size.width,
                height: underHeight - 40,
                clipBehavior: Clip.hardEdge,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                ),

                // color: Colors.amber,
                duration: const Duration(milliseconds: 50),
                child: views[1],
              ),
            ),
            GestureDetector(
              onPanDown: (details) {
                _controller.stop();
              },
              onPanUpdate: (details) {
                panPosition = details.globalPosition;
                setState(() {
                  _dragAlignment += Alignment(
                    details.delta.dx / (size.width / 2),
                    details.delta.dy / (size.height / 2),
                  );
                });
              },
              onPanEnd: (details) {
                _runAnimation(details.velocity.pixelsPerSecond, size);
              },
              child: Align(
                alignment: isFreelyDragged
                    ? Alignment(
                        (panPosition.dx / size.width) * 2 - 1,
                        (panPosition.dy / size.height) * 2 - 1 - 0.2,
                      )
                    : _dragAlignment,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: AnimatedContainer(
                    width: width,
                    clipBehavior: Clip.hardEdge,
                    height: height,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      // image: DecorationImage(
                      //   fit: BoxFit.fill,
                      //   image: AssetImage('images/selfie1.webp'),
                      // ),
                    ),
                    // color: Colors.pink,
                    duration: const Duration(milliseconds: 50),
                    child: views[0],
                  ),
                ),
              ),
            ),
          ],
        );
      }
      return const SizedBox();
    } else {
      return Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(widget.name.image!),
            fit: BoxFit.cover,
          ),
        ),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
          child: Container(
            decoration: BoxDecoration(color: Colors.white.withOpacity(0.0)),
            // child: const CircleAvatar(
            //   // backgroundImage: NetworkImage(widget.name.image),
            //   // radius: 100,
            //
            // ),
            clipBehavior: Clip.hardEdge,
          ),
        ),
      );
    }
  }

  // Column(
  // children:
  //     List.generate(views.length, (index) => Expanded(child: views[index])),
  // );

  bool enabled = true;

  Widget _toolbar() {
    // if (widget.role == ClientRole.Audience) return const SizedBox();
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: widget.isVideo == true
          ? Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                RawMaterialButton(
                  onPressed: () {
                    _engine.switchCamera();
                  },
                  child: const Icon(
                    Icons.switch_camera,
                    color: Color(0xff323232),
                    size: 20,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      enabled = !enabled;
                    });
                    _engine.enableLocalVideo(enabled);
                  },
                  child: const Icon(
                    Icons.videocam_rounded,
                    color: Color(0xff323232),
                    size: 20,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
                RawMaterialButton(
                  onPressed: () {
                    setState(() {
                      muted = !muted;
                    });
                    _engine.muteLocalAudioStream(muted);
                  },
                  child: Icon(
                    muted ? Icons.mic_off : Icons.mic,
                    color: const Color(0xff323232),
                    size: 20,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.white,
                  padding: const EdgeInsets.all(12),
                ),
                RawMaterialButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 20,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15),
                ),
              ],
            )
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Column(
                    children: [
                      CircleAvatar(
                        backgroundImage: NetworkImage(widget.name.image!),
                        radius: 100,
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.name.name!,
                        style: const TextStyle(
                          fontFamily: "Roboto",
                          fontSize: 32,
                          fontWeight: FontWeight.w700,
                          color: Colors.white,
                        ),
                      )
                    ],
                  ),
                ),
                const SizedBox(
                  height: 100,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              enabled = !enabled;
                            });
                            _engine.setEnableSpeakerphone(enabled);
                          },
                          child: const Icon(
                            Icons.volume_up_rounded,
                            color: Color(0xff323232),
                            size: 20,
                          ),
                          shape: const CircleBorder(),
                          elevation: 2,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Speaker",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        RawMaterialButton(
                          onPressed: () {
                            setState(() {
                              enabled = !enabled;
                            });
                            _engine.enableVideo();

                            _engine.enableLocalVideo(enabled);
                          },
                          child: const Icon(
                            Icons.videocam_rounded,
                            color: Color(0xff323232),
                            size: 20,
                          ),
                          shape: const CircleBorder(),
                          elevation: 2,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Video Call",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Column(
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
                            color: const Color(0xff323232),
                            size: 20,
                          ),
                          shape: const CircleBorder(),
                          elevation: 2,
                          fillColor: Colors.white,
                          padding: const EdgeInsets.all(12),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        const Text(
                          "Mute",
                          style: TextStyle(
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                  ],
                ),
                const SizedBox(
                  height: 53,
                ),
                const Text(
                  'Calling...',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 20,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                RawMaterialButton(
                  onPressed: () {
                    Calls().endCall(
                      const Uuid().v4(),
                    );
                    setState(() {
                      callLog.add(ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            widget.name.image!,
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          widget.name.name!,
                          style: const TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: const Text(
                          "9:13",
                          style: TextStyle(
                            color: secondaryColor,
                            //Color(0xff697077),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),

                          // );
                          // },
                        ),
                        trailing: const Icon(
                          Icons.phone_missed_sharp,
                          color: Colors.green,
                          size: 20,
                        ),
                      ));
                    });
                    // Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.call_end,
                    color: Colors.white,
                    size: 20,
                  ),
                  shape: const CircleBorder(),
                  elevation: 2,
                  fillColor: Colors.redAccent,
                  padding: const EdgeInsets.all(15),
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
    _controller.dispose();

    super.dispose();
  }

  Map userM = Hive.box('beepo').get('userData');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          _viewRows(),
          _panel(),
          _toolbar(),
        ],
      ),
    );
  }
}
