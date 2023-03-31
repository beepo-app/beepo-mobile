import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:xmtp/xmtp.dart';

import '../../components/address_avatar.dart';
import '../../components/message_item.dart';
import '../../data/local/messages_store.dart';
import '../../di/injection.dart';
import '../../domain/repository/xmtp_repository.dart';
import '../../utils/abbreviate.dart';

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    Key key,
    @required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  final TextEditingController _editingController = TextEditingController();
  StreamSubscription<DecodedMessage> _subscription;
  bool isLoading = false;

  final XmtpRepository _xmtpRepository = getIt();

  _loadMessages() async {
    setState(() {
      isLoading = true;
    });
    var existingMessages = await _xmtpRepository.getMessages(widget.conversation);
    store.setMessages(existingMessages);
    setState(() {
      isLoading = false;
    });
  }

  _listenForNewMessages() {
    _subscription = _xmtpRepository.streamMessages(widget.conversation).listen(
      (newMessage) {
        store.addMessage(newMessage);
      },
    );
  }

  _sendMessage(String message) async {
    await _xmtpRepository.sendMessage(widget.conversation, message);
    _editingController.clear();
  }

  @override
  void initState() {
    super.initState();
    _loadMessages();
    _listenForNewMessages();
  }

  @override
  void dispose() {
    super.dispose();
    store.setMessages([]);
    _subscription?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(abbreviate(widget.conversation.peer.hexEip55)),
        titleTextStyle: Theme.of(context).textTheme.bodyMedium,
        centerTitle: false,
        leadingWidth: 80,
        leading: Row(
          children: [
            IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(CupertinoIcons.back),
            ),
            AddressAvatar(
              radius: 15.0,
              address: widget.conversation.peer,
            )
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: isLoading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Observer(
                      builder: (context) {
                        return ListView.builder(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          itemCount: store.messages.length,
                          shrinkWrap: true,
                          reverse: true,
                          itemBuilder: (context, index) {
                            var message = store.messages[index];
                            return MessageItem(
                              message: message,
                              me: widget.conversation.me,
                            );
                          },
                        );
                      },
                    ),
            ),
            const Divider(height: 1),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _editingController,
                      decoration: InputDecoration(
                        hintText: "Type message...",
                        suffixIcon: IconButton(
                          onPressed: () {
                            _sendMessage(_editingController.text);
                          },
                          icon: Icon(
                            CupertinoIcons.arrow_up_circle_fill,
                            size: 32,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ),
                        border: InputBorder.none,
                      ),
                      onSubmitted: _sendMessage,
                      minLines: 1,
                      maxLines: 6,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
