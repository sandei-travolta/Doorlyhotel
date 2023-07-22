import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../database/users.dart';
import 'package:http/http.dart' as http;

class AuthenticationService{
  final FirebaseAuth _auth=FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  Future loginuser(String email,String password) async{
    try{
      UserCredential result=await _auth.signInWithEmailAndPassword(email: email, password: password);
      return result.user;
    }
    catch(e){
      print(e.toString());
    }
  }
  Future registerUser(String name,String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await UserCollection().CreateUserData(name,email,result.user!.uid);
      return result.user!.uid;
    }
    catch (e) {
      print(e.toString());
    }
  }


  Future signOut() async{
    try{
      await _auth.signOut();
    }
    catch(e){
      print(e.toString());
    }
  }
  User? getCurrentUser(){
    return FirebaseAuth.instance.currentUser;
  }
  Future signInWithFacebook() async {
    try {
      // Perform the Facebook login
      final LoginResult result = await FacebookAuth.instance.login();

      // Check if the Facebook login was successful
      if (result.status == LoginStatus.success) {
        // Fetch the user's profile information from Facebook's Graph API
        final graphResponse = await http.get(Uri.parse(
            'https://graph.facebook.com/v2.12/me?fields=name,picture.width(800).height(800),first_name,last_name,email&access_token=${result.accessToken!.token}'));

        final profile = jsonDecode(graphResponse.body);

        // Sign in with Firebase using the obtained Facebook access token
        final OAuthCredential credential =
        FacebookAuthProvider.credential(result.accessToken!.token);
        UserCredential authResult =
        await _auth.signInWithCredential(credential);

        // Create user data if the user is registering for the first time
        if (authResult.additionalUserInfo?.isNewUser ?? false) {
          String name = profile['name'];
          String email = profile['email'];
          String uid = authResult.user!.uid;
          await UserCollection().CreateUserData(name, email, uid);
        }

        return authResult.user;
      } else if (result.status == LoginStatus.cancelled) {
        print("Facebook login cancelled");
      } else {
        print("Facebook login failed");
      }
    } catch (e) {
      print("Error during Facebook login: ${e.toString()}");
    }
  }
  Future signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();

      if (googleSignInAccount != null) {
        final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleSignInAuthentication.accessToken,
          idToken: googleSignInAuthentication.idToken,
        );

        final UserCredential userCredential =
        await _auth.signInWithCredential(credential);
        final User userDetails = userCredential.user!;

        // Save user details or perform any other actions needed
        String _name = userDetails.displayName ?? "";
        String _email = userDetails.email ?? "";
        String _imageUrl = userDetails.photoURL ?? "";
        String _provider = "GOOGLE";
        String _uid = userDetails.uid;

        await UserCollection().CreateUserData(_name, _email, _uid);

        // Notify listeners or handle any other state management here if needed
        // ...

      } else {
        // Handle the case when user cancels the Google sign-in
        print("Google sign-in canceled");
      }
    } catch (e) {
      // Handle any exceptions that might occur during the sign-in process
      print("Error signing in with Google: ${e.toString()}");
    }
  }
  Future<User?> loginHotel(String email, String password) async {
    try {
      UserCredential result = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Check if the user exists in the 'admin' collection
      bool isAdmin = await checkIfUserIsAdmin(result.user?.uid);

      if (isAdmin) {
        // Return the User object if the user is an admin
        return result.user;
      } else {
        // Return null if the user is not an admin
        return null;
      }
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
  Future<bool> checkIfUserIsAdmin(String? uid) async {
    if (uid == null) return false;

    try {
      // Reference the 'admin' collection in Firestore
      CollectionReference adminCollection = FirebaseFirestore.instance.collection('Hotels');

      // Query for documents where the UID field matches the user's UID
      QuerySnapshot snapshot = await adminCollection.where('Uid', isEqualTo: uid).get();

      // Check if any documents were found
      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print(e.toString());
      return false;
    }
  }
}