import 'dart:math';
import 'package:flutter/material.dart';

class Sizes {
  factory Sizes() {
    return _instance;
  }

  Sizes._();

   bool allowFontScaling;
   Size designSize;
   Size screenSize;

  static Sizes _instance;

  static void init(
    BoxConstraints constraints, {
    @required Size designSize,
    bool allowFontScaling = false,
  }) {
    _instance = Sizes._()
      ..designSize = designSize
      ..screenSize = Size(constraints.maxWidth, constraints.maxHeight)
      ..allowFontScaling = allowFontScaling;
  }

  double get widthScaleFactor => screenSize.width / designSize.width;
  double get heightScaleFactor => screenSize.height / designSize.height;
  double get minScaleFactor => min(widthScaleFactor, heightScaleFactor);

  double scaleWidth(num width) => width * widthScaleFactor;
  double scaleHeight(num height) => height * heightScaleFactor;
  double scaleRadius(num r) => r * minScaleFactor;

  double scaleFontSize(num fontSize) {
    final textScaleFactor = WidgetsBinding.instance.window.textScaleFactor;
    return fontSize * minScaleFactor * textScaleFactor;
  }
}

extension SizeExtension on num {
  double get w => Sizes().scaleWidth(this);
  double get h => Sizes().scaleHeight(this);
  double get sw => Sizes().screenSize.width * this;
  double get sh => Sizes().screenSize.height * this;
  double get sp => Sizes().scaleFontSize(this);
}
