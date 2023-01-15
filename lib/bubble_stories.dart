import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BubbleStories extends StatefulWidget {
  const BubbleStories({
    Key key,
    this.uid,
    this.docu,
    this.hasStory = true,
    // this.useNetworkImage = false,
  }) : super(key: key);

  final bool hasStory;
  final String uid;
  final List docu;

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
                  // child: CachedNetworkImage(
                  //   imageUrl: image,
                  //   fit: BoxFit.fill,
                  // ),
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
}
