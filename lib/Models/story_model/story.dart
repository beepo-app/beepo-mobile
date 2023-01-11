import 'package:freezed_annotation/freezed_annotation.dart';

part 'story.freezed.dart';
part 'story.g.dart';

@freezed
class Story with _$Story {
  factory Story({
    /// The url of the story.
    ///
    /// It is nullable because the backend sets the url after the story is uploaded.
    String url,
    @required MediaType mediaType,

    /// The duration a story is displayed.
    ///
    /// Defaults to 10 seconds.
    @Default(_duration) Duration duration,
    DateTime createdDate,
    @Default(0) String hoursAgo,
    String path,

    /// The id of the user who created the story
    @required String uid,
  }) = _Story;

  factory Story.fromJson(Map<String, Object> json) => _$StoryFromJson(json);
}

enum MediaType {
  @JsonValue('IMAGE')
  image,
  @JsonValue('VIDEO')
  video,
}

const _duration = Duration(seconds: 10);
