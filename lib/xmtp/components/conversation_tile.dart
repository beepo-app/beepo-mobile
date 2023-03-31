import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:xmtp/xmtp.dart';

import '../di/injection.dart';
import '../domain/repository/xmtp_repository.dart';
import '../screens/messages/messages_screen.dart';
import 'address_avatar.dart';
import 'address_chip.dart';

class ConversationTile extends StatefulWidget {
  const ConversationTile({
    Key key,
    @required this.conversation,
  }) : super(key: key);

  final Conversation conversation;

  @override
  State<ConversationTile> createState() => _ConversationTileState();
}

class _ConversationTileState extends State<ConversationTile> {
  DecodedMessage _lastMessage;

  final XmtpRepository _xmtpRepository = getIt();

  _getInitialLastMessage() async {
    var lastMessage = await _xmtpRepository.getLastMessage(widget.conversation);
    setState(() {
      _lastMessage = lastMessage;
    });
  }

  _listenLastMessage() {
    _xmtpRepository.streamMessages(widget.conversation).listen((message) {
      setState(() {
        _lastMessage = message;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    _getInitialLastMessage();
    _listenLastMessage();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AddressAvatar(address: widget.conversation.peer),
      title: Row(
        children: [
          AddressChip(
            address: widget.conversation.peer,
            me: widget.conversation.me,
          ),
        ],
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(
          _lastMessage?.sender == widget.conversation.me
              ? "You: ${_lastMessage?.content as String ?? ""}"
              : _lastMessage?.content as String ?? "",
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      horizontalTitleGap: 12,
      trailing: _lastMessage != null
          ? Text(DateFormat.jm().format(_lastMessage.sentAt))
          : null,
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return MessagesScreen(conversation: widget.conversation);
            },
          ),
        );
      },
    );
  }
}
