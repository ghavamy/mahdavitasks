import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'note_store.dart';

class DaysPage extends StatelessWidget {
  final int year;
  final int month;
  const DaysPage({super.key, required this.year, required this.month});

  @override
  Widget build(BuildContext context) {
    final store = context.watch<NotesStore>();
    final days = store.daysInMonth(year, month);

    return Scaffold(
      appBar: AppBar(
        title: Text('${PersianUtils.toPersianDigits(year.toString())}  ${PersianUtils.monthName(month - 1)}'),
        centerTitle: true,
      ),
      body: ListView.separated(
        padding: const EdgeInsets.symmetric(vertical: 8),
        itemCount: days.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final d = days[i];
          final notes = store.entriesOn(year, month, d);
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'روز ${PersianUtils.dayOrdinal(d)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.right,
                ),
                const SizedBox(height: 6),
                ...notes.map((n) => Card(
                      elevation: 0,
                      color: const Color(0xFFF7F7F7),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Text(n.text, textAlign: TextAlign.right),
                      ),
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}