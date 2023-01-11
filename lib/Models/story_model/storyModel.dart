// import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/models/story_model/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:voster/models/story_model/story.dart';
import 'package:flutter/material.dart';

class StoryModel {
  final String url;
  final MediaType mediaType;
  final Duration duration;
  final DateTime createdDate;
  final int hoursAgo;
  final String path;
  final String caption;


  const StoryModel({
  this.url,
  @required this.mediaType,
  this.duration,
  this.createdDate,
  this.hoursAgo,
  this.path,
  this.caption,

  });

  // get stories => null;

  StoryModel copyWith({
     String url,
     MediaType mediaType,
     Duration duration,
     DateTime createdDate,
     int hoursAgo,
     String path,
     String caption,
  }) =>
      StoryModel(
        url: url ?? this.url,
        mediaType: mediaType ?? this.mediaType,
        duration: duration ?? this.duration,
        createdDate: createdDate ?? this.createdDate,
        hoursAgo: hoursAgo ?? this.hoursAgo,
        path: path ?? this.path,
        caption: caption ?? this.caption,
      );
  factory StoryModel.fromMap(Map<String, dynamic> snapshot) {
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
    );
  }

  Map<String, dynamic> toJson() => {
    'url': url,
    'mediaType': mediaType,
    'duration' : duration,
    'createdDate' : createdDate,
    'hoursAgo' : hoursAgo,
    'path' : path,
    'caption' : caption,
  };

  factory StoryModel.fromJson(Map<String, dynamic> snapshot) => StoryModel(
    url: snapshot['url'],
    mediaType: snapshot['mediaType'],
    duration: snapshot['duration'],
    createdDate: snapshot['createdDate'],
    hoursAgo: snapshot['hoursAgo'],
    path: snapshot['path'],
    caption: snapshot['caption'],
  );

  static StoryModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return StoryModel(
      url: snapshot['url'],
      mediaType: snapshot['mediaType'],
      duration: snapshot['duration'],
      createdDate: snapshot['createdDate'],
      hoursAgo: snapshot['hoursAgo'],
      path: snapshot['path'],
      caption: snapshot['caption'],
    );
  }
}
