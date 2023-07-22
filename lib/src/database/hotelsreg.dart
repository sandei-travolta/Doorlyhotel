import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

class hotelregistration{
  final CollectionReference hotelregcollection=FirebaseFirestore.instance.collection("hotelreg");
  final CollectionReference reportcollection=FirebaseFirestore.instance.collection("Reported");
  final CollectionReference likecollection=FirebaseFirestore.instance.collection("Favourites");
  final CollectionReference likescollection=FirebaseFirestore.instance.collection("Likes");
  static UploadTask? uploadFile(String destination,File file){

    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  static UploadTask? uploadFile1(String destination,File file){

    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  static UploadTask? uploadFile2(String destination,File file){

    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      print(e.toString());
      return null;
    }
  }
  static UploadTask? uploadFile3(String destination,File file){

    try{
      final ref = FirebaseStorage.instance.ref(destination);
      return ref.putFile(file);
    }
    catch(e){
      print(e.toString());
      return null;
    }

  }
  Future<void> regHotel(String name,String manager,String email,String number,String city,String desription,String image,String image1,String image2,String image3) async{
    try{
      await hotelregcollection.add({
        'Hotel_name':name,
        'Manager_name':manager,
        'Contact':email,
        'Mobile':number,
        'Location':city,
        'image':image,
        'image1':image1,
        'image2':image2,
        'image3':image3,
        'description': desription
      });
    }catch(e){
      print(e.toString());
    }
  }
  Future reportHotel(String name,String manager,String email,String number,String city,String desription,String image,String image1,String image2,String image3,String uid) async{
    try{
      await reportcollection.add({
        'Hotel_name':name,
        'Manager_name':manager,
        'Contact':email,
        'Mobile':number,
        'Location':city,
        'image':image,
        'image1':image1,
        'image2':image2,
        'image3':image3,
        'description': desription,
        'Uid':uid
      });
    }catch(e){
      print(e.toString());
    }
  }

  Future<void> likehotel(String name,String manager,String email,String number,String city,String desription,String image,String image1,String image2,String image3, String userId,String uid) async {
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
          'Hotel_name':name,
          'Manager_name':manager,
          'Contact':email,
          'Mobile':number,
          'Location':city,
          'image':image,
          'image1':image1,
          'image2':image2,
          'image3':image3,
          'description': desription,
          'Uid':uid
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