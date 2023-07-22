import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/src/screens/favourites.dart';
import 'package:hotel_finder/src/screens/inbox.dart';
import 'package:hotel_finder/src/screens/userprofile.dart';

import '../database/hotels.dart';
import 'details.dart';
class homepage extends StatefulWidget {
  const homepage({Key? key}) : super(key: key);

  @override
  State<homepage> createState() => _homepageState();
}

class _homepageState extends State<homepage> {
  TextEditingController searchcontroller=TextEditingController();
  int _selectedIndex=0;
  final pages=[
    Explore(),
    favourites(),
    ChatListScreen(FirebaseAuth.instance.currentUser!.uid),
    userprofile()
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
        bottomNavigationBar: BottomNavigationBar(
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.search,color: Colors.black,size: 40,),
              label: "Discover"
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.favorite_border,color: Colors.black,size: 40),
                label: "Wishlist"
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
        )
      ),
    );
  }
}

class Explore extends StatefulWidget {
   Explore({
    super.key,
  });

  @override
  State<Explore> createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  TextEditingController searchcontroller=TextEditingController();
  List itemsList=[];
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHotels();
  }
  fetchHotels() async{
    dynamic result= await Hoteldatabase().getHotels();
    if(result==null){
      print("Unable to fetch data");
    }
    else{
      setState(() {
        itemsList=result;
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 70,),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          child: TextField(
            controller: searchcontroller,
            onChanged: (value){
            },
            decoration: InputDecoration(
              hintText: "Search for hotel,city",
              hintStyle: TextStyle(
              ),
              border: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.grey,width: 2),
                borderRadius: BorderRadius.all(Radius.circular(12))
              )
            ),
          ),
        ),
        SizedBox(height: 10,),
        Divider(),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 15,),
              Expanded(
                child: ListView.builder(
                  itemCount: itemsList.length,
                  itemBuilder: (context, index) {
                    if (index >= itemsList.length) {
                      // Handle the case when the index is out of range
                      return SizedBox.shrink(); // Return an empty SizedBox if index is out of range
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 30.0,horizontal: 10),
                      child: GestureDetector(
                        onTap: (){
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Detailscreen(hotelData: itemsList[index]),
                            ),
                          );
                        },
                        child: Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                height: 300,
                                width: 380,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(20), // Set the desired border radius here
                                  child: Image(
                                    image: NetworkImage(itemsList[index]['image']),
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                              SizedBox(height: 10,),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0),
                                child: Text(itemsList[index]['Hotel_name'],style: TextStyle(fontSize: 25),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,top: 10),
                                child: Text(itemsList[index]['Location'],style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 20.0,top: 10),
                                child: Text("\$100/night",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
                              )
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ],
          ),
        )
      ],
    );
  }
}