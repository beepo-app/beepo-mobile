import 'package:blockies_ethereum/blockie_widget.dart';
import 'package:blockies_ethereum/blockies_ethereum.dart';
import 'package:flutter/material.dart';
import 'package:web3dart/credentials.dart';

class AddressAvatar extends StatelessWidget {
  const AddressAvatar({Key key, this.address, this.radius = 20}) : super(key: key);

  final EthereumAddress address;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius,
      backgroundColor: Colors.white,
      child: BlockieWidget(
        data: address?.hexEip55 ?? "",
        size: radius * 0.035,
        shape: BlockiesShape.circle,
      ),
    );
  }
}
