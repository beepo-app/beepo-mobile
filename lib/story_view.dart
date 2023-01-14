// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:story_view/story_view.dart';

import 'Models/user_model.dart';
import 'components.dart';

class Homes extends StatefulWidget {
  final UserModel user;

  Homes({this.user});

  @override
  State<Homes> createState() => _HomesState();
}

class _HomesState extends State<Homes> {
  final StoryController controller = StoryController();

  Map userM = Hive.box('beepo').get('userData');

  // int i = 0;
  final storyItems = <StoryItem>[];

  // final currentIndex =

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
            //   style: TextStyle(
            //     color: Colors.white,
            //     backgroundColor: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
          ));
          break;
        case "video":
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: controller,
            caption:
                // Text(
                story.caption,
            //   style: TextStyle(
            //     color: Colors.white,
            //     backgroundColor: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
          ));
          break;
      }
    }
  }

  // DateTime date;
  // String diff;

  //  calDate(DateTime date){
  //   final time = date.difference(DateTime.now());
  //   if(time.inHours > 24){
  //     diff = "${time.inDays} ago";
  //   }
  //   else if(time.inMinutes > 60){
  //     diff = "${time.inHours} ago";
  //   }
  //   else if(time.inSeconds > 60){
  //     diff = "${time.inMinutes} ago";
  //   }
  //   else{
  //     diff = "Just Now";
  //   }
  // }
  int i;
  final PageController cont = PageController();

  @override
  void initState() {
    addStoryItems();
    // calDate(date);
    i = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Stack(children: [
        Material(
          type: MaterialType.transparency,
          child: PageView(children: [
            // widget.user =>
            StoryView(
              controller: controller,
              storyItems: storyItems,
              onStoryShow: (s) {
                // final index = storyItems.indexOf(s);
                // // DateTime date;
                // setState(() {
                //   date = widget.user.stories[index].createdDate;
                // });
                // controller.
                // i = i+1;
                print("Showing a story");
              },
              onVerticalSwipeComplete: (f) {
                // i++;
                if (f == Direction.up) {
                  if(i<storyItems.length-1){
                  controller.next();
                  setState(() {
                    i = i+ 1;
                  });}
                  else{
                    Navigator.pop(context);
                  }
                  // Navigator.pop(context);
                }
                else if( f == Direction.down){
                  controller.previous();
                  if(i!=0){
                    setState(() {
                      i= i-1;
                    });

                  }
                  else {
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
  final UserModel user;

  const MoreStories({
    Key key,
    @required this.user,
  }) : super(key: key);

  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  PageController controller;

  @override
  void initState() {
    final initialPage = userss.indexOf(widget.user);
    controller = PageController(initialPage: initialPage);
    // addStoryItems();
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
    return PageView(
        controller: controller,
        children: userss
            .map((e) => StoryWidget(user: e, controller: controller))
            .toList());
  }
}

class StoryWidget extends StatefulWidget {
  final UserModel user;
  final PageController controller;

  StoryWidget({
    @required this.user,
    @required this.controller,
  });

  @override
  State<StoryWidget> createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  StoryController storyController;

  void addStoryItems() {
    for (final story in widget.user.stories) {
      switch (story.mediaType) {
        case "image":
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: storyController,
            caption:
                // Text(
                story.caption,
            duration: Duration(seconds: 20),
            //   style: TextStyle(
            //     color: Colors.white,
            //     backgroundColor: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
          ));
          break;
        case "video":
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: storyController,
            caption:
                // Text(
                story.caption,
            //   style: TextStyle(
            //     color: Colors.white,
            //     backgroundColor: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
          ));
          break;
      }
    }
  }

  @override
  void initState() {
    storyController = StoryController();
    addStoryItems();
    super.initState();
  }

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  // const StoryWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return StoryView(
      storyItems: storyItems,
      onStoryShow: (s) {
        print("Showing a story");
      },
      onComplete: () {
        final currentIndex = userss.indexOf(widget.user);
        final isLastPage = userss.length - 1 == currentIndex;
        if (isLastPage) {
          Navigator.pop(context);
        }
        widget.controller.nextPage(
          duration: Duration(microseconds: 30000),
          curve: Curves.easeIn,
        );
        print("Completed a cycle");
      },
      progressPosition: ProgressPosition.top,
      repeat: false,
      controller: storyController,
    );
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
