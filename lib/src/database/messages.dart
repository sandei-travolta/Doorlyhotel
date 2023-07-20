import 'package:cloud_firestore/cloud_firestore.dart';
class MessagingService {
  // For sending a message to a user or hotel
  Future<void> sendMessage(String conversationId, String message, DateTime time, String from, String to) async {
    try {
      // Save the message in the 'messages' subcollection under the given conversation ID
      await FirebaseFirestore.instance.collection('chats').doc(conversationId).collection('messages').add({
        'message': message,
        'time': time,
        'from': from,
        'to': to,
      });

      final usersCollection = FirebaseFirestore.instance.collection('Users');

      // Create a query for documents where the 'Uid' field equals 'from' value
      final querySnapshot = await usersCollection.where('Uid', isEqualTo: from).get();

      if (querySnapshot.docs.isNotEmpty) {
        final fromDocumentRef = querySnapshot.docs.first.reference;

        // Check if the 'messages' subcollection exists in the 'from' document
        final messagesCollection = fromDocumentRef.collection('messages');
        final toDocumentSnapshot = await messagesCollection.doc(to).get();

        if (!toDocumentSnapshot.exists) {
          // Create an empty document with the 'to' value (user ID) as the document ID
          await messagesCollection.doc(to).set({});
          print('Message sent successfully.');
        } else {
          print('Message already exists for this user.');
        }
      } else {
        print('User document with "Uid" equal to "from" does not exist.');
      }
    } catch (e) {
      print('Error sending message: ${e.toString()}');
    }
  }
  // For getting all messages of a specific conversation from Firestore database
  Stream<QuerySnapshot<Map<String, dynamic>>> getAllMessages(String conversationId) {
    return FirebaseFirestore.instance
        .collection('chats')
        .doc(conversationId)
        .collection('messages')
        .orderBy('time', descending: true)
        .snapshots();
  }

  // Helper method to get the conversation ID based on the sender and receiver IDs
  String getConversationID(String id1, String id2) {
    return id1.hashCode <= id2.hashCode ? '$id1-$id2' : '$id2-$id1';
  }
}
