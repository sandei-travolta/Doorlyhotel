import 'package:async/async.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
class MessagingService {
  Future<void> createConversation(String conversationId, List<String> participants) async {
    try {
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).set({
        'participants': participants,
      });
      print('Conversation created successfully.');
    } catch (e) {
      print('Error creating conversation: ${e.toString()}');
    }
  }

  Future<void> sendMessage(String conversationId, String message, DateTime time, String from, String to) async {
    try {
      // Save the message in the 'messages' subcollection under the given conversation ID
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).collection('messages').add({
        'message': message,
        'time': time,
        'from': from,
        'to': to,
        'timestamp': FieldValue.serverTimestamp(), // Add a timestamp for when the message was sent
      });

      // Update the 'chathotels' subcollection in the 'hotel' collection for both sender and receiver users
      await FirebaseFirestore.instance.collection('Users').doc(to).collection('chathotels').doc(conversationId).set({
        'conversationId': conversationId,
        'lastMessage': message,
        'lastMessageTime': time,
      });

      await FirebaseFirestore.instance.collection('Hotels').doc(to).collection('chathotels').doc(conversationId).set({
        'conversationId': conversationId,
        'lastMessage': message,
        'lastMessageTime': time,
      });

      // Create the conversation if it does not exist
      final conversationSnapshot = await FirebaseFirestore.instance.collection('chats').doc(conversationId).get();
      if (!conversationSnapshot.exists) {
        await createConversation(conversationId, [from, to]);
      }

      print('Message sent successfully.');
    } catch (e) {
      print('Error sending message: ${e.toString()}');
    }
  }



  // Helper method to get the conversation ID based on the sender and receiver IDs
  String getConversationID(String id1, String id2) {
    return id1.hashCode <= id2.hashCode ? '$id1-$id2' : '$id2-$id1';
  }
  Stream<List<String>> getUserChatParticipants(String currentUserId) {
    try {
      final chatsCollectionRef = FirebaseFirestore.instance.collection('chats');

      final fromQuery = chatsCollectionRef
          .where('from', isEqualTo: currentUserId)
          .orderBy('time', descending: true)
          .snapshots();

      final toQuery = chatsCollectionRef
          .where('to', isEqualTo: currentUserId)
          .orderBy('time', descending: true)
          .snapshots();

      // Combine the results of the 'from' and 'to' queries
      final combinedStream = StreamGroup.merge([fromQuery, toQuery]);

      return combinedStream.map((querySnapshot) {
        // Collect the user IDs of participants from 'from' and 'to' fields
        final List<String> participants = [];
        for (final doc in querySnapshot.docs) {
          final fromUserId = doc.data()['from'];
          final toUserId = doc.data()['to'];
          if (fromUserId != currentUserId) {
            participants.add(fromUserId);
          }
          if (toUserId != currentUserId) {
            participants.add(toUserId);
          }
        }
        // Remove duplicates from the participants list
        final uniqueParticipants = participants.toSet().toList();
        return uniqueParticipants;
      });
    } catch (e) {
      print('Error retrieving chat participants: $e');
      // Handle the error gracefully
      return Stream.value([]);
    }
  }

  Stream<List<Map<String, dynamic>>> getConversationsWithUser(String userId) {
    try {
      final userChatsRef =
      FirebaseFirestore.instance.collection('Users').doc(userId).collection('chathotels');

      return userChatsRef.snapshots().asyncMap((querySnapshot) async {
        List<Map<String, dynamic>> conversations = [];
        for (var chat in querySnapshot.docs) {
          final Map<String, dynamic> conversationData = chat.data();
          final String conversationId = conversationData['conversationId'];

          final conversationSnapshot =
          await FirebaseFirestore.instance.collection('chats').doc(conversationId).get()
          as QueryDocumentSnapshot<Map<String, dynamic>>?;

          if (conversationSnapshot != null && conversationSnapshot.exists) {
            conversations.add(conversationSnapshot.data());
          }
        }

        return conversations;
      });
    } catch (e) {
      print('Error fetching conversations: ${e.toString()}');
      return Stream.value([]);
    }
  }


  // Helper method to get the ID of the other participant in the conversation
  Future<Map<String, dynamic>> getUsersDetails(List<String> userIds) async {
    try {
      final usersCollectionRef = FirebaseFirestore.instance.collection('Users');
      final hotelsCollectionRef = FirebaseFirestore.instance.collection('Hotels');

      final List<Future<DocumentSnapshot<Map<String, dynamic>>>> documentFutures = [];

      // Fetch documents for each user ID from both collections using the 'where' clause
      for (final userId in userIds) {
        final userDocumentFuture = usersCollectionRef.where('Uid', isEqualTo: userId).limit(1).get().then((value) => value.docs.isNotEmpty ? value.docs.first : null);
        final hotelDocumentFuture = hotelsCollectionRef.where('Uid', isEqualTo: userId).limit(1).get().then((value) => value.docs.isNotEmpty ? value.docs.first : null);

        // Add both futures to the list of document futures
        documentFutures.add(userDocumentFuture as Future<DocumentSnapshot<Map<String, dynamic>>>);
        documentFutures.add(hotelDocumentFuture as Future<DocumentSnapshot<Map<String, dynamic>>>);
      }

      // Wait for all futures to complete and get the user and hotel documents
      final List<DocumentSnapshot<Map<String, dynamic>>> documents = await Future.wait(documentFutures);

      // Create a map to store user details with user ID as the key
      final Map<String, dynamic> userDetailsMap = {};

      // Extract user details from the documents and store in the map
      for (int i = 0; i < documents.length; i++) {
        final DocumentSnapshot<Map<String, dynamic>> document = documents[i];
        final String userId = userIds[i];
        if (document != null && document.exists) {
          final Map<String, dynamic>? userData = document.data();
          userDetailsMap[userId] = userData;
        }
      }

      return userDetailsMap;
    } catch (e) {
      print('Error fetching user details: $e');
      throw e;
    }
  }
}
