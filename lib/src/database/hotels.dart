import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:hotel_finder/src/database/hotelsreg.dart';
import 'package:hotel_finder/src/database/messages.dart';

class Hoteldatabase{
  Future getHotels() async {
    List hotelsList = [];
    try {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Hotels')
          .get();

      querySnapshot.docs.forEach((document) {
        hotelsList.add(document.data());
      });

      return hotelsList;
    } catch (e) {
      print('Error getting users list: $e');
      // Handle error here, such as showing an error message.
      return [];
    }
  }
  Future blockHotel(String name,String manager,String email,String number,String city,String desription,String image,String image1,String image2,String image3,String hid)async{
    try{
      await hotelregistration().reportHotel(name,manager,email,number,city,desription,image,image1,image2,image3,hid);

    }catch(e){
      print("error,not working here");
      print(e.toString());
    }
  }
  Future likeHotel(String name,String manager,String email,String number,String city,String desription,String image,String image1,String image2,String image3,String uid,String hid)async{
    try{
      await hotelregistration().likehotel(name,manager,email,number,city,desription,image,image1,image2,image3,uid,hid);

    }catch(e){
      print("error,not working here");
      print(e.toString());
    }
  }
  String getConversationID(String from, String to) {
    // Assuming you have some logic to determine the smaller and larger user ID (alphabetically or numerically)
    String smallerId = (from.compareTo(to) < 0) ? from : to;
    String largerId = (from.compareTo(to) < 0) ? to : from;

    // Combine the two user IDs to create a unique conversation ID
    return '$smallerId-$largerId';
  }

  Future<void> messageHotel(String message, DateTime time, String from, String to) async {
    try {
      // Assuming you have already retrieved the conversationId based on the 'from' and 'to' values
      String conversationId = MessagingService().getConversationID(from, to);

      // Use the sendMessage method from MessagingService to send the message
      await MessagingService().sendMessage(conversationId, message, time, from, to);

      print('Message sent to hotel successfully.');
    } catch (e) {
      print('Error sending message to hotel: ${e.toString()}');
    }
  }

  Future<List<Map<String, dynamic>>> getFavourites() async {
    List<Map<String, dynamic>> favouritesList = [];
    try {
      // Get the current logged-in user
      User? currentUser = FirebaseAuth.instance.currentUser;

      if (currentUser != null) {
        String userUid = currentUser.uid;

        // Fetch the user document that has a Uid field matching the current user's UID
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('Users')
            .where('Uid', isEqualTo: userUid)
            .limit(1) // Assuming there's only one document with a matching Uid
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          DocumentSnapshot userSnapshot = querySnapshot.docs.first;

          // Get a reference to the "favourites" subcollection inside the user document
          CollectionReference favouritesCollectionRef =
          userSnapshot.reference.collection('Favourites');

          // Fetch the documents inside the "favourites" subcollection
          QuerySnapshot favouritesSnapshot = await favouritesCollectionRef.get();

          // Process the documents inside the "favourites" subcollection
          favouritesSnapshot.docs.forEach((document) {
            Map<String, dynamic> data = document.data() as Map<String, dynamic>;
            favouritesList.add(data);
          });
        }
      }

      return favouritesList;
    } catch (e) {
      print('Error getting favourites list: $e');
      // Handle error here, such as showing an error message.
      return [];
    }
  }
}