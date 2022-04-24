import 'package:flutter/material.dart';

class Onboard extends StatelessWidget {
  final String image;
  final String text;
  Onboard({this.image, this.text, int value});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Image.asset(image),
        SizedBox(height: 18),
        Expanded(
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xff0e014c),
              fontSize: 14,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }
}
