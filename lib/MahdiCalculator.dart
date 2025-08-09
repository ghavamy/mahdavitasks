import 'package:flutter/material.dart';
import 'MahdiTimer.dart';

class MahdiCalculator extends StatelessWidget{
  static DateTime targetDate = DateTime(874, 1, 5, 5, 0, 0);

  const MahdiCalculator({super.key});

  static Duration getElapsed() {
    return DateTime.now().difference(targetDate);
  }

  static Map<String, int> getElapsedBreakdown() {
    final Duration elapsed = getElapsed();

    final int totalSeconds = elapsed.inSeconds;
    final int totalDays = elapsed.inDays;

    // Breakdown into years, months, days, hours, minutes, seconds
    final int years = totalDays ~/ 365;
    final int months = (totalDays % 365) ~/ 30;
    final int days = totalDays % 30;
    final int hours = (totalSeconds ~/ 3600) % 24;
    final int minutes = (totalSeconds ~/ 60) % 60;
    final int seconds = totalSeconds % 60;

    return {
      'years': years,
      'months': months,
      'days': days,
      'hours': hours,
      'minutes': minutes,
      'seconds': seconds,
    };
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      home: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpg'),
                fit: BoxFit.cover,
                // Optional: add a soft dim for readability
                colorFilter: ColorFilter.mode(
                  Colors.black.withOpacity(0.2),
                  BlendMode.darken,
                ),
              ),
            ),
          ),
          Scaffold(
            backgroundColor: Colors.transparent, // <-- Crucial
            appBar: AppBar(
              title: Text('زمان‌شمار مهدوی'),
              backgroundColor: Colors.indigo,
            ),
            body:MahdiTimer(),
          ),
        ],
      ),
    );
  }
}