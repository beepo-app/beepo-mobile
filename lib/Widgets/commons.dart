import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';

dynamic loadingDialog(String label) {
  Get.dialog(
    Material(
      color: Colors.black.withOpacity(.2),
      child: Center(
        child: Container(
          width: 160,
          height: 160,
          padding: const EdgeInsets.all(30),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.white,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              const CircularProgressIndicator(
                  // valueColor: AlwaysStoppedAnimation(primaryColor),
                  ),
              const SizedBox(height: 20),
              Text(
                label,
                textAlign: TextAlign.center,
              )
            ],
          ),
        ),
      ),
    ),
  );
}

Widget loader() {
  return const Center(child: CircularProgressIndicator());
}

//custom appbar
AppBar appBar(String title, {bool centerTitle = true}) {
  return AppBar(
    elevation: 0,
    centerTitle: centerTitle,
    backgroundColor: secondaryColor,
    title: Text(
      title,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
    ),
    foregroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(
        bottom: Radius.circular(15),
      ),
    ),
  );
}
