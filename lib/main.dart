import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'AniamtionSplashScreen.dart';
import 'DatesWindow/note_store.dart';
import 'notification_alarm.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final firstLaunch = await isFirstLaunch();

  // Load your NotesStore
  final notesStore = NotesStore();
  await notesStore.loadData();

  // No cloud sync anymore — just local data
  if (firstLaunch) {
    // You could seed some default notes here if you want
  }

  await setupNotificationsAndWorkManager();

  runApp(
    ChangeNotifierProvider.value(
      value: notesStore,
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

Future<bool> isFirstLaunch() async {
  final prefs = await SharedPreferences.getInstance();
  final hasLaunchedBefore = prefs.getBool('hasLaunchedBefore') ?? false;

  if (!hasLaunchedBefore) {
    await prefs.setBool('hasLaunchedBefore', true);
    return true; // First launch
  }
  return false; // Not first launch
}