import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/colors.dart';
import 'package:hotel_finder/src/firebase/auth_service.dart';
import 'package:hotel_finder/src/loginpage.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';
class ResetPassword extends StatefulWidget {
  const ResetPassword({Key? key}) : super(key: key);

  @override
  State<ResetPassword> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  var newpassword="";
  final passwordcontoller=TextEditingController();
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    passwordcontoller.dispose();
  }
  final currentuser=FirebaseAuth.instance.currentUser!.uid;
  changepassword()async{
    newpassword = passwordcontoller.text;
    try{
      await FirebaseAuth.instance.currentUser!.updatePassword(newpassword);
      FirebaseAuth.instance.signOut();
      Navigator.push(context, MaterialPageRoute(builder: (context)=>loginpage()));
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        backgroundColor: buttonColor,
        content:Text("Password Changed")
      ));
    }catch(e){
      print(e.toString());
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          backgroundColor: buttonColor,
          content:Text("Must be more than six characters")
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text("Change Password",style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(hint: "Enter Emial",obsecure: false,),
            ),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(hint: "New password",obsecure: true,controller: passwordcontoller,),
            ),
            SizedBox(height: 30,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    changepassword();
                  },
                  child: Container(
                    height: 50,
                    width: 300,
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12)
                    ),
                    child: Center(child: Text("Change password",style: TextStyle(fontSize: 20),),),
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
