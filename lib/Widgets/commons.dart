import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
