import 'package:hotel_finder/src/firebase/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCollection{
  AuthenticationService authenticationService=AuthenticationService();
  final CollectionReference usersCollection=FirebaseFirestore.instance.collection("Users");
  Future<void> CreateUserData(String name,String email,String uid) async{
    try{
      await usersCollection.add({
      'Name':name,
      'Email':email,
       'Uid':uid
      });
    }
    catch(e){
      print('Error creating user data: $e');
    }
  }
  Future<Map<String, dynamic>> getUsersDetails() async {
    String uid = authenticationService.getCurrentUser()!.uid;

    try {
      print(uid);
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection('Users')
          .where('UId', isEqualTo: uid)
          .get();

      if (querySnapshot.docs.length > 0) {
        return querySnapshot.docs[0].data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error getting users list: $e');
      // Handle error here, such as showing an error message.
      return {};
    }
  }

}