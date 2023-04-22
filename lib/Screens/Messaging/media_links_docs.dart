// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:linkwell/linkwell.dart';

class MediaLinks extends StatefulWidget {
  // const UserProfile({Key key}) : super(key: key);
  final UserModel model;

  MediaLinks({@required this.model});

  @override
  State<MediaLinks> createState() => _MediaLinksState();
}

class _MediaLinksState extends State<MediaLinks> with TickerProviderStateMixin {
  bool enable = false;
  bool enable2 = true;
  bool enable3 = false;

  Map userM = Hive.box('beepo').get('userData');
  TabController tabController;

  @override
  void initState() {

    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: 250,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                          imageUrl: widget.model.image,
                          tag: "imagex",
                        );
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Hero(
                        tag: 'imagex',
                        child: CachedNetworkImage(
                          width: 110,
                          height: 110,
                          imageUrl: widget.model.image,
                          placeholder: (context, url) =>
                              Center(child: CircularProgressIndicator()),
                          errorWidget: (context, url, error) => Icon(
                            Icons.person,
                            color: secondaryColor,
                          ),
                          filterQuality: FilterQuality.high,
                          // fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  Text(
                    widget.model.name,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                    ),
                  ),
                  SizedBox(height: 6),
                  Text(
                    widget.model.userName,
                    style: TextStyle(
                      color: Color(0x66ffffff),
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Media',
                          style: TextStyle(color: Colors.black),
                        ),

                        // text: 'Media',
                      ),
                      Tab(
                        child: Text(
                          'Docs',
                          style: TextStyle(color: Colors.black),
                        ),

                        // text: 'Media',
                      ),
                      Tab(
                        child: Text(
                          'Links',
                          style: TextStyle(color: Colors.black),
                        ),
                        // text: 'Media',
                      ),
                      // Text('Media'),
                      // Text('Docs'),
                      // Text('Links'),
                    ],
                    controller: tabController,
                  ),
                  SizedBox(
                    height: 23,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: txtColor1,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('messages')
                                .doc(userM['uid'])
                                .collection('userMessages')
                                .doc(widget.model.uid)
                                .collection('messageList')
                                .where('type', isEqualTo: 'photo')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  mainAxisSpacing: 20,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 3,
                                  children: List.generate(
                                      snapshot.data.docs.length, (index) {
                                    return Container(
                                      height: 91,
                                      width: 102,
                                      decoration: BoxDecoration(
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                            return FullScreenImage(
                                              imageUrl: snapshot
                                                  .data.docs[index]['content'],
                                              tag: "images$index",
                                            );
                                          }));
                                        },
                                        child: ClipRRect(
                                          child: Hero(
                                            tag: "images$index",
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data.docs[index]['content'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return CircularProgressIndicator(
                                color: primaryColor,
                              );
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('messages')
                                .doc(userM['uid'])
                                .collection('userMessages')
                                .doc(widget.model.uid)
                                .collection('messageList')
                                .where('type', isEqualTo: 'video')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  mainAxisSpacing: 20,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 3,
                                  children: List.generate(
                                      snapshot.data.docs.length, (index) {
                                    return GestureDetector(
                                      // onTap: () => Get.to(Store()),
                                      child: Container(
                                        height: 91,
                                        width: 102,
                                        decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data.docs[index]
                                                ['content'],
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return CircularProgressIndicator(
                                color: primaryColor,
                              );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('messages')
                            .doc(userM['uid'])
                            .collection('userMessages')
                            .doc(widget.model.uid)
                            .collection('messageList')
                            .where('type', isEqualTo: 'message')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data.docs[index]['text']
                                              .toString()
                                              .split('?')
                                              .first
                                              .split('.')
                                              .last ==
                                          'com' ||
                                      snapshot.data.docs[index]['text']
                                              .toString()
                                              .split('?')
                                              .first
                                              .split('.')
                                              .last ==
                                          'net/') {
                                    return Container(
                                      // width: 50,
                                      height: 50,
                                      // width: MediaQuery.of(context).size.width * 0.5,
                                      decoration: BoxDecoration(color: primaryColor, borderRadius: BorderRadius.circular(15)),
                                      margin: EdgeInsets.only(top: 10),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                                      alignment: Alignment.center,
                                      child: LinkWell(
                                          snapshot.data.docs[index]['text'],
                                          linkStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: secondaryColor,
                                            fontSize: 11,
                                          )),
                                    );
                                  }
                                  return SizedBox();
                                });
                          }
                          return CircularProgressIndicator(
                            color: primaryColor,
                          );
                        }),
                  ),
                ],
                controller: tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}


class MediaLinksGroup extends StatefulWidget {
  // const UserProfile({Key key}) : super(key: key);
  final String image;

  const MediaLinksGroup({Key key, @required this.image}) : super(key: key);

  @override
  State<MediaLinksGroup> createState() => _MediaLinksGroupState();
}

class _MediaLinksGroupState extends State<MediaLinksGroup> with TickerProviderStateMixin {
  bool enable = false;
  bool enable2 = true;
  bool enable3 = false;

  Map userM = Hive.box('beepo').get('userData');
  TabController tabController;

