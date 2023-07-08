import 'dart:io';

import 'package:beepo/Utils/extensions.dart';
import 'package:beepo/response.dart';
import 'package:beepo/Screens/moments/story_upload_method.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:image_picker/image_picker.dart';
import 'package:video_thumbnail/video_thumbnail.dart' as video;
import 'package:image/image.dart' as img;
import 'package:wechat_assets_picker/wechat_assets_picker.dart';
import '../../Models/story_model/storyModel.dart';
import 'add_story.dart';

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
  final StoryUploadMethod? _storyMethod;
  final ImagePicker? _imagePicker;
  StoryUploadProvider(this._storyMethod, this._imagePicker);

  factory StoryUploadProvider.initialize() => StoryUploadProvider(
        StoryUploadMethod.initialize(),
        ImagePicker(),
      );

  late File _file;

  File get file => _file;

  late StoryModel _story;
  Map userM = Hive.box('beepo').get('userData');

  StoryUploadStatus _status = StoryUploadStatus.initial;

  StoryUploadStatus get status => _status;

  late String _mediaType;

  String get mediaType => _mediaType;

  late Uint8List _thumbnail;

  Uint8List get thumbnail => _thumbnail;

  late String _caption;

  String get caption => _caption;

  Future<void> uploadStory() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.uploading);
      await _storyMethod!.uploadStory(
          story: _story, file: _file, uid: userM['uid'], caption: _caption);
    } on Failure catch (_) {
      _setStoryUploadStatus(StoryUploadStatus.failure);
      rethrow;
    }
  }

  void getCaption(String text) {
    _caption = text;
    notifyListeners();
  }

  //TODO: Request permission to access media and camera
  Future<void> pickMediaGallery(BuildContext context) async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      List<AssetEntity>? result = await AssetPicker.pickAssets(
        context,
        pickerConfig: const AssetPickerConfig(
          maxAssets: 1,
          requestType: RequestType.all,
        ),
      );
      // await _imagePicker.pickImage(source: ImageSource.gallery);
      if (result != null) {
        _selectFile(await result.first.file);
        result.first.type == AssetType.image
            ? _setMediaType("image")
            : result.first.type == AssetType.video
                ? _setMediaType('video')
                : _setMediaType("audio");

        final story = StoryModel(
          mediaType: _mediaType,
          uid: userM['uid'],
          name: userM['displayName'],
          profileImage: userM['profilePictureUrl'],
        );
        _setStory(story);
      }
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  int ity = 0;
  changeCamera(CameraDescription camera) {
    if (camera.lensDirection.index != 0) {
      // setState(() {
      ity = camera.lensDirection.index + 1;

      notifyListeners();
      // i = 1;
      print('Camera Changed');
      // });
    } else {
      // setState(() {
      ity = 0;
      notifyListeners();
      print('Camera Changed back');

      // });
    }
  }

  Future<void> pickImageCamera1() async {
    try {
      // await initializeControllerFuture;
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await controlle.takePicture();

      // if (!mounted) return;

      // final result = await _imagePicker.pickImage(source: ImageSource.camera);
      final img.Image? capturedImage =
          img.decodeImage(await File(result.path).readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      final noke = img.flipHorizontal(orientedImage);
      final yeske = await File(result.path).writeAsBytes(img.encodeJpg(noke));
      _selectFile(yeske);
      _setMediaType("image");
      final story = StoryModel(
        mediaType: _mediaType,
        uid: userM['uid'],
        name: userM['displayName'],
        profileImage: userM['profilePictureUrl'],
      );
      _setStory(story);
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  Future<void> pickImageCamera() async {
    // notifyListeners();

    // initializeControllerFuture =  controller.initialize();
    // notifyListeners();

    try {
      // await initializeControllerFuture;
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await controlle.takePicture();

      // if (!mounted) return;

      // final result = await _imagePicker.pickImage(source: ImageSource.camera);
      final img.Image? capturedImage =
          img.decodeImage(await File(result.path).readAsBytes());
      final img.Image orientedImage = img.bakeOrientation(capturedImage!);
      // final noke =         img.flipHorizontal(orientedImage);
      final yeske =
          await File(result.path).writeAsBytes(img.encodeJpg(orientedImage));
      _selectFile(yeske);
      _setMediaType("image");
      final story = StoryModel(
        mediaType: _mediaType,
        uid: userM['uid'],
        name: userM['displayName'],
        profileImage: userM['profilePictureUrl'],
      );
      _setStory(story);
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  Future<void> pickVideo() async {
    try {
      _setStoryUploadStatus(StoryUploadStatus.gettingReady);
      //TODO: Add permission check
      final result = await _imagePicker!.pickVideo(
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
        _setMediaType('video');
        final story = StoryModel(
          mediaType: _mediaType,
          uid: userM['uid'],
          name: userM['displayName'],
          profileImage: userM['profilePictureUrl'],
        );
        _setStory(story);
      }
    } on PlatformException catch (_) {
      rethrow;
    }
  }

  Future<void> getVideoThumbnail() async {
    try {
      final thumbImage = await video.VideoThumbnail.thumbnailData(
        video: _file.path,
        maxWidth: 128,
        imageFormat: video.ImageFormat.JPEG,
        // specify the width of the thumbnail, let the height auto-scaled to keep the source aspect ratio
        quality: 25,
      );
      if (thumbImage != null) {
        _setThumbnail(thumbImage);
      }
    } catch (e) {
      rethrow;
    }
  }

  void _selectFile(File? file) {
    _file = file!;
    notifyListeners();
  }

  void _setStory(StoryModel story) {
    _story = story;
    notifyListeners();
  }

  void _setStoryUploadStatus(StoryUploadStatus status) {
    _status = status;
    _status.log();
    notifyListeners();
  }

  void _setMediaType(String type) {
    _mediaType = type;
    notifyListeners();
  }

  void _setThumbnail(Uint8List thumbnail) {
    _thumbnail = thumbnail;
    notifyListeners();
  }

  // void reset() {
  //   _resetFileToNull();
  //   _resetStoryToNull();
  //   _resetStatusToInitial();
  //   _resetMediaTypeToNull();
  //   _resetThumbnailToNull();
  // }

  // void _resetFileToNull() {
  //   _file = null;
  //   notifyListeners();
  // }

  // void _resetStoryToNull() {
  //   _story = null;
  //   notifyListeners();
  // }

  // void _resetStatusToInitial() {
  //   _status = StoryUploadStatus.initial;
  //   notifyListeners();
  // }

  // void _resetMediaTypeToNull() {
  //   _mediaType = '';
  //   notifyListeners();
  // }

  // void _resetThumbnailToNull() {
  //   _thumbnail = null;
  //   notifyListeners();
  // }
}
