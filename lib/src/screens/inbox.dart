import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../database/messages.dart';

import 'package:flutter/material.dart';

import 'message.dart';
class ChatListScreen extends StatelessWidget {
  final String currentUserId;
  ChatListScreen(this.currentUserId);
  final messagingService = MessagingService();

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<Map<String, dynamic>>>(
      stream: messagingService.getConversationsWithUser(currentUserId),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // While data is being fetched, show a loading indicator.
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        if (snapshot.hasError) {
          // If there's an error while fetching data, show an error message.
          return Center(
            child: Text('Error retrieving conversations'),
          );
        }

        // Retrieve the conversations data from the snapshot.
        final List<Map<String, dynamic>> conversations = snapshot.data ?? [];

        return FutureBuilder<Map<String, dynamic>>(
          future: messagingService.getUsersDetails(getParticipantsIds(conversations)),
          builder: (context, userDetailsSnapshot) {
            if (userDetailsSnapshot.connectionState == ConnectionState.waiting) {
              // While user details are being fetched, show a loading indicator.
              return Center(
                child: CircularProgressIndicator(),
              );
            }

            if (userDetailsSnapshot.hasError) {
              // If there's an error while fetching user details, show an error message.
              return Center(
                child: Text('Error retrieving user details'),
              );
            }

            // Retrieve user details map from the snapshot.
            final Map<String, dynamic> userDetailsMap = userDetailsSnapshot.data ?? {};

            return ListView.builder(
              itemCount: conversations.length,
              itemBuilder: (context, index) {
                final Map<String, dynamic> conversationData = conversations[index];
                final String conversationId = conversationData['conversationId'];
                final String lastMessage = conversationData['lastMessage'];
                final DateTime lastMessageTime = DateTime.fromMillisecondsSinceEpoch(conversationData['lastMessageTime']);

                // Get the participant IDs and extract their names from userDetailsMap
                final List<String> participantIds = getParticipantsIds([conversationData]);
                final String otherParticipantId = participantIds.firstWhere((id) => id != currentUserId, orElse: () => '');
                final String otherParticipantName = userDetailsMap[otherParticipantId]?['displayName'] ?? 'Unknown'; // Replace 'displayName' with the correct field for the name

                return ListTile(
                  title: Text(otherParticipantName), // Display the other participant's name
                  subtitle: Text(lastMessage),
                  onTap: () {
                    // When a conversation is tapped, navigate to the ConversationScreen with the conversation ID.
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ConversationScreen(conversationId),
                      ),
                    );
                  },
                );
              },
            );
          },
        );
      },
    );
  }

  // Helper method to extract participant IDs from the conversations data
  List<String> getParticipantsIds(List<Map<String, dynamic>> conversations) {
    final List<String> participantIds = [];
    for (final conversationData in conversations) {
      final List<String> participants = conversationData['participants']?.cast<String>() ?? [];
      participantIds.addAll(participants);
    }
    return participantIds.toSet().toList();
  }
}

class ConversationScreen extends StatelessWidget {
  final String conversationId; // The ID of the conversation to display

  ConversationScreen(this.conversationId);

  @override
  Widget build(BuildContext context) {
    // Implement the UI to display the messages of the conversation
    // You can use a StreamBuilder to listen for new messages in real-time
    // and display the list of messages accordingly.
    // You can also implement the UI for sending new messages in this screen.

    return Scaffold(
      appBar: AppBar(
        title: Text('Conversation'),
      ),
      body: Center(
        child: Text('Conversation screen for ID: $conversationId'),
      ),
    );
  }
}


