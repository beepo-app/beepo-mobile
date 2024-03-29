// import 'package:beepo/Models/story_model/story.dart';

import 'package:beepo/Models/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hive/hive.dart';
import '../../Models/story_model/storyModel.dart';

class StoryDownloadMethod {
  Map userM = Hive.box('beepo').get('userData');

  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;

  StoryDownloadMethod({
    required FirebaseAuth auth,
    required FirebaseFirestore firestore,
  })  : _auth = auth,
        _firestore = firestore;

  factory StoryDownloadMethod.initialize() => StoryDownloadMethod(
        auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
      );

  Stream<bool> currentUserHasStory() async* {
    final user = _auth.currentUser;
    final storiesCollection = _firestore.collection('stories');
    final stories = storiesCollection.where('uid', isEqualTo: user!.uid);
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
    final User? user = _auth.currentUser;
    final followingCollection = _firestore.collection('following');
    final following =
        followingCollection.doc(user!.uid).collection('userFollowing');
    yield* following
        .snapshots()
        .map((snapshot) => snapshot.docs.map((e) => e.id).toList());
  }
}
