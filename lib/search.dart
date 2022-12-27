// ignore_for_file: prefer_const_constructors, use_key_in_widget_constructors

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/Service/auth.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchSearch extends StatefulWidget {
  @override
  State<SearchSearch> createState() => _SearchSearchState();
}

class _SearchSearchState extends State<SearchSearch> {
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
                  final data = snapshot.data.docs[index].data();
                  return _searchcontroller.text.isNotEmpty
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ChatDm(
                                          model: UserModel(
                                            uid: data['uid'],
                                            name: data['name'],
                                            image: data['image'],
                                            userName: data['userName'],
                                            searchKeywords:
                                                data['searchKeywords'],
                                          ),
                                        )));
                          },
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(data['image']),
                            ),
                          ),
                          title: Text(
                            data['userName'],
                            style: TextStyle(
                                fontSize: 14, fontWeight: FontWeight.w600),
                          ),
                          // subtitle: Text('@${data['username']}'),
                        )
                      : const SizedBox();
                },
              );
            }),
      ),
    );
  }
}

class SearchSearch2 extends StatefulWidget {
  @override
  State<SearchSearch2> createState() => _SearchSearch2State();
}

class _SearchSearch2State extends State<SearchSearch2> {
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
                .collection("conversation")
                .doc(AuthService().uid)
                .collection('currentConversation')
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
                  final data = snapshot.data.docs[index].data();
                  return _searchcontroller.text.isNotEmpty
                      ? ListTile(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => ChatDm(
                                  model: UserModel(
                                    uid: data['receiver'],
                                    name: data['displayName'],
                                    image: data['image'],
                                    userName: data['name'],
                                    searchKeywords: data['searchKeywords'],
                                  ),
                                ),
                              ),
                            );
                          },
                          leading: Container(
                            width: 46,
                            height: 46,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                            ),
                            child: ClipOval(
                              child: Image.network(data['image']),
                            ),
                          ),
                          title: Text(
                            data['name'],
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          // subtitle: Text('@${data['username']}'),
                        )
                      : const SizedBox();
                },
              );
            }),
      ),
    );
  }
}

class SocialAppBar extends StatelessWidget implements PreferredSizeWidget {
  const SocialAppBar({
    @required this.title,
    this.leading = true,
  }) ;
  final Widget title;
  final bool leading;

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: primaryColor,
      title: title,
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
  const SearchBar({
    this.ontap,
    this.autofocus = false,
    this.readonly = false,
    this.controller,
    this.onChanged,
  }) ;

  final VoidCallback ontap;
  final bool readonly;
  final bool autofocus;
  final TextEditingController controller;
  final Function(String) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 271,
          height: 32,
          child: TextField(
            controller: controller,
            readOnly: readonly,
            autofocus: autofocus,
            onTap: ontap,
            onChanged: onChanged,
            decoration: customTextFieldDecoration(
              context: context,
              hint: 'search',
              suffixICon: null,
              prefixIcon: const Icon(Icons.search_rounded),
              errorText: null,
            ),
          ),
        )
      ],
    );
  }
}

customTextFieldDecoration(
        {@required BuildContext context,
        @required String hint,
        Widget suffixICon,
        Widget prefixIcon,
        String errorText}) =>
    InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
          fontSize: 14,
          fontStyle: FontStyle.italic,
          fontWeight: FontWeight.w400),
      suffixIcon: suffixICon,
      prefixIcon: prefixIcon,
      errorText: errorText,
      contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 25.0),
      border: const OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      enabledBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColorLight, width: 1.0),
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide:
            BorderSide(color: Theme.of(context).primaryColor, width: 1.5),
        borderRadius: const BorderRadius.all(Radius.circular(32.0)),
      ),
    );
