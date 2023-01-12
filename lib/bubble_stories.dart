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
        hasStory
            ? Container(
                margin: const EdgeInsets.only(right: 7.0, top: 10),
                padding: const EdgeInsets.all(2.0),
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                ),
                width: 60,
                height: 60,
                child: CircleAvatar(
                  backgroundImage: NetworkImage(image),
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
          hasStory ? text : ' ',
          style: const TextStyle(color: Colors.white, fontSize: 10),
        ),
      ],
    );
  }
}
