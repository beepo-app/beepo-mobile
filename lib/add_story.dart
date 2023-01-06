// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:beepo/constants.dart';
import 'package:beepo/extensions.dart';
import 'package:beepo/models/story_model/story.dart';
import 'package:beepo/story_settings_modal.dart';
import 'package:beepo/story_upload_provider.dart';
import 'package:beepo/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:provider/provider.dart';
import 'package:video_player/video_player.dart';

import 'Utils/styles.dart';

class AddStory extends StatefulWidget {
  const AddStory({Key key}) : super(key: key);
  static const String routeName = '/add-story';

  @override
  State<AddStory> createState() => _AddStoryState();
}

class _AddStoryState extends State<AddStory> {
  VideoPlayerController _videoPlayerController;

  @override
  void dispose() {
    _videoPlayerController?.dispose();
    super.dispose();
  }

  //? Find a better name for this method
  Future<bool> _checkVideoDurationIsNotLong(File file) async {
    _videoPlayerController = VideoPlayerController.file(file);
    await _videoPlayerController?.initialize();
    if (_videoPlayerController.value.duration.inSeconds > 30) {
      return false;
    } else {
      return true;
    }
  }

  void _showSnackBar(BuildContext context, {@required String message}) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(message),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
          child: Column(
        children: [
          Expanded(
            flex: 3,
            child: Consumer<StoryUploadProvider>(
              builder: (context, uploader, _) {
                final selectedFile = uploader.file;
                final status = uploader.status;
                final selectedMediaType = uploader.mediaType;
                final videoThumbnail = uploader.thumbnail;
                return Stack(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        // If the selected media is an image, show the selected image,
                        // else it is a video, show the video thumbnail.
                        // If no media is selected, decoration image will be null.

                        // If image is selected (file is not null)
                        image: (selectedFile != null &&
                                selectedMediaType == MediaType.image)
                            ? DecorationImage(
                                image: FileImage(File(selectedFile.path)),
                                fit: BoxFit.cover,
                              )
                            // If video is selected (file is not null)
                            : (selectedFile != null &&
                                    selectedMediaType == MediaType.video &&
                                    videoThumbnail != null)
                                ? DecorationImage(
                                    image: MemoryImage(videoThumbnail),
                                    fit: BoxFit.cover,
                                  )
                                : null,
                      ),
                      child: (selectedFile != null)
                          ? const SizedBox.shrink()
                          : Text(
                              'Select media to upload',
                              style: context.textTheme.headline5,
                            ),
                    ),
                    if (selectedFile != null)
                      // The upload button is only visible when the user has selected a file
                      Positioned(
                        top: 40,
                        right: 15,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                              backgroundColor: primaryColor,),
                          onPressed: () async {
                            if (status == StoryUploadStatus.uploading) {
                              // If the user is uploading a story, we don't want to do anything,
                              // so we show a snackbar to let them know that they are already uploading
                              _showSnackBar(context,
                                  message: 'Upload in progress');
                            } else {
                              final result = await uploader.uploadStory();
                              result.fold(
                                (failure) => _showSnackBar(context,
                                    message: failure.message),
                                (success) => _showSnackBar(context,
                                    message: 'Story uploaded successfully'),
                              );
                              Navigator.pop(context);
                            }
                          },
                          icon: const Icon(Icons.upload_rounded),
                          label: (status == StoryUploadStatus.uploading)
                              ? const SizedBox(
                                  height: 25,
                                  width: 25,
                                  child: CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  ),
                                )
                              : const Text('Upload'),
                        ),
                      ),
                    Align(
                      alignment: Alignment.topLeft,
                      //TODO: Detect when the user navigates away from the screen without pressing the close button
                      // and call reset() on the provider
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                          context.read<StoryUploadProvider>().reset();
                        },
                        icon: const Icon(Icons.close),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topRight,
                      child: IconButton(
                        onPressed: () => StoryModalSheet.openModalBottomSheet(
                          child: const StorySettings(),
                          context: context,
                        ),
                        icon: const Icon(Icons.settings),
                      ),
                    )
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(
                top: 0, left: 20.0, right: 20.0, bottom: 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                InkWell(
                  onTap: () async {
                    await context
                        .read<StoryUploadProvider>()
                        .pickImageGallery();
                    // Navigator.pop(context);
                  },
                  child: Row(
                    children: [
                      SvgPicture.asset(AppImages.newGallery),
                      SizedBox(
                        width: 8,
                      ),
                      const Text(
                        'Gallery',
                        style: TextStyle(fontWeight: FontWeight.w600),
                      )
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await context.read<StoryUploadProvider>().pickVideo();
                    if (mounted) {
                      final selectedFile =
                          context.read<StoryUploadProvider>().file;
                      final selectedMediaType =
                          context.read<StoryUploadProvider>().mediaType;
                      if (selectedFile != null &&
                          selectedMediaType == MediaType.video) {
                        final isVideoDurationNotLong =
                            await _checkVideoDurationIsNotLong(selectedFile);
                        if (isVideoDurationNotLong && mounted) {
                          final result = await context
                              .read<StoryUploadProvider>()
                              .getVideoThumbnail();
                          result.fold(
                            (failure) => _showSnackBar(context,
                                message: failure.message),
                            (success) {},
                          );
                        } else {
                          _showSnackBar(context,
                              message:
                                  'Video duration cannot be more than 30 seconds');
                          context.read<StoryUploadProvider>().reset();
                        }
                      }
                    }
                  },
                  icon: const Icon(
                    Icons.videocam_outlined,
                    size: 35,
                  ),
                ),
                IconButton(
                  onPressed: () async {
                    await context.read<StoryUploadProvider>().pickImageCamera();
                  },
                  icon: SvgPicture.asset(
                    AppImages.camera,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ],
            ),
          ),
        ],
      )),
    );
  }
}

