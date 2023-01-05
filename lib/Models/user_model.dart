import 'package:beepo/models/story_model/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:voster/models/story_model/story.dart';
import 'package:flutter/material.dart';

class UserModel {
  final String uid;
  final String name;
  final String image;
  final List searchKeywords;
  final String userName;

  const UserModel({
    @required this.uid,
    @required this.name,
    @required this.userName,
    @required this.image,

    @required this.searchKeywords,
  });

  UserModel copyWith({
    String uid,
    String name,
    String image,
    String userName,
    List searchKeywords, List<Story> stories,
  }) =>
      UserModel(
          uid: uid ?? this.uid,
          name: name ?? this.name,
          image: image ?? this.image,
        userName: userName ?? this.userName,
        searchKeywords: searchKeywords ?? this.searchKeywords,
      );
  factory UserModel.fromMap(Map<String, dynamic> snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      image: snapshot['image'],
      userName: snapshot['userName'],
      searchKeywords: snapshot['searchKeywords']
    );
  }

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'name': name,
    'image' : image,
    'userName' : userName,
    'searchKeywords' : searchKeywords,
  };

  factory UserModel.fromJson(Map<String, dynamic> json) => UserModel(
    uid: json['uid'],
    name: json['name'],
    userName: json['userName'],
    image: json['image'],
    searchKeywords: json['searchKeywords'],
  );

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      userName: snapshot['userName'],
      image: snapshot['image'],
      searchKeywords: snapshot['searchKeywords'],
    );
  }
}
