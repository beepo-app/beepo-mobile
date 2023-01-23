// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_return

import 'package:beepo/extensions.dart';
import 'package:beepo/provider.dart';
import 'package:beepo/story_download_provider.dart';

// import 'package:beepo/story_screen.dart';
import 'package:beepo/story_view.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

// import 'Models/story_model/story.dart';
import 'Models/story_model/storyModel.dart';
import 'Models/user_model.dart';
import 'Models/wallet.dart';
import 'Screens/Browser/browser_page.dart';
import 'Screens/Wallet/token_screen.dart';
import 'Utils/styles.dart';
import 'add_story.dart';
import 'bubble_stories.dart';
import 'groupMessages.dart';
import 'myMessages.dart';

class FilledButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  FilledButton({@required this.text, this.color, @required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 237,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(
            color ?? secondaryColor,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class OutlnButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  // final Color color;

  OutlnButton({
    @required this.text,
    // required this.color,
    @required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 237,
      height: 42,
      child: TextButton(
        onPressed: onPressed,
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: TextStyle(
            color: secondaryColor,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
        style: ButtonStyle(
          side: MaterialStateProperty.all(
            BorderSide(
              width: 1,
              color: secondaryColor,
            ),
          ),
          backgroundColor: MaterialStateProperty.all(
            Colors.white,
          ),
          shape: MaterialStateProperty.all(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
        ),
      ),
    );
  }
}

List<UserModel> userss = [];

class ChatTab extends StatefulWidget {
  // ChatTab({Key key}) : super(key: key);

  @override
  State<ChatTab> createState() => _ChatTabState();
}

class _ChatTabState extends State<ChatTab> {
  String receiver;
  bool showInput = false;

  Stream<List<StoryModel>> currentUserStories;
  Stream<List<StoryModel>> friendsStories;

  // Stream<List<UserModel>> currentUserFollowingStories;
  Stream<List<DocumentSnapshot>> currentUserFollowing;

  Map userM = Hive.box('beepo').get('userData');

  Widget usert;
  CameraDescription firstCamera;
  CameraDescription secondCamera;

  // List<CameraDescription> cameras;
  gethg() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras[0];
    secondCamera = cameras[1];
    print(
        'number of cameras: ${cameras.length} ${firstCamera.lensDirection.name}');
// cameras.take(2);
  }

  @override
  void initState() {
    // TODO: implement initState
    // context.read<ChatNotifier>().getUsers();
    currentUserStories =
        context.read<StoryDownloadProvider>().getCurrentUserStories();
    // currentUserFollowingStories =
    //     context.read<StoryDownloadProvider>().getFollowingUsersStories();
    // friendsStories = context.read<StoryDownloadProvider>().getFriendStories();
    // currentUserFollowing =
    //     context.read<StoryDownloadProvider>().getUsers();
    gethg();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          // scrollDirection: Axis.horizontal,
          children: [
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            // Homes()
                            // CameraApp()
                            //       TakePictureScreen(camera: firstCamera,)
                            AddStory(
                              camera1: firstCamera,
                              camera2: secondCamera,
                            )));
              },
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC4C4C4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Update Moment",
                    style: TextStyle(
                      color: Color(0xb2ffffff),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 100,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  StreamBuilder<List<StoryModel>>(
                      stream: currentUserStories,
                      initialData: const [],
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          try {
                            List<StoryModel> userStories = snapshot.data;
                            'UserStories: $userStories'.log();
                            Map useR;
                            useR = Hive.box('beepo').get('userData');

                            UserModel userf = UserModel(
                              uid: useR['uid'],
                              name: useR['displayName'],
                              userName: useR['username'],
                              image: useR['profilePictureUrl'],
                              // searchKeywords: fuck.data['searchKeywords'],
                            );

                            final user = userf.copyWith(
                              stories: userStories,
                              uid: userM['uid'],
                            );

                            return CurrentUserStoryBubble(user: user);
                          } catch (e) {
                            print(e);
                          }
                        }
                        if (!snapshot.hasData) {
                          print("i can't get data");
                        }
                        if (snapshot.hasError) {
                          print(snapshot.error);
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('usersStories')
                          .where('uid', isNotEqualTo: userM['uid'])
                          .snapshots(),
                      // initialData: const [],
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data.docs.isEmpty) {
                            return SizedBox();
                          }
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data.docs.length,
                            itemBuilder: (context, index) {
                              print(snapshot.data.docs.length);

                              return BubbleStories(
                                uid: snapshot.data.docs[index].id,
                                index: index,
                                docu: snapshot.data.docs,
                                myStory: false,
                                // index: index,
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      })
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(20),
                topRight: Radius.circular(20),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  showInput
                      ? TextField(
                          onSubmitted: (value) {
                            setState(() {
                              showInput = !showInput;
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search messages',
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                        )
                      : Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Messages",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                              ),
                            ),
                            IconButton(
                              onPressed: () {
                                setState(() {
                                  showInput = !showInput;
                                });
                              },
                              icon: Icon(
                                Icons.search,
                                color: Color(0xff908f8d),
                                size: 20,
                              ),
                            ),
                            // SizedBox(width: 20),
                            // Icon(
                            //   Icons.more_vert_outlined,
                            //   color: Color(0xff908f8d),
                            //   size: 18,
                            // ),
                          ],
                        ),
                  Consumer<ChatNotifier>(
                    builder: (context, pro, _) => Column(
                      children: [
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('groups')
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {

                              if (snapshot.data.docs.isNotEmpty) {
                                return ListView.separated(
                                  padding: const EdgeInsets.only(top: 10),
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: snapshot.data.docs.length,
                                  separatorBuilder: (ctx, i) =>
                                  const SizedBox(height: 0),
                                  itemBuilder: (ctx, index) {
                                    return GroupMessages(
                                      uid: snapshot.data.docs[index].id,
                                      index: index,
                                      docu: snapshot.data.docs,
                                    );
                                  },
                                );
                              }
                              else{
                                return SizedBox();
                              }
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),
                        StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('conversation')
                              .doc(userM['uid'] == '' ? ' ' : userM['uid'])
                              .collection("currentConversation")
                              .orderBy('created', descending: true)
                              .snapshots(),
                          builder:
                              (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {

                              if (snapshot.data.docs.isEmpty) {
                                return Padding(
                                  padding: const EdgeInsets.only(top: 50),
                                  child: const Center(
                                    child: Text(
                                      'No Messages\n Tap on the + icon to start a conversation',
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                );
                              }
                              return ListView.separated(
                                padding: const EdgeInsets.only(top: 10),
                                physics: const NeverScrollableScrollPhysics(),
                                shrinkWrap: true,
                                itemCount: snapshot.data.docs.length,
                                separatorBuilder: (ctx, i) =>
                                    const SizedBox(height: 0),
                                itemBuilder: (ctx, index) {
                                  return MyMessages(
                                    uid: snapshot.data.docs[index].id,
                                    index: index,
                                    docu: snapshot.data.docs,
                                  );
                                },
                              );
                            }
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        ),

                      ],
                    ),
                  ),

                  //),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class CallTab extends StatefulWidget {
  // CallTab({Key key}) : super(key: key);

  @override
  State<CallTab> createState() => _CallTabState();
}

class _CallTabState extends State<CallTab> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 25),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Messages",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                    ),
                  ),
                ),
                Icon(
                  Icons.search,
                  color: Color(0xff908f8d),
                  size: 20,
                ),
                SizedBox(width: 20),
                Icon(
                  Icons.more_vert_outlined,
                  color: Color(0xff908f8d),
                  size: 18,
                ),
              ],
            ),
            const SizedBox(height: 27),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: Image.asset(
                  'assets/profile2.png',
                  height: 50,
                  width: 50,
                ),
              ),
              title: const Text(
                "Precious ",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                ),
              ),
              subtitle: const Text(
                "9:13",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),

                // );
                // },
              ),
              trailing: const Icon(
                Icons.phone_missed_sharp,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageSender extends StatelessWidget {
  final bool isMe;
  final String text;
  final Timestamp time;
  final String displayname;

  const MessageSender({
    @required this.isMe,
    @required this.text,
    @required this.time,
    @required this.displayname,
  });

  @override
  Widget build(BuildContext context) {
    var day = time.toDate().day.toString();
    var month = time.toDate().month.toString();
    var year = time.toDate().toString().substring(2);
    var date = day + '-' + month + '-' + year;
    var hour = time.toDate().hour;
    var min = time.toDate().minute;

    var ampm;
    if (hour > 12) {
      hour = hour % 12;
      ampm = 'pm';
    } else if (hour == 12) {
      ampm = 'pm';
    } else if (hour == 0) {
      hour = 12;
      ampm = 'am';
    } else {
      ampm = 'am';
    }
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isMe ? Radius.circular(12) : Radius.circular(0),
            topRight: isMe ? Radius.circular(0) : Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          color: !isMe ? Color(0xffc4c4c4) : Color(0xff0E014C),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              text,
              style: isMe
                  ? TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    )
                  : TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                    ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  hour.toString() + ":" + min.toString() + ampm,
                  style: isMe
                      ? TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                        )
                      : TextStyle(
                          color: Colors.black,
                          fontSize: 10,
                        ),
                ),
                isMe
                    ? SizedBox(width: 5)
                    : SizedBox(
                        width: 0,
                      ),
                isMe
                    ? Icon(
                        Icons.done_all,
                        color: Colors.white,
                        size: 15,
                      )
                    : SizedBox(
                        width: 0,
                      ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

class Group extends StatelessWidget {
  final bool isMe;
  final String text;
  final Timestamp time;
  final UserModel user;

  const Group({Key key,
    @required this.isMe,
    @required this.text,
    @required this.time,
    this.user,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var day = time.toDate().day.toString();
    var month = time.toDate().month.toString();
    var year = time.toDate().toString().substring(2);
    var date = day + '-' + month + '-' + year;
    var hour = time.toDate().hour;
    var min = time.toDate().minute;

    var ampm;
    if (hour > 12) {
      hour = hour % 12;
      ampm = 'pm';
    } else if (hour == 12) {
      ampm = 'pm';
    } else if (hour == 0) {
      hour = 12;
      ampm = 'am';
    } else {
      ampm = 'am';
    }
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: isMe ? Radius.circular(12) : Radius.circular(0),
            topRight: isMe ? Radius.circular(0) : Radius.circular(12),
            bottomLeft: Radius.circular(12),
            bottomRight: Radius.circular(12),
          ),
          color: !isMe ? Color(0xffc4c4c4) : Color(0xff0E014C),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
          isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [

            Text(
              text,
              style: isMe
                  ? TextStyle(
                color: Colors.white,
                fontSize: 14,
              )
                  : TextStyle(
                color: Colors.black,
                fontSize: 14,
              ),
            ),
            SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  hour.toString() + ":" + min.toString() + ampm,
                  style: isMe
                      ? TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                  )
                      : TextStyle(
                    color: Colors.black,
                    fontSize: 10,
                  ),
                ),
                isMe
                    ? SizedBox(width: 5)
                    : SizedBox(
                  width: 0,
                ),
                isMe
                    ? Icon(
                  Icons.done_all,
                  color: Colors.white,
                  size: 15,
                )
                    : SizedBox(
                  width: 0,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}


class CurrentUserStoryBubble extends StatelessWidget {
  const CurrentUserStoryBubble({
    Key key,
    @required this.user,
  }) : super(key: key);

  // final List<Story> stories;
  final UserModel user;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => Homes(user: user)));
      },
      child: BubbleStories(
        uid: user.uid,
        hasStory: user.stories.isNotEmpty,
        myStory: true,
        // useNetworkImage: true,
      ),
    );
  }
}

