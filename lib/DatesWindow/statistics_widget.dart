import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'note_store.dart';
import '../BasicFiles/PersianFormats.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();
    final today = Jalali.now();
    final todayEntries = store.entriesOn(
      today.year,
      today.month,
      today.day,
    );

    // Calculate weekly stats
    final weekStart = today.addDays(-(today.weekDay - 1));
    int weeklyCount = 0;
    for (int i = 0; i < 7; i++) {
      final day = weekStart.addDays(i);
      weeklyCount += store.entriesOn(day.year, day.month, day.day).length;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Title
          const Text(
            'آمار اعمال',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: Color(0xFFFFFFFF)
            ),
            textAlign: TextAlign.center,
          ),

          // Divider line
          const SizedBox(height: 8),
          Divider(
            thickness: 1,
            color: Color.fromARGB(255, 0, 102, 255),
          ),
          const SizedBox(height: 12),

          // Stats row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatCard(
                context,
                'امروز',
                PersianUtils.toPersianDigits(todayEntries.length.toString()),
                Color.fromARGB(255, 0, 0, 0),
              ),
              _buildStatCard(
                context,
                'این هفته',
                PersianUtils.toPersianDigits(weeklyCount.toString()),
                Color.fromARGB(255, 0, 0, 0),
              ),
              _buildStatCard(
                context,
                'کل',
                PersianUtils.toPersianDigits(
                  _getTotalCount(store).toString(),
                ),
                Color.fromARGB(255, 0, 0, 0),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      BuildContext context, String label, String value, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
              fontFamily: 'Vazir',
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: color.withOpacity(0.8),
              fontFamily: 'Vazir',
            ),
          ),
        ],
      ),
    );
  }

  int _getTotalCount(NotesStore store) {
    int total = 0;
    for (final year in store.years) {
      for (final month in store.monthsIn(year)) {
        for (final day in store.daysInMonth(year, month)) {
          total += store.entriesOn(year, month, day).length;
        }
      }
    }
    return total;
  }
}