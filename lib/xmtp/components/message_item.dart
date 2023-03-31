import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web3dart/credentials.dart';
import 'package:xmtp/xmtp.dart';

import 'address_avatar.dart';
import 'address_chip.dart';

class MessageItem extends StatelessWidget {
  const MessageItem({
    Key key,
    @required this.message,
    this.me,
  }) : super(key: key);

  final DecodedMessage message;
  final EthereumAddress me;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AddressAvatar(address: message.sender),
      title: Row(children: [AddressChip(address: message.sender, me: me)]),
      horizontalTitleGap: 12,
      trailing: Text(DateFormat.jm().format(message.sentAt)),
      subtitle: Padding(
        padding: const EdgeInsets.only(left: 12.0),
        child: Text(message.content as String),
      ),
    );
  }
}
