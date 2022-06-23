import 'package:beepo/bottom_nav.dart';
import 'package:beepo/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

class PhraseScreen extends StatelessWidget {
  final String phrase;
  const PhraseScreen({Key key, this.phrase}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Backup Phrase",
          style: TextStyle(
            color: Color(0xb20e014c),
            fontSize: 14,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              children: const [
                Icon(Icons.security, size: 20),
                SizedBox(width: 10),
                Text(
                  'Backup your key phrase to a safe place',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(15),
              ),
              padding: const EdgeInsets.only(
                top: 20,
                bottom: 30,
                left: 20,
                right: 20,
              ),
              child: Text(
                phrase,
                style: const TextStyle(
                  height: 2,
                  fontSize: 16,
                ),
              ),
            ),
            const SizedBox(height: 40),
            OutlnButton(
              text: "Copy",
              onPressed: () {
                Clipboard.setData(ClipboardData(text: phrase));
                Get.snackbar(
                  "Copied to clipboard",
                  "Your backup phrase has been copied to your clipboard",
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.green,
                  borderRadius: 15,
                  colorText: Colors.white,
                  margin: const EdgeInsets.all(20),
                );
              },
            ),
            const SizedBox(height: 20),
            FilledButton(
              text: 'Proceed',
              onPressed: () => Get.to(BottomNavHome()),
            )
          ],
        ),
      ),
    );
  }
}
