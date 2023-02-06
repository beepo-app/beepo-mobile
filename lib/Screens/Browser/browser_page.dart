// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../Utils/styles.dart';
import '../../components.dart';

class BrowserPage extends StatefulWidget {
  BrowserPage({Key key}) : super(key: key);

  @override
  State<BrowserPage> createState() => _BrowserPageState();
}

class _BrowserPageState extends State<BrowserPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          titleSpacing: -5,
          title: Row(
            children: [
              Icon(
                Icons.lock,
                color: Colors.white,
                size: 15,
              ),
              SizedBox(width: 5),
              Text(
                "mento.finance",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          leading: IconButton(
            icon: Transform.rotate(
                angle: 44.8,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                  size: 30,
                )),
            onPressed: () {
              Get.back();
            },
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: Row(
                children: [
                  Image.asset('assets/Celo.png', height: 26, width: 26),
                  SizedBox(width: 40),
                  Icon(Icons.more_vert_sharp, color: Colors.white, size: 25),
                ],
              ),
            ),
          ]),
      body: Container(
          color: Color(0xffDEEDE6),
          child: Column(
            children: [
              Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: secondaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(20),
                    bottomRight: Radius.circular(20),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  color: Color(0xffDEEDE6),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Image.asset('assets/mentofi.png', height: 50),
                          ContainerButton(),
                          Container(
                            padding: EdgeInsets.all(10),
                            height: 50,
                            width: 50,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                            ),
                            child: Icon(Icons.folder_open_rounded,
                                color: Colors.grey, size: 30),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              )
            ],
          )),
    );
  }
}
