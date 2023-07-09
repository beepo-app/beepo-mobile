import 'package:flutter/material.dart';

class StoryModalSheet {
  static Future<void> openModalBottomSheet({
    required Widget child,
    required BuildContext context,
  }) {
    return Future.delayed(Duration.zero, () {
      return showModalBottomSheet(
        isScrollControlled: true,
        context: context,
        builder: (context) {
          return DraggableScrollableSheet(
            initialChildSize: 0.2,
            minChildSize: 0.2,
            snap: true,
            expand: false,
            builder: (context, scrollController) => child,
          );
        },
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(20),
            topLeft: Radius.circular(20),
          ),
        ),
      );
    });
  }
}
