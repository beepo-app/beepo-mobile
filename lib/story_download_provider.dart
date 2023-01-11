import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:beepo/Models/story_model/story.dart';
import 'package:beepo/Models/user_model.dart';
import 'package:beepo/story_download_method.dart';
import 'package:beepo/extensions.dart';

class StoryDownloadProvider extends ChangeNotifier {
  final StoryDownloadMethod _storyMethod;
  StoryDownloadProvider({
    @required StoryDownloadMethod storyMethod,
  }) : _storyMethod = storyMethod;

  factory StoryDownloadProvider.initialize() => StoryDownloadProvider(
        storyMethod: StoryDownloadMethod.initialize(),
      );

  Stream<bool> currentUserHasStory() => _storyMethod.currentUserHasStory();

  Stream<List<Story>> getCurrentUserStories() => _storyMethod.getCurrentUserStories();
  Stream<List<Story>> getFriendStories() => _storyMethod.getFriendsStories();

  Stream<List<UserModel>> getFollowingUsersStories() => _storyMethod.getFollowingUsersStories();
}