class WalletListTile extends StatelessWidget {
  final String image;
  final String title;
  final String subtext;
  final String amount;
  final Wallet wallet;
  final String fiatValue;

  WalletListTile({
    @required this.image,
    @required this.title,
    @required this.subtext,
    @required this.amount,
    this.wallet,
    this.fiatValue,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        boxShadow: const [
          BoxShadow(
            color: Color(0x3f000000),
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
        color: const Color(0xfffffbfb),
      ),
      margin: const EdgeInsets.symmetric(horizontal: 5),
      child: ListTile(
        onTap: () => Get.to(WalletToken(
          wallet: wallet,
          balance: amount,
          value: fiatValue,
        )),
        dense: true,
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(17),
          child: CachedNetworkImage(
            imageUrl: image,
            height: 34,
            width: 34,
            fit: BoxFit.cover,
          ),
        ),
        title: Row(
          children: [
            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
            const SizedBox(width: 5),
            Text(
              '\$$fiatValue',
              style: const TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            )
          ],
        ),
        subtitle: Row(
          children: [
            Expanded(
              child: Text(
                subtext,
                style: const TextStyle(
                  color: Color(0xcc000000),
                  fontSize: 12,
                ),
              ),
            ),
            Text(
              amount,
              style: const TextStyle(
                color: Color(0xcc000000),
                fontSize: 14,
              ),
            )
          ],
        ),
      ),
    );
  }
}

