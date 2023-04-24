// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, missing_return

import 'package:beepo/Screens/Profile/user_profile_screen.dart';
import 'package:beepo/Screens/moments/story_download_provider.dart';

// import 'package:beepo/story_screen.dart';
import 'package:beepo/Screens/moments/story_view.dart';
import 'package:beepo/extensions.dart';
import 'package:beepo/provider.dart';
import 'package:beepo/search.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_link_preview/flutter_link_preview.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:linkwell/linkwell.dart';
import 'package:provider/provider.dart';

// import 'Models/story_model/story.dart';
import 'Models/market_data.dart';
import 'Models/story_model/storyModel.dart';
import 'Models/user_model.dart';
import 'Models/wallet.dart';
import 'Screens/Browser/browser_page.dart';
import 'Screens/Messaging/chat_dm_screen.dart';
import 'Screens/Messaging/groupMessages.dart';
import 'Screens/Messaging/myMessages.dart';
import 'Screens/Wallet/token_screen.dart';
import 'Screens/moments/add_story.dart';
import 'Screens/moments/bubble_stories.dart';
import 'Utils/styles.dart';

class FilledButtons extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color color;

  FilledButtons({@required this.text, this.color, @required this.onPressed});

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

  Stream<List<DocumentSnapshot>> currentUserFollowing;

  Box box1 = Hive.box('beepo');

  setLeave() async {
    await FirebaseFirestore.instance
        .collection('LeaveGroup')
        .doc(userM['uid'])
        .set({'isRemoved': 'false'});
  }

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
  }

  final TextEditingController _searchcontroller = TextEditingController();

  String remove;

  @override
  void initState() {
    currentUserStories =
        context.read<StoryDownloadProvider>().getCurrentUserStories();
    gethg();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tem = FirebaseFirestore.instance
        .collection('LeaveGroup')
        .doc(userM['uid'])
        .get();

    tem.then((value) =>
            // setState(() {
            remove = value.data()['isRemoved'].toString()
        // print(remove);
        );
    // }));

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStory(
                      camera1: firstCamera,
                      camera2: secondCamera,
                    ),
                  ),
                );
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
                  ),
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
                          } catch (e) {}
                        }
                        if (!snapshot.hasData) {}
                        if (snapshot.hasError) {}
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
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: showInput
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SearchBar2(
                            controller: _searchcontroller,
                            autofocus: true,
                            showInput: showInput,
                            onChanged: (value) {
                              setState(() {});
                            },
                          ),
                          // Text('omooo'),omooo
                          SizedBox(
                            height: 200,
                            // fit: FlexFit.loose,
                            // flex: 1,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                left: 22.0,
                                right: 22.0,
                              ),
                              child: StreamBuilder<QuerySnapshot<Map>>(
                                  stream: FirebaseFirestore.instance
                                      .collection("conversation")
                                      .doc(userM['uid'])
                                      .collection('currentConversation')
                                      .where("searchKeywords",
                                          arrayContains: _searchcontroller.text
                                              .trim()
                                              .toLowerCase())
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    if (!snapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(
                                          color: primaryColor,
                                        ),
                                      );
                                    }
                                    if (snapshot.data == null) {
                                      return const SizedBox(
                                        height: 2,
                                      );
                                    }
                                    return ListView.builder(
                                      itemCount: snapshot.data.docs.length,
                                      // shrinkWrap: true,
                                      itemBuilder: (context, index) {
                                        final data =
                                            snapshot.data.docs[index].data();
                                        print(
                                            'this is the length:  ${snapshot.data.docs.length}');
                                        return _searchcontroller.text.isNotEmpty
                                            ? ListTile(
                                                onTap: () {
                                                  Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                      builder: (context) =>
                                                          ChatDm(
                                                        model: UserModel(
                                                          uid: data['receiver'],
                                                          name: data[
                                                              'displayName'],
                                                          image: data['image'],
                                                          userName:
                                                              data['name'],
                                                          searchKeywords: data[
                                                              'searchKeywords'],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                },
                                                leading: Container(
                                                  width: 46,
                                                  height: 46,
                                                  decoration:
                                                      const BoxDecoration(
                                                    shape: BoxShape.circle,
                                                  ),
                                                  child: ClipOval(
                                                    child: CachedNetworkImage(
                                                      imageUrl: data['image'],
                                                      placeholder: (context,
                                                              url) =>
                                                          Center(
                                                              child:
                                                                  CircularProgressIndicator()),
                                                      errorWidget: (context,
                                                              url, error) =>
                                                          Icon(
                                                        Icons.person,
                                                        color: secondaryColor,
                                                      ),
                                                      filterQuality:
                                                          FilterQuality.high,
                                                    ),
                                                  ),
                                                ),
                                                title: Text(
                                                  data['name'],
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                // subtitle: Text('@${data['username']}'),
                                              )
                                            : const SizedBox();
                                      },
                                    );
                                  }),
                            ),
                          )
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "Messages",
                                  style: TextStyle(
                                    color: secondaryColor,
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
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
                                  color: Color(0xff697077),
                                  //Color(0xff908f8d),
                                  size: 25,
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
                                // if (remove == 'false')
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('groups')
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.docs.isNotEmpty) {
                                        return ListView.separated(
                                          padding:
                                              const EdgeInsets.only(top: 10),
                                          physics:
                                              const NeverScrollableScrollPhysics(),
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
                                      } else {
                                        return SizedBox();
                                      }
                                    }
                                    return const SizedBox();
                                  },
                                ),
                                StreamBuilder(
                                  stream: FirebaseFirestore.instance
                                      .collection('conversation')
                                      .doc(userM['uid'] == ''
                                          ? ' '
                                          : userM['uid'])
                                      .collection("currentConversation")
                                      .orderBy('created', descending: true)
                                      .snapshots(),
                                  builder: (context,
                                      AsyncSnapshot<QuerySnapshot> snapshot) {
                                    if (snapshot.hasData) {
                                      if (snapshot.data.docs.isEmpty) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(top: 50),
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
                                        physics:
                                            const NeverScrollableScrollPhysics(),
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
                          )
                        ],
                      ),
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
  Map userM = Hive.box('beepo').get('userData');

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _searchController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 17),
      color: Colors.white,
      child: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            Row(
              children: [
                Expanded(
                  child: Text(
                    "Call History",
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 19,
                    ),
                  ),
                ),
                // Icon(
                //   Icons.search,
                //   color: Color(0xff697077),
                //   size: 20,
                // ),
                // SizedBox(width: 20),
                // Icon(
                //   Icons.more_vert_outlined,
                //   color: Color(0xff697077),
                //   size: 18,
                // ),
              ],
            ),
            SizedBox(
             height: MediaQuery.of(context).size.height,
              child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('calls')
                      .doc(userM['uid'])
                      .collection('allCalls').orderBy('created', descending: true,)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if(!snapshot.hasData){
                      return SizedBox.shrink();
                    }

                    return ListView.builder(
                      shrinkWrap: true,
                        itemBuilder: (context, index) {
                          Timestamp time = snapshot.data.docs[index]['created'];
                          return ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(25),
                          child: Image.network(
                            snapshot.data.docs[index]['image'],
                            height: 50,
                            width: 50,
                            fit: BoxFit.cover,
                          ),
                        ),
                        title: Text(
                          snapshot.data.docs[index]['name'],
                          style: TextStyle(
                            color: Color.fromRGBO(0, 0, 0, 1),
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        subtitle: Text(
                          '${time.toDate().hour} : ${time.toDate().minute}',
                          style: TextStyle(
                            color: secondaryColor,
                            //Color(0xff697077),
                            fontSize: 10,
                            fontWeight: FontWeight.w500,
                          ),

                          // );
                          // },
                        ),
                        trailing: snapshot.data.docs[index]['callType'] == 'callReceived'? const Icon(
                          Icons.phone_missed_sharp,
                          color: Colors.red,
                          size: 20,
                        ): const Icon(
                          Icons.phone_callback,
                          color: Colors.green,
                          size: 20,
                        ),
                      );
                    },
                      itemCount: snapshot.data.docs.length,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageReply extends StatelessWidget {
  final bool isMe;
  final String text;
  final Timestamp time;
  final bool onSwipedMessage;
  final String replyMessage;
  final String replyName;
  final String replyUsername;

  const MessageReply({
    @required this.isMe,
    @required this.text,
    @required this.time,
    this.onSwipedMessage,
    this.replyMessage,
    this.replyName,
    this.replyUsername,
  });

  String convertStringToLink(String text) {
    String textData = text;
    final urlRegExp = RegExp(
        r"((https?:www\.)|(http?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    final urlMatches = urlRegExp.allMatches(text);
    List<String> urls = urlMatches
        .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
        .toList();
    urls.forEach((x) => print(x));
    // final urlRegExp = RegExp(
    //     r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
    // final urlMatches = urlRegExp.allMatches(textData);
    // List<String> urls = urlMatches
    //     .map((urlMatch) => textData.substring(urlMatch.start, urlMatch.end))
    //     .toList();
    // List linksString = [];
    // for (var linkText in urls) {
    //   linksString.add(linkText);
    // }
    //
    // // if (linksString.isNotEmpty) {
    // //   for (var linkTextData in linksString) {
    // //     textData =
    // //         textData.replaceAll(linkTextData, 'https://' + linkTextData);
    // //   }
    // // }
    if (text.isEmpty) {
      return null;
    }
    return textData;
  }

  Widget buildReply(String message, String username, String displayName) =>
      Container(
        decoration: BoxDecoration(
          color: isMe
              ? Color(0xffffffff).withOpacity(0.3)
              : Color(0xff697077).withOpacity(0.2),
          borderRadius: BorderRadius.circular(5),
        ),
        padding: EdgeInsets.only(
          left: 14,
          right: 10,
          top: 5,
          bottom: 5,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  displayName,
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: primaryColor,
                  ),
                ),
                // Text(
                //   '@${username}',
                //   style: TextStyle(
                //     fontSize: 12,
                //     fontWeight: FontWeight.w400,
                //     color: Color(0xffc82513),
                //   ),
                // ),
              ],
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              message,
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w400,
                color: Colors.white,
              ),
            )
          ],
        ),
      );

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
            topLeft: isMe ? Radius.circular(15) : Radius.circular(15),
            topRight: isMe ? Radius.circular(15) : Radius.circular(15),
            bottomLeft: Radius.circular(15),
            bottomRight: Radius.circular(15),
          ),
          color: !isMe ? Color(0xFFE6E9EE) : Color(0xff0E014C),
        ),
        constraints: BoxConstraints(
          // maxWidth: double.infinity
          maxWidth: MediaQuery.of(context).size.width * 0.5,
        ),
        padding: const EdgeInsets.all(8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (onSwipedMessage && replyMessage != "")
              buildReply(replyMessage, replyUsername, replyName),
            if (convertStringToLink(text) != null)
              FlutterLinkPreview(
                  url: convertStringToLink(text),
                  titleStyle: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: txtColor1,
                  ),
                  builder: (info) {
                    if (info == null) return const SizedBox();
                    if (info is WebImageInfo) {
                      return CachedNetworkImage(
                        imageUrl: info.image,
                        fit: BoxFit.contain,
                      );
                    }

                    final WebInfo webInfo = info;
                    if (!WebAnalyzer.isNotEmpty(webInfo.title)) {
                      return const SizedBox();
                    }
                    return Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: const Color(0xFFF0F1F2),
                      ),
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                imageUrl: webInfo.icon ?? "",
                                imageBuilder: (context, imageProvider) {
                                  return Image(
                                    image: imageProvider,
                                    fit: BoxFit.contain,
                                    width: 30,
                                    height: 30,
                                    errorBuilder: (context, error, stackTrace) {
                                      return const Icon(Icons.link);
                                    },
                                  );
                                },
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  webInfo.title,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          if (WebAnalyzer.isNotEmpty(webInfo.description)) ...[
                            const SizedBox(height: 8),
                            Text(
                              webInfo.description,
                              maxLines: 5,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                          if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                            const SizedBox(height: 8),
                            CachedNetworkImage(
                              imageUrl: webInfo.image,
                              fit: BoxFit.contain,
                            ),
                          ]
                        ],
                      ),
                    );
                  }),
            LinkWell(
              text,
              style: isMe
                  ? TextStyle(
                      fontFamily: 'Roboto',
                      color: Colors.white,
                      fontSize: 11.5,
                    )
                  : TextStyle(
                      fontFamily: 'Roboto',
                      color: secondaryColor,
                      fontSize: 11.5,
                    ),
              linkStyle: TextStyle(
                fontFamily: 'Roboto',
                color: primaryColor,
                fontSize: 11.5,
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
                          fontSize: 9,
                        )
                      : TextStyle(
                          color: secondaryColor,
                          fontSize: 9,
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
                        size: 14,
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
  final bool sameUser;
  final bool onSwipedMessage;
  final String replyMessage;
  final String replyName;
  final String replyUsername;

  const Group({
    Key key,
    @required this.isMe,
    @required this.text,
    @required this.time,
    this.user,
    @required this.sameUser,
    @required this.onSwipedMessage,
    @required this.replyMessage,
    @required this.replyName,
    @required this.replyUsername,
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
    Widget buildReply(String message, String username, String displayName) =>
        Container(
          decoration: BoxDecoration(
            color: isMe
                ? Color(0xffffffff).withOpacity(0.3)
                : Color(0xff697077).withOpacity(0.2),
            borderRadius: BorderRadius.circular(5),
          ),
          padding: EdgeInsets.only(
            left: 14,
            right: 10,
            top: 5,
            bottom: 5,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    displayName,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: primaryColor,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 15,
              ),
              Text(
                message,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                  color: Colors.white,
                ),
              )
            ],
          ),
        );

    String convertStringToLink(String text) {
      String textData = text;
      final urlRegExp = RegExp(
          r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
      final urlMatches = urlRegExp.allMatches(text);
      List<String> urls = urlMatches
          .map((urlMatch) => text.substring(urlMatch.start, urlMatch.end))
          .toList();
      urls.forEach((x) => print(x));
      // final urlRegExp = RegExp(
      //     r"((https?:www\.)|(https?:\/\/)|(www\.))[-a-zA-Z0-9@:%._\+~#=]{1,256}\.[a-zA-Z0-9]{1,6}(\/[-a-zA-Z0-9()@:%_\+.~#?&\/=]*)?");
      // final urlMatches = urlRegExp.allMatches(textData);
      // List<String> urls = urlMatches
      //     .map((urlMatch) => textData.substring(urlMatch.start, urlMatch.end))
      //     .toList();
      // List linksString = [];
      // for (var linkText in urls) {
      //   linksString.add(linkText);
      // }
      //
      // // if (linksString.isNotEmpty) {
      // //   for (var linkTextData in linksString) {
      // //     textData =
      // //         textData.replaceAll(linkTextData, 'https://' + linkTextData);
      // //   }
      // // }
      if (text.isEmpty) {
        return null;
      }
      return textData;
    }

    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Row(
        crossAxisAlignment:
            !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
            SizedBox(
              width: 46,
            ),
          if (!isMe)
            if (!sameUser)
              Padding(
                padding: const EdgeInsets.only(right: 5),
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserProfile(model: user)));
                  },
                  child: CircleAvatar(
                    radius: 20,
                    backgroundImage: CachedNetworkImageProvider(user.image ??
                        'https://pbs.twimg.com/profile_images/1619846077506621443/uWNSRiRL_400x400.jpg'),
                  ),
                ),
              ),
          if (sameUser)
            Padding(
              padding: const EdgeInsets.only(right: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
              ),
            ),
          SizedBox(width: 4),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: isMe ? Radius.circular(12) : Radius.circular(12),
                  topRight: isMe ? Radius.circular(12) : Radius.circular(12),
                  bottomLeft: Radius.circular(12),
                  bottomRight: Radius.circular(12),
                ),
                color: !isMe ? Color(0xFFE6E9EE) : Color(0xff0E014C),
              ),
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width * 0.8,
                minWidth: MediaQuery.of(context).size.width * 0.15,
              ),
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.start : CrossAxisAlignment.start,
                children: [
                  if (!isMe)
                    if (!sameUser)
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            user.name,
                            style: TextStyle(
                              color: secondaryColor,
                              fontFamily: 'SignikaNegative',
                              fontSize: 13,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Spacer(),
                          Text(
                            '@${user.userName}',
                            style: TextStyle(
                              color: secondaryColor,
                              fontFamily: '@Precious001',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                  SizedBox(height: 2),
                  if (onSwipedMessage && replyMessage != "")
                    buildReply(replyMessage, replyUsername, replyName),
                  if (convertStringToLink(text) != null)
                    FlutterLinkPreview(
                        url: convertStringToLink(text),
                        titleStyle: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: txtColor1,
                        ),
                        builder: (info) {
                          if (info == null) return const SizedBox();
                          if (info is WebImageInfo) {
                            return CachedNetworkImage(
                              imageUrl: info.image,
                              fit: BoxFit.contain,
                            );
                          }

                          final WebInfo webInfo = info;
                          if (!WebAnalyzer.isNotEmpty(webInfo.title)) {
                            return const SizedBox();
                          }
                          return Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: const Color(0xFFF0F1F2),
                            ),
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: <Widget>[
                                    CachedNetworkImage(
                                      imageUrl: webInfo.icon ?? "",
                                      imageBuilder: (context, imageProvider) {
                                        return Image(
                                          image: imageProvider,
                                          fit: BoxFit.contain,
                                          width: 30,
                                          height: 30,
                                          errorBuilder:
                                              (context, error, stackTrace) {
                                            return const Icon(Icons.link);
                                          },
                                        );
                                      },
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        webInfo.title,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                                if (WebAnalyzer.isNotEmpty(
                                    webInfo.description)) ...[
                                  const SizedBox(height: 8),
                                  Text(
                                    webInfo.description,
                                    maxLines: 5,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                                if (WebAnalyzer.isNotEmpty(webInfo.image)) ...[
                                  const SizedBox(height: 8),
                                  CachedNetworkImage(
                                    imageUrl: webInfo.image,
                                    fit: BoxFit.contain,
                                  ),
                                ]
                              ],
                            ),
                          );
                        }),
                  Padding(
                    padding: const EdgeInsets.all(3.0),
                    child: LinkWell(
                      text,
                      style: isMe
                          ? TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                              // decoration: TextDecoration.underline,
                            )
                          : TextStyle(
                              color: Colors.black,
                              //Colors.black,
                              fontSize: 11.5,
                              // decoration: TextDecoration.underline,
                            ),
                      linkStyle: TextStyle(
                        color: Colors.blueAccent,
                        fontSize: 11,
                        decoration: TextDecoration.underline,
                      ),
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
                                fontSize: 9,
                              )
                            : TextStyle(
                                color: Colors.black,
                                fontSize: 9,
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
                              size: 14,
                            )
                          : SizedBox(
                              width: 0,
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (!isMe)
            SizedBox(
              width: 26,
            ),
        ],
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
  final String fiatSymbol;
  final CoinMarketData coinMarketData;
  final String fiatValue;

  WalletListTile({
    @required this.image,
    @required this.title,
    @required this.subtext,
    @required this.amount,
    this.coinMarketData,
    this.wallet,
    this.fiatValue,
    this.fiatSymbol,
  });

  @override
  Widget build(BuildContext context) {
    String currentMarketPrice = coinMarketData?.data?.currentPrice ?? '0';
    String change24h = coinMarketData?.data?.priceChangePercentage24H ?? '0';
    bool isPositive = change24h.startsWith('-') ? false : true;
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
          coinMarketData: coinMarketData,
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
              fiatSymbol + fiatValue,
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
              child: Row(
                children: [
                  Text(
                    '\$$currentMarketPrice',
                    style: const TextStyle(
                      color: Color(0xcc000000),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Text(
                    (isPositive ? '+' : '') + '$change24h%',
                    style: TextStyle(
                      color: isPositive ? Colors.green : Colors.red,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 10),
            Text(
              amount,
              style: const TextStyle(
                color: Color(0xcc000000),
                fontSize: 13,
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
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(35),
                  bottomLeft: Radius.circular(35),
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
          GestureDetector(
            onTap: () {},
            child: Container(
              alignment: Alignment.center,
              height: 40,
              width: 60,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(35),
                  bottomRight: Radius.circular(35),
                ),
              ),
              child: const Text(
                'About',
                style: TextStyle(
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
