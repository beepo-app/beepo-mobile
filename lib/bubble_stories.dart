import 'package:beepo/text_styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class BubbleStories extends StatelessWidget {
  const BubbleStories({
    Key key,
    @required this.text,
    @required this.image,
    this.hasStory = true,
    // this.useNetworkImage = false,
  }) : super(key: key);

  final String text;
  final String image;
  final bool hasStory;

  // final bool useNetworkImage;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            margin: const EdgeInsets.only(right: 7.0, top: 10),
            padding: const EdgeInsets.all(2.0),
            // width: 60,
            // height: 60,
            child: CircleAvatar(
              child: CachedNetworkImage(
                imageUrl: image,
                fit: BoxFit.cover,
              ),
              radius: 30,
            )),
        Text(
          hasStory ? text : ' ',
          style: kstoryTextStyle,
        ),
      ],
    );
  }
}
