import 'package:beepo/Service/xmtp.dart';
import 'package:flutter/material.dart';
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
