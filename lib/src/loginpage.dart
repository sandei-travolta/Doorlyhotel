import 'package:flutter/material.dart';
import 'package:hotel_finder/colors.dart';
import 'package:hotel_finder/src/create_account.dart';
import 'package:hotel_finder/src/firebase/auth_service.dart';
import 'package:hotel_finder/src/screens/homepage.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';
class loginpage extends StatefulWidget {
   loginpage({Key? key}) : super(key: key);

  @override
  State<loginpage> createState() => _loginpageState();
}

class _loginpageState extends State<loginpage> {
  final _key =GlobalKey<FormState>();
  final AuthenticationService _authenticationService=AuthenticationService();
  TextEditingController emailcontroller=TextEditingController();
  TextEditingController passwordcontroller=TextEditingController();
  void signinUser() async{
    dynamic authresult=await _authenticationService.loginuser(emailcontroller.text, passwordcontroller.text);
    if(authresult==null){
      print("unable to sign in");
    }else{
      Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
      emailcontroller.clear();
      passwordcontroller.clear();
      print("Signed in");
    }
  }
  Future<void> signInWithFacebook() async {
    final AuthenticationService authService = AuthenticationService();

    // Call the signInWithFacebook method from the AuthenticationService class
    final user = await authService.signInWithFacebook();

    // Check if the sign-in was successful
    if (user != null) {
      // Do something after successful sign-in, e.g., navigate to a new screen
      print("Facebook sign-in successful. User: ${user.displayName}");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
      // Replace the line above with the navigation code you want
    } else {
      // Handle sign-in failure or cancellation
      print("Facebook sign-in failed or cancelled.");
    }
  }
  Future<void> signInWithGoogle() async{
    final AuthenticationService authSevice=AuthenticationService();
    final user=await authSevice.signInWithGoogle();
    if (user != null) {
      // Do something after successful sign-in, e.g., navigate to a new screen
      print("Google sign-in successful. User: ${user.displayName}");
      Navigator.push(context, MaterialPageRoute(builder: (context)=>homepage()));
      // Replace the line above with the navigation code you want
    } else {
      // Handle sign-in failure or cancellation
      print("Google sign-in failed or cancelled.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Text("Welcome",style: TextStyle(fontSize: 30),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Forminput(controller: emailcontroller,hint: "enterm email",obsecure: false,),
            ),
            SizedBox(height: 15,),
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
            ),
            SizedBox(height: 40,),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: (){
                    signInWithFacebook();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image(image: AssetImage("res/images/facebook_733547.png"),fit: BoxFit.fill,),
                  ),
                ),
                InkWell(
                  onTap: (){
                    signInWithGoogle();
                  },
                  child: Container(
                    height: 40,
                    width: 40,
                    child: Image(image: AssetImage("res/images/google_300221.png"),),
                  ),
                ),
                Container(
                  height: 40,
                  width: 40,
                  child: Image(image: AssetImage("res/images/twitter_733579.png"),),
                )
              ],
            ),
            SizedBox(height: 70,),
            InkWell(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>register()));
                },
                child: Text("Create Account?",style: TextStyle(color: linktextcolor),)),
            SizedBox(height: 80,),
          ],
        ),
      );
  }
}
