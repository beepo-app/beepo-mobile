// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/story_download_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:story_view/story_view.dart';

import 'Models/user_model.dart';

class Homes extends StatefulWidget {
  final UserModel user;

  Homes({this.user});

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  final StoryController controller = StoryController();

  Map userM = Hive.box('beepo').get('userData');

  final storyItems = <StoryItem>[];

  void addStoryItems() {
    for (final story in widget.user.stories) {
      switch (story.mediaType) {
        case "image":
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: controller,
            caption:
                // Text(
                story.caption,
            duration: Duration(seconds: 20),
          ));
          break;
        case "video":
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: controller,
            caption:
                // Text(
                story.caption,
          ));
          break;
      }
    }
  }

  int i;

  // final PageController cont = PageController();

  @override
  void initState() {
    addStoryItems();
    // calDate(date);
    i = 0;
    if (DateTime.now()
            .difference(widget.user.stories[0].createdDate.toDate())
            .inSeconds >
        12 * 3600) {
      context.read<StoryDownloadProvider>().delete(widget.user.stories[0]);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Material(
          type: MaterialType.transparency,
          child: PageView(children: [
            StoryView(
              controller: controller,
              storyItems: storyItems,
              onStoryShow: (s) {
                print("Showing a story ${widget.user.stories.length}");
              },
              onVerticalSwipeComplete: (f) {
                if (f == Direction.up) {
                  if (i < storyItems.length - 1) {
                    controller.next();
                    setState(() {
                      i = i + 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                  // Navigator.pop(context);
                } else if (f == Direction.down) {
                  controller.previous();
                  if (i != 0) {
                    setState(() {
                      i = i - 1;
                    });
                  } else {
                    Navigator.pop(context);
                  }
                }
              },
              onComplete: () {
                Navigator.pop(context);
                // i++;
                // cont.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);

                print("Completed a cycle");
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              inline: true,
            ),
          ]),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 50, left: 20),
          child: GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ChatDm(
                            model: widget.user,
                          )));
            },
            child: StatusProfile(
              user: widget.user,
              date:
                  '${DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inHours}h:${DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inMinutes - 60 * DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inHours}min ago',
            ),
          ),
        )
      ]);
}

class MoreStories extends StatefulWidget {
  final String uid;
  final List docu;
  final UserModel user;

  const MoreStories({
    Key key,
    @required this.uid,
    @required this.docu,
    @required this.user,
  }) : super(key: key);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  Map userM = Hive.box('beepo').get('userData');

  final StoryController controller = StoryController();

  final storyItems = <StoryItem>[];

  void addStoryItems() {
    for (final story in widget.user.stories) {
      switch (story.mediaType) {
        case "image":
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: controller,
            caption:
                // Text(
                story.caption,
            duration: Duration(seconds: 20),
          ));
          break;
        case "video":
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: controller,
            caption:
                // Text(
                story.caption,
          ));
          break;
      }
    }
  }

  int i;

  @override
  void initState() {
    // getProfileData();
    addStoryItems();
    // calDate(date);
    i = 0;
    if (DateTime.now()
            .difference(widget.user.stories[0].createdDate.toDate())
            .inHours >
        13) {
      if(widget.user.stories.length != 1){
        context.read<StoryDownloadProvider>().delete(widget.user.stories[0]);
        FirebaseFirestore.instance
            .collection('usersStories')
            .doc(widget.user.stories[0].uid)
            .delete();
      }
      else{
        Navigator.pop(context);
        context.read<StoryDownloadProvider>().delete(widget.user.stories[0]);
        FirebaseFirestore.instance
            .collection('usersStories')
            .doc(widget.user.stories[0].uid)
            .delete();
        setState(() {

        });
      }
    }
    super.initState();
  }

  @override
  void dispose() {
    // storyController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      Material(
        type: MaterialType.transparency,
        child: StoryView(
              controller: controller,
              storyItems: storyItems,
              onStoryShow: (s) {
                print("Showing a story");
              },
              onVerticalSwipeComplete: (f) {
                // if (f == Direction.up) {
                //   if (i < storyItems.length - 1) {
                //     controller.next();
                //     setState(() {
                //       i = i + 1;
                //     });
                //   } else {
                //     // pageController.nextPage(
                //     //     duration: Duration(microseconds: 300),
                //     //     curve: Curves.easeIn);
                //     Navigator.pop(context);
                //   }
                //   // Navigator.pop(context);
                // } else if (f == Direction.down) {
                //   controller.previous();
                //   if (i != 0) {
                //     setState(() {
                //       i = i - 1;
                //     });
                //   } else {
                //     Navigator.pop(context);
                //   }
                // }
              },
              onComplete: () {
                // if (index < (widget.docu.length - 1)) {
                //   pageController.nextPage(
                //       duration: Duration(microseconds: 300),
                //       curve: Curves.easeIn);
                // }
                Navigator.pop(context);
                // i++;
                // cont.nextPage(duration: Duration(seconds: 1), curve: Curves.easeIn);

                print("Completed a cycle");
              },
              progressPosition: ProgressPosition.top,
              repeat: false,
              inline: true,
            ),

      ),
      Padding(
        padding: const EdgeInsets.only(top: 80, left: 20),
        child: GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChatDm(
                          model: widget.user,
                        )));
          },
          child: StatusProfile(
              user: widget.user,
              date:
                  '${DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inHours}h:${DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inMinutes - 60 * DateTime.now().difference(widget.user.stories[i].createdDate.toDate()).inHours}min ago'),
        ),
      )
    ]);
  }
}

class StatusProfile extends StatelessWidget {
  // const StatusProfile({Key? key}) : super(key: key);
  final UserModel user;
  final String date;

  const StatusProfile({Key key, this.user, this.date}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 24,
          backgroundImage: NetworkImage(user.image),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                user.name,
                style: TextStyle(
                  fontSize: 20,
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 5,
              ),
              Text(
                date,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
