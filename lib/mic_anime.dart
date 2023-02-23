// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'Utils/styles.dart';

class GroupProfile extends StatefulWidget {
  final String image;

  const GroupProfile({Key key, this.image}) : super(key: key);

  @override
  State<GroupProfile> createState() => _GroupProfileState();
}

class _GroupProfileState extends State<GroupProfile> {
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
              height: 252,
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
                      // Navigator.push(context, MaterialPageRoute(builder: (_) {
                      //   return FullScreenImage(
                      //     imageUrl: widget.image,
                      //     tag: "imagex",
                      //   );
                      // }));
                    },
                    child: SizedBox(
                      height: 100,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: Hero(
                          tag: 'imagex',
                          child: Image.asset(widget.image),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.only(left: 20, right: 20),
                color: Colors.white,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 30),
                    Center(
                      child: Text(
                        "Hi there, am new to Beepo and I love it",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Color(0xff0e014c),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Divider(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Shared Media, Links and Docs',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            color: txtColor1,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                            onPressed: () {},
                            icon: Icon(Icons.arrow_forward_ios_outlined))
                      ],
                    ),
                    Text('Members',style: TextStyle(
                      fontFamily: 'Roboto',
                      color: txtColor1,
                      fontWeight: FontWeight.w700,
                      fontSize: 19,
                    ),),
                    Expanded(
                      child: StreamBuilder(
                          stream: FirebaseFirestore.instance
                              .collection('users')
                              .snapshots(),
                          builder: (context,
                              AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasData) {
                              return ListView.builder(
                                  itemCount: snapshot.data.docs.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      padding: EdgeInsets.all(10),
                                      margin: EdgeInsets.all(5),
                                      decoration: BoxDecoration(
                                        // color: Color(0xffc4c4c4),
                                        borderRadius: BorderRadius.circular(10)
                                      ),
                                      child: Row(
                                        children: [
                                          CircleAvatar(
                                            // borderRadius: BorderRadius.circular(5),
                                            backgroundImage: CachedNetworkImageProvider(
                                              snapshot
                                                  .data.docs[index]['image'] == ""?'https://pbs.twimg.com/profile_images/1619846077506621443/uWNSRiRL_400x400.jpg':snapshot
                                                  .data.docs[index]['image'],
                                              maxHeight: 45,
                                              maxWidth: 45,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 15,
                                          ),
                                          Text('${snapshot.data.docs[index]
                                              ['name']}  \n@${snapshot.data.docs[index]
                                          ['userName']}', style: TextStyle(
                                            fontFamily: 'Roboto',
                                            color: Colors.black,
                                            fontWeight: FontWeight.w400,
                                            fontSize: 14,
                                          ),),
                                        ],
                                      ),
                                    );
                                  });
                            }
                            return SizedBox();
                          }),
                    )
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
