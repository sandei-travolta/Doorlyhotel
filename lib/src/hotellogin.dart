import 'package:flutter/material.dart';
import 'package:hotel_finder/colors.dart';
import 'package:hotel_finder/src/firebase/auth_service.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';
class hloginpage extends StatefulWidget {
  hloginpage({Key? key}) : super(key: key);

  @override
  State<hloginpage> createState() => _hloginpageState();
}

class _hloginpageState extends State<hloginpage> {
  final _key =GlobalKey<FormState>();
  final AuthenticationService _authenticationService=AuthenticationService();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  void signinUser() async{
    dynamic authresult=await _authenticationService.loginuser(emailcontroller.text, passwordcontroller.text);
    if(authresult==null){
      print("unable to sign in");
    }else{
      emailcontroller.clear();
      passwordcontroller.clear();
      print("Signed in");
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
            Text("Welcome",style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Forminput(controller: emailcontroller,hint: "enter email",obsecure: false,),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Forminput(controller: passwordcontroller,hint: "password",obsecure: true,),
            ),
            SizedBox(height: 30,),
            InkWell(
                onTap: (){},
                child: Text("Forgot password ?",style: TextStyle(color: linktextcolor),)),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: (){
                  signinUser();
                },
                child: Container(
                  height: 50,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.blue,
                  ),
                  child: Center(
                    child: Text("Sign In"),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
