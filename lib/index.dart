// import 'dart:async';
//
// import 'package:agora_rtc_engine/rtc_engine.dart';
// import 'package:flutter/material.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'Screens/Messaging/calls/calls.dart';
// import 'Utils/styles.dart';
//
// class IndexPage extends StatefulWidget {
//   const IndexPage({Key key}) : super(key: key);
//
//   @override
//   State<IndexPage> createState() => _IndexPageState();
// }
//
// class _IndexPageState extends State<IndexPage> {
//
//   final _channelController = TextEditingController();
//   bool _validateError = false;
//   ClientRole _role = ClientRole.Broadcaster;
//   Future<void> _handleCameraAndMic(Permission permission) async {
//     final status = await permission.request();
//     print(status);
//   }
//   Future<void> onJoin() async {
//     // update input validation
//     setState(() {
//       _channelController.text.isEmpty
//           ? _validateError = true
//           : _validateError = false;
//     });
//     // if (_channelController.text.isNotEmpty) {
//       await _handleCameraAndMic(Permission.camera);
//       await _handleCameraAndMic(Permission.microphone);
//       await Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (context) =>  VideoCall(
//             channelName: 'hackAngel',
//             role: ClientRole.Broadcaster,
//           ),
//         ),
//       );
//     // }
// }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // appBar: AppBar(
//       //   automaticallyImplyLeading: false,
//       //   title: const Text('Video call'),
//       //   centerTitle: true,
//       //   backgroundColor: secondaryColor,
//       // ),
//       body: Center(
//         child: Container(
//           padding: const EdgeInsets.symmetric(horizontal: 20),
//           height: 400,
//           child: Column(
//             children: <Widget>[
//               Row(
//                 children: <Widget>[
//                   Expanded(
//                       child: TextField(
//                         controller: _channelController,
//                         decoration: InputDecoration(
//                           errorText:
//                           _validateError ? 'Channel name is mandatory' : null,
//                           border: const UnderlineInputBorder(
//                             borderSide: BorderSide(width: 1),
//                           ),
//                           hintText: 'Channel name',
//                         ),
//                       ))
//                 ],
//               ),
//               Column(
//                 children: [
//                   ListTile(
//                     title: Text(ClientRole.Broadcaster.toString()),
//                     leading: Radio(
//                       value: ClientRole.Broadcaster,
//                       groupValue: _role,
//                       onChanged: (ClientRole value) {
//                         setState(() {
//                           _role = value;
//                         });
//                       },
//                     ),
//                   ),
//                   ListTile(
//                     title: Text(ClientRole.Audience.toString()),
//                     leading: Radio(
//                       value: ClientRole.Audience,
//                       groupValue: _role,
//                       onChanged: (ClientRole value) {
//                         setState(() {
//                           _role = value;
//                         });
//                       },
//                     ),
//                   )
//                 ],
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 20),
//                 child: Row(
//                   children: <Widget>[
//                     Expanded(
//                       child: TextButton(
//                         onPressed: onJoin,
//                         child: const Text('Join'),
//                         style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 40)),
//                         // color: Colors.blueAccent,
//                         // textColor: Colors.white,
//                       ),
//                     )
//                   ],
//                 ),
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//
//   }
// }
