import 'package:flutter/material.dart';
import 'package:mahdavitasks/AniamtionSplashScreen.dart';
import 'package:provider/provider.dart';
import 'DatesWindow/note_store.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final notesStore = NotesStore();
  await notesStore.loadData();
  
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
    return MaterialApp(
      home: const AnimatedSplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        // Theme color scheme based on Islamic/spiritual design principles
        // Colors chosen to evoke tranquility and spiritual reflection
        colorScheme: ColorScheme.fromSeed(
          // Teal-based seed color representing serenity and balance
          seedColor: const Color(0xFF007B83),
          brightness: Brightness.light,
        ).copyWith(
          // Primary: Deep teal for main UI elements and emphasis
          primary: const Color(0xFF007B83),
          // Secondary: Bright teal for accents and interactive elements
          secondary: const Color(0xFF00C2BA),
          // Tertiary: Sage green for subtle highlights and complementary elements
          tertiary: const Color(0xFF7CAC99),
          // Surface: Light gray for backgrounds and containers
          surface: const Color(0xFFF7F7F7),
        ),
        // Persian font family for proper RTL text rendering
        fontFamily: 'Vazir',
      ),
    );
  }
}