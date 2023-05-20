import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Service/xmtp.dart';
import '../../../Utils/styles.dart';

class DmScreen extends StatefulWidget {
  final Conversation conversation;
  const DmScreen({Key key, this.conversation}) : super(key: key);

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  List<DecodedMessage> messages = [];
  Future<List<DecodedMessage>> getMessages;

  @override
  void initState() {
    super.initState();
    getMessages =
        context.read<XMTPProvider>().listMessages(convo: widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.peer.hex),
      ),
      body: FutureBuilder<List<DecodedMessage>>(
        future: getMessages,
        builder: (BuildContext context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          messages = snapshot.data;

          return StreamBuilder<DecodedMessage>(
            stream: context
                .read<XMTPProvider>()
                .streamMessages(convo: widget.conversation),
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                messages.insert(0, snapshot.data);
              }
              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      itemCount: messages.length,
                      shrinkWrap: true,
                      reverse: true,
                      itemBuilder: (context, index) {
                        DecodedMessage message = messages[index];
                        bool isMe = message.sender != widget.conversation.peer;
                        return ListTile(
                          title: Text(message.content),
                          subtitle: Text(
                              DateFormat.yMd().add_jm().format(message.sentAt)),
                        );
                      },
                    ),
                  ),
                  ChatControlsWidget(convo: widget.conversation),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

class ChatControlsWidget extends StatefulWidget {
  const ChatControlsWidget({
    Key key,
    this.convo,
  }) : super(key: key);

  final Conversation convo;

  @override
  State<ChatControlsWidget> createState() => _ChatControlsWidgetState();
}

class _ChatControlsWidgetState extends State<ChatControlsWidget> {
  final TextEditingController messageController = TextEditingController();

  @override
  void initState() {
    super.initState();
    messageController.addListener(() {
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                TextField(
                  style: const TextStyle(fontSize: 16),
                  controller: messageController,
                  decoration: InputDecoration(
                    fillColor: const Color(0xFFE6E9EE),
                    hintText: 'Type a message',
                    isDense: false,
                    hintStyle:
                        const TextStyle(color: Color(0xff697077), fontSize: 15),
                    prefixIcon: GestureDetector(
                      onTap: () {
                        // setState(() {
                        //   isTyping = !isTyping;
                        // });
                      },
                      child: IconButton(
                          onPressed: () {
                            // context
                            //     .read<ChatNotifier>()
                            //     .cameraUploadImageChat(widget.model.uid);
                          },
                          constraints: const BoxConstraints(
                            maxWidth: 30,
                          ),
                          icon: SvgPicture.asset('assets/camera.svg')),
                    ),
                    suffixIcon: FittedBox(
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: const Icon(
                              Iconsax.dollar_circle,
                              size: 21,
                              color: secondaryColor,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              // context
                              //     .read<ChatNotifier>()
                              //     .pickUploadImageChat(
                              //         widget.model.uid, context);
                            },
                            constraints: const BoxConstraints(
                              maxWidth: 30,
                            ),
                            icon: const Icon(
                              Iconsax.gallery,
                              size: 20,
                              color: secondaryColor,
                            ),
                          ),
                          const SizedBox(width: 8),
                        ],
                      ),
                    ),
                    filled: true,
                    enabledBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      // borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                  // expands: true,
                  keyboardType: TextInputType.multiline,
                  minLines: 1,
                  maxLines: 5,
                ),
              ],
            ),
          ),
          messageController.text.isEmpty
              ? IconButton(
                  onPressed: () {
                    // showModalBottomSheet(
                    //     shape: const OutlineInputBorder(
                    //         borderSide: BorderSide.none,
                    //         borderRadius: BorderRadius.only(
                    //             topLeft: Radius.circular(20),
                    //             topRight: Radius.circular(20))),
                    //     context: context,
                    //     builder: (ctx) => CustomVoiceRecorderWidget(
                    //           isGroupChat: false,
                    //           receiverId: widget.model.uid,
                    //         ));
                  },
                  icon: SvgPicture.asset(
                    'assets/microphone.svg',
                    width: 27,
                    height: 27,
                  ))
              : IconButton(
                  onPressed: () async {
                    context.read<XMTPProvider>().sendMessage(
                        convo: widget.convo, content: messageController.text);
                    messageController.clear();

                    // // var status = await OneSignal.shared.getDeviceState();
                    // //
                    // // var playerId = status.userId;
                    // await OneSignal.shared
                    //     .postNotification(OSCreateNotification(
                    //   playerIds: [player],
                    //   content: context.read<ChatNotifier>().chatText,
                    //   heading: 'Beepo',
                    //   subtitle: userM['displayName'],
                    //   sendAfter: DateTime.now(),
                    //   buttons: [
                    //     OSActionButton(text: "test1", id: "id1"),
                    //     OSActionButton(text: "test2", id: "id2"),
                    //   ],
                    //   androidSound:
                    //       'assets/mixkit-interface-hint-notification-911.wav',
                    //   androidSmallIcon: 'assets/beepo_img.png',
                    //
                    // )
                    // );
                    // context.read<ChatNotifier>().clearText();

                    // setState(() {
                    //   isReplying = false;
                    //   replyMessage = '';
                    // });
                    // EncryptData.encryptFernet(context.read<ChatNotifier>().chatText);
                    // OneSignal.shared.
                  },
                  icon: const Icon(
                    Icons.send,
                    color: secondaryColor,
                  ),
                ),
          const SizedBox(width: 10)
        ],
      ),
    );
  }
}
