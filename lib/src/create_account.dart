import 'package:flutter/material.dart';
import 'package:hotel_finder/src/loginpage.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';

import 'firebase/auth_service.dart';
class register extends StatefulWidget {
  const register({Key? key}) : super(key: key);

  @override
  State<register> createState() => _registerState();
}

class _registerState extends State<register> {

  TextEditingController namecontoller=TextEditingController();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcotroller=TextEditingController();
  TextEditingController confirmpasswordcontroller=TextEditingController();

  final AuthenticationService _authenticationSerices=AuthenticationService();

  void registerUser() async{
    if(passwordcotroller!=confirmpasswordcontroller){
      String userid= await _authenticationSerices.registerUser(namecontoller.text,emailcontroller.text,passwordcotroller.text);
      if(userid!=null){
        print("User registered successfully");
        Navigator.push(context, MaterialPageRoute(builder: (context)=>loginpage()));
        namecontoller.clear();
        emailcontroller.clear();
        passwordcotroller.clear();
        confirmpasswordcontroller.clear();
      }
      else{
        print("user registration failed");
      }
    }else{
      ///replace with actual snackbar
      print("password does not match");
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 40,),
            Text("Register",style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: namecontoller,obsecure: false,hint: "Entere your full name",),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: emailcontroller,obsecure: false,hint: "Enter your email",),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: passwordcotroller,obsecure: true,hint: "Enter password",),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: confirmpasswordcontroller,obsecure: true,hint: "Confirm password",),
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: (){
                  registerUser();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue
                  ),
                  child: Center(
                    child: Text("Register"),
                  ),
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }
}
