import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/src/screens/widgets.dart';

import '../database/hotels.dart';
import '../database/messages.dart';
import '../firebase/auth_service.dart';
import 'message.dart';
class Inbox extends StatelessWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

/*c*//*lass Inbox extends StatefulWidget {
  const Inbox({Key? key}) : super(key: key);

  @override
  State<Inbox> createState() => _InboxState();
}

class _InboxState extends State<Inbox> {
  final firebase=FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: Container(

            child: StreamBuilder(
              stream: firebase.collection("chats").snapshots(),
              builder: (context,AsyncSnapshot<QuerySnapshot> snapshot) {
                List data=!snapshot.hasData?[]:snapshot.data!.docs.where((element) => element['Users'].toString().contains(FirebaseAuth.instance.currentUser!.uid)).toList();
                return ListView.builder(
                  itemCount: data.length,
                  reverse: true,
                  itemBuilder: (context, i) {
                    List users=data[i]['users'];
                    var chats=users.where((element) => element!=FirebaseAuth.instance.currentUser!.uid);
                    var user=chats.isNotEmpty? chats.first:users.where((element) => element == FirebaseAuth.instance.currentUser!.uid).first;
                    return FutureBuilder(
                      future: firebase.collection('users').doc().get(),
                      builder: (context,AsyncSnapshot snap) {
                        return !snap.hasData? Container():ChatWidgets.card(
                          title: snap.data['name'],
                          subtitle: data[i]['last_message'],
                          time: '04:40',
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) {
                                  return  MessageScreen(
                                    id: user,
                                  );
                                },
                              ),
                            );
                          },
                        );
                      }
                    );
                  },
                );
              }
            ),
          ),
        ),
      ],
    );
  }
}
*/