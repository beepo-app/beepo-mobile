// ignore_for_file: prefer_const_constructors

import 'package:beepo/Models/user_model.dart';
import 'package:beepo/Screens/Messaging/chat_dm_screen.dart';
import 'package:beepo/Utils/styles.dart';
import 'package:beepo/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void displaySnack(BuildContext context, String text) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    content: Text(
      text,
      style: TextStyle(color: Theme.of(context).primaryColor),
    ),
    action: SnackBarAction(
        label: 'Dismiss',
        textColor: Colors.pink,
        onPressed: () {
          ScaffoldMessenger.of(context).removeCurrentSnackBar();
        }),
  ));
}

class MySearchDelegate extends SearchDelegate {
  MySearchDelegate({@required this.listong});

  final List<String> listong;

  @override
  Widget buildLeading(BuildContext context) => IconButton(
      onPressed: () => close(context, null),
      icon: const Icon(
        Icons.arrow_back,
        color: Colors.pink,
      ));

  @override
  List<Widget> buildActions(BuildContext context) => [
        IconButton(
            onPressed: () {
              if (query.isEmpty) {
                close(context, null);
              } else {
                query = '';
              }
            },
            icon: Icon(Icons.clear)),
      ];

  @override
  Widget buildResults(BuildContext context) => ChatDm(
        model: UserModel(
          uid: context.read<ChatNotifier>().chosen['uid'],
          name: context.read<ChatNotifier>().chosen['name'],
          image: context.read<ChatNotifier>().chosen['image'],
          searchKeywords: context.read<ChatNotifier>().chosen['searchKeywords'],
          userName: context.read<ChatNotifier>().chosen['userName'],
        ),
      );

  @override
  Widget buildSuggestions(BuildContext context) {
    List<String> searchResults = listong;
    try {
      List<String> suggestions = searchResults.where((searchResults) {
        final result = searchResults.toLowerCase();
        final input = query.toLowerCase();

        return result.contains(input);
      }).toList();

      return StreamBuilder(
          stream: FirebaseFirestore.instance
              .collection('users')
              .where('name'.toLowerCase(), isEqualTo: query.toLowerCase())
              .snapshots(),
          builder: (context, AsyncSnapshot snapshot) {
            return ListView.builder(
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  if (!snapshot.hasData) {
                    return const SizedBox();
                  }
                  if (snapshot.data == null) {
                    return const SizedBox();
                  }
                  return ListTile(
                    onTap: () {
                      query = suggestion;
                      context.read<ChatNotifier>().getUsers(UserModel(
                            uid: snapshot.data.docs[index].id,
                            name: suggestion,
                            image: snapshot.data.docs[index]['image'],
                            searchKeywords: snapshot.data.docs[index]
                                ['searchKeywords'],
                            userName: snapshot.data.docs[index]['userName'],
                          ));
                      showResults(context);
                    },
                    leading: Container(
                      width: 46,
                      height: 46,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                      ),
                      child: ClipOval(
                        child:
                            Image.network(snapshot.data.docs[index]['image']),
                      ),
                    ),
                    title: Text(
                      suggestion,
                      // style: chatAuthorTextStyle,
                    ),
                    // subtitle: Text('@${data['username']}'),
                  );
                });
          });
    } catch (e) {
      print(e);
    }
    return Center(
      child: CircularProgressIndicator(
        color: primaryColor,
      ),
    );
  }
}
