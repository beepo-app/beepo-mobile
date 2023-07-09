// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:beepo/Models/story_model/story.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:beepo/Models/story_model/storyModel.dart';

class UserModel {
  final String? uid;
  final String? name;
  final String? image;
  final List? searchKeywords;
  final String? userName;
  final List<StoryModel>? stories;
  final String? firebaseToken;
  final String? hdWalletAddress;
  final String? bitcoinWalletAddress;

  const UserModel({
    this.uid,
    this.name,
    this.userName,
    this.image,
    this.searchKeywords,
    this.stories,
    this.firebaseToken,
    this.hdWalletAddress,
    this.bitcoinWalletAddress,
  });

  factory UserModel.fromMap(Map<String, dynamic> snapshot) {
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      image: snapshot['image'],
      userName: snapshot['userName'],
      searchKeywords: snapshot['searchKeywords'],
      stories: snapshot['stories'],
      hdWalletAddress: snapshot['hdWalletAddress'],
      bitcoinWalletAddress: snapshot['bitcoinWalletAddress'],
      firebaseToken: snapshot['firebaseToken'],
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'name': name,
        'image': image,
        'userName': userName,
        'searchKeywords': searchKeywords,
        'stories': stories,
        'hdWalletAddress': hdWalletAddress,
        'bitcoinWalletAddress': bitcoinWalletAddress,
        'firebaseToken': firebaseToken
      };

  factory UserModel.fromJson(Map<dynamic, dynamic>? json) => UserModel(
        uid: json!['uid'],
        name: json['name'],
        userName: json['userName'],
        image: json['image'],
        searchKeywords: json['searchKeywords'],
        stories: (json['stories'] as List)
            .map((e) => StoryModel.fromJson(e))
            .toList(),
        hdWalletAddress: json['hdWalletAddress'],
        bitcoinWalletAddress: json['bitcoinWalletAddress'],
        firebaseToken: 'firebaseToken',
      );

  static UserModel fromSnap(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;
    return UserModel(
      uid: snapshot['uid'],
      name: snapshot['name'],
      userName: snapshot['userName'],
      image: snapshot['image'],
      searchKeywords: snapshot['searchKeywords'],
      stories: snapshot['stories'],
      hdWalletAddress: snapshot['hdWalletAddress'],
      bitcoinWalletAddress: snapshot['bitcoinWalletAddress'],
      firebaseToken: snapshot['firebaseToken'],
    );
  }

  UserModel copyWith({
    String? uid,
    String? name,
    String? image,
    List? searchKeywords,
    String? userName,
    List<StoryModel>? stories,
    String? firebaseToken,
    String? hdWalletAddress,
    String? bitcoinWalletAddress,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      image: image ?? this.image,
      searchKeywords: searchKeywords ?? this.searchKeywords,
      userName: userName ?? this.userName,
      stories: stories ?? this.stories,
      firebaseToken: firebaseToken ?? this.firebaseToken,
      hdWalletAddress: hdWalletAddress ?? this.hdWalletAddress,
      bitcoinWalletAddress: bitcoinWalletAddress ?? this.bitcoinWalletAddress,
    );
  }
}