  @override
  void initState() {

    super.initState();
    tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 30,
          ),
          onPressed: () => Get.back(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.more_vert_outlined),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height*0.34,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20)),
                  color: Color(0xff0e014c)),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 56),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(context, MaterialPageRoute(builder: (_) {
                        return FullScreenImage(
                          imageUrl: widget.image,
                          tag: "imagex",
                        );
                      }));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(60),
                      child: Hero(
                        tag: 'imagex',
                        child: Image.asset(widget.image)
                      ),
                    ),
                  ),
                  SizedBox(height: 12),
                  // Text(
                  //   widget.model.name,
                  //   style: TextStyle(
                  //     color: Colors.white,
                  //     fontSize: 24,
                  //   ),
                  // ),
                  // SizedBox(height: 6),
                  // Text(
                  //   widget.model.userName,
                  //   style: TextStyle(
                  //     color: Color(0x66ffffff),
                  //     fontSize: 13,
                  //   ),
                  // ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(left: 20, right: 20),
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  TabBar(
                    tabs: [
                      Tab(
                        child: Text(
                          'Media',
                          style: TextStyle(color: Colors.black),
                        ),

                        // text: 'Media',
                      ),
                      Tab(
                        child: Text(
                          'Docs',
                          style: TextStyle(color: Colors.black),
                        ),

                        // text: 'Media',
                      ),
                      Tab(
                        child: Text(
                          'Links',
                          style: TextStyle(color: Colors.black),
                        ),
                        // text: 'Media',
                      ),
                      // Text('Media'),
                      // Text('Docs'),
                      // Text('Links'),
                    ],
                    controller: tabController,
                  ),
                  SizedBox(
                    height: 23,
                  ),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Recent',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: txtColor1,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('groupMessages')
                                .where('type', isEqualTo: 'photo')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  mainAxisSpacing: 20,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 3,
                                  children: List.generate(
                                      snapshot.data.docs.length, (index) {
                                    return Container(
                                      height: 91,
                                      width: 102,
                                      decoration: BoxDecoration(
                                        // color: Colors.grey,
                                        borderRadius: BorderRadius.circular(15),
                                      ),
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.push(context,
                                              MaterialPageRoute(builder: (_) {
                                                return FullScreenImage(
                                                  imageUrl: snapshot
                                                      .data.docs[index]['content'],
                                                  tag: "images$index",
                                                );
                                              }));
                                        },
                                        child: ClipRRect(
                                          child: Hero(
                                            tag: "images$index",
                                            child: CachedNetworkImage(
                                              imageUrl: snapshot
                                                  .data.docs[index]['content'],
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return CircularProgressIndicator(
                                color: primaryColor,
                              );
                            }),
                        StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('groupMessages')
                                .where('type', isEqualTo: 'video')
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              if (snapshot.hasData) {
                                return GridView.count(
                                  physics: NeverScrollableScrollPhysics(),
                                  padding: const EdgeInsets.only(bottom: 20),
                                  mainAxisSpacing: 20,
                                  shrinkWrap: true,
                                  crossAxisSpacing: 15,
                                  crossAxisCount: 3,
                                  children: List.generate(
                                      snapshot.data.docs.length, (index) {
                                    return GestureDetector(
                                      // onTap: () => Get.to(Store()),
                                      child: Container(
                                        height: 91,
                                        width: 102,
                                        decoration: BoxDecoration(
                                          // color: Colors.grey,
                                          borderRadius:
                                          BorderRadius.circular(15),
                                        ),
                                        child: ClipRRect(
                                          child: CachedNetworkImage(
                                            imageUrl: snapshot.data.docs[index]
                                            ['content'],
                                            fit: BoxFit.fill,
                                          ),
                                          borderRadius:
                                          BorderRadius.circular(10),
                                        ),
                                      ),
                                    );
                                  }),
                                );
                              }
                              return CircularProgressIndicator(
                                color: primaryColor,
                              );
                            }),
                      ],
                    ),
                  ),
                  SizedBox(),
                  Padding(
                    padding: const EdgeInsets.only(left: 12, right: 12),
                    child: StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('groupMessages')
                            .where('type', isEqualTo: 'message')
                            .snapshots(),
                        builder: (context,
                            AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            return ListView.builder(
                                itemCount: snapshot.data.docs.length,
                                itemBuilder: (context, index) {
                                  if (snapshot.data.docs[index]['text']
                                      .toString()
                                      .split('?')
                                      .first
                                      .split('.')
                                      .last ==
                                      'com' ||
                                      snapshot.data.docs[index]['text']
                                          .toString()
                                          .split('?')
                                          .first
                                          .split('.')
                                          .last ==
                                          'net/') {
                                    return Container(
                                      // width: 50,
                                      height: 50,
                                      // width: MediaQuery.of(context).size.width * 0.5,
                                      decoration: BoxDecoration(color: secondaryColor, borderRadius: BorderRadius.circular(15)),
                                      margin: EdgeInsets.only(top: 10),
                                      constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.5),
                                      alignment: Alignment.center,
                                      child: LinkWell(
                                          snapshot.data.docs[index]['text'],
                                          linkStyle: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.white,
                                            decoration: TextDecoration.underline,
                                            fontSize: 11,
                                          )),
                                    );
                                  }
                                  return SizedBox();
                                });
                          }
                          return CircularProgressIndicator(
                            color: primaryColor,
                          );
                        }),
                  ),
                ],
                controller: tabController,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
