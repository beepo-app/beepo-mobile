// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'package:beepo/Screens/moments/story_download_provider.dart';
import 'package:beepo/Utils/extensions.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:camera/camera.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import '../../Models/story_model/storyModel.dart';
import '../../Models/user_model.dart';
import '../../Utils/styles.dart';
import '../../Widgets/components.dart';
import 'add_story.dart';
import 'bubble_stories.dart';

class MomentsTab extends StatefulWidget {
  const MomentsTab({Key? key, required this.hasStory}) : super(key: key);
  final bool hasStory;

  @override
  State<MomentsTab> createState() => _MomentsTabState();
}

class _MomentsTabState extends State<MomentsTab> {
  String? receiver;
  bool showInput = false;

  Stream<List<StoryModel>>? currentUserStories;
  Stream<List<StoryModel>>? friendsStories;

  Stream<List<DocumentSnapshot>>? currentUserFollowing;

  Box box1 = Hive.box('beepo');

  setLeave() async {
    await FirebaseFirestore.instance
        .collection('LeaveGroup')
        .doc(userM['uid'])
        .set({'isRemoved': 'false'});
  }

  Map userM = Hive.box('beepo').get('userData');

  Widget? usert;
  CameraDescription? firstCamera;
  CameraDescription? secondCamera;

  // List<CameraDescription> cameras;
  gethg() async {
    // Obtain a list of the available cameras on the device.
    final cameras = await availableCameras();
    // Get a specific camera from the list of available cameras.
    firstCamera = cameras[0];
    secondCamera = cameras[1];
  }

  final TextEditingController _searchcontroller = TextEditingController();

  String? remove;

  @override
  void initState() {
    currentUserStories =
        context.read<StoryDownloadProvider>().getCurrentUserStories();
    gethg();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tem = FirebaseFirestore.instance
        .collection('LeaveGroup')
        .doc(userM['uid'])
        .get();

    tem.then((value) {
      if (value.data() != null) {
        remove = value.data()!['isRemoved'].toString();
      }
    });

    return Column(
      children: [
        Row(
          children: [
            const SizedBox(width: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AddStory(
                      camera1: firstCamera!,
                      camera2: secondCamera,
                    ),
                  ),
                );
              },
              child: Column(
                children: [
                  Container(
                    height: 60,
                    width: 60,
                    decoration: const BoxDecoration(
                      color: Color(0xFFC4C4C4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.add,
                      size: 35,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 7),
                  const Text(
                    "Update Moment",
                    style: TextStyle(
                      color: Color(0xb2ffffff),
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              width: 10,
            ),
            Expanded(
              child: Container(
                margin: EdgeInsets.only(top: 10),
                height: 100,
                child: ListView(scrollDirection: Axis.horizontal, children: [
                  StreamBuilder<List<StoryModel>>(
                      stream: currentUserStories,
                      initialData: const [],
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          try {
                            List<StoryModel> userStories = snapshot.data!;
                            'UserStories: $userStories'.log();
                            Map useR;
                            useR = Hive.box('beepo').get('userData');

                            UserModel userf = UserModel(
                              uid: useR['uid'],
                              name: useR['displayName'],
                              userName: useR['username'],
                              image: useR['profilePictureUrl'],
                              bitcoinWalletAddress: '',
                              firebaseToken: '',
                              hdWalletAddress: '',
                              searchKeywords: [],
                              stories: [],
                              // searchKeywords: fuck.data['searchKeywords'],
                            );

                            final user = userf.copyWith(
                              stories: userStories,
                              uid: userM['uid'],
                            );

                            return CurrentUserStoryBubble(user: user);
                          } catch (e) {
                            rethrow;
                          }
                        }
                        if (!snapshot.hasData) {}
                        if (snapshot.hasError) {}
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }),
                  StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('usersStories')
                          .where('uid', isNotEqualTo: userM['uid'])
                          .snapshots(),
                      // initialData: const [],
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        if (snapshot.hasData) {
                          if (snapshot.data!.docs.isEmpty) {
                            return SizedBox();
                          }
                          return ListView.builder(
                            primary: false,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            scrollDirection: Axis.horizontal,
                            itemCount: snapshot.data!.docs.length,
                            itemBuilder: (context, index) {
                              return BubbleStories(
                                uid: snapshot.data!.docs[index].id,
                                index: index,
                                docu: snapshot.data!.docs,
                                myStory: false,
                                isExplore: false,

                                // index: index,
                              );
                            },
                          );
                        }
                        return Center(
                          child: CircularProgressIndicator(
                            color: primaryColor,
                          ),
                        );
                      }),
                ]),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        Expanded(
          child: Container(
            padding: const EdgeInsets.only(left: 15, right: 15, top: 15),
            width: double.infinity,
            decoration: const BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(0),
                topRight: Radius.circular(0),
              ),
              color: Colors.white,
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(
                  10.0,
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Explore Moments',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontStyle: FontStyle.normal,
                            fontSize: 18,
                            fontWeight: FontWeight.w400,
                          ),

                        ),
                        Row(
                          children: [Text('Latests'), Icon(Icons.sort)],
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    StreamBuilder(
                        stream: FirebaseFirestore.instance
                            .collection('usersStories')
                            .where('uid', isNotEqualTo: userM['uid'])
                            .snapshots(),
                        // initialData: const [],
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          if (snapshot.hasData) {
                            if (snapshot.data!.docs.isEmpty) {
                              return SizedBox();
                            }
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 11,
                                mainAxisSpacing: 30,
                                childAspectRatio: 0.8,
                              ),
                              itemBuilder: (context, index) {
                                return Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Colors.transparent,
                                  ),
                                  // padding: const EdgeInsets.symmetric(
                                  //   horizontal: 10,
                                  // ),
                                  // height: 200,
                                  // alignment: Alignment.center,
                                  child: Stack(
                                    children: [
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(12),
                                        child: CachedNetworkImage(
                                          // height: double.infinity,
                                          width: double.infinity,
                                          imageUrl: snapshot.data!.docs[index]
                                              ['url'],
                                          placeholder: (context, url) => Center(
                                              child:
                                                  CircularProgressIndicator()),
                                          errorWidget: (context, url, error) =>
                                              Icon(
                                            Icons.person,
                                            color: secondaryColor,
                                          ),
                                          filterQuality: FilterQuality.high,
                                          fit: BoxFit.fitWidth,
                                        ),
                                      ),
                                      Align(
                                        alignment: Alignment.bottomLeft,
                                        child: Padding(
                                          padding: const EdgeInsets.all(20.0),
                                          child: Row(
                                            children: [
                                              CircleAvatar(
                                                backgroundImage:
                                                    CachedNetworkImageProvider(
                                                  snapshot.data!.docs[index]
                                                      ['profileImage'],
                                                ),
                                                radius: 30,
                                              ),
                                              SizedBox(
                                                width: 10,
                                              ),
                                              Text(
                                                snapshot.data!.docs[index]
                                                    ['name'],
                                                style: TextStyle(
                                                  fontFamily: 'Roboto',
                                                  fontSize: 20,
                                                  fontWeight: FontWeight.w700,
                                                  color: Colors.white,
                                                ),
                                              )
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                    fit: StackFit.loose,
                                  ),
                                );
                              },
                              itemCount: snapshot.data!.docs.length,
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                            );
                          }
                          return Center(
                            child: CircularProgressIndicator(
                              color: primaryColor,
                            ),
                          );
                        })
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
