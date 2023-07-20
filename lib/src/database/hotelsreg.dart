import 'package:cloud_firestore/cloud_firestore.dart';

class hotelregistration{
  final CollectionReference hotelregcollection=FirebaseFirestore.instance.collection("hotelreg");
  final CollectionReference reportcollection=FirebaseFirestore.instance.collection("Reported");
  final CollectionReference likecollection=FirebaseFirestore.instance.collection("Favourites");
  final CollectionReference likescollection=FirebaseFirestore.instance.collection("Likes");
  Future<void> regHotel(String name,String manager,String email,String number,String city) async{
    try{
      await hotelregcollection.add({
        'Hotel_name':name,
        'Manager_name':manager,
        'Contact':email,
        'Mobile':number,
        'Location':city
      });
    }catch(e){
      print(e.toString());
    }
  }
  Future reportHotel(String name,String manager) async{
    try{
      await reportcollection.add({
        'Hotel_name':name,
        'Manager_name':manager,
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> likehotel(String name, String manager, String userId) async {
    try {
      // Get the reference to the 'users' collection
      final usersCollection = FirebaseFirestore.instance.collection('Users');

      // Query to get the user document where the 'uid' field matches the given userId
      final querySnapshot = await usersCollection.where('Uid', isEqualTo: userId).get();

      // Check if the user document with the matching userId field exists
      if (querySnapshot.docs.isNotEmpty) {
        final userDocument = querySnapshot.docs.first.reference;

        // Create a new sub-collection 'Favourites' inside the user's document
        final userFavouritesCollection = userDocument.collection('Favourites');

        // Add the data to the 'Favourites' collection
        await userFavouritesCollection.add({
          'Hotel_name': name,
          'Manager_name': manager,
        });

        print('Data added to Favourites collection for user with uid $userId.');
      } else {
        print('User with uid $userId not found.');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  Future<void> addlikes(String userId,String hotelId) async {
    try {
      // Get the reference to the 'users' collection
      final usersCollection = FirebaseFirestore.instance.collection('Hotels');

      // Query to get the user document where the 'uid' field matches the given userId
      final querySnapshot = await usersCollection.where(
          'Uid', isEqualTo: userId).get();

      // Check if the user document with the matching userId field exists
      if (querySnapshot.docs.isNotEmpty) {
        final userDocument = querySnapshot.docs.first.reference;

        // Create a new sub-collection 'Favourites' inside the user's document
        final userFavouritesCollection = userDocument.collection('Favourites');

        // Add the data to the 'Favourites' collection
        await userFavouritesCollection.add({
          'User': userId,
        });

        print('Data added to Favourites collection for user with uid $userId.');
      } else {
        print('User with uid $userId not found.');
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }
}