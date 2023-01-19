import 'package:beepo/Models/story_model/storyModel.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/story_download_provider.dart';
import 'package:beepo/story_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BubbleStories extends StatefulWidget {
  const BubbleStories({
    Key key,
    @required this.uid,
    this.docu,
    this.hasStory = true,
    this.myStory,
    // this.useNetworkImage = false,
  }) : super(key: key);

  final bool hasStory;
  final String uid;
  final List docu;
  final bool myStory;

  @override
  State<BubbleStories> createState() => _BubbleStoriesState();
}

class _BubbleStoriesState extends State<BubbleStories> {
  String img = '';
  String displayName = '';
  String userName = '';

  void getProfileData() async {
    var profile = await FirebaseFirestore.instance
        .collection('users')
        .doc(widget.uid)
        .get();

    img = profile['image'];
    displayName = profile['name'];
    userName = profile['userName'];
    setState(() {});
  }

  @override
  void initState() {
    getProfileData();
    super.initState();
  }

  // final bool useNetworkImage;
  @override
  Widget build(BuildContext context) {
    if (widget.myStory == false) {
      return InkWell(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => StreamBuilder<List<StoryModel>>(
                      stream: context
                          .read<StoryDownloadProvider>()
                          .getFriendsStories(widget.uid),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<StoryModel> uset = snapshot.data;
                          UserModel beta = UserModel(
                                  uid: widget.uid,
                                  name: displayName,
                                  image: img,
                                  userName: userName)
                              .copyWith(stories: uset);
                          // if (DateTime.now()
                          //         .difference(
                          //             beta.stories[0].createdDate.toDate())
                          //         .inHours >
                          //     14) {
                          //   context
                          //       .read<StoryDownloadProvider>()
                          //       .delete(beta.stories[0]);
                          //
                          // }
                          return MoreStories(
                            uid: widget.uid,
                            docu: widget.docu,
                            user: beta,
                          );
                        }
                        return const Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      })));
        },
        child: Column(
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
                    child: img != null
                        ? CircleAvatar(
                            backgroundImage: NetworkImage(img),
                            radius: 30,
                          )
                        : const CircleAvatar(
                            child: Icon(
                              Icons.person,
                              color: secondaryColor,
                            ),
                          ),
                  )
                : const SizedBox(
                    width: 1,
                  ),
            Text(
              widget.hasStory ? displayName : ' ',
              style: const TextStyle(color: Colors.white, fontSize: 10),
            ),
          ],
        ),
      );
    } else {
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
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(img),
                    radius: 30,
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
    }
    return const SizedBox.shrink();
  }
}