class BrowserContainer extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
              color: Colors.white,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(image),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer2 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer2({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
              image: DecorationImage(
                image: AssetImage(image),
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: const Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer3 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer3({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              color: const Color(0xff40D6E1),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: const Color(0x3f000000),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: const Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class BrowserContainer4 extends StatelessWidget {
  final String image;
  final String title;

  BrowserContainer4({this.image, this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () => Get.to(BrowserPage()),
          child: Container(
            padding: const EdgeInsets.all(0),
            width: 55,
            height: 53,
            decoration: BoxDecoration(
              color: const Color(0xff2081E2),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                const BoxShadow(
                  color: Color(0x3f000000),
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Image.asset(
              image,
              height: 55,
              width: 55,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          title,
          style: const TextStyle(
            color: Color(0xff0e014c),
            fontSize: 11,
          ),
        ),
      ],
    );
  }
}

class ContainerButton extends StatelessWidget {
  // const ContainerButton({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 30,
      width: 180,
      decoration: BoxDecoration(
        boxShadow: [
          const BoxShadow(
            color: const Color(0x0c000234),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomLeft: const Radius.circular(35),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const Text(
                    'Swap',
                    style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const Spacer(),
                  const VerticalDivider(),
                ],
              ),
            ),
          ),
          const Divider(),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              color: const Color.fromRGBO(255, 255, 255, 1),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Spacer(),
                  const Text(
                    'Granda',
                    style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey),
                  ),
                  const Spacer(),
                  const VerticalDivider(),
                ],
              ),
            ),
          ),
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: const BorderRadius.only(
                  topRight: const Radius.circular(35),
                  bottomRight: const Radius.circular(35),
                ),
              ),
              child: const Text(
                'About',
                style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
