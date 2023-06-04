import 'dart:io';

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Utils/extensions.dart';
import 'package:beepo/response.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

import '../../Models/story_model/storyModel.dart';

class StoryUploadMethod {
  final FirebaseAuth _auth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  StoryUploadMethod({
    @required FirebaseAuth auth,
    @required FirebaseFirestore firestore,
    @required FirebaseStorage storage,
  })  : _auth = auth,
        _firestore = firestore,
        _storage = storage;

  factory StoryUploadMethod.initialize() => StoryUploadMethod(
        // auth: FirebaseAuth.instance,
        firestore: FirebaseFirestore.instance,
        storage: FirebaseStorage.instance,
      );
  Map userM = Hive.box('beepo').get('userData');

  Future<Either<Failure, Success>> uploadStory({
    @required StoryModel story,
    @required File file,
    @required String uid,
    String caption,
    // @required String friendId,
  }) async {
    try {
      // final user = _auth.currentUser;
      final storiesCollection = _firestore.collection('usersStories');

      final usersWithStoriesCollection = _firestore.collection('stories');

      // Get media url
      final mediaUrl = await _uploadMediaToStorage(file);
      return mediaUrl.fold(
        (failure) async => left(failure),
        (metadata) async {
          // Upload story to firestore
          final storyData = story
              .copyWith(
                url: metadata.url,
                createdDate: Timestamp.now(),
                path: metadata.path,
                caption: caption,
              )
              .toJson();
          await storiesCollection.doc(userM['uid']).set(storyData);
          await usersWithStoriesCollection.add(storyData);
          // .toJson());
          return right(const Success());
        },
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, _MediaMetaData>> _uploadMediaToStorage(
      File file) async {
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
      return fileUrl.fold(
        (failure) async {
          // Delete the file from storage if there is an error retrieving download url
          await _deleteFileFromStorage(storageRef);
          return left(failure);
        },
        (success) {
          final metadata = _MediaMetaData(
            url: success.data,
            path: storageRef.fullPath,
          );
          'MetaData pata: ${metadata.path}'.log();
          return right(metadata);
        },
      );
    } on FirebaseException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Success<String>>> _getDownloadUrl(
      Reference ref) async {
    try {
      final url = await ref.getDownloadURL();
      return right(Success(url));
    } on FirebaseException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Success>> _deleteFileFromStorage(Reference ref) async {
    try {
      await ref.delete();
      return right(const Success());
    } on FirebaseException catch (e) {
      return left(Failure(e.message));
    }
  }
}

class _MediaMetaData {
  final String url;
  final String path;

  const _MediaMetaData({
    @required this.url,
    @required this.path,
  });
}
