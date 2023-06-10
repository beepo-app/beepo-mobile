import 'package:beepo/Service/users.dart';
import 'package:beepo/Service/xmtp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Models/user_model.dart';
import '../../../Utils/styles.dart';
import 'chat_screen.dart';

class XMTPCoversationList extends StatelessWidget {
  const XMTPCoversationList({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Conversation>>(
      future: context.watch<XMTPProvider>().listConversations(),
      builder: (BuildContext context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        List<Conversation> conversations = snapshot.data;

        return ListView.builder(
          itemCount: conversations.length,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Conversation convo = conversations[index];
            return ChatListItem(convo: convo);
          },
        );
      },
    );
  }
}

class ChatListItem extends StatelessWidget {
  const ChatListItem({
    Key key,
    @required this.convo,
  }) : super(key: key);

  final Conversation convo;

  @override
  Widget build(BuildContext context) {
    print(convo.peer.hexEip55);
    return FutureBuilder<UserModel>(
      future: UsersService().getUserByAddress(convo.peer.hexEip55),
      builder: (ctx, user) {
        if (user.hasError) {
          return Text('data');
        }
        if (!user.hasData) {
          return LinearProgressIndicator();
        }

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: SizedBox(
            height: 40,
            width: 40,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(25),
              child: CachedNetworkImage(
                imageUrl: user.data.image,
                height: 40,
                width: 40,
                placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                  color: secondaryColor,
                )),
                errorWidget: (context, url, error) => Icon(
                  Icons.person,
                  color: secondaryColor,
                ),
              ),
            ),
          ),
          title: Text(user.data.name),
          // subtitle: Text(convo.peer.hex),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => DmScreen(
                  conversation: convo,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

class ChatMessageWidget extends StatelessWidget {
  final DecodedMessage message;
  final bool isMe;

  const ChatMessageWidget({Key key, this.message, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: !isMe ? const Color(0xFFE6E9EE) : const Color(0xff0E014C),
        ),
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.6,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
          vertical: 10,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              message.content,
              style: TextStyle(
                color: !isMe ? Colors.black : Colors.white,
              ),
            ),
            const SizedBox(height: 2),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  DateFormat("jm").format(message.sentAt),
                  style: TextStyle(
                    fontSize: 10,
                    color: !isMe ? Colors.black : Colors.white,
                  ),
                ),
                if (isMe)
                  const Padding(
                    padding: EdgeInsets.only(left: 5),
                    child: Icon(
                      Icons.done_all,
                      color: Colors.white,
                      size: 12,
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
