import 'package:flutter/material.dart';
import 'package:weatherapp/homescreen.dart';
void main() {
  runApp(
     MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreen(),
      theme: ThemeData(
        primaryColor: Colors.blue,
        hintColor: Colors.blueAccent,
        fontFamily: 'Montserrat'
        ),
    ),);
}

