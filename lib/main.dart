import 'package:flutter/material.dart';
import 'package:mahdavitasks/MahdiCalculator.dart';
import 'package:provider/provider.dart';
import 'DatesWindow/note_store.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => NotesStore(),
      child: const MyApp(),
    ),
  );
}

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