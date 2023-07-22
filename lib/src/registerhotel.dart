import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:hotel_finder/src/database/hotelsreg.dart';
import 'package:hotel_finder/src/hotellogin.dart';
import 'package:hotel_finder/src/widgets/texfields.dart';

import 'package:path/path.dart' as path;


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
  TextEditingController detailscontroller=TextEditingController();
  String? filename;
  String? filename1;
  String? filename2;
  String? filename3;
  PlatformFile? pickedfile;
  PlatformFile? pickedfile1;
  PlatformFile? pickedfile2;
  PlatformFile? pickedfile3;
  bool isloding=false;
  bool isloding1=false;
  bool isloding2=false;
  bool isloding3=false;
  FilePickerResult? result;
  FilePickerResult? result1;
  FilePickerResult? result2;
  FilePickerResult? result3;
  File? filetodisplay;
  File? filetodisplay1;
  File? filetodisplay2;
  File? filetodisplay3;
  PlatformFile? convertToFilePicker(File file) {
    return PlatformFile(
      path: file.path,
      name: file.path.split('/').last,
      size: file.lengthSync(),
      bytes: file.readAsBytesSync(),
    );
  }
  void pickfile()async{
    try{
      setState(() {
        isloding=true;
      });
      result =await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if(result!=null){
        filename=result!.files.first.name;
        pickedfile=result!.files.first;
        filetodisplay=File(pickedfile!.path.toString());
      }
      setState(() {
        isloding=false;
      });
    }
    catch(e){

    }
  }
  void pickfile1()async{
    try{
      setState(() {
        isloding1=true;
      });
      result1 =await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if(result1!=null){
        filename1=result1!.files.first.name;
        pickedfile1=result1!.files.first;
        filetodisplay1=File(pickedfile1!.path.toString());
      }
      setState(() {
        isloding=false;
      });
    }
    catch(e){

    }
  }
  void pickfile2()async{
    try{
      setState(() {
        isloding2=true;
      });
      result2 =await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if(result2!=null){
        filename2=result2!.files.first.name;
        pickedfile2=result2!.files.first;
        filetodisplay2=File(pickedfile2!.path.toString());
      }
      setState(() {
        isloding=false;
      });
    }
    catch(e){

    }
  }
  void pickfile3()async{
    try{
      setState(() {
        isloding3=true;
      });
      result3 =await FilePicker.platform.pickFiles(
        type: FileType.image,
        allowMultiple: false,
      );
      if(result3!=null){
        filename3=result3!.files.first.name;
        pickedfile3=result3!.files.first;
        filetodisplay3=File(pickedfile3!.path.toString());
      }
      setState(() {
        isloding=false;
      });
    }
    catch(e){

    }
  }
  Future register()async{
    if(hotelnamecontroller!=null && managernamecontroller!=null && emailcontroler!=null && mobilecntroller!=null && detailscontroller!=null){
      final fileName=path.basename(filetodisplay!.path);
      final fileName1=path.basename(filetodisplay1!.path);
      final fileName2=path.basename(filetodisplay2!.path);
      final fileName3=path.basename(filetodisplay3!.path);
      final destination='files';
      var task=hotelregistration.uploadFile(destination, filetodisplay!);
      var task1=hotelregistration.uploadFile1(destination, filetodisplay1!);
      var task2=hotelregistration.uploadFile2(destination, filetodisplay2!);
      var task3=hotelregistration.uploadFile3(destination, filetodisplay3!);
      if(task==null || task1==null ||task2==null)return;
      final snapshot = await task!.whenComplete(() {});
      final snapshot1 = await task1!.whenComplete(() {});
      final snapshot2= await task2!.whenComplete(() {});
      final snapshot3= await task3!.whenComplete(() {});
      final urlDownload = await snapshot.ref.getDownloadURL();
      final urlDownload1 = await snapshot.ref.getDownloadURL();
      final urlDownload2 = await snapshot.ref.getDownloadURL();
      final urlDownload3= await snapshot.ref.getDownloadURL();
      await hotelregistration().regHotel(hotelnamecontroller.text, managernamecontroller.text, emailcontroler.text, mobilecntroller.text,citycontroller.text,detailscontroller.text,urlDownload,urlDownload1,urlDownload2,urlDownload3);
      Navigator.push(context, MaterialPageRoute(builder: (context)=>hloginpage()));
      hotelnamecontroller.clear();
      managernamecontroller.clear();
      emailcontroler.clear();
      mobilecntroller.clear();
      citycontroller.clear();
      detailscontroller.clear();
      pickedfile=null;
      pickedfile1=null;
      pickedfile2=null;
      pickedfile3=null;
    }else{
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("one or more fieldsis empty"),
        backgroundColor: Colors.blueAccent,
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 50,),
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
                Text("Upload Hotel pictures",style: TextStyle(fontSize: 20),),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 35.0),
                  child: Row(
                    children: [
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              pickfile();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                                child: pickedfile != null? Center(child: Text(filename!),):Center(child: Icon(Icons.add)),
                            ),
                          ),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              pickfile1();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: pickedfile1 != null? Center(child: Text(filename1!),):Center(child: Icon(Icons.add)),
                            ),
                          ),
                        ],
                      ),SizedBox(width: 20,),
                      Column(
                        children: [
                          InkWell(
                            onTap: (){
                              pickfile2();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: pickedfile2 != null? Center(child: Text(filename2!),):Center(child: Icon(Icons.add)),
                            ),
                          ),
                          SizedBox(height: 20,),
                          InkWell(
                            onTap: (){
                              pickfile3();
                            },
                            child: Container(
                              height: 150,
                              width: 150,
                              decoration: BoxDecoration(
                                color: Colors.white70,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: pickedfile3!= null? Center(child: Text(filename3!),):Center(child: Icon(Icons.add)),
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: detailscontroller,
                    keyboardType: TextInputType.multiline,
                    minLines: 3,
                    maxLines: 40,
                    style: TextStyle(color:Colors.black), // Change text color if needed
                    decoration: InputDecoration(
                      hintText: "Provide Hotel description",
                      filled: true,
                      fillColor:Color(0xffd2e6ef) ,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide.none,
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey), // Outline border color when focused
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Colors.grey), // Outline border color when not focused
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 30,),
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
                          color: buttonColor
                      ),
                      child: Center(
                        child: Text("Register"),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 20,)
              ],
            ),
          ),
        ),
      ),
    );
  }
}
