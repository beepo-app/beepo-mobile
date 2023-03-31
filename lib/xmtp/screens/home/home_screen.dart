import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

import '../../components/conversation_tile.dart';
import '../../components/my_profile_card.dart';
import '../../data/local/messages_store.dart';
import '../../di/injection.dart';
import '../../domain/repository/xmtp_repository.dart';
import '../messages/messages_screen.dart';

GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _editingController = TextEditingController();
  final XmtpRepository _repository = getIt();

  _createNewConversation() async {
    var conversation = await _repository.createConversation(
      _editingController.text,
    );
    if (mounted) {
      Navigator.push(context, MaterialPageRoute(builder: (context) {
        return MessagesScreen(conversation: conversation);
      }));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text("Conversations"),
      ),
      body: Observer(
        builder: (context) {
          if (store.conversations.isEmpty) {
            return Column(
              children: [
                ListView(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyProfileCard(address: _repository.getMyAddress()),
                    ),
                  ],
                ),
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.only(bottom: 72),
                    child: const Center(
                      child: Text("No conversations"),
                    ),
                  ),
                ),
              ],
            );
          }

          return ListView.builder(
            itemCount: store.conversations.length,
            itemBuilder: (context, index) {
              var conversation = store.conversations[index];

              if (index == 0) {
                return Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: MyProfileCard(address: _repository.getMyAddress()),
                    ),
                    ConversationTile(conversation: conversation)
                  ],
                );
              }

              return ConversationTile(conversation: conversation);
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
            context: _scaffoldKey.currentContext ?? context,
            builder: (context) {
              return AlertDialog(
                title: const Text("New Conversation"),
                content: TextField(
                  controller: _editingController,
                  decoration: const InputDecoration(hintText: "To address"),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: _createNewConversation,
                    child: const Text("Create"),
                  ),
                ],
              );
            },
          );
        },
        child: const Icon(Icons.person_add),
      ),
    );
  }
}
