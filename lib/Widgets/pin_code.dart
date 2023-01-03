import 'package:beepo/Utils/styles.dart';
import 'package:flutter/material.dart';

class NumberKeyboard extends StatelessWidget {
  final Function(int) onPressed;

  const NumberKeyboard({Key key, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
      child: Column(
        children: [
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NumberKey(number: 1, onPressed: onPressed),
                _NumberKey(number: 2, onPressed: onPressed),
                _NumberKey(number: 3, onPressed: onPressed),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NumberKey(number: 4, onPressed: onPressed),
                _NumberKey(number: 5, onPressed: onPressed),
                _NumberKey(number: 6, onPressed: onPressed),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _NumberKey(number: 7, onPressed: onPressed),
                _NumberKey(number: 8, onPressed: onPressed),
                _NumberKey(number: 9, onPressed: onPressed),
              ],
            ),
          ),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(width: 38),
                _NumberKey(number: 0, onPressed: onPressed),
                _NumberKey(number: -1, onPressed: onPressed),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _NumberKey extends StatelessWidget {
  final int number;
  final void Function(int) onPressed;

  const _NumberKey({Key key, this.number, this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onPressed(number);
      },
      child: Container(
        decoration: BoxDecoration(
          color: secondaryColor,
          shape: BoxShape.circle,
        ),
        padding: EdgeInsets.all(14),
        alignment: Alignment.center,
        child: number == -1
            ? Icon(
                Icons.cancel_sharp,
                color: Colors.white,
                size: 14,
              )
            : Text(
                '$number',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
      ),
    );
  }
}
