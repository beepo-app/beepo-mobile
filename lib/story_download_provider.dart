import 'dart:async';

// import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/extensions.dart';
import 'package:beepo/story_download_method.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';

import 'Models/story_model/storyModel.dart';

class StoryDownloadProvider extends ChangeNotifier {
  final StoryDownloadMethod _storyMethod;

  StoryDownloadProvider({
    @required StoryDownloadMethod storyMethod,
  }) : _storyMethod = storyMethod;

  factory StoryDownloadProvider.initialize() => StoryDownloadProvider(
        storyMethod: StoryDownloadMethod.initialize(),
      );

  Stream<bool> currentUserHasStory() => _storyMethod.currentUserHasStory();

  // Map userM = Hive.box('beepo').get('userData');

  Stream<List<StoryModel>> getCurrentUserStories() =>
      _storyMethod.getCurrentUserStories();

  // Stream<List<StoryModel>> getFriendStories() =>
  //     _storyMethod.getFriendsStories();

  Stream<List<StoryModel>> getFriendsStories(String uid) async* {
    // final storiesCollection = _firestore.collection('stories');
    final stories = FirebaseFirestore.instance.collection('stories').where('uid', isEqualTo: uid);
    // final snapshot = stories.orderBy('createdDate', descending: true).snapshots();
    yield* stories.snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());
    // yield* storiesStream;
  }

  delete(StoryModel user) {
    final storiesCollection = FirebaseFirestore.instance.collection('stories');
    storiesCollection.doc(user.uid).delete();

    // final stories = storiesCollection
    //     .where('uid', isEqualTo: user.uid)
    //     .orderBy('createdDate');
    // final hhknd= stories.snapshots().map((snapshot) =>
    //     snapshot.docs.map((doc) => StoryModel.fromJson(doc.data())).toList());

    // for (final story in hhknd) {}
  }

  Stream<List<UserModel>> getFollowingUsersStories() =>
      _storyMethod.getFollowingUsersStories();

  Stream<List<UserModel>> getFollowingUsers() =>
      _storyMethod.getFollowingUsers();
// Stream<List<DocumentSnapshot>> getUsers() => _storyMethod.getUsersInStories();

}
