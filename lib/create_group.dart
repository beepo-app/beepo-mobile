import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CreateGroup extends StatefulWidget {
  // const CreateGroup({Key key}) : super(key: key);
  final List<Map<String, dynamic>> membersList;

  const CreateGroup({Key key, @required this.membersList}) : super(key: key);

  @override
  State<CreateGroup> createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  bool isLoading = false;

  void createGroup() async {
    setState(() {
      isLoading = true;
    });
    await _firestore.collection('groups').doc('this').set({
      "members" : widget.membersList,
      "id": "this",
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
