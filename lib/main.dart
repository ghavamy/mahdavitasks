import 'package:flutter/material.dart';
import 'package:mahdavitasks/MahdiCalculator.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MahdiCalculator(),
      debugShowCheckedModeBanner: false,
    );
  }
}