import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

import '../utils/abbreviate.dart';

class AddressChip extends StatelessWidget {
  const AddressChip({Key key, this.address, this.me}) : super(key: key);

  final EthereumAddress address;
  final EthereumAddress me;

  @override
  Widget build(BuildContext context) {
    return Chip(
      labelStyle: TextStyle(color: address == me ? Colors.deepPurple : null),
      backgroundColor: address == me ? Colors.deepPurple[50] : null,
      label: Text(abbreviate(address?.hexEip55 ?? "")),
    );
  }
}
