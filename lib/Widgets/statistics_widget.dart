import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';
import '../DatesWindow/note_store.dart';
import '../BasicFiles/PersianFormats.dart';

class StatisticsWidget extends StatelessWidget {
  const StatisticsWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();
    final today = Jalali.now();

    // امروز count
    final todayCount =
        store.entriesOn(today.year, today.month, today.day).length;

    // هفته count
    final weekStart = today.addDays(-(today.weekDay - 1));
    int weeklyCount = 0;
    for (int i = 0; i < 7; i++) {
      final day = weekStart.addDays(i);
      weeklyCount += store.entriesOn(day.year, day.month, day.day).length;
    }

    // ماه count
    final monthDays = store.daysInMonth(today.year, today.month);
    int monthlyCount = 0;
    for (final d in monthDays) {
      monthlyCount += store.entriesOn(today.year, today.month, d).length;
    }

    // کل count
    final totalCount = _getTotalCount(store);

    final stats = [
      {'label': 'کل', 'value': totalCount},
      {'label': 'ماه', 'value': monthlyCount},
      {'label': 'هفته', 'value': weeklyCount},
      {'label': 'روز', 'value': todayCount},
    ];

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.1),
          border: const Border(
            top: BorderSide(color: Color.fromARGB(80, 0, 0, 0), width: 1),
          ),
        ),
        child: Row(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 8.0),
              child: Text(
                'اعمال',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                  color: Colors.white,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: stats.map((stat) {
                  return _buildStatCard(
                    context,
                    stat['label'].toString(),
                    PersianUtils.toPersianDigits(stat['value'].toString()),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(BuildContext context, String label, String value) {
    return Container(
      width: 60,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blueAccent, width: 1),
      ),
      child: Column(
        children: [
          // Header with label
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.blueAccent,
              borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
            ),
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazir',
                color: Colors.white,
              ),
            ),
          ),

          // Bottom with number
          Expanded(
            child: Container(
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.15),
                borderRadius:
                    const BorderRadius.vertical(bottom: Radius.circular(12)),
              ),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Vazir',
                  color: Colors.white,
                ),
              ),
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