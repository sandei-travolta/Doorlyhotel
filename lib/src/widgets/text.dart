import 'package:flutter/material.dart';
class tittles extends StatelessWidget {
  const tittles({Key? key, this.text_value}) : super(key: key);
  final text_value;
  @override
  Widget build(BuildContext context) {
    return Text(text_value,style: TextStyle(color: Colors.black.withOpacity(0.8),fontSize: 32,fontWeight: FontWeight.w600),);
  }
}
