// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../Utils/styles.dart';
import '../components.dart';
import 'chatToken_screen.dart';

class Store2 extends StatefulWidget {
  Store2({Key key}) : super(key: key);

  @override
  State<Store2> createState() => _Store2State();
}

class _Store2State extends State<Store2> {
  final TextEditingController name = TextEditingController();
  final TextEditingController details = TextEditingController();
  final TextEditingController value = TextEditingController();

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
            Container(
              height: 100,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20), bottomRight: Radius.circular(20)),
                  color: secondaryColor),
            ),
            Expanded(
                child: Container(
              color: Colors.white,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Add items",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: secondaryColor,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    SizedBox(height: 30),
                    Text(
                      "Item Name",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 12),
                    TextField(
                      controller: name,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Item Details",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      controller: details,
                      decoration: InputDecoration(
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "Item Value",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 10),
                    TextField(
                      keyboardType: TextInputType.phone,
                      controller: value,
                      decoration: InputDecoration(
                        suffixIcon: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 35,
                              child: IconButton(
                                icon: Icon(
                                  Icons.keyboard_arrow_up_outlined,
                                  color: secondaryColor,
                                  size: 30,
                                ),
                                onPressed: () {},
                              ),
                            ),
                            SizedBox(width: 2),
                            Text(
                              "USD",
                              style: TextStyle(
                                color: secondaryColor,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(width: 8),
                          ],
                        ),
                        isDense: true,
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.all(Radius.circular(15)),
                            borderSide: BorderSide(
                              color: Colors.grey,
                              width: 1,
                            )),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(15)),
                          borderSide: BorderSide(width: 1, color: Colors.grey),
                        ),
                      ),
                    ),
                    SizedBox(height: 65),
                    Text(
                      "Item image",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: secondaryColor,
                        fontSize: 14,
                      ),
                    ),
                    SizedBox(height: 17),
                    Text(
                      "You can upload  a maximum of 4 images. Supported file type (Jpeg, Png).",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0x660e014c),
                        fontSize: 11,
                      ),
                    ),
                    SizedBox(height: 40),
                    GridView.count(
                      physics: NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.only(bottom: 20),
                      mainAxisSpacing: 20,
                      shrinkWrap: true,
                      crossAxisSpacing: 15,
                      crossAxisCount: 3,
                      children: List.generate(6, (index) {
                        return GestureDetector(
                          onTap: () {},
                          child: Container(
                            padding: const EdgeInsets.all(10),
                            height: 91,
                            width: 102,
                            decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Icon(
                              Icons.image_outlined,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        );
                      }),
                    ),
                    SizedBox(height: 25),
                    Center(
                      child: FilledButton(
                        color: secondaryColor,
                        text: "Add item",
                        onPressed: () => Get.to(ChatToken()),
                      ),
                    ),
                    SizedBox(height: 35),
                  ],
                ),
              ),
            ))
          ],
        ),
      ),
    );
  }
}