class StorySettings extends StatefulWidget {
  const StorySettings({Key key}) : super(key: key);

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
          const Padding(
            padding: EdgeInsets.only(top: 26.0, left: 26.0),
            child: Text(
              'Hide Story From',
              style: chatAuthorTextStyle,
            ),
          ),
          const TextField(
            decoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(horizontal: 26.0),
              hintText: 'Hide your story or video from specific people',
              hintStyle: TextStyle(fontSize: 12),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 23.0, left: 26.0, bottom: 0),
            child: Text(
              "Allow Message Replies",
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
              });
            },
          ),
          RowWithSwitch(
            text: const Text(
              'People you follow',
              style: klikesStyle,
            ),
            allowEveryone: peopleYouFollowReply,
            switchedClicked: (value) {
              setState(() {
                peopleYouFollowReply = value;
              });
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: RowWithSwitch(
              text: const Text(
                'Allow Sharing',
                style: chatAuthorTextStyle,
              ),
              allowEveryone: allowSharing,
              switchedClicked: (value) {
                setState(() {
                  allowSharing = value;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 26.0),
            child: Text(
              'Allow people to share your story to their timeline',
              style: TextStyle(fontSize: 10.0),
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 32.0, left: 26.0),
            child: Text(
              'Who can Share? ',
              style: chatAuthorTextStyle,
            ),
          ),
          RowWithSwitch(
            text: const Text(
              'Everyone',
              style: klikesStyle,
            ),
            allowEveryone: allowEveryoneShare,
            switchedClicked: (value) {
              setState(() {
                allowEveryoneShare = value;
              });
            },
          ),
          RowWithSwitch(
            text: const Text(
              'People you follow',
              style: klikesStyle,
            ),
            allowEveryone: peopleYouFollowShare,
            switchedClicked: (value) {
              setState(() {
                peopleYouFollowShare = value;
              });
            },
          )
        ],
      ),
    ]);
  }
}

class RowWithSwitch extends StatelessWidget {
  const RowWithSwitch({
    Key key,
    @required this.allowEveryone,
    @required this.switchedClicked,
    @required this.text,
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
