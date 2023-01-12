import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// import 'package:flutter/cupertino.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

class StoryModel {
  final String url;
  final String mediaType;

  // final Duration duration;
  final Timestamp createdDate;

  // final int hoursAgo;
  final String path;
  final String caption;
  final String uid;
  final String name;
  final String profileImage;

  const StoryModel({
    this.url,
    @required this.mediaType,
    // this.duration = const Duration(seconds: 20),
    this.createdDate,
    // @Default(0) this.hoursAgo,
    this.path,
    @Default(' ') this.caption,
    @required this.uid,
    @required this.name,
    @required this.profileImage,
  });

  // get stories => null;

  StoryModel copyWith({
    String url,
    String uid,
    String mediaType,
    // Duration duration,
    Timestamp createdDate,
    // int hoursAgo,
    String path,
    String name,
    String profileImage,
    String caption,
  }) =>
      StoryModel(
        url: url ?? this.url,
        mediaType: mediaType ?? this.mediaType,
        // duration: duration ?? this.duration,
        createdDate: createdDate ?? this.createdDate,
        // hoursAgo: hoursAgo ?? this.hoursAgo,
        path: path ?? this.path,
        caption: caption ?? this.caption,
        uid: uid ?? this.uid,
        profileImage: profileImage ?? this.profileImage,
        name: name ?? this.profileImage,
      );

  factory StoryModel.fromMap(Map<String, dynamic> snapshot) {
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      // duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      // hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
      profileImage: snapshot['profileImage'],
      name: snapshot['name'],
      uid: snapshot['uid'],
    );
  }

  Map<String, dynamic> toJson() => {
        'url': url,
        'mediaType': mediaType,
        // 'duration': duration,
        'createdDate': createdDate,
        // 'hoursAgo': hoursAgo,
        'path': path,
        'caption': caption,
        'name': name,
        'profileImage': profileImage,
        'uid': uid,
      };

  factory StoryModel.fromJson(Map<String, dynamic> snapshot) => StoryModel(
        url: snapshot['url'],
        mediaType: snapshot['mediaType'],
        // duration: snapshot['duration'],
        createdDate: snapshot['createdDate'],
        // hoursAgo: snapshot['hoursAgo'],
        path: snapshot['path'],
        caption: snapshot['caption'],
        uid: snapshot['uid'],
        profileImage: snapshot['profileImage'],
        name: snapshot['name'],
      );

  static StoryModel fromSnap(AsyncSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      // duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      // hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
      profileImage: snapshot['profileImage'],
      name: snapshot['name'],
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
