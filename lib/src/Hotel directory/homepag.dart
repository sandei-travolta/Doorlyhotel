import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/src/Hotel%20directory/settings.dart';

import '../../colors.dart';
import '../database/users.dart';
import '../firebase/auth_service.dart';
import '../screens/message.dart';
import 'messages.dart';
class Hotelhomepage extends StatefulWidget {
  const Hotelhomepage({Key? key}) : super(key: key);

  @override
  State<Hotelhomepage> createState() => _HotelhomepageState();
}

class _HotelhomepageState extends State<Hotelhomepage> {
  int _selectedIndex=0;
  final pages=[
    Hotelpage(),
    Messages(),
    Hotelprofile(),
  ];
  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: pages[_selectedIndex],
        bottomNavigationBar:  Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: BottomNavigationBar(
            items: [
              BottomNavigationBarItem(
                  icon: Icon(Icons.house_outlined,color: Colors.black,size: 40,),
                  label: "Home"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.messenger_outline,color: Colors.black,size: 40),
                  label: "Inbox"
              ),
              BottomNavigationBarItem(
                  icon: Icon(Icons.person_3_outlined,color: Colors.black,size: 40),
                  label: "profile"
              ),
            ],
            currentIndex: _selectedIndex,
            selectedItemColor: Colors.grey,
            onTap: _onItemTapped,
          ),
        ),
      ),
    );
  }
}
class Hotelpage extends StatefulWidget {
  const Hotelpage({Key? key}) : super(key: key);

  @override
  State<Hotelpage> createState() => _HotelpageState();
}

class _HotelpageState extends State<Hotelpage> {
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
    Map<String, dynamic>? result = await UserCollection().getHotelDetails();
    if (result == null) {
      print("Unable to fetch data");
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {

    final CarouselOptions options = CarouselOptions(
      height: 200,
      autoPlay: true,
      enlargeCenterPage: true,
      enableInfiniteScroll: false,
      viewportFraction: 0.8,
      aspectRatio: 16 / 9,
    );
    return  FutureBuilder<Map<String, dynamic>?>(
        future: fetchUsers(),
      builder: (context,snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          // Future is still ongoing, show a loading indicator if needed.
          return CircularProgressIndicator();
        } else if (snapshot.hasError) {
          // Handle any error that occurred during fetching.
          return Text('Error fetching data: ${snapshot.error}');
        } else {
          // Data is fetched successfully, update userDetails.
          userDetails = snapshot.data;
          final List<String> imageUrls = [
            userDetails!['image1'],
            userDetails!['image2'],
            userDetails!['image3']
          ];
          return SingleChildScrollView(
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
                      borderRadius: BorderRadius.circular(20),
                      // Set the desired border radius here
                      child: Image(
                        image: NetworkImage(userDetails!['image'],),
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
                          width: MediaQuery
                              .of(context)
                              .size
                              .width,
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
                      Text(userDetails!['Hotel_name'],
                          style: TextStyle(fontSize: 25)),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text(userDetails!['Location'], style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20.0, top: 10),
                  child: Text("\$100/night", style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),),
                ),
                Padding(
                  padding: const EdgeInsets.only(
                      left: 20.0, top: 10, bottom: 20),
                  child: Text(userDetails!['Contact'], style: TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w300),),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  child: Text(userDetails!['description'],
                    maxLines: 15,),
                ),
                SizedBox(height: 50,),
                SizedBox(height: 30,)
              ],
            ),
          );
        }
      });
  }
}

