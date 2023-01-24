// ignore_for_file: prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';

import 'package:quick_notify/quick_notify.dart';


class Note extends StatefulWidget {
  const Note({Key key}) : super(key: key);

  @override
  _NoteState createState() => _NoteState();
}

class _NoteState extends State<Note> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  child: Text('hasPermission'),
                  onPressed: () async {
                    var hasPermission = await QuickNotify.hasPermission();
                    print('hasPermission $hasPermission');
                  },
                ),
                ElevatedButton(
                  child: Text('requestPermission'),
                  onPressed: () async {
                    var requestPermission = await QuickNotify.requestPermission();
                    print('requestPermission $requestPermission');
                  },
                ),
              ],
            ),
            ElevatedButton(
              child: Text('notify'),
              onPressed: () {
                QuickNotify.notify(
                  title: 'My title',
                  content: 'My content',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}