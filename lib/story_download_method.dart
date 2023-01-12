// import 'package:beepo/Models/story_model/story.dart';
import 'dart:io';

import 'package:beepo/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import 'Models/story_model/storyModel.dart';

class StoryDownloadMethod {
  Map userM = Hive.box('beepo').get('userData');

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  StoryDownloadMethod({
    @required FirebaseAuth auth,
    @required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  factory StoryDownloadMethod.initialize() => StoryDownloadMethod(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      );

  Stream<bool> currentUserHasStory() async* {
    final user = _auth.currentUser;
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection.where('uid', isEqualTo: user.uid);
    yield* stories.snapshots().map((snapshot) => snapshot.docs.isNotEmpty);
  }

  Stream<List<StoryModel>> getCurrentUserStories() async* {
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection
        .where('uid', isEqualTo: userM['uid'])
        .orderBy('createdDate');
    // final snapshot = stories.orderBy('createdDate', descending: true).snapshots();
    yield* stories.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
    // yield* storiesStream;
  }

  // Stream<List<UserModel>> getUsersInStories(FirebaseFirestore firestore) {
  //   CollectionReference usersRef = firestore.collection('users');
  //   CollectionReference storiesRef = firestore.collection('stories');
  //
  //   // Get a stream of the 'uid' field from the stories collection
  //   final storyUids = storiesRef.snapshots().map((snapshot) =>
  //       snapshot.docs.map((doc) => StoryModel.fromJson(doc.data()).uid).toList()
  //   );
  //
  //   // Use the 'uid' field to filter the users collection
  //   // final its =
  //   storyUids.map((uids) =>
  //       usersRef.where('uid', whereIn: uids)
  //   ).map((snapshot) => UserModel.fromJson(snapshot.docs)).toList();
  // }
  final CollectionReference usersRef = FirebaseFirestore.instance.collection('users');
  final CollectionReference storiesRef = FirebaseFirestore.instance.collection('stories');

  Stream<List<DocumentSnapshot>> getUsersInStories() {
    return storiesRef.snapshots().asyncMap((snapshot) {
      final List<String> uids = snapshot.docs.map((doc) => doc['uid']).toList();
      return usersRef.where('uid', whereIn: uids).get();
    }).map((snapshot) => snapshot.docs);
  }

  Stream<List<StoryModel>> getFriendsStories() async* {
    // final user = _auth.currentUser;
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection
        .where('uid', isNotEqualTo: userM['uid'])
        .orderBy('createdDate');
    // final snapshot = stories.orderBy('createdDate', descending: true).snapshots();
    yield* stories.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
    // yield* storiesStream;
  }

  // get stories of users that the current user is following
  Stream<List<UserModel>> getFollowingUsersStories() async* {
    getFollowingUsers().map((users) {
      final storiesCollection = _firestore.collection('stories');
      // return users with their stories
      final stories = storiesCollection.where('uid',
          whereIn: users.map((user) => user.uid).toList());
      users.map((user) async* {
        final userStories = stories.where('uid', isNotEqualTo: userM['uid']);
        final uStories = userStories.snapshots().map((snapshot) => snapshot.docs
            .map((doc) => StoryModel.fromJson(doc.data()))
            .toList());
        yield* uStories.map((stories) => user.copyWith(stories: stories));
      });
    });
  }

  Stream<List<UserModel>> getFollowingUsers() async* {
    // _getFollowingUsersId().map((followingUsersId) async* {
    final usersCollection = _firestore.collection('users');
    // final users = usersCollection.where('uid', isNotEqualTo: userM['uid']);
    yield* usersCollection.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
    // });
  }

  Stream<List<String>> _getFollowingUsersId() async* {
    final User user = _auth.currentUser;
    final followingCollection = _firestore.collection('following');
    final following =
        followingCollection.doc(user.uid).collection('userFollowing');
    yield* following
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
  }
}
