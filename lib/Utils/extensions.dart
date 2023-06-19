import 'dart:convert';
import 'dart:developer' as devtools show log;

import 'package:flutter/material.dart';

extension Log on Object {
  /// An extension method on `Object` that logs `toString` of an Object to the console.
  void log() => devtools.log(toString());
}

extension ThemeExtension on BuildContext {
  /// An extension method on `BuildContext` that returns the current theme data.
  ThemeData get themeData => Theme.of(this);

  /// An extension method on `BuildContext` that returns the current text theme.
  TextTheme get textTheme => themeData.textTheme;
}

extension StringExtensions on String {
  //check is string is json
  bool get isJSON {
    try {
      jsonDecode(this);
    } catch (e) {
      return false;
    }
    return true;
  }
}
