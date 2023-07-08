// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:io';

import 'package:beepo/Screens/moments/story_settings_modal.dart';
import 'package:beepo/Screens/moments/story_upload_provider.dart';
import 'package:beepo/Constants/text_styles.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import '../../Utils/styles.dart';

late CameraController controlle;

class AddStory extends StatefulWidget {
  const AddStory({Key? key, required this.camera1, required this.camera2})
      : super(key: key);
  final CameraDescription camera1;
  final CameraDescription camera2;

  // static const String routeName = '/add-story';

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  late VideoPlayerController _videoPlayerController;
  late TextEditingController controller = TextEditingController();
  late Future<void> initializeControllerFuture;

  late CameraDescription selected;

  late String currentCameraTab;

  @override
  void dispose() {
    _videoPlayerController.dispose();
    controlle.dispose();
    super.dispose();
  }

// bool hasChanged = false;
  //? Find a better name for this method
  Future<bool> _checkVideoDurationIsNotLong(File file) async {
    _videoPlayerController = VideoPlayerController.file(file);
    await _videoPlayerController?.initialize();
    if (_videoPlayerController.value.duration.inSeconds > 40) {
      return false;
    } else {
      return true;
    }
  }

  void _showSnackBar(BuildContext context, {required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  void initState() {
    super.initState();
    controlle = CameraController(
      // Get a specific camera from the list of available cameras.
      widget.camera1,
      // Define the resolution to use.
      ResolutionPreset.ultraHigh,
    );
    initializeControllerFuture = controlle.initialize();
    selected = widget.camera1;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.transparent,
        body: SafeArea(
          // maintainBottomViewPadding: true,
          child: Consumer<StoryUploadProvider>(
            builder: (context, uploader, _) {
              final selectedFile = uploader.file;
              final status = uploader.status;
              final selectedMediaType = uploader.mediaType;
              final videoThumbnail = uploader.thumbnail;
              return Stack(
                children: [
                  Container(
                    height: MediaQuery.of(context).size.height,
                    alignment: Alignment.topCenter,
                    decoration: BoxDecoration(
                      // If the selected media is an image, show the selected image,
                      // else it is a video, show the video thumbnail.
                      // If no media is selected, decoration image will be null.

                      // If image is selected (file is not null)
                      image: (selectedMediaType == "image")
                          ? DecorationImage(
                              image: FileImage(File(selectedFile.path)),
                              fit: BoxFit.contain,
                            )
                          // If video is selected (file is not null)
                          : (selectedMediaType == "video")
                              ? DecorationImage(
                                  image: MemoryImage(videoThumbnail),
                                  fit: BoxFit.contain,
                                )
                              : null,
                      color: Colors.black,
                    ),
                    child: selectedFile.path.isEmpty
                        ? const SizedBox.shrink()
                        : FutureBuilder<void>(
                            future: initializeControllerFuture,
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                // If the Future is complete, display the preview.
                                return CameraPreview(controlle);
                              } else {
                                // Otherwise, display a loading indicator.
                                return const Center(
                                    child: CircularProgressIndicator(
                                  color: secondaryColor,
                                ));
                              }
                            },
                          ),
                    // (selectedFile != null)
                    //     ? const SizedBox.shrink()
                    //     : Text(
                    //         'Select media to upload',
                    //         style: context.textTheme.headline5,
                    //       ),
                  ),
                  // The upload button is only visible when the user has selected a file
                  Align(
                    alignment: Alignment.topLeft,
                    //TODO: Detect when the user navigates away from the screen without pressing the close button
                    // and call reset() on the provider
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: const Icon(
                        Icons.close,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: IconButton(
                      onPressed: () => StoryModalSheet.openModalBottomSheet(
                        child: StorySettings(),
                        context: context,
                      ),
                      icon: const Icon(
                        Icons.settings,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: (context
                            .watch<StoryUploadProvider>()
                            .file
                            .path
                            .isEmpty)
                        ? Container(
                            // width: double.infinity,
                            height: 140,
                            decoration: BoxDecoration(color: Colors.black),
                            padding: EdgeInsets.only(
                              left: 20,
                              right: 20,
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        IconButton(
                                          onPressed: () async {
                                            await context
                                                .read<StoryUploadProvider>()
                                                .pickMediaGallery(context);
                                            if (mounted) {
                                              final selectedFile = context
                                                  .read<StoryUploadProvider>()
                                                  .file;
                                              final selectedMediaType = context
                                                  .read<StoryUploadProvider>()
                                                  .mediaType;
                                              if (selectedMediaType ==
                                                  "gallery") {
                                                final isVideoDurationNotLong =
                                                    await _checkVideoDurationIsNotLong(
                                                        selectedFile);
                                                if (isVideoDurationNotLong &&
                                                    mounted) {
                                                  await context
                                                      .read<
                                                          StoryUploadProvider>()
                                                      .getVideoThumbnail();
                                                } else {
                                                  _showSnackBar(context,
                                                      message:
                                                          'Video duration cannot be more than 40 seconds');
                                                }
                                              }
                                            }
                                          },
                                          icon: Icon(
                                            Icons.photo,
                                            size: 38,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(
                                      height: 75,
                                      width: 75,
                                      child: IconButton(
                                          onPressed: () async {
                                            await initializeControllerFuture;
                                            if (selected == widget.camera2) {
                                              await context
                                                  .read<StoryUploadProvider>()
                                                  .pickImageCamera1();
                                            } else {
                                              await context
                                                  .read<StoryUploadProvider>()
                                                  .pickImageCamera();
                                            }
                                            // selected == widget.camera1?

                                            // : await context
                                            // .read<StoryUploadProvider>()
                                            // .pickImageCamera1();
                                          },
                                          icon: Container(
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Color(0xFFE6E9EE),
                                              border: Border.all(
                                                  color: Colors.orange,
                                                  width: 2),
                                              // borderRadius: BorderRadius.circular(50)
                                            ),
                                          )
                                          // SvgPicture.asset(
                                          //   AppImages.camera,
                                          //   color: secondaryColor,
                                          // ),
                                          ),
                                    ),
                                    GestureDetector(
                                      child:
                                          SvgPicture.asset('assets/Rotate.svg'),
                                      onTap: () {
                                        setState(() {
                                          // hasChanged = !hasChanged;
                                          if (selected == widget.camera1) {
                                            selected = widget.camera2;
                                          } else {
                                            selected = widget.camera1;
                                          }
                                          // selected =
                                          // selected == widget.camera1 ? widget.camera2 : widget
                                          //     .camera1;
                                        });
                                        controlle = CameraController(selected,
                                            ResolutionPreset.ultraHigh);
                                        initializeControllerFuture =
                                            controlle.initialize();
                                      },
                                    ),
                                  ],
                                ),
                                SizedBox(height: 10),
                                Text(
                                  "Tap for photo, hold for videos",
                                  style: TextStyle(
                                    color: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 5),
                              ],
                            ))
                        : Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Row(
                              children: [
                                Expanded(
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: TextField(
                                      controller: controller,
                                      decoration: InputDecoration(
                                        hintText: "Add a caption...",
                                        isDense: false,
                                        hintStyle: TextStyle(
                                          fontSize: 14.5,
                                          fontStyle: FontStyle.italic,
                                          color: Colors.black,
                                        ),
                                        fillColor: Colors.white,
                                        hoverColor: Colors.white,
                                        focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        enabledBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 15,
                                ),
                                GestureDetector(
                                  onTap: () async {
                                    if (status == StoryUploadStatus.uploading) {
                                      // If the user is uploading a story, we don't want to do anything,
                                      // so we show a snackbar to let them know that they are already uploading
                                      _showSnackBar(context,
                                          message: 'Upload in progress');
                                    } else {
                                      uploader.getCaption(
                                          controller.text.trim().isEmpty
                                              ? " "
                                              : controller.text.trim());

                                      await uploader.uploadStory();

                                      Navigator.pop(context);
                                      controller.clear();
                                    }
                                  },
                                  child: Container(
                                    height: 40,
                                    width: 40,
                                    decoration: BoxDecoration(
                                      color: secondaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: (status ==
                                            StoryUploadStatus.uploading)
                                        ? const SizedBox(
                                            height: 25,
                                            width: 25,
                                            child: CircularProgressIndicator(
                                              valueColor:
                                                  AlwaysStoppedAnimation<Color>(
                                                      Colors.white),
                                              // value: 20,
                                            ),
                                          )
                                        : Icon(
                                            Icons.send,
                                            color: Colors.white,
                                          ),
                                  ),
                                )
                              ],
                            ),
                          ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class StorySettings extends StatefulWidget {
  const StorySettings({Key? key}) : super(key: key);

  @override
  State<StorySettings> createState() => _StorySettingsState();
}

class _StorySettingsState extends State<StorySettings> {
  bool allowEveryoneReply = true;
  bool peopleYouFollowReply = false;
  bool allowSharing = true;
  bool allowEveryoneShare = true;
  bool peopleYouFollowShare = false;

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // const Padding(
          //   padding: EdgeInsets.only(top: 26.0, left: 26.0),
          //   child: Text(
          //     'Hide Story From',
          //     style: chatAuthorTextStyle,
          //   ),
          // ),
          // const TextField(
          //   decoration: InputDecoration(
          //     contentPadding: EdgeInsets.symmetric(horizontal: 26.0),
          //     hintText: 'Hide your story or video from specific people',
          //     hintStyle: TextStyle(fontSize: 12),
          //   ),
          // ),
          const Padding(
            padding: EdgeInsets.only(top: 23.0, left: 26.0, bottom: 0),
            child: Text(
              "Who can see your moment?",
              style: chatAuthorTextStyle,
            ),
          ),
          RowWithSwitch(
            text: const Text(
              'Everyone',
              style: klikesStyle,
            ),
            allowEveryone: allowEveryoneReply,
            switchedClicked: (value) {
              setState(() {
                allowEveryoneReply = value;
                peopleYouFollowReply = !peopleYouFollowReply;
              });
            },
          ),
          RowWithSwitch(
            text: const Text(
              'People you chat with',
              style: klikesStyle,
            ),
            allowEveryone: peopleYouFollowReply,
            switchedClicked: (value) {
              setState(() {
                peopleYouFollowReply = value;
                allowEveryoneReply = !allowEveryoneReply;
              });
            },
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 10.0),
          //   child: RowWithSwitch(
          //     text: const Text(
          //       'Allow Sharing',
          //       style: chatAuthorTextStyle,
          //     ),
          //     allowEveryone: allowSharing,
          //     switchedClicked: (value) {
          //       setState(() {
          //         allowSharing = value;
          //       });
          //     },
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.symmetric(horizontal: 26.0),
          //   child: Text(
          //     'Allow people to share your story to their timeline',
          //     style: TextStyle(fontSize: 10.0),
          //   ),
          // ),
          // const Padding(
          //   padding: EdgeInsets.only(top: 32.0, left: 26.0),
          //   child: Text(
          //     'Who can Share? ',
          //     style: chatAuthorTextStyle,
          //   ),
          // ),
          // RowWithSwitch(
          //   text: const Text(
          //     'Everyone',
          //     style: klikesStyle,
          //   ),
          //   allowEveryone: allowEveryoneShare,
          //   switchedClicked: (value) {
          //     setState(() {
          //       allowEveryoneShare = value;
          //     });
          //   },
          // ),
          // RowWithSwitch(
          //   text: const Text(
          //     'People you follow',
          //     style: klikesStyle,
          //   ),
          //   allowEveryone: peopleYouFollowShare,
          //   switchedClicked: (value) {
          //     setState(() {
          //       peopleYouFollowShare = value;
          //     });
          //   },
          // )
        ],
      ),
    ]);
  }
}

class RowWithSwitch extends StatelessWidget {
  const RowWithSwitch({
    Key? key,
    required this.allowEveryone,
    required this.switchedClicked,
    required this.text,
  }) : super(key: key);

  final bool allowEveryone;
  final Function(bool) switchedClicked;
  final Widget text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 26.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          text,
          Switch(
            value: allowEveryone,
            onChanged: switchedClicked,
          )
        ],
      ),
    );
  }
}
