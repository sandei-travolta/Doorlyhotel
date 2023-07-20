import 'package:flutter/material.dart';
class Forminput extends StatelessWidget {
  const Forminput({Key? key, this.controller, this.hint, this.obsecure}) : super(key: key);
  final controller;
  final hint;
  final obsecure;
  @override
  Widget build(BuildContext context) {
    return Container(
      child: TextField(
        controller: controller,
        obscureText: obsecure,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(
            color: Colors.black,
            ///fontfamily
            ///fontsize
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.white,),
          ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.grey),
        ),
          fillColor: Color(0xffd2e6ef),
          filled: true
        ),
      ),
    );
  }
}
