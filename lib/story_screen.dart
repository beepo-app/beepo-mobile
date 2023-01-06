// ignore_for_file: missing_return

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:beepo/constants.dart';
import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/sizing.dart';

import 'Models/user_model.dart';

class StoryScreen extends StatefulWidget {
  const StoryScreen({
    Key key,
    @required this.user,
  }) : super(key: key);
  static const String routeName = '/story-screen';

  final UserModel user;

  @override
  State<StoryScreen> createState() => _StoryScreenState();
}

class _StoryScreenState extends State<StoryScreen>
    with SingleTickerProviderStateMixin {
    PageController _pageController;
    TextEditingController _messageController;
    AnimationController _animationController;
  VideoPlayerController _videoController;

  final FocusNode _focusNode = FocusNode();
  final stories = <Story>[];

  int _currentIndex = 0;

  double yaxis;
  double topPadding = 0;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
    _messageController = TextEditingController();
    _animationController = AnimationController(vsync: this);
    final Story firstStory = widget.user.stories.first;
    _loadStory(story: firstStory, animatedToPage: false);

    _animationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _animationController.stop();
        _animationController.reset();
        if (!mounted) return;
        setState(() {
          if (_currentIndex + 1 < widget.user.stories.length) {
            _currentIndex += 1;
            _loadStory(story: widget.user.stories[_currentIndex]);
          } else {
            // _currentIndex = 0;
            // _loadStory(story: widget.user.stories[_currentIndex]);
            Navigator.pop(context);
          }
        });
      }
    });

    _focusNode.addListener(() {
      if (_focusNode.hasFocus) {
        _animationController.stop();
        _videoController?.pause();
      }
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _messageController.dispose();
    _animationController.dispose();
    _videoController?.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void showViewers(BuildContext context, int count, UserModel user) async {
    _animationController.stop();
    _videoController?.pause();
    await showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return FractionallySizedBox(
            heightFactor: count < 10 ? double.parse('0.$count') - 0.1 : 0.8,
            child: ListView.builder(
              itemCount: count,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: CircleAvatar(
                      radius: 20.0,
                      backgroundColor: AppColors.borderGrey,
                      backgroundImage:
                          CachedNetworkImageProvider(user.image),
                    ),
                    title: Text('Item $index'));
              },
            ),
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(8),
            topLeft: Radius.circular(8),
          ),
        ));
    _animationController.forward();
    _videoController?.play();
  }

  @override
  Widget build(BuildContext context) {
    final user = widget.user;
    final Story story = widget.user.stories[_currentIndex];

    return Scaffold(
      // resizeToAvoidBottomInset: false,
      backgroundColor: Colors.transparent,
      body: SafeArea(
        child: GestureDetector(
          onVerticalDragUpdate: (details) {
            setState(() {
              yaxis ??= details.globalPosition.dy;
              if (yaxis - details.globalPosition.dy > 50) {
                if (topPadding - 5 >= 0) {
                  topPadding -= 5;
                }
                //TODO: Add implementation to show story viewers
                // showViewers(context, 10, story.user);
                // _animationController.forward();
                // _videoController?.play();
              }
              if (details.globalPosition.dy - yaxis > 50) {
                topPadding += 5;
                if (topPadding > 50) {
                  Navigator.pop(context);
                }
              }
              // else
              //   gestureUp = true;
              // height -= details.delta.dy;
              // if (height > maxHeight)
              //     height = maxHeight;
              // else if (height < minHeight)
              //     height = minHeight;
            });
          },
          onVerticalDragEnd: (details) {
            setState(() {
              yaxis = null;
              topPadding = 0;
            });
          },

          // onPanCancel: () {
          //   _onLongPressCancel(story);
          // },
          // onPanDown: (_) {
          //   _timer = Timer(const Duration(milliseconds: 200), () {
          //     // time duration
          //     // your function here
          //     _onLongPress(story);
          //   });
          // },
          onTapDown: (details) => _onTapDown(details, story),

          // onLongPressEnd: (details) => _onLongPressCancel(story),
          // onLongPress: () {
          //   _onLongPress(story);
          // },

          child: Padding(
            padding: EdgeInsets.only(top: topPadding),
            child: Column(
              children: [
                Expanded(
                  child: Stack(
                    children: [
                      PageView.builder(
                          controller: _pageController,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: widget.user.stories.length,
                          itemBuilder: (context, index) {
                            final Story story = widget.user.stories[index];
                            switch (story.mediaType) {
                              case MediaType.image:
                                // return Image.network(story.url);
                                return CachedNetworkImage(
                                  imageUrl: story.url,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                );
                              case MediaType.video:
                                if (_videoController != null &&
                                    _videoController.value.isInitialized) {
                                  return FittedBox(
                                    fit: BoxFit.fitWidth,
                                    child: SizedBox(
                                      width: _videoController.value.size.width,
                                      height:
                                          _videoController.value.size.height,
                                      child: VideoPlayer(_videoController),
                                    ),
                                  );
                                } else {
                                  return const Center(
                                    child: CupertinoActivityIndicator(
                                      radius: 15,
                                    ),
                                  );
                                }
                            }
                          }),
                      Positioned(
                        top: 10.0,
                        left: 10.0,
                        right: 10.0,
                        child: Column(
                          children: [
                            Row(
                                children: widget.user.stories
                                    .asMap()
                                    .map((key, value) {
                                      return MapEntry(
                                        key,
                                        AnimatedBar(
                                          animationController:
                                              _animationController,
                                          position: key,
                                          currentIndex: _currentIndex,
                                        ),
                                      );
                                    })
                                    .values
                                    .toList()),
                            //TODO: Fetch current story user info
                            //? The user who posted the story
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 10.0, horizontal: 1.5),
                              child: UserInfo(user: user),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // SizedBox(
                //   height: 2.0,
                // ),
                // TextField(
                //   focusNode: _focusNode,
                //   maxLines: 6,
                //   minLines: 1,
                //   // expands: true,
                //   controller: _messageController,
                //   decoration: statusMessageTextDecoration(
                //     suffixICon: _messageController.text.isNotEmpty
                //         ? IconButton(
                //             onPressed: () {},
                //             icon: const Icon(
                //               Icons.send,
                //               color: AppColors.primaryColor,
                //             ))
                //         : SizedBox(
                //             width: 0.5.sw,
                //             child: Row(
                //               mainAxisAlignment: MainAxisAlignment.end,
                //               children: [
                //                 IconButton(
                //                     onPressed: () {},
                //                     icon: const Icon(
                //                       Icons.mic_outlined,
                //                       color: AppColors.primaryColor,
                //                     )),
                //                 IconButton(onPressed: () {}, icon: const Icon(Icons.image, color: AppColors.primaryColor)),
                //                 IconButton(
                //                     onPressed: () {}, icon: const Icon(Icons.emoji_emotions_outlined, color: AppColors.primaryColor)),
                //               ],
                //             ),
                //           ),
                //     prefixIcon: IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined, color: AppColors.primaryColor)),
                //     hint: 'Write a message',
                //     context: context,
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }

  // void _onLongPress(story) {
  //   if (story.media == MediaType.video) {
  //     if (_videoController!.value.isPlaying) {
  //       _videoController!.pause();
  //     } else {
  //       _videoController!.play();
  //     }
  //   }
  //   _animationController.stop();
  // }

  // void _onLongPressCancel(story) {
  //   if (story.media == MediaType.video) {
  //     if (_videoController!.value.isPlaying == false) {
  //       _videoController!.play();
  //     }
  //   }
  //   _animationController.forward();
  // }

  void _onTapDown(TapDownDetails details, Story story) {
    final double dx = details.globalPosition.dx;
    FocusScope.of(context).requestFocus(FocusNode());
    if (dx < 1 / 3) {
      setState(() {
        if (_currentIndex - 1 >= 0) {
          _currentIndex -= 1;
        } else {
          _currentIndex = 0;
        }
        _loadStory(story: widget.user.stories[_currentIndex]);
      });
    } else if (dx > 2 * 1 / 3) {
      setState(() {
        if (_currentIndex + 1 < widget.user.stories.length) {
          _currentIndex += 1;

          _loadStory(story: widget.user.stories[_currentIndex]);
        } else {
          Navigator.pop(context);
        }
      });
    } else {
      if (story.mediaType == MediaType.video) {
        if (_videoController.value.isPlaying) {
          _videoController.pause();
          _animationController.stop();
        } else {
          _videoController.play();
          _animationController.forward();
        }
      } else {
        if (_animationController.isAnimating) {
          _animationController.stop();
        } else {
          _animationController.forward();
        }
      }
    }
  }

  // void _pauseStoryViewers(Story story) {
  //   if (story.media == MediaType.video) {
  //     if (_videoController!.value.isPlaying) {
  //       _videoController!.pause();
  //       _animationController.stop();
  //     } else {
  //       _videoController!.play();
  //       _animationController.forward();
  //     }
  //   } else {
  //     if (_animationController.isAnimating) {
  //       _animationController.stop();
  //     } else {
  //       _animationController.forward();
  //     }
  //   }
  // }

  void _loadStory({@required Story story, bool animatedToPage = true}) {
    _animationController.stop();
    _animationController.reset();

    switch (story.mediaType) {
      case MediaType.image:
        _videoController?.pause();
        _animationController.duration = story.duration;
        _animationController.forward();
        break;
      case MediaType.video:
        _videoController?.pause();

        _videoController = null;
        _videoController?.dispose();
        _videoController = VideoPlayerController.network(story.url)
          ..initialize().then((value) {
            setState(() {});
            if (_videoController.value.isInitialized) {
              _animationController.duration = _videoController.value.duration;
              _videoController.play();
              _animationController.forward();
            }
          });
        break;
    }
    if (animatedToPage) {
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 1),
        curve: Curves.easeInOut,
      );
    }
  }
}

class AnimatedBar extends StatelessWidget {
  const AnimatedBar(
      {Key key,
      @required this.animationController,
      @required this.position,
      @required this.currentIndex})
      : super(key: key);

  final AnimationController animationController;
  final int position;
  final int currentIndex;

  Container _buildContainer(double width, Color color, BuildContext context) {
    return Container(
      height: 5.0,
      width: width,
      decoration: BoxDecoration(
          color: color,
          border: Border.all(
            color: Theme.of(context).primaryColor,
            width: 0.8,
          ),
          borderRadius: BorderRadius.circular(3.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Flexible(
        child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 1.5,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return Stack(
            children: [
              _buildContainer(
                double.infinity,
                position < currentIndex
                    ? AppColors.white
                    : AppColors.white.withOpacity(0.5),
                context,
              ),
              position == currentIndex
                  ? AnimatedBuilder(
                      animation: animationController,
                      builder: (context, child) {
                        return _buildContainer(
                          constraints.maxWidth * animationController.value,
                          AppColors.white,
                          context,
                        );
                      })
                  : const SizedBox.shrink()
            ],
          );
        },
      ),
    ));
  }
}

class UserInfo extends StatelessWidget {
  const UserInfo({Key key, @required this.user}) : super(key: key);
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20.0,
          backgroundColor: AppColors.borderGrey,
          backgroundImage: CachedNetworkImageProvider(
            user.image,
          ),
        ),
        const SizedBox(
          width: 10.0,
        ),
        Expanded(
          child: InkWell(
            onTap: () {},
            child: Text(
              user.name,
              style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 18.0,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ),
        IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(
              Icons.close,
              size: 30.0,
              color: Colors.grey,
            )),
      ],
    );
  }
}
