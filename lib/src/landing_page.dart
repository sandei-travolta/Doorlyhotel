import 'package:flutter/material.dart';
import 'package:hotel_finder/colors.dart';
import 'package:hotel_finder/src/hotellogin.dart';
import 'package:hotel_finder/src/loginpage.dart';
import 'package:hotel_finder/src/registerhotel.dart';
class landingpage extends StatefulWidget {
  const landingpage({Key? key}) : super(key: key);

  @override
  State<landingpage> createState() => _landingpageState();
}

class _landingpageState extends State<landingpage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: LandingPage(),
    );
  }

  Scaffold LandingPage() {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
           image: AssetImage("res/images/pexels-aleksandar-pasaric-2041556.jpg",),fit: BoxFit.fill
          )
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: buttons(text: "Looking for hotel ?",nextpage: loginpage(),),
            ),
            SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0),
              child: buttons(text: "Add your hotel",nextpage: registerHotel(),),
            ),
            SizedBox(height: 30,)
          ],
        ),
      ),
    );
  }
}

class buttons extends StatelessWidget {
  const buttons({
    super.key, this.text, this.nextpage,
  });
  final text;
  final nextpage;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        Navigator.push(context, MaterialPageRoute(builder: (context)=>nextpage));
      },
      child: Container(
        height: 60,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(child: Text(text,style: TextStyle(fontSize: 20,fontWeight: FontWeight.w400,color: Colors.white),),),
      ),
    );
  }
}
