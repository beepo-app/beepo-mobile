import 'package:freezed_annotation/freezed_annotation.dart';
part 'response.freezed.dart';

/// This is the response model for handling async calls.
@freezed
class Response<T> with _$Response<T> {
  Response.success([T? data]);
  Response.failure([String? message]);
}
