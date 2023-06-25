import 'dart:convert';
import 'dart:developer';

import 'package:beepo/Service/users.dart';
import 'package:beepo/Utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Models/user_model.dart';
import '../../../Models/wallet.dart';
import '../../../Service/auth.dart';
import '../../../Service/wallets.dart';
import '../../../Service/xmtp.dart';
import '../../../Utils/styles.dart';
import '../../../Widgets/components.dart';
import '../../../Widgets/toasts.dart';
import '../../Profile/user_profile_screen.dart';
import '../../Wallet/preview_transfer.dart';
import 'widgets.dart';

class DmScreen extends StatefulWidget {
  final Conversation conversation;
  const DmScreen({Key key, this.conversation}) : super(key: key);

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  List<DecodedMessage> messages = [];
  Future<List<DecodedMessage>> getMessages;
  UserModel user;
  Future<UserModel> getUserDetails;

  @override
  void initState() {
    super.initState();
    getUserDetails =
        UsersService().getUserByAddress(widget.conversation.peer.hexEip55);
    getMessages =
        context.read<XMTPProvider>().listMessages(convo: widget.conversation);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<UserModel>(
        future: getUserDetails,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          user = snap.data;
          return Scaffold(
            appBar: AppBar(
              leadingWidth: 40,
              title: Row(
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => UserProfile(
                            model: user,
                          ),
                        ),
                      );
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(19),
                      child: SizedBox(
                        height: 35,
                        width: 35,
                        child: CachedNetworkImage(
                          height: 35,
                          width: 35,
                          imageUrl: user.image,
                          errorWidget: (context, url, error) => Container(
                            color: Colors.white,
                            child: Icon(
                              Icons.person,
                              color: secondaryColor,
                            ),
                          ),
                          filterQuality: FilterQuality.high,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        user.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        "@" + user.userName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              backgroundColor: secondaryColor,
              elevation: 0,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
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
                          child: GroupedListView(
                            elements: messages.reversed.toList(),
                            padding: const EdgeInsets.symmetric(horizontal: 16),
                            groupBy: (DecodedMessage element) {
                              return DateFormat('yMMMMd')
                                  .format(element.sentAt);
                            },
                            physics: const AlwaysScrollableScrollPhysics(
                                parent: BouncingScrollPhysics()),
                            groupSeparatorBuilder: (String groupByValue) {
                              return SizedBox(
                                height: 40,
                                child: Align(
                                  child: Container(
                                    padding: const EdgeInsets.all(8.0),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(7),
                                      color: secondaryColor,
                                    ),
                                    child: Text(
                                      groupByValue,
                                      textAlign: TextAlign.center,
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            },
                            floatingHeader: true,
                            reverse: true,
                            useStickyGroupSeparators: true,
                            itemBuilder: (context, DecodedMessage msg) {
                              bool isMe =
                                  msg.sender != widget.conversation.peer;

                              print(msg.content.toString().isJSON);

                              bool isTransfer = msg.content.toString().isJSON;

                              if (isTransfer) {
                                final transfer =
                                    jsonDecode(msg.content.toString());

                                return TransferPreview(
                                  transfer: transfer,
                                  isMe: isMe,
                                );
                              }

                              return ChatMessageWidget(
                                message: msg,
                                isMe: isMe,
                              );
                            },
                            separator: const SizedBox(height: 10),
                            order: GroupedListOrder.DESC,
                          ),
                        ),
                        ChatControlsWidget(
                          convo: widget.conversation,
                          user: user,
                        ),
                      ],
                    );
                  },
                );
              },
            ),
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
    this.user,
  }) : super(key: key);

  final Conversation convo;
  final UserModel user;

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

  void sendToken(Wallet wallet) {
    final amount = TextEditingController();
    Get.dialog(
      Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Send ${wallet.ticker}",
                style: TextStyle(
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 20),
              TextField(
                controller: amount,
                keyboardType: TextInputType.number,
                style: TextStyle(
                  color: Color(0xff0d004c),
                  fontSize: 18,
                ),
                decoration: InputDecoration(
                  isDense: true,
                  hintText: "Amount",
                  suffixText: wallet.ticker ?? " ",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1,
                      )),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15)),
                    borderSide: BorderSide(width: 1, color: Colors.grey),
                  ),
                ),
              ),
              SizedBox(height: 20),
              FilledButtons(
                color: secondaryColor,
                text: "Continue",
                onPressed: () {
                  if (amount.text.isEmpty) {
                    showToast('Please enter amount');
                  } else {
                    Get.back();
                    Get.off(
                      ConfirmTransfer(
                        wallet: wallet,
                        amount: double.parse(amount.text),
                        address: wallet.ticker == "BITCOIN"
                            ? widget.user.bitcoinWalletAddress
                            : widget.user.hdWalletAddress,
                        convo: widget.convo,
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
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
                            onPressed: () {
                              Get.bottomSheet(
                                BottomSheet(
                                  onClosing: () {},
                                  enableDrag: false,
                                  shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                  ),
                                  builder: (ctx) {
                                    return FutureBuilder<Object>(
                                      future: WalletsService().getWallets(),
                                      builder: (context, snapshot) {
                                        if (!snapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }

                                        List<Wallet> wallets = snapshot.data;
                                        return Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                "Send Token to ${widget.user.name}",
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w600,
                                                ),
                                              ),
                                              SizedBox(height: 10),
                                              Expanded(
                                                child: ListView.builder(
                                                  shrinkWrap: true,
                                                  itemCount: wallets.length,
                                                  itemBuilder:
                                                      (context, index) {
                                                    Wallet wallet =
                                                        wallets[index];
                                                    return Container(
                                                      width: double.infinity,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15),
                                                        color:
                                                            Color(0xFFE2E2E2),
                                                      ),
                                                      margin: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 8,
                                                        vertical: 5,
                                                      ),
                                                      child: ListTile(
                                                        dense: true,
                                                        onTap: () {
                                                          sendToken(wallet);
                                                        },
                                                        leading: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(17),
                                                          child:
                                                              CachedNetworkImage(
                                                            imageUrl:
                                                                wallet.logoUrl,
                                                            height: 34,
                                                            width: 34,
                                                            fit: BoxFit.cover,
                                                          ),
                                                        ),
                                                        title: Text(
                                                          wallet.name,
                                                        ),
                                                        subtitle: Text(
                                                          wallet.ticker,
                                                        ),
                                                      ),
                                                    );
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                    );
                                  },
                                ),
                              );
                            },
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
          // messageController.text.isEmpty
          //     ? IconButton(
          //         onPressed: () {
          //           // showModalBottomSheet(
          //           //     shape: const OutlineInputBorder(
          //           //         borderSide: BorderSide.none,
          //           //         borderRadius: BorderRadius.only(
          //           //             topLeft: Radius.circular(20),
          //           //             topRight: Radius.circular(20))),
          //           //     context: context,
          //           //     builder: (ctx) => CustomVoiceRecorderWidget(
          //           //           isGroupChat: false,
          //           //           receiverId: widget.model.uid,
          //           //         ));
          //         },
          //         icon: SvgPicture.asset(
          //           'assets/microphone.svg',
          //           width: 27,
          //           height: 27,
          //         ))
          //     :
          IconButton(
            onPressed: () async {
              if (messageController.text.isEmpty) {
                return;
              }
              context.read<XMTPProvider>().sendMessage(
                    convo: widget.convo,
                    content: messageController.text,
                  );
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
