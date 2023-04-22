import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:avatar_glow/avatar_glow.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Widgets/toasts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../provider.dart';

class CustomVoiceRecorderWidget extends StatefulWidget {
  final bool isGroupChat;
  final String receiverId;
  const CustomVoiceRecorderWidget(
      {Key key, @required this.isGroupChat, this.receiverId = ''})
      : super(key: key);

  @override
  State<CustomVoiceRecorderWidget> createState() =>
      _CustomVoiceRecorderWidgetState();
}

class _CustomVoiceRecorderWidgetState extends State<CustomVoiceRecorderWidget> {
  RecorderController recorderController;
  PlayerController playerController;
  bool isRecording = false;
  double radius = 50;
  String path = '';
  int min = 0;
  int sec = 0;
  void initialiseController() {
    recorderController = RecorderController()
      ..androidEncoder = AndroidEncoder.aac
      ..androidOutputFormat = AndroidOutputFormat.mpeg4
      ..iosEncoder = IosEncoder.kAudioFormatMPEG4AAC
      ..sampleRate = 16000;
  }

  bool isPlaying = false;

  void onCurrentDuration() {
    recorderController.onCurrentDuration.listen((event) {
      setState(() {
        min = event.inMinutes;
        sec = event.inSeconds.remainder(60);
      });
    });
  }

  void onPlayerStateChanged() {
    playerController = PlayerController();
    playerController.onPlayerStateChanged.listen((state) {
      setState(() {
        state = playerController.playerState;
      });
    });
  }

  @override
  void initState() {
    initialiseController();
    onPlayerStateChanged();
    onCurrentDuration();

    super.initState();
  }

  IconData buildPlayerIcon() {
    switch (playerController.playerState) {
      case PlayerState.playing:
        return Icons.pause;
      case PlayerState.paused:
        return Icons.play_arrow;
      default:
        return Icons.play_arrow;
    }
  }

  void startRecording() async {
    await recorderController.record();
  }

  Future<String> stopRecording() async {
    return await recorderController.stop();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height / 2.6,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              height: 5,
              width: 60,
              decoration: BoxDecoration(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(50),
              ),
            ),
            const SizedBox(height: 10),
            Text(isRecording
                ? 'Recording...'
                : 'Tap on the mic to record, tap again to stop.'),
            const SizedBox(height: 10),
            SizedBox(
              height: 50,
              child: Material(
                color: secondaryColor,
                borderRadius: BorderRadius.circular(25),
                child: Padding(
                  padding: const EdgeInsets.only(left: 16, right: 20),
                  child: Row(
                    children: [
                      IconButton(
                          onPressed: () {
                            if (playerController.playerState.isPlaying) {
                              playerController.pausePlayer();
                            } else {
                              playerController.startPlayer();
                            }
                          },
                          icon: path.isEmpty
                              ? const Icon(
                                  Icons.record_voice_over,
                                  color: Colors.white,
                                )
                              : Icon(buildPlayerIcon(), color: Colors.white)),
                      Expanded(
                        child: isRecording || path.isEmpty
                            ? AudioWaveforms(
                                enableGesture: true,
                                shouldCalculateScrolledPosition: true,
                                size: const Size(double.infinity, 50.0),
                                recorderController: recorderController,
                                waveStyle: const WaveStyle(
                                  waveColor: Colors.white,
                                  extendWaveform: true,
                                  showMiddleLine: false,
                                ),
                              )
                            : AudioFileWaveforms(
                                size: const Size(double.infinity, 50),
                                playerController: playerController,
                                playerWaveStyle: const PlayerWaveStyle(
                                    seekLineThickness: 3,
                                    waveThickness: 3,
                                    showSeekLine: false),
                              ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        "${min.toString().padLeft(2, '0')}:${sec.toString().padLeft(2, '0')}",
                        style: const TextStyle(color: Colors.white),
                      )
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 10),
            AvatarGlow(
              glowColor: secondaryColor.withOpacity(0.8),
              endRadius: isRecording ? 45 : 40,
              animate: isRecording ? true : false,
              child: path.isNotEmpty
                  ? CircleAvatar(
                      radius: 24,
                      backgroundColor: secondaryColor,
                      child: IconButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                            playerController.stopAllPlayers();
                          },
                          icon: const Icon(Icons.delete, color: Colors.white)),
                    )
                  : GestureDetector(
                      onTap: () async {
                        HapticFeedback.mediumImpact();
                        setState(() => isRecording = !isRecording);
                        if (isRecording) {
                          await recorderController.record();
                        } else {
                          final path = await recorderController.stop();

                          setState(() => this.path = path);
                          await playerController.preparePlayer(path: this.path);
                        }
                      },
                      child: AnimatedContainer(
                          decoration: BoxDecoration(
                              color: secondaryColor,
                              borderRadius: BorderRadius.circular(60)),
                          width: isRecording ? 50 : 45,
                          height: isRecording ? 50 : 45,
                          duration: const Duration(milliseconds: 2000),
                          child: const Icon(Icons.mic, color: Colors.white)),
                    ),
            ),
            const Spacer(),
            MaterialButton(
              height: 50,
              minWidth: double.infinity,
              onPressed: () {
                if (path.isEmpty) {
                  showToast('Please record a message');
                  return;
                }
                Navigator.of(context).pop();
                if (widget.isGroupChat) {
                  //
                } else {
                  context
                      .read<ChatNotifier>()
                      .uploadAudio(widget.receiverId, path);
                }
              },
              color: secondaryColor,
              shape: OutlineInputBorder(
                borderSide: BorderSide.none,
                borderRadius: BorderRadius.circular(28),
              ),
              child: const Text(
                'Send',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
