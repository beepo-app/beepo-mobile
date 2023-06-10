// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'dart:developer';

import 'package:beepo/Constants/app_constants.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';
import 'package:xmtp/xmtp.dart';

import '../../../Models/user_model.dart';
import '../../../Service/xmtp.dart';
import 'chat_screen.dart';

class SearchUsersScreen extends StatefulWidget {
  @override
  State<SearchUsersScreen> createState() => _SearchUsersScreenState();
}

class _SearchUsersScreenState extends State<SearchUsersScreen> {
  final TextEditingController _searchcontroller = TextEditingController();

  @override
  void dispose() {
    super.dispose();
    _searchcontroller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SocialAppBar(
        title: SearchBar(
          controller: _searchcontroller,
          autofocus: true,
          onChanged: (value) {
            setState(() {});
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.only(
          left: 22.0,
          right: 22.0,
        ),
        child: StreamBuilder<QuerySnapshot<Map>>(
            stream: FirebaseFirestore.instance
                .collection("users")
                .where("searchKeywords",
                    arrayContains: _searchcontroller.text.trim().toLowerCase())
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: primaryColor,
                  ),
                );
              }
              if (snapshot.data == null) {
                return const SizedBox();
              }
              return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  final user =
                      UserModel.fromJson(snapshot.data.docs[index].data());
                  return _searchcontroller.text.isNotEmpty
                      ? ListTile(
                          onTap: () async {
                            print(user.hdWalletAddress);
                            //combine users data and my data to a string
                            final convo = await context
                                .read<XMTPProvider>()
                                .newConversation(user.hdWalletAddress);

                            if (convo == null) {
                              log('Conversation is null');
                              return;
                            }

                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => DmScreen(
                                  conversation: convo,
                                ),
                              ),
                            );

                            // Navigator.push(
                            //   context,
                            //   MaterialPageRoute(
                            //     builder: (context) => ChatDmXmtp(
                            //       model: UserModel(
                            //         uid: data['uid'],
                            //         name: data['name'],
                            //         image: data['image'],
                            //         userName: data['userName'],
                            //         searchKeywords: data['searchKeywords'],
                            //       ),
                            //     ),
                            //   ),
                            // );
                          },
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: CachedNetworkImage(
                                imageUrl: user.image,
                                placeholder: (context, url) =>
                                    Center(child: CircularProgressIndicator()),
                                filterQuality: FilterQuality.high,
                                errorWidget: (context, url, error) => Icon(
                                  Icons.person,
                                  color: secondaryColor,
                                ),
                              ),
                            ),
                          ),
                          title: Text(
                            user.name,
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          subtitle: Text('@' + user.userName),
                        )
                      : const SizedBox();
                },
              );
            }),
      ),
    );
  }
}

//
//
// class SearchSearch2 extends StatefulWidget {
//   @override
//   State<SearchSearch2> createState() => _SearchSearch2State();
// }
//
//
// class _SearchSearch2State extends State<SearchSearch2> {
//   final TextEditingController _searchcontroller = TextEditingController();
//   Map userM = Hive.box('beepo').get('userData');
//
//   @override
//   void dispose() {
//     super.dispose();
//     _searchcontroller.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: SocialAppBar(
//         title: SearchBar(
//           controller: _searchcontroller,
//           autofocus: true,
//           onChanged: (value) {
//             setState(() {});
//           },
//         ),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.only(
//           left: 22.0,
//           right: 22.0,
//         ),
//         child: StreamBuilder<QuerySnapshot<Map>>(
//             stream: FirebaseFirestore.instance
//                 .collection("conversation")
//                 .doc(userM['uid'])
//                 .collection('currentConversation')
//                 .where("searchKeywords",
//                     arrayContains: _searchcontroller.text.trim().toLowerCase())
//                 .snapshots(),
//             builder: (context, snapshot) {
//               if (!snapshot.hasData) {
//                 return const Center(
//                   child: CircularProgressIndicator(
//                     color: primaryColor,
//                   ),
//                 );
//               }
//               if (snapshot.data == null) {
//                 return const SizedBox();
//               }
//               return ListView.builder(
//                 itemCount: snapshot.data.docs.length,
//                 itemBuilder: (context, index) {
//                   final data = snapshot.data.docs[index].data();
//                   return _searchcontroller.text.isNotEmpty
//                       ? ListTile(
//                           onTap: () {
//                             Navigator.push(
//                               context,
//                               MaterialPageRoute(
//                                 builder: (context) => ChatDm(
//                                   model: UserModel(
//                                     uid: data['receiver'],
//                                     name: data['displayName'],
//                                     image: data['image'],
//                                     userName: data['name'],
//                                     searchKeywords: data['searchKeywords'],
//                                   ),
//                                 ),
//                               ),
//                             );
//                           },
//                           leading: Container(
//                             width: 46,
//                             height: 46,
//                             decoration: const BoxDecoration(
//                               shape: BoxShape.circle,
//                             ),
//                             child: ClipOval(
//                               child: CachedNetworkImage(
//                                 imageUrl: data['image'],
//                                 placeholder: (context, url) =>
//                                     Center(child: CircularProgressIndicator()),
//                                 errorWidget: (context, url, error) => Icon(
//                                   Icons.person,
//                                   color: secondaryColor,
//                                 ),
//                                 filterQuality: FilterQuality.high,
//                               ),
//                             ),
//                           ),
//                           title: Text(
//                             data['name'],
//                             style: TextStyle(
//                               fontSize: 14,
//                               fontWeight: FontWeight.w600,
//                             ),
//                           ),
//                           // subtitle: Text('@${data['username']}'),
//                         )
//                       : const SizedBox();
//                 },
//               );
//             }),
//       ),
//     );
//   }
// }

class SocialAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SocialAppBar({
    @required this.title,
    this.leading = true,
  });

  final Widget title;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: secondaryColor,
      title: title,
      toolbarHeight: 150,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(20),
        bottomRight: Radius.circular(20),
      )),
      leading: leading
          ? IconButton(
              onPressed: () => Navigator.pop(context),
              icon: Icon(Icons.arrow_back))
          : null,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(50);
}

class SearchBar extends StatelessWidget {
  SearchBar({
    this.ontap,
    this.autofocus = false,
    this.readonly = false,
    this.controller,
    this.onChanged,
  });

  final VoidCallback ontap;
  final bool readonly;
  final bool autofocus;

  final TextEditingController controller;
  final Function(String) onChanged;
  final node1 = FocusNode();
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 32,
      child: TextField(
        cursorColor: Colors.white,
        controller: controller,
        style: TextStyle(color: Colors.white),
        readOnly: readonly,
        autofocus: autofocus,
        focusNode: node1,
        onTap: ontap,
        onChanged: onChanged,
        decoration: customTextFieldDecoration(
          context: context,
          hint: 'search',
          suffixICon: null,
          prefixIcon: const Icon(
            Icons.search_rounded,
            size: 23,
            color: Colors.white,
          ),
          errorText: null,
        ),
      ),
    );
  }
}

class SearchBar2 extends StatefulWidget {
  SearchBar2({
    this.ontap,
    this.autofocus = false,
    this.readonly = false,
    this.controller,
    this.onChanged,
    this.showInput = false,
  });

  final VoidCallback ontap;
  final bool readonly;
  final bool autofocus;
  bool showInput;

  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  State<SearchBar2> createState() => _SearchBar2State();
}

class _SearchBar2State extends State<SearchBar2> {
  final node1 = FocusNode();

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 290,
          height: 32,
          child: TextField(
            // textCapitalization: TextCapitalization.sentences,
            cursorColor: Colors.white,
            onSubmitted: (value) {
              setState(() {
                widget.showInput = !widget.showInput;
              });
            },
            readOnly: widget.readonly,
            autofocus: widget.autofocus,
            focusNode: node1,
            onTap: widget.ontap,
            onChanged: widget.onChanged,
            decoration: InputDecoration(
              border: InputBorder.none,
              contentPadding: EdgeInsets.fromLTRB(15, 2, 0, 2),
              hintText: 'Search messages...',
              hintStyle: TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor.withOpacity(0.10),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: secondaryColor.withOpacity(0.10),
                ),
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            //later check
          ),
        )
      ],
    );
  }
}

customTextFieldDecoration({
  @required BuildContext context,
  @required String hint,
  Widget suffixICon,
  Widget prefixIcon,
  String errorText,
  bool outline = false,
}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: 15,
        fontStyle: FontStyle.italic,
        fontWeight: FontWeight.w400,
        color: Colors.white,
      ),
      suffixIcon: suffixICon,
      prefixIcon: prefixIcon,
      errorText: errorText,
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: outline
          ? OutlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).primaryColorLight, width: 1.0),
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
            )
          : InputBorder.none,
      focusedBorder: outline
          ? OutlineInputBorder(
              borderSide:
                  BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
              borderRadius: const BorderRadius.all(Radius.circular(32.0)),
            )
          : InputBorder.none,
    );
