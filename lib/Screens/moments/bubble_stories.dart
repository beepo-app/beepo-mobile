import 'package:beepo/Models/story_model/storyModel.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/moments/story_download_provider.dart';
import 'package:beepo/Screens/moments/story_view.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

class BubbleStories extends StatefulWidget {
  const BubbleStories({
    Key key,
    this.index,
    this.docu,
    @required this.uid,
    this.hasStory = true,
    this.myStory,
    // this.useNetworkImage = false,
  }) : super(key: key);

  final bool hasStory;
  final int index;
  final List docu;
  final String uid;
  final bool myStory;

  @override
  State<BubbleStories> createState() => _BubbleStoriesState();
}

class _BubbleStoriesState extends State<BubbleStories> {
  Map userM = Hive.box('beepo').get('userData');
  PageController cont;
  List<MoreStories> moment = [];

  goToMoment() {
    for (final doc in widget.docu) {
      StreamBuilder<List<StoryModel>>(
          stream: context
              .read<StoryDownloadProvider>()
              .getFriendsStories(doc['uid']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<StoryModel> uset = snapshot.data;
              UserModel beta = UserModel(
                uid: doc['uid'],
                name: doc['name'],
                image: doc['profileImage'],
                // userName: userName,
              ).copyWith(stories: uset);
              moment.add(MoreStories(
                uid: doc['uid'],
                docu: widget.docu,
                user: beta,
              ));
              cont = PageController(initialPage: widget.index);
              return const SizedBox.shrink();
            }
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          });
    }

  }

  @override
  void initState() {
    // getProfileData();
    // goToMoment();
    super.initState();
  }

  // final bool useNetworkImage;
  @override
  Widget build(BuildContext context) {
    if (widget.myStory == false) {
      return InkWell(
        onTap: () {
          // goToMoment();
        },
        child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('users')
                .where('uid', isEqualTo: widget.uid)
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const SizedBox();
              }
              // usName = snapshot.data.docs[0]['userName'];
              return Column(
                children: [
                  widget.hasStory
                      ? Container(
                          margin: const EdgeInsets.only(right: 7.0, top: 10),
                          padding: const EdgeInsets.all(2.0),
                          decoration: const BoxDecoration(
                            shape: BoxShape.circle,
                          ),
                          width: 60,
                          height: 60,
                          child: snapshot.data.docs[0]['image'].isNotEmpty
                              ? CircleAvatar(
                                  backgroundImage: CachedNetworkImageProvider(
                                      snapshot.data.docs[0]['image']),
                                  radius: 30,
                                )
                              : const CircleAvatar(
                                  child: Icon(
                                    Icons.person,
                                    color: secondaryColor,
                                  ),
                                  backgroundColor: secondaryColor,
                                ),
                        )
                      : const SizedBox(
                          width: 1,
                        ),
                  Text(
                    widget.hasStory ? snapshot.data.docs[0]['name'] : ' ',
                    style: const TextStyle(color: Colors.white, fontSize: 10),
                  ),
                ],
              );
            }),
      );
    } else {
      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('uid', isEqualTo: userM['uid'])
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
            return Column(
              children: [
                widget.hasStory
                    ? Container(
                        margin: const EdgeInsets.only(right: 7.0, top: 10),
                        padding: const EdgeInsets.all(2.0),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                        ),
                        width: 60,
                        height: 60,
                        child: snapshot.data.docs[0]['image'].isNotEmpty
                            ? CircleAvatar(
                                backgroundImage: CachedNetworkImageProvider(
                                    snapshot.data.docs[0]['image']),
                                radius: 30,
                              )
                            : const CircleAvatar(
                                child: Icon(
                                  Icons.person,
                                  color: secondaryColor,
                                ),
                                backgroundColor: secondaryColor,
                              ),
                      )
                    : const SizedBox(
                        width: 1,
                      ),
                Text(
                  widget.hasStory ? 'Your Moments' : ' ',
                  style: const TextStyle(color: Colors.white, fontSize: 10),
                ),
              ],
            );
          });
    }
  }
}
