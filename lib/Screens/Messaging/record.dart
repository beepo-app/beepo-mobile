import 'dart:async';

import 'package:beepo/Utils/styles.dart';
import 'package:beepo/Providers/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import '../../Models/user_model.dart';
import 'flow_shader.dart';
import 'globals.dart';
import 'lottie_animation.dart';

class RecordButton extends StatefulWidget {
  const RecordButton({
    Key? key,
    required this.controller,
    required this.model,
  }) : super(key: key);

  final AnimationController controller;
  final UserModel model;

  @override
  State<RecordButton> createState() => _RecordButtonState();
}

class _RecordButtonState extends State<RecordButton> {
  static const double size = 55;

  final double lockerHeight = 200;
  double timerWidth = 0;

  late Animation<double> buttonScaleAnimation;
  late Animation<double> timerAnimation;
  late Animation<double> lockerAnimation;

  late DateTime startTime;
  late Timer timer;
  String recordDuration = "00:00";

  bool isLocked = false;
  bool showLottie = false;

  @override
  void initState() {
    super.initState();
    buttonScaleAnimation = Tween<double>(begin: 1, end: 1.2).animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.0, 0.3, curve: Curves.elasticInOut),
      ),
    );
    widget.controller.addListener(() {
      setState(() {});
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    timerWidth =
        MediaQuery.of(context).size.width - 2 * Globals.defaultPadding - 4;
    timerAnimation =
        Tween<double>(begin: timerWidth + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
    lockerAnimation =
        Tween<double>(begin: lockerHeight + Globals.defaultPadding, end: 0)
            .animate(
      CurvedAnimation(
        parent: widget.controller,
        curve: const Interval(0.2, 1, curve: Curves.easeIn),
      ),
    );
  }

  @override
  void dispose() {
    timer.cancel();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        lockSlider(),
        cancelSlider(),
        audioButton(),
        if (isLocked) timerLocked(),
      ],
    );
  }

  Widget lockSlider() {
    return Positioned(
      bottom: -lockerAnimation.value,
      child: Container(
        height: lockerHeight,
        width: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.white,
        ),
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const FaIcon(FontAwesomeIcons.lock, size: 20),
            const SizedBox(height: 8),
            FlowShader(
              direction: Axis.vertical,
              child: Column(
                children: [
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                  Icon(Icons.keyboard_arrow_up),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget cancelSlider() {
    return Positioned(
      right: -timerAnimation.value,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              showLottie ? LottieAnimation() : Text(recordDuration),
              const SizedBox(width: size),
              FlowShader(
                child: Row(
                  children: [
                    Icon(Icons.keyboard_arrow_left),
                    Text("Slide to cancel")
                  ],
                ),
                duration: const Duration(seconds: 3),
                flowColors: const [Colors.white, Colors.grey],
              ),
              const SizedBox(width: size),
            ],
          ),
        ),
      ),
    );
  }

  Widget timerLocked() {
    return Positioned(
      right: 0,
      child: Container(
        height: size,
        width: timerWidth,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(Globals.borderRadius),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 25),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () async {
              // Vibrate.feedback(FeedbackType.success);
              timer.cancel();

              startTime = DateTime.now();
              recordDuration = "00:00";
              context.read<ChatNotifier>().stopRecord(widget.model.uid!);
              context.read<ChatNotifier>().durationCalc();

              setState(() {
                isLocked = false;
              });
            },
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              mainAxisSize: MainAxisSize.max,
              children: [
                Text(recordDuration),
                FlowShader(
                  child: const Text("Tap lock to stop"),
                  duration: const Duration(seconds: 3),
                  flowColors: const [Colors.white, Colors.grey],
                ),
                const Center(
                  child: FaIcon(
                    FontAwesomeIcons.lock,
                    size: 18,
                    color: secondaryColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget audioButton() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: GestureDetector(
        child: Transform.scale(
            scale: buttonScaleAnimation.value,
            child: SvgPicture.asset(
              'assets/microphone.svg',
              width: 27,
              height: 27,
            )),
        onLongPressDown: (_) {
          debugPrint("onLongPressDown");
          widget.controller.forward();
        },
        onLongPressEnd: (details) async {
          debugPrint("onLongPressEnd");

          if (isCancelled(details.localPosition, context)) {
            // Vibrate.feedback(FeedbackType.heavy);

            timer.cancel();

            startTime = DateTime.now();
            recordDuration = "00:00";

            setState(() {
              showLottie = true;
            });

            Timer(const Duration(milliseconds: 1440), () async {
              widget.controller.reverse();
              debugPrint("Cancelled recording");
              context.read<ChatNotifier>().cancelRecord();
              // var filePath = await record.stop();
              // debugPrint(filePath);
              // File(filePath).delete();
              // debugPrint("Deleted $filePath");
              showLottie = false;
            });
          } else if (checkIsLocked(details.localPosition)) {
            widget.controller.reverse();

            // Vibrate.feedback(FeedbackType.heavy);
            debugPrint("Locked recording");
            debugPrint(details.localPosition.dy.toString());
            setState(() {
              isLocked = true;
            });
          } else {
            widget.controller.reverse();

            // Vibrate.feedback(FeedbackType.success);

            timer.cancel();

            startTime = DateTime.now();
            recordDuration = "00:00";
            context.read<ChatNotifier>().stopRecord(widget.model.uid!);
            context.read<ChatNotifier>().durationCalc();

            // var filePath = await Record().stop();
            // AudioState.files.add(filePath);
            // Globals.audioListKey.currentState
            //     .insertItem(AudioState.files.length - 1);
            // debugPrint(filePath);
          }
        },
        onLongPressCancel: () {
          debugPrint("onLongPressCancel");
          widget.controller.reverse();
        },
        onLongPress: () async {
          debugPrint("onLongPress");
          // Vibrate.feedback(FeedbackType.success);
          context.read<ChatNotifier>().startRecord();
          // if (await Record().hasPermission()) {
          //   record = Record();
          //   await record.start(
          //     path: Globals.documentPath +
          //         "audio_${DateTime.now().millisecondsSinceEpoch}.m4a",
          //     encoder: AudioEncoder.aacEld,
          //     bitRate: 128000,
          //     samplingRate: 44100,
          //   );
          //   startTime = DateTime.now();
          //   timer = Timer.periodic(const Duration(seconds: 1), (_) {
          //     final minDur = DateTime.now().difference(startTime).inMinutes;
          //     final secDur = DateTime.now().difference(startTime).inSeconds % 60;
          //     String min = minDur < 10 ? "0$minDur" : minDur.toString();
          //     String sec = secDur < 10 ? "0$secDur" : secDur.toString();
          //     setState(() {
          //       recordDuration = "$min:$sec";
          //     });
          //   });
          // }
        },
      ),
    );
  }

  bool checkIsLocked(Offset offset) {
    return (offset.dy < -35);
  }

  bool isCancelled(Offset offset, BuildContext context) {
    return (offset.dx < -(MediaQuery.of(context).size.width * 0.2));
  }
}
