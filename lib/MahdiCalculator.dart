import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mahdavitasks/Widgets/statistics_widget.dart';
import 'package:workmanager/workmanager.dart';
import 'MahdiTimer.dart';

class MahdiCalculator extends StatelessWidget {
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
      home: Stack(
        children: [
          // Background + main content
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/BackGround.jpeg'),
                fit: BoxFit.cover,
              ),
            ),
            child: Scaffold(
              backgroundColor: Colors.transparent,
              body: Stack(
                children: [
                  BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 6, sigmaY: 6),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                  const MahdiTimer(),
                ],
              ),
            ),
          ),

        ElevatedButton.icon(
        icon: const Icon(Icons.notifications_active),
        label: const Text("Trigger One‑Off Notification"),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          textStyle: const TextStyle(fontSize: 16),
        ),
        onPressed: () {
          Workmanager().cancelAll();
          // Register the one‑off task
          Workmanager().registerOneOffTask(
            DateTime.now().millisecondsSinceEpoch.toString(),
            "checkTasks",
            initialDelay: Duration(seconds: 30),
          );
        },
      ),


          // Footer completely outside the Scaffold
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: MediaQuery.removeViewInsets(
              removeBottom: true, // ignore keyboard pushing
              context: context,
              child: SafeArea(
                top: false,
                child: const StatisticsWidget(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}