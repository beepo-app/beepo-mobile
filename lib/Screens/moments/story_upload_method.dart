import 'dart:io';
import 'package:beepo/Utils/extensions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:hive/hive.dart';
import '../../Models/story_model/storyModel.dart';

class StoryUploadMethod {
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  StoryUploadMethod({
    required FirebaseFirestore firestore,
    required FirebaseStorage storage,
  })  : _firestore = firestore,
        _storage = storage;

  factory StoryUploadMethod.initialize() => StoryUploadMethod(
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
      );
  Map userM = Hive.box('beepo').get('userData');

  Future<void> uploadStory({
    required StoryModel story,
    required File file,
    required String uid,
    String? caption,
    // @required String friendId,
  }) async {
    try {
      // final user = _auth.currentUser;
      final storiesCollection = _firestore.collection('usersStories');

      final usersWithStoriesCollection = _firestore.collection('stories');

      // Get media url
      final mediaUrl = await _uploadMediaToStorage(file);

      final storyData = story
          .copyWith(
            url: mediaUrl.url,
            createdDate: Timestamp.now(),
            path: mediaUrl.path,
            caption: caption,
          )
          .toJson();
      await storiesCollection.doc(userM['uid']).set(storyData);
      await usersWithStoriesCollection.add(storyData);
      // .toJson());
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<_MediaMetaData> _uploadMediaToStorage(File file) async {
    try {
      // final user = _auth.currentUser;
      // Creates a reference to where the file will be stored
      final storageRef = _storage
          .ref()
          .child('stories/${userM['uid']}/${file.path.split('/').last}');
      // Uploads the file to firebase storage
      await storageRef.putFile(file);

      // Get the file url
      final fileUrl = await _getDownloadUrl(storageRef);

      // Delete the file from storage if there is an error retrieving download url
      await _deleteFileFromStorage(storageRef);

      final metadata = _MediaMetaData(
        url: fileUrl,
        path: storageRef.fullPath,
      );
      'MetaData pata: ${metadata.path}'.log();
      return metadata;
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<String> _getDownloadUrl(Reference ref) async {
    try {
      final url = await ref.getDownloadURL();
      return url;
    } on FirebaseException catch (_) {
      rethrow;
    }
  }

  Future<void> _deleteFileFromStorage(Reference ref) async {
    try {
      await ref.delete();
    } on FirebaseException catch (_) {
      rethrow;
    }
  }
}

class _MediaMetaData {
  final String url;
  final String path;

  const _MediaMetaData({
    required this.url,
    required this.path,
  });
}
