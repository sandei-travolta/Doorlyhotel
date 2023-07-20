import 'package:cloud_firestore/cloud_firestore.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, String>?> getNameAndUid(String userId) async {
    try {
      DocumentSnapshot snapshot = await _firestore.collection('Users').doc(userId).get();

      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
        String name = data['Name'];
        String Uid = data['Uid'];

        return {
          'name': name,
          'Uid': Uid,
        };
      } else {
        return null; // User document does not exist
      }
    } catch (e) {
      print('Error fetching user data: $e');
      return null;
    }
  }
}