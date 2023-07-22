import 'package:flutter/material.dart';

import '../database/hotels.dart';
import 'details.dart';
class favourites extends StatefulWidget {
  const favourites({Key? key}) : super(key: key);

  @override
  State<favourites> createState() => _favouritesState();
}

class _favouritesState extends State<favourites> {
  List itemsList=[];
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchHotels();
  }
  fetchHotels() async{
    dynamic result= await Hoteldatabase().getFavourites();
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
    return  Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
                      padding: const EdgeInsets.symmetric(vertical: 30.0),
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
                                    image: AssetImage("assets/images/dummyimage.jpg"),
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
                                child: Text("Nairobi",style: TextStyle(fontSize: 20,fontWeight: FontWeight.w300),),
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
