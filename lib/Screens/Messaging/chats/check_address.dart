import 'package:beepo/Service/xmtp.dart';
import 'package:beepo/Widgets/commons.dart';
import 'package:beepo/Widgets/components.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Widgets/toasts.dart';
import 'chat_address.dart';

class CheckAddress extends StatefulWidget {
  CheckAddress({Key key}) : super(key: key);

  @override
  State<CheckAddress> createState() => _CheckAddressState();
}

class _CheckAddressState extends State<CheckAddress> {
  final TextEditingController _addressController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
        'Check Address',
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                hintText: 'Enter ETH Address',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
            const SizedBox(height: 20),
            FilledButtons(
              onPressed: () async {
                if (_addressController.text.trim().isEmpty) {
                  showToast('Please enter an address');
                  return;
                }
                final convo =
                    await context.read<XMTPProvider>().newConversation(
                          _addressController.text.trim(),
                        );

                if (convo != null) {
                  Get.to(DmScreenAddress(
                    conversation: convo,
                  ));
                }
              },
              text: 'Chat with Address',
            ),
          ],
        ),
      ),
    );
  }
}
