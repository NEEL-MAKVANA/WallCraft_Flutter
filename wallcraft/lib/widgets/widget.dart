import 'package:flutter/material.dart';

Widget brandName(){
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text("Wall", style: TextStyle(
        color: Colors.black87,
      ),),
      Text('Craft', style: TextStyle(
        color: Colors.blue,
      ),),
    ],
  );
}