import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/src/database/hotelsreg.dart';
import 'package:hotel_finder/src/database/users.dart';
import 'package:hotel_finder/src/firebase/auth_service.dart';
import 'package:hotel_finder/src/screens/message.dart';

import '../../colors.dart';
import '../database/hotels.dart';
class Detailscreen extends StatefulWidget {
  final Map<String, dynamic> hotelData;

  const Detailscreen({Key? key, required this.hotelData}) : super(key: key);

  @override
  State<Detailscreen> createState() => _DetailscreenState();
}

class _DetailscreenState extends State<Detailscreen> {
  AuthenticationService authenticationService=AuthenticationService();
  String name = "";
  Map<String, dynamic> userDetails = {};
  final Hoteldatabase _hotelsdatabase=Hoteldatabase();
  fetchUsers() async{
    Map<String, dynamic> result = await UserCollection().getUsersDetails();
    if(result==null){
      print("Unable to fetch data");
    }
    else{
      setState(() {
        userDetails = result;
        name=userDetails['Uid'];
      });
    }
  }
  Future<void> likeHotel() async {
    String uid = authenticationService.getCurrentUser()!.uid;
    // Check if the name variable is not empty or null
    if (uid.isNotEmpty) {
      print(uid);
      await _hotelsdatabase.likeHotel(
        widget.hotelData['Hotel_name'], widget.hotelData['Contact'], widget.hotelData['Manager_name'], widget.hotelData['Location'],widget.hotelData['Mobile'],widget.hotelData['description'],widget.hotelData['image'],widget.hotelData['image1'],widget.hotelData['image2'],widget.hotelData['image3'],
        uid,widget.hotelData['Uid']
      );
      await hotelregistration().addlikes(uid,widget.hotelData['Uid']);
    } else {
      print("Name is empty or null. Cannot like the hotel.");
    }
  }
  void blockhotel()async{

    String userid= await _hotelsdatabase.blockHotel(widget.hotelData['Hotel_name'], widget.hotelData['Contact'], widget.hotelData['Manager_name'], widget.hotelData['Location'],widget.hotelData['Mobile'],widget.hotelData['description'],widget.hotelData['image'],widget.hotelData['image1'],widget.hotelData['image2'],widget.hotelData['image3'],widget.hotelData['Uid']);
    if(userid!=null){
      print("Blocked");
    }
    else{
      print("Unable to blacklist");
    }
  }


  @override
  Widget build(BuildContext context) {
    final List<String> imageUrls = [
      widget.hotelData['image1'],
      widget.hotelData['image2'],
      widget.hotelData['image3']
    ];
    final CarouselOptions options = CarouselOptions(
      height: 200,
      autoPlay: true,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      viewportFraction: 0.8,
      aspectRatio: 16 / 9,
    );
    return Scaffold(
      appBar: AppBar(
        backgroundColor: buttonColor,
        title: Center(child: Text(widget.hotelData['Hotel_name'])),
        elevation: 0,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 30,),
              Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Container(
                  height: 300,
                  width: 380,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20), // Set the desired border radius here
                    child: Image(
                      image: NetworkImage(widget.hotelData['image']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20,),
              CarouselSlider(
                items: imageUrls.map((url) {
                  return Builder(
                    builder: (BuildContext context) {
                      return Container(
                        width: MediaQuery.of(context).size.width,
                        margin: EdgeInsets.symmetric(horizontal: 5.0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: DecorationImage(
                            image: NetworkImage(url),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  );
                }).toList(),
                options: options,
              ),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(widget.hotelData['Hotel_name'],style: TextStyle(fontSize: 25)),
                    IconButton(onPressed: (){
                      likeHotel();
                    }, icon: Icon(Icons.favorite_border))
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10),
                child: Text(widget.hotelData['Location'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10),
                child: Text("\$100/night",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 20),
                child: Text(widget.hotelData['Contact'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Text(widget.hotelData['description'],maxLines: 50)),
              SizedBox(height: 20,),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: InkWell(
                  onTap: (){
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MessageScreen(hotelName: widget.hotelData['Hotel_name'],hotelId: widget.hotelData['Uid'],id: FirebaseAuth.instance.currentUser!.uid,),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      color: buttonColor,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            child: Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.messenger_outline,size: 30,color: Colors.white,),
                                  SizedBox(height: 1,),
                                  Text("Message",style: TextStyle(fontSize: 25,color: Colors.white),),
                                  SizedBox(height: 3,)
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30,)
            ],
          ),
        ),
      ),
    );
  }
}
