// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import 'store2_screen.dart';

class Store extends StatefulWidget {
  const Store({Key key}) : super(key: key);

  @override
  State<Store> createState() => _StoreState();
}

class _StoreState extends State<Store> {
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
          "Store",
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
                color: Colors.white,
                padding: EdgeInsets.all(20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Text(
                          "Save",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            color: secondaryColor,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      SizedBox(height: 40),
                      Text(
                        "About",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(
                        padding: const EdgeInsets.all(10),
                        height: 123,
                        width: 322,
                        decoration: BoxDecoration(
                          color: Color(0xffF9F9F9),
                          border: Border.all(
                            width: 1,
                            color: Color(0xffCFCDDB),
                          ),
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      SizedBox(height: 25),
                      Text(
                        "Store Catalogue",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 14,
                        ),
                      ),
                      SizedBox(height: 25),
                      GridView.count(
                        physics: NeverScrollableScrollPhysics(),
                        padding: const EdgeInsets.only(bottom: 20),
                        mainAxisSpacing: 20,
                        shrinkWrap: true,
                        crossAxisSpacing: 15,
                        crossAxisCount: 3,
                        children: List.generate(6, (index) {
                          return GestureDetector(
                            onTap: () => Get.to(Store()),
                            child: Container(
                              padding: const EdgeInsets.all(10),
                              height: 91,
                              width: 102,
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                          );
                        }),
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          IconButton(
                            onPressed: () => Get.to(Store2()),
                            icon: Icon(
                              Icons.add_circle_outline_outlined,
                              color: secondaryColor,
                            ),
                          ),
                          SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => Get.to(Store2()),
                            child: Text(
                              "Add items",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ))
            ],
          )),
    );
  }
}
