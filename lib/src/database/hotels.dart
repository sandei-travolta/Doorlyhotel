import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future blockHotel(String name,String manager)async{
    try{
      await hotelregistration().reportHotel(name,manager);

    }catch(e){
      print("error,not working here");
      print(e.toString());
    }
  }
  Future likeHotel(String name,String manager,String uid)async{
    try{
      await hotelregistration().likehotel(name,manager,uid);

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

}