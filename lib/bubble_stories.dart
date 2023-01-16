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
    this.index,
    // this.useNetworkImage = false,
  }) : super(key: key);

  final bool hasStory;
  final String uid;
  final List docu;
  final bool myStory;
  final int index;

  @override
  State<BubbleStories> createState() => _BubbleStoriesState();
}

class _BubbleStoriesState extends State<BubbleStories> {
  String img = '';
  String displayName = '';
  String userName = '';

  void getPage() async {
    for (final page in widget.docu) {
      pages.add(StreamBuilder<List<StoryModel>>(
          stream: context
              .read<StoryDownloadProvider>()
              .getFriendsStories(page['uid']),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<StoryModel> uset = snapshot.data;
              UserModel beta = UserModel(
                      uid: page['uid'],
                      name: page['name'],
                      image: page['profileImage'],
                      // userName: userName,
              )
                  .copyWith(stories: uset);
              return MoreStories(
                uid: page['uid'],
                docu: widget.docu,
                user: beta,
              );
            }
            return const Center(
              child: CircularProgressIndicator(
                color: primaryColor,
              ),
            );
          }));
    }
  }

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

  List<Widget> pages = [];

  // getPages() {
  //
  // }

  PageController pageController;

  @override
  void initState() {
    getPage();
    getProfileData();
    super.initState();
  }

  int selectedIndex = 0;

  // final bool useNetworkImage;
  @override
  Widget build(BuildContext context) {
    if (widget.myStory == false) {
      return InkWell(

        onTap: () {
          setState(() {
            pageController = PageController(initialPage: widget.index);
          });
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PageView.builder(
                        itemBuilder: (context, index) {

                          print('number of pages ${pages.length}');

                          return pages[index];
                        },
                        itemCount: pages.length,
                        controller: pageController,

                        onPageChanged: (bit) {
                          // setState(() {
                          //   selectedIndex = selectedIndex + 1;
                          // });
                          // pageController.animateToPage(
                          //     pageController.page.toInt() + 1,
                          //     duration: Duration(microseconds: 300),
                          //     curve: Curves.easeIn);
                        },
                      )));

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
                    child: CircleAvatar(
                      backgroundImage: NetworkImage(img),
                      radius: 30,
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
            widget.hasStory ? displayName : ' ',
            style: const TextStyle(color: Colors.white, fontSize: 10),
          ),
        ],
      );
    }
    return const SizedBox.shrink();
  }
}
