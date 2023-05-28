import 'package:beepo/Service/xmtp.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

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
          physics: const NeverScrollableScrollPhysics(),
          itemBuilder: (context, index) {
            Conversation convo = conversations[index];
            return ListTile(
              title: Text(convo.peer.hex),
              subtitle: Text(convo.topic),
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
          color: !isMe ? Color(0xFFE6E9EE) : Color(0xff0E014C),
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
