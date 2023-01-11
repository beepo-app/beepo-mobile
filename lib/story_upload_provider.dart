import 'dart:io';
import 'dart:typed_data';
import 'package:beepo/Service/auth.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:beepo/response.dart';
import 'package:beepo/models/story_model/story.dart';
import 'package:beepo/story_upload_method.dart';
import 'package:beepo/extensions.dart';

enum StoryUploadStatus {
  initial,
  gettingReady,
  uploading,
  success,
  failure,
}

//TODO: Seperate media selection from upload
//? Movie media selection to a separate class
class StoryUploadProvider extends ChangeNotifier {
  final StoryUploadMethod _storyMethod;
  // final FirebaseAuth _firebaseAuth;
  final ImagePicker _imagePicker;
  StoryUploadProvider({
    @required StoryUploadMethod storyMethod,
    // @required FirebaseAuth firebaseAuth,
    @required ImagePicker imagePicker,
  })  : _storyMethod = storyMethod,
        // _firebaseAuth = firebaseAuth,
        _imagePicker = imagePicker;

  factory StoryUploadProvider.initialize() => StoryUploadProvider(
        storyMethod: StoryUploadMethod.initialize(),
        // firebaseAuth: FirebaseAuth.instance,
        imagePicker: ImagePicker(),
      );

  File _file;
  File get file => _file;

  Story _story;
  Map userM = Hive.box('beepo').get('userData');


  StoryUploadStatus _status = StoryUploadStatus.initial;
  StoryUploadStatus get status => _status;

  MediaType _mediaType;
  MediaType get mediaType => _mediaType;

  Uint8List _thumbnail;
  Uint8List get thumbnail => _thumbnail;

  Future<Either<Failure, Success>> uploadStory() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.uploading);
      final response =
          await _storyMethod.uploadStory(story: _story, file: _file, uid: userM['uid'],);
      return response.fold(
        (failure) async {
          _setStoryUploadStatus(StoryUploadStatus.failure);
          return left(failure);
        },
        (success) async {
          _setStoryUploadStatus(StoryUploadStatus.success);
          return right(const Success('Story uploaded successfully'));
        },

      );
    } on Failure catch (e) {
      _setStoryUploadStatus(StoryUploadStatus.failure);
      return left(e);
    }

  }

  //TODO: Request permission to access media and camera
  Future<Either<Failure, Success>> pickImageGallery() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await _imagePicker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        _selectFile(File(result.path));
        if (_file != null) {
          _setMediaType(MediaType.image);
          final story = Story(
            mediaType: _mediaType,
            uid: userM['uid'],
          );
          _setStory(story);
          if (_story != null) {
            return right(const Success());
          } else {
            _resetStatusToInitial();
            return left(const Failure('Something went wrong'));
          }
        } else {
          _resetStatusToInitial();
          return left(const Failure('Something went wrong'));
        }
      } else {
        _resetStatusToInitial();
        return left(const Failure('No file selected'));
      }
    } on PlatformException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Success>> pickImageCamera() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await _imagePicker.pickImage(source: ImageSource.camera);
      if (result != null) {
        _selectFile(File(result.path));
        if (_file != null) {
          _setMediaType(MediaType.image);
          final story = Story(
            mediaType: _mediaType,
            uid: userM['uid'],
          );
          _setStory(story);
          if (_story != null) {
            return right(const Success());
          } else {
            _resetStatusToInitial();
            return left(const Failure('Something went wrong'));
          }
        } else {
          _resetStatusToInitial();
          return left(const Failure('Something went wrong'));
        }
      } else {
        _resetStatusToInitial();
        return left(const Failure('No file selected'));
      }
    } on PlatformException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Success>> pickVideo() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await _imagePicker.pickVideo(
        source: ImageSource.gallery,
        //! Max duration does not work
        //! See: {https://github.com/flutter/flutter/issues/83630}
        //? A workaround  was used to check the duration of the video
        maxDuration: const Duration(seconds: 30),
      );
      if (result != null) {
        final length = await result.length();
        'Path length: ${result.path.length}'.log();
        'File name: ${result.name}'.log();
        'File location: ${result.path}'.log();
        'File length: $length'.log();
        _selectFile(File(result.path));
        if (_file != null) {
          _setMediaType(MediaType.video);
          final story = Story(
            mediaType: _mediaType,
            uid: userM['uid'],
          );
          _setStory(story);
          if (_story != null) {
            return right(const Success());
          } else {
            _resetStatusToInitial();
            return left(const Failure('Something went wrong'));
          }
        } else {
          _resetStatusToInitial();
          return left(const Failure('Something went wrong'));
        }
      } else {
        _resetStatusToInitial();
        return left(const Failure('No file selected'));
      }
    } on PlatformException catch (e) {
      return left(Failure(e.message));
    }
  }

  Future<Either<Failure, Success>> getVideoThumbnail() async {
    try {
      final thumbImage = await VideoThumbnail.thumbnailData(
        video: _file.path,
        maxWidth:
            128, // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      if (thumbImage != null) {
        _setThumbnail(thumbImage);
        return right(const Success());
      } else {
        return left(const Failure('Unable to get video thumbnail'));
      }
    } catch (e) {
      return left(Failure(e.toString()));
    }
  }

  void _selectFile(File file) {
    _file = file;
    notifyListeners();
  }

  void _setStory(Story story) {
    _story = story;
    notifyListeners();
  }

  void _setStoryUploadStatus(StoryUploadStatus status) {
    _status = status;
    _status.log();
    notifyListeners();
  }

  void _setMediaType(MediaType mediaType) {
    _mediaType = mediaType;
    notifyListeners();
  }

  void _setThumbnail(Uint8List thumbnail) {
    _thumbnail = thumbnail;
    notifyListeners();
  }

  void reset() {
    _resetFileToNull();
    _resetStoryToNull();
    _resetStatusToInitial();
    _resetMediaTypeToNull();
    _resetThumbnailToNull();
  }

  void _resetFileToNull() {
    _file = null;
    notifyListeners();
  }

  void _resetStoryToNull() {
    _story = null;
    notifyListeners();
  }

  void _resetStatusToInitial() {
    _status = StoryUploadStatus.initial;
    notifyListeners();
  }

  void _resetMediaTypeToNull() {
    _mediaType = null;
    notifyListeners();
  }

  void _resetThumbnailToNull() {
    _thumbnail = null;
    notifyListeners();
  }
}