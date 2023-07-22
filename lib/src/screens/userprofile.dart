import 'package:flutter/material.dart';
import 'package:hotel_finder/src/landing_page.dart';

import '../../colors.dart';
import '../database/users.dart';
import '../firebase/auth_service.dart';
import 'changepassword.dart';
class userprofile extends StatefulWidget {
  const userprofile({Key? key}) : super(key: key);

  @override
  State<userprofile> createState() => _userprofileState();
}

class _userprofileState extends State<userprofile> {
  bool language = true;
  AuthenticationService _authenticationSerices=AuthenticationService();
  Map<String, dynamic>? userDetails;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }
  Future<Map<String, dynamic>?> fetchUsers() async {
    // Specify the return type of the function
    // as Future<Map<String, dynamic>?>.
    Map<String, dynamic>? result = await UserCollection().getUsersDetails();
    if (result == null) {
      print("Unable to fetch data");
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    final MaterialStateProperty<Color?> trackColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Track color when the switch is selected.
        if (states.contains(MaterialState.selected)) {
          return buttonColor;
        }
        // Otherwise return null to set default track color
        // for remaining states such as when the switch is
        // hovered, focused, or disabled.
        return null;
      },
    );
    final MaterialStateProperty<Color?> overlayColor =
    MaterialStateProperty.resolveWith<Color?>(
          (Set<MaterialState> states) {
        // Material color when switch is selected.
        if (states.contains(MaterialState.selected)) {
          return Colors.amber.withOpacity(0.54);
        }
        // Material color when switch is disabled.
        if (states.contains(MaterialState.disabled)) {
          return Colors.grey.shade400;
        }
        // Otherwise return null to set default material color
        // for remaining states such as when the switch is
        // hovered, or focused.
        return null;
      },
    );

    return FutureBuilder<Map<String, dynamic>?>(
      future: fetchUsers(),
      builder:(context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future is still ongoing, show a loading indicator if needed.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any error that occurred during fetching.
          return Text('Error fetching data: ${snapshot.error}');
        } else {
          // Data is fetched successfully, update userDetails.
          userDetails = snapshot.data;
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 100,),
              CircleAvatar(
                radius: 80, backgroundColor: Colors.grey.withOpacity(0.4),),
              SizedBox(height: 20,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userDetails!['Name'] ?? '',
                    style: TextStyle(fontSize: 30),),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(userDetails!['Email'] ?? '',
                    style: TextStyle(fontSize: 15),),
                ],
              ),
              SizedBox(
                height: 100,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      child: Text(
                        "Change Language", style: TextStyle(fontSize: 20),),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text("English", style: TextStyle(fontSize: 15),),
                        Switch(value: language, onChanged: (bool value) {
                          setState(() {
                            language = !language;
                          });
                        }),
                      ],
                    )
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Container(
                      child: Text("About app", style: TextStyle(fontSize: 20),),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 25,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    InkWell(
                      onTap: (){
                        Navigator.push(context,MaterialPageRoute(builder: (context)=>ResetPassword()));
                      },
                      child: Container(
                        child: Text(
                          "Change password", style: TextStyle(fontSize: 20),),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 100,),
              InkWell(
                  onTap: () async {
                    await _authenticationSerices.signOut().then((result) {
                      Navigator.push(context, MaterialPageRoute(builder: (
                          context) => landingpage()));
                    });
                  },
                  child: Text("Log out",
                    style: TextStyle(fontSize: 20, color: Colors.greenAccent),))
            ],
          );
        }
      });
  }
}
