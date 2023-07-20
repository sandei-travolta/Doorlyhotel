import 'package:flutter/material.dart';
import 'package:hotel_finder/src/database/hotelsreg.dart';
import 'package:hotel_finder/src/hotellogin.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';

import '../colors.dart';
class registerHotel extends StatefulWidget {
  const registerHotel({Key? key}) : super(key: key);

  @override
  State<registerHotel> createState() => _registerHotelState();
}

class _registerHotelState extends State<registerHotel> {
  TextEditingController hotelnamecontroller=TextEditingController();
  TextEditingController managernamecontroller=TextEditingController();
  TextEditingController emailcontroler=TextEditingController();
  TextEditingController mobilecntroller=TextEditingController();
  TextEditingController citycontroller=TextEditingController();
  Future register()async{
    if(hotelnamecontroller!=null && managernamecontroller!=null && emailcontroler!=null && mobilecntroller!=null){
      await hotelregistration().regHotel(hotelnamecontroller.text, managernamecontroller.text, emailcontroler.text, mobilecntroller.text,citycontroller.text);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>hloginpage()));
      hotelnamecontroller.clear();
      managernamecontroller.clear();
      emailcontroler.clear();
      mobilecntroller.clear();
    }else{
      print("one or more field is empty");
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
            SizedBox(height: 10,),
            Text("Register hotel",style: TextStyle(fontSize: 32),),
            SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: hotelnamecontroller,hint: "Hotel name",obsecure: false,),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: managernamecontroller,hint: "Hotel Manager name",obsecure: false,),
            ),
            SizedBox(height:15),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: emailcontroler,hint: "Hotel email",obsecure: false,),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: mobilecntroller,hint: "mobile number",obsecure: false,),
            ),
            SizedBox(height: 15,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10.0),
              child: Forminput(controller: citycontroller,hint: "City",obsecure: false,),
            ),
            SizedBox(height: 20,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onTap: (){
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>hloginpage()));
                  },
                    child: Text("already registered?",style: TextStyle(color: linktextcolor,fontSize: 15,fontWeight: FontWeight.w400)))
              ],
            ),
            SizedBox(height: 30,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: InkWell(
                onTap: (){
                  register();
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
            )
          ],
        ),
      ),
    );
  }
}
