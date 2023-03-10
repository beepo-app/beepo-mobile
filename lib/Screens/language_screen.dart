// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';

class Language extends StatefulWidget {
  Language({Key key}) : super(key: key);

  @override
  State<Language> createState() => _LanguageState();
}

class _LanguageState extends State<Language> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          onPressed: (() => Get.back()),
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
            size: 30,
          ),
        ),
        title: Text(
          "My Profile",
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
          ),
        ),
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                    color: secondaryColor),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(20),
                color: Colors.white,
                child: Column(
                  children: [
                    SizedBox(height: 30),
                    Text(
                      "Language",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 30),
                    Row(
                      children: [
                        Expanded(
                          child: Text(
                            "English",
                            style: TextStyle(
                              color: secondaryColor,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Icon(
                          Icons.check,
                          size: 18,
                        )
                      ],
                    ),
                    SizedBox(height: 14),
                    Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Deutsch",
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                          ),
                        )),
                    SizedBox(height: 12),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "普通话",
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
