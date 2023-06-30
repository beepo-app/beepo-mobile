import 'package:beepo/Service/users.dart';
import 'package:beepo/Service/xmtp.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Models/user_model.dart';
import '../../../Utils/styles.dart';
import 'chat_address.dart';
import 'chat_screen.dart';

class XMTPCoversationList extends StatefulWidget {
  const XMTPCoversationList({Key key}) : super(key: key);

  @override
  State<XMTPCoversationList> createState() => _XMTPCoversationListState();
}

class _XMTPCoversationListState extends State<XMTPCoversationList> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<XMTPProvider>(context, listen: false).fetchConversations();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<XMTPProvider>(
      builder: (BuildContext context, XMTPProvider provider, _) {
        if (provider.isLoadingConversations) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }

        final convos = provider.conversations;
        if (convos.isEmpty) {
          return const Center(child: Text('No conversations yet'));
        }

        return FutureBuilder<List<DecodedMessage>>(
          future:
              context.watch<XMTPProvider>().mostRecentMessage(convo: convos),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            List<DecodedMessage> messages = snapshot.data;
            if (convos.isNotEmpty) {
              convos.sort((a, b) {
                // Compare the message time of conversations 'a' and 'b'
                DateTime timeA = messages
                    .firstWhereOrNull((element) => element.topic == a.topic)
                    ?.sentAt;
                DateTime timeB = messages
                    .firstWhereOrNull((element) => element.topic == b.topic)
                    ?.sentAt;

                if (timeA != null && timeB != null) {
                  return timeB.compareTo(timeA); // Sort in descending order
                } else if (timeA != null) {
                  return -1; // 'a' has a message, 'b' doesn't have
                } else if (timeB != null) {
                  return 1; // 'b' has a message, 'a' doesn't have
                } else {
                  return 0; // Both 'a' and 'b' don't have messages
                }
              });
            }
            return ListView.builder(
              itemCount: convos.length,
              shrinkWrap: true,
              padding: EdgeInsets.zero,
              physics: const NeverScrollableScrollPhysics(),
              itemBuilder: (context, index) {
                final convo = convos[index];

                DecodedMessage message = messages.firstWhereOrNull(
                    (element) => element.topic == convo.topic);
                return ChatListItem(convo: convo, message: message);
              },
            );
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
    @required this.message,
  }) : super(key: key);

  final Conversation convo;
  final DecodedMessage message;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<UserModel>(
      future: UsersService().getUserByAddress(convo.peer.hexEip55),
      builder: (ctx, user) {
        if (!user.hasData && !user.hasError) {
          return Shimmer.fromColors(
            baseColor: Colors.grey.shade300,
            highlightColor: Colors.grey.shade100,
            child: ListTile(
              leading: const CircleAvatar(),
              title: Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              subtitle: Container(
                height: 10,
                width: 100,
                color: Colors.white,
              ),
              contentPadding: EdgeInsets.zero,
            ),
          );
        }

        bool noBeepoAcct =
            user.hasError && user.error.toString() == 'No user found';

        return ListTile(
          contentPadding: EdgeInsets.zero,
          leading: noBeepoAcct
              ? CircleAvatar(
                  backgroundColor: Colors.grey,
                  child: Text(
                    convo.peer.hexEip55.substring(0, 2),
                    style: const TextStyle(color: Colors.white),
                  ),
                )
              : SizedBox(
                  height: 40,
                  width: 40,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(25),
                    child: CachedNetworkImage(
                      imageUrl: user.data.image,
                      height: 40,
                      width: 40,
                      placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(
                        color: secondaryColor,
                      )),
                      errorWidget: (context, url, error) => const Icon(
                        Icons.person,
                        color: secondaryColor,
                      ),
                    ),
                  ),
                ),
          title: Text(
            noBeepoAcct ? convo.peer.hexEip55 : user.data.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
          ),
          subtitle: message == null
              ? SizedBox()
              : Row(
                  children: [
                    Expanded(
                        child: Text(
                      message.content,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                    const SizedBox(width: 8),
                    Text(
                      DateFormat("jm").format(message.sentAt),
                      style: const TextStyle(
                        fontSize: 10,
                        color: Colors.grey,
                      ),
                    ),
                  ],
                ),
          onTap: () {
            if (noBeepoAcct) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DmScreenAddress(
                    conversation: convo,
                  ),
                ),
              );
            } else {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DmScreen(
                    conversation: convo,
                  ),
                ),
              );
            }
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

class TransferPreview extends StatelessWidget {
  final Map transfer;
  final bool isMe;
  const TransferPreview({Key key, this.transfer, this.isMe}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: GestureDetector(
        onTap: () {
          launchUrl(Uri.parse(transfer['url']));
        },
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            color: Colors.grey.withOpacity(.3),
          ),
          constraints: BoxConstraints(
            maxWidth: Get.width * .4, // Get.width * .4
          ),
          width: Get.width * .4,
          height: 100,
          padding: const EdgeInsets.all(10),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isMe ? Icons.arrow_upward : Icons.arrow_downward,
                    size: 20,
                    color: isMe ? Colors.red : Colors.green,
                  ),
                  const SizedBox(width: 5),
                  Text(
                    'You ${isMe ? 'sent' : 'received'}',
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Text(
                '${transfer['value']} BNB',
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: secondaryColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
