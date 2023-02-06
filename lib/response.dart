import 'package:freezed_annotation/freezed_annotation.dart';
part 'response.freezed.dart';

/// This is the response model for handling async calls.
@freezed
class Response<T> with _$Response<T>{
  const factory Response.success([T data]) = Success<T>;
  const factory Response.failure([String message]) = Failure;
}