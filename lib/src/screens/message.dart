import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/colors.dart';
import 'package:hotel_finder/src/database/hotels.dart';
import 'package:hotel_finder/src/database/messages.dart';


import '../firebase/auth_service.dart';


class MessageScreen extends StatefulWidget {
  final String hotelName;
  final String hotelId;

  const MessageScreen({required this.hotelName, required this.hotelId, required id});

  @override
  State<MessageScreen> createState() => _MessageScreenState();
}
class _MessageScreenState extends State<MessageScreen> {
  Hoteldatabase hoteldatabase=Hoteldatabase();
  final TextEditingController _messageController = TextEditingController();
  AuthenticationService authenticationService=AuthenticationService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String currentUserId = "";
   // Replace this with the current user's ID
  void initState() {
    super.initState();
    final AuthenticationService authenticationService = AuthenticationService();
    final User? currentUser = authenticationService.getCurrentUser();
    if (currentUser != null) {
      currentUserId = currentUser.uid;
      print(currentUserId);
    }
  }

  void _sendMessage() async {
    final String message = _messageController.text.trim();
    if (message.isNotEmpty) {
      await hoteldatabase.messageHotel(message,DateTime.now(),currentUserId, widget.hotelId);
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        elevation: 0,
        title: Text('Message ${widget.hotelName}'),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: _firestore
                  .collection('chats')
                  .doc(MessagingService().getConversationID(currentUserId, widget.hotelId))
                  .collection('messages')
                  .orderBy('time')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final messages = snapshot.data?.docs;
                  List<Widget> messageWidgets = [];
                  for (var message in messages!) {
                    final messageText = message['message'];
                    final messageSender = message['from'];

                    final messageWidget = MessageBubble(
                      message: messageText,
                      isMe: messageSender == currentUserId,
                    );

                    messageWidgets.add(messageWidget);
                  }
                  return ListView(
                    children: messageWidgets,
                  );
                } else {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    decoration: InputDecoration(hintText: 'Enter your message...'),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: _sendMessage,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;

  MessageBubble({required this.message, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
      child: Align(
        alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
          decoration: BoxDecoration(
            color: isMe ? Colors.blue : Colors.grey[300],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Text(
            message,
            style: TextStyle(
              color: isMe ? Colors.white : Colors.black,
              fontSize: 16.0,
            ),
          ),
        ),
      ),
    );
  }
}

