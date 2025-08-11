import 'package:flutter/material.dart';

class Maindatewindow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Pure white background
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Text(
          '', // Empty for now
          style: TextStyle(color: Colors.black),
        ),
      ),
    );
  }
}