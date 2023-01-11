
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class StoryModel {
  final String url;
  final String mediaType;
  // final Duration duration;
  final DateTime createdDate;
  final int hoursAgo;
  final String path;
  final String caption;
  final String uid;

  const StoryModel({
    this.url,
    @required this.mediaType,
    // this.duration = const Duration(seconds: 30),
    this.createdDate,
    this.hoursAgo = 0,
    this.path,
    this.caption,
    this.uid,
  });

  // get stories => null;

  StoryModel copyWith({
    String url,
    String uid,
    String mediaType,
    // Duration duration,
    DateTime createdDate,
    int hoursAgo,
    String path,
    String caption,
  }) =>
      StoryModel(
        url: url ?? this.url,
        mediaType: mediaType ?? this.mediaType,
        // duration: duration ?? this.duration,
        createdDate: createdDate ?? this.createdDate,
        hoursAgo: hoursAgo ?? this.hoursAgo,
        path: path ?? this.path,
        caption: caption ?? this.caption,
        uid: uid ?? this.uid,
      );

  factory StoryModel.fromMap(Map<String, dynamic> snapshot) {
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      // duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'mediaType': mediaType,
        // 'duration': duration,
        'createdDate': createdDate,
        'hoursAgo': hoursAgo,
        'path': path,
        'caption': caption,
        'uid': uid,
      };

  factory StoryModel.fromJson(Map<String, dynamic> snapshot) => StoryModel(
        url: snapshot['url'],
        mediaType: snapshot['mediaType'],
        // duration: snapshot['duration'],
        createdDate: snapshot['createdDate'],
        hoursAgo: snapshot['hoursAgo'],
        path: snapshot['path'],
        caption: snapshot['caption'],
        uid: snapshot['uid'],
      );

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      // duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
      uid: snapshot['uid'],
    );
  }
}

// enum MediaType {
//   @JsonValue('IMAGE')
//   image,
//   @JsonValue('VIDEO')
//   video,
// }