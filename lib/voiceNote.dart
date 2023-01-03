import 'dart:io';

import 'package:audioplayers/audioplayers.dart';
import 'package:beepo/Service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:record_mp3/record_mp3.dart';

class VoiceNote extends StatefulWidget {
  ScrollController scrollController;
  VoiceNote(this.scrollController);
  // const VoiceNote({Key? key}) : super(key: key);

  @override
  State<VoiceNote> createState() => _VoiceNoteState();
}

class _VoiceNoteState extends State<VoiceNote> {



  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
