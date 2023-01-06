import 'package:beepo/Service/auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:flutter/material.dart';

class StoryDownloadMethod {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  const StoryDownloadMethod({
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

  Stream<List<Story>> getCurrentUserStories() async* {
    // final user = _auth.currentUser;
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection.where('uid', isEqualTo: AuthService().uid);
    // final snapshot = stories.orderBy('createdDate', descending: true).snapshots();
    yield* stories.snapshots().map((snapshot) => snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());
    // yield* storiesStream;
  }

  Stream<List<Story>> getFriendsStories() async* {
    // final user = _auth.currentUser;
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection.where('uid', isNotEqualTo: AuthService().uid);
    // final snapshot = stories.orderBy('createdDate', descending: true).snapshots();
    yield* stories.snapshots().map((snapshot) => snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());
    // yield* storiesStream;
  }

  // get stories of users that the current user is following
  Stream<List<UserModel>> getFollowingUsersStories() async* {
    _getFollowingUsers().map((users) async* {
      final storiesCollection = _firestore.collection('stories');
      final stories = storiesCollection.where('uid', whereIn: users.map((user) => user.uid).toList());
      // return users with their stories
      users.map((user) async* {
        final userStories = stories.where('uid', isEqualTo: user.uid);
        final uStories = userStories.snapshots().map((snapshot) => snapshot.docs.map((doc) => Story.fromJson(doc.data())).toList());
        yield* uStories.map((stories) => user.copyWith(stories: stories));
      });
    });
  }

  Stream<List<UserModel>> _getFollowingUsers() async* {
    // _getFollowingUsersId().map((followingUsersId) async* {
      final usersCollection = _firestore.collection('users');
      final users = usersCollection.where('uid', isNotEqualTo: AuthService().uid);
      yield* users.snapshots().map((snapshot) => snapshot.docs.map((doc) => UserModel.fromJson(doc.data())).toList());
    // });
  }

  Stream<List<String>> _getFollowingUsersId() async* {
    final User user = _auth.currentUser;
    final followingCollection = _firestore.collection('following');
    final following = followingCollection.doc(user.uid).collection('userFollowing');
    yield* following.snapshots().map((snapshot) => snapshot.docs.map((e) => e.id).toList());
  }
}
