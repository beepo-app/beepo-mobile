import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class TransferSuccess extends StatefulWidget {
  final String address;
  const TransferSuccess(this.address);

  @override
  State<TransferSuccess> createState() => _TransferSuccessState();
}

class _TransferSuccessState extends State<TransferSuccess> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar('Transaction'),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Lottie.asset(
                'assets/lottie/lottie_success.json',
                height: 200,
                width: 300,
                fit: BoxFit.fitWidth,
              ),
              Text('Amount'),
              SizedBox(height: 5),
              Text('is on it’s way to:'),
              SizedBox(height: 10),
              Text(
                widget.address,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff0d004c),
                  fontSize: 18,
                ),
              ),
              SizedBox(height: 60),
              FilledButton(
                text: 'Done',
                onPressed: () => Get.close(2),
              )
            ],
          ),
        ),
      ),
    );
  }
}
