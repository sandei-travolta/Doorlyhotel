import 'package:flutter/material.dart';

class topNav extends StatelessWidget {
  const topNav({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.only(bottomLeft: Radius.circular(12),bottomRight: Radius.circular(12))
      ),
      child: Center(
        child: Text("Admin Panel",style: TextStyle(fontSize:30,color: Colors.white),),
      ),
    );
  }
}
