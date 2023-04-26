import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../../../Models/user_model.dart';
import '../../../../Utils/styles.dart';
import '.../../../Profile/user_profile_screen.dart';

class GroupBubbleChat extends StatelessWidget {
  final bool isMe;
  final String text;
  final Timestamp time;
  final UserModel user;
  final bool sameUser;

  const GroupBubbleChat({
    Key key,
    @required this.isMe,
    @required this.text,
    @required this.time,
    this.user,
    @required this.sameUser,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var day = time.toDate().day.toString();
    var month = time.toDate().month.toString();
    var year = time.toDate().toString().substring(2);
    var date = day + '-' + month + '-' + year;
    var hour = time.toDate().hour;
    var min = time.toDate().minute;

    String ampm = '';
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
      child: Row(
        crossAxisAlignment:
            !isMe ? CrossAxisAlignment.start : CrossAxisAlignment.center,
        mainAxisAlignment:
            isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (isMe)
            const SizedBox(
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
            const Padding(
              padding: EdgeInsets.only(right: 5),
              child: CircleAvatar(
                radius: 20,
                backgroundColor: Colors.white,
              ),
            ),
          const SizedBox(width: 4),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(12),
                  topRight: isMe
                      ? const Radius.circular(12)
                      : const Radius.circular(12),
                  bottomLeft: const Radius.circular(12),
                  bottomRight: const Radius.circular(12),
                ),
                color:
                    !isMe ? const Color(0xFFE6E9EE) : const Color(0xff0E014C),
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
                            style: const TextStyle(
                              color: secondaryColor,
                              fontFamily: 'SignikaNegative',
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const Spacer(),
                          Text(
                            '@${user.userName}',
                            style: const TextStyle(
                              color: secondaryColor,
                              fontFamily: '@Precious001',
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                  const SizedBox(height: 2),
                  RichText(
                    text: TextSpan(
                      text: text,
                      style: isMe
                          ? const TextStyle(
                              color: Colors.white,
                              fontSize: 11.5,
                            )
                          : const TextStyle(
                              color: Colors.black,
                              //Colors.black,
                              fontSize: 11.5,
                            ),
                    ),
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        hour.toString() + ":" + min.toString() + ampm,
                        style: isMe
                            ? const TextStyle(
                                color: Colors.white,
                                fontSize: 9,
                              )
                            : const TextStyle(
                                color: Colors.black,
                                fontSize: 9,
                              ),
                      ),
                      isMe
                          ? const SizedBox(width: 5)
                          : const SizedBox(
                              width: 0,
                            ),
                      isMe
                          ? const Icon(
                              Icons.done_all,
                              color: Colors.white,
                              size: 14,
                            )
                          : const SizedBox(
                              width: 0,
                            ),
                    ],
                  )
                ],
              ),
            ),
          ),
          if (!isMe)
            const SizedBox(
              width: 26,
            ),
        ],
      ),
    );
  }
}
