// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'story.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Story _$StoryFromJson(Map<String, dynamic> json) {
  return _Story.fromJson(json);
}

/// @nodoc
mixin _$Story {
  /// The url of the story.
  ///
  /// It is nullable because the backend sets the url after the story is uploaded.
  String get url => throw _privateConstructorUsedError;
  MediaType get mediaType => throw _privateConstructorUsedError;

  /// The duration a story is displayed.
  ///
  /// Defaults to 10 seconds.
  Duration get duration => throw _privateConstructorUsedError;
  DateTime get createdDate => throw _privateConstructorUsedError;
  int get hoursAgo => throw _privateConstructorUsedError;
  String get path => throw _privateConstructorUsedError;

  /// The id of the user who created the story
  String get uid => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $StoryCopyWith<Story> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $StoryCopyWith<$Res> {
  factory $StoryCopyWith(Story value, $Res Function(Story) then) =
      _$StoryCopyWithImpl<$Res>;
  $Res call(
      {String url,
      MediaType mediaType,
      Duration duration,
      DateTime createdDate,
      int hoursAgo,
      String path,
      String uid});
}

/// @nodoc
class _$StoryCopyWithImpl<$Res> implements $StoryCopyWith<$Res> {
  _$StoryCopyWithImpl(this._value, this._then);

  final Story _value;
  // ignore: unused_field
  final $Res Function(Story) _then;

  @override
  $Res call({
    Object url = freezed,
    Object mediaType = freezed,
    Object duration = freezed,
    Object createdDate = freezed,
    Object hoursAgo = freezed,
    Object path = freezed,
    Object uid = freezed,
  }) {
    return _then(_value.copyWith(
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: mediaType == freezed
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as MediaType,
      duration: duration == freezed
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hoursAgo: hoursAgo == freezed
          ? _value.hoursAgo
          : hoursAgo // ignore: cast_nullable_to_non_nullable
              as int,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
abstract class _$$_StoryCopyWith<$Res> implements $StoryCopyWith<$Res> {
  factory _$$_StoryCopyWith(_$_Story value, $Res Function(_$_Story) then) =
      __$$_StoryCopyWithImpl<$Res>;
  @override
  $Res call(
      {String url,
      MediaType mediaType,
      Duration duration,
      DateTime createdDate,
      int hoursAgo,
      String path,
      String uid});
}

/// @nodoc
class __$$_StoryCopyWithImpl<$Res> extends _$StoryCopyWithImpl<$Res>
    implements _$$_StoryCopyWith<$Res> {
  __$$_StoryCopyWithImpl(_$_Story _value, $Res Function(_$_Story) _then)
      : super(_value, (v) => _then(v as _$_Story));

  @override
  _$_Story get _value => super._value as _$_Story;

  @override
  $Res call({
    Object url = freezed,
    Object mediaType = freezed,
    Object duration = freezed,
    Object createdDate = freezed,
    Object hoursAgo = freezed,
    Object path = freezed,
    Object uid = freezed,
  }) {
    return _then(_$_Story(
      url: url == freezed
          ? _value.url
          : url // ignore: cast_nullable_to_non_nullable
              as String,
      mediaType: mediaType == freezed
          ? _value.mediaType
          : mediaType // ignore: cast_nullable_to_non_nullable
              as MediaType,
      duration: duration == freezed
          ? _value.duration
          : duration // ignore: cast_nullable_to_non_nullable
              as Duration,
      createdDate: createdDate == freezed
          ? _value.createdDate
          : createdDate // ignore: cast_nullable_to_non_nullable
              as DateTime,
      hoursAgo: hoursAgo == freezed
          ? _value.hoursAgo
          : hoursAgo // ignore: cast_nullable_to_non_nullable
              as int,
      path: path == freezed
          ? _value.path
          : path // ignore: cast_nullable_to_non_nullable
              as String,
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Story implements _Story {
  _$_Story(
      {this.url,
      @required this.mediaType,
      this.duration = _duration,
      this.createdDate,
      this.hoursAgo = 0,
      this.path,
      @required this.uid});

  factory _$_Story.fromJson(Map<String, dynamic> json) =>
      _$$_StoryFromJson(json);

  /// The url of the story.
  ///
  /// It is nullable because the backend sets the url after the story is uploaded.
  @override
  final String url;
  @override
  final MediaType mediaType;

  /// The duration a story is displayed.
  ///
  /// Defaults to 10 seconds.
  @override
  @JsonKey()
  final Duration duration;
  @override
  final DateTime createdDate;
  @override
  @JsonKey()
  final int hoursAgo;
  @override
  final String path;

  /// The id of the user who created the story
  @override
  final String uid;

  @override
  String toString() {
    return 'Story(url: $url, mediaType: $mediaType, duration: $duration, createdDate: $createdDate, hoursAgo: $hoursAgo, path: $path, uid: $uid)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Story &&
            const DeepCollectionEquality().equals(other.url, url) &&
            const DeepCollectionEquality().equals(other.mediaType, mediaType) &&
            const DeepCollectionEquality().equals(other.duration, duration) &&
            const DeepCollectionEquality()
                .equals(other.createdDate, createdDate) &&
            const DeepCollectionEquality().equals(other.hoursAgo, hoursAgo) &&
            const DeepCollectionEquality().equals(other.path, path) &&
            const DeepCollectionEquality().equals(other.uid, uid));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(url),
      const DeepCollectionEquality().hash(mediaType),
      const DeepCollectionEquality().hash(duration),
      const DeepCollectionEquality().hash(createdDate),
      const DeepCollectionEquality().hash(hoursAgo),
      const DeepCollectionEquality().hash(path),
      const DeepCollectionEquality().hash(uid));

  @JsonKey(ignore: true)
  @override
  _$$_StoryCopyWith<_$_Story> get copyWith =>
      __$$_StoryCopyWithImpl<_$_Story>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_StoryToJson(
      this,
    );
  }
}

abstract class _Story implements Story {
  factory _Story(
      {final String url,
      @required final MediaType mediaType,
      final Duration duration,
      final DateTime createdDate,
      final int hoursAgo,
      final String path,
      @required final String uid}) = _$_Story;

  factory _Story.fromJson(Map<String, dynamic> json) = _$_Story.fromJson;

  @override

  /// The url of the story.
  ///
  /// It is nullable because the backend sets the url after the story is uploaded.
  String get url;
  @override
  MediaType get mediaType;
  @override

  /// The duration a story is displayed.
  ///
  /// Defaults to 10 seconds.
  Duration get duration;
  @override
  DateTime get createdDate;
  @override
  int get hoursAgo;
  @override
  String get path;
  @override

  /// The id of the user who created the story
  String get uid;
  @override
  @JsonKey(ignore: true)
  _$$_StoryCopyWith<_$_Story> get copyWith =>
      throw _privateConstructorUsedError;
}
