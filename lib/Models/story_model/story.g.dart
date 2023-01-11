// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'story.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Story _$$_StoryFromJson(Map<String, dynamic> json) => _$_Story(
      url: json['url'] as String,
      mediaType: $enumDecode(_$MediaTypeEnumMap, json['mediaType']),
      duration: json['duration'] == null
          ? _duration
          : Duration(microseconds: json['duration'] as int),
      createdDate: json['createdDate'] == null
          ? null
          : DateTime.parse(json['createdDate'] as String),
      hoursAgo: json['hoursAgo'] as String ?? '',
      path: json['path'] as String,
      uid: json['uid'] as String,
    );

Map<String, dynamic> _$$_StoryToJson(_$_Story instance) => <String, dynamic>{
      'url': instance.url,
      'mediaType': _$MediaTypeEnumMap[instance.mediaType],
      'duration': instance.duration.inMicroseconds,
      'createdDate': instance.createdDate?.toIso8601String(),
      'hoursAgo': instance.hoursAgo,
      'path': instance.path,
      'uid': instance.uid,
    };

const _$MediaTypeEnumMap = {
  MediaType.image: 'IMAGE',
  MediaType.video: 'VIDEO',
};
