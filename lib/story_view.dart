// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

// import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:story_view/story_view.dart';

import 'Models/user_model.dart';
import 'models/story_model/story.dart';

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
        case MediaType.image:
          storyItems.add(StoryItem.pageImage(
            url: story.url,
            controller: controller,
            caption:
                // Text(
                "Omotuo & Nkatekwan; You will love this meal if taken as supper.",
            //   style: TextStyle(
            //     color: Colors.white,
            //     backgroundColor: Colors.black54,
            //     fontSize: 17,
            //   ),
            // ),
          ));
          break;
        case MediaType.video:
          storyItems.add(StoryItem.pageVideo(
            story.url,
            controller: controller,
            caption:
                // Text(
                "Hektas, sektas and skatad",
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

  DateTime date;
  String diff;

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

  final PageController cont = PageController();

  @override
  void initState() {
    addStoryItems();
    // calDate(date);
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
                print("Showing a story");
              },
              onVerticalSwipeComplete: (f) {
                // i++;
                if (f == Direction.down) {
                  Navigator.pop(context);
                }
              },
              onComplete: () {
                // Navigator.pop(context);
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
              date: 'Just Now',
            ),
          ),
        )
      ]);
}

class MoreStories extends StatefulWidget {
  @override
  _MoreStoriesState createState() => _MoreStoriesState();
}

class _MoreStoriesState extends State<MoreStories> {
  final storyController = StoryController();

  @override
  void dispose() {
    storyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("More"),
      ),
      body: StoryView(
        storyItems: [
          StoryItem.text(
            title: "I guess you'd love to see more of our food. That's great.",
            backgroundColor: Colors.blue,
          ),
          StoryItem.text(
            title: "Nice!\n\nTap to continue.",
            backgroundColor: Colors.red,
            textStyle: TextStyle(
              fontFamily: 'Dancing',
              fontSize: 40,
            ),
          ),
          StoryItem.pageImage(
            url:
                "https://image.ibb.co/cU4WGx/Omotuo-Groundnut-Soup-braperucci-com-1.jpg",
            caption: "Still sampling",
            controller: storyController,
          ),
          StoryItem.pageImage(
              url: "https://media.giphy.com/media/5GoVLqeAOo6PK/giphy.gif",
              caption: "Working with gifs",
              controller: storyController),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side",
            controller: storyController,
          ),
          StoryItem.pageImage(
            url: "https://media.giphy.com/media/XcA8krYsrEAYXKf4UQ/giphy.gif",
            caption: "Hello, from the other side2",
            controller: storyController,
          ),
        ],
        onStoryShow: (s) {
          print("Showing a story");
        },
        onComplete: () {
          print("Completed a cycle");
        },
        progressPosition: ProgressPosition.top,
        repeat: false,
        controller: storyController,
      ),
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
