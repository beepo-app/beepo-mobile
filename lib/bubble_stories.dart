import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
// import 'package:voster/screens/social/my_widgets/profile_picture.dart';
import 'package:beepo/sizing.dart';
import 'package:beepo/constants.dart';
import 'package:beepo/text_styles.dart';

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
          margin: const EdgeInsets.only(right: 7.0),
          padding: const EdgeInsets.all(2.0),
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            gradient: hasStory ? AppColors.pinkTextGradient : null,
            shape: BoxShape.circle,
          ),
          child: CachedNetworkImage(imageUrl: image,)
        ),
        Text(
          hasStory? text : ' ',
          style: kstoryTextStyle,
        ),
      ],
    );
  }
}
