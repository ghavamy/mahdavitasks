// note_store.dart
import 'package:flutter/foundation.dart';
import 'package:shamsi_date/shamsi_date.dart';

class NoteEntry {
  final DateTime date; // use only Y/M/D for grouping
  final String text;

  NoteEntry({required DateTime date, required this.text})
      : date = DateTime(date.year, date.month, date.day);
}

class YearMonth {
  final int year;
  final int month;
  const YearMonth(this.year, this.month);

  @override
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}

class NotesStore extends ChangeNotifier {
  // data[year][month][day] -> List<NoteEntry>
  final Map<int, Map<int, Map<int, List<NoteEntry>>>> _data = {};

  void add(NoteEntry e) {

    final shamsiDate = Jalali.fromDateTime(e.date);
    final y = shamsiDate.year, m = shamsiDate.month, d = shamsiDate.day;
    _data.putIfAbsent(y, () => {});
    _data[y]!.putIfAbsent(m, () => {});
    _data[y]![m]!.putIfAbsent(d, () => []);
    _data[y]![m]![d]!.add(e);
    notifyListeners();
  }

  List<YearMonth> get allYearMonths {
    final list = <YearMonth>[];
    for (final y in _data.keys) {
      for (final m in _data[y]!.keys) {
        list.add(YearMonth(y, m));
      }
    }
    list.sort((a, b) {
      if (a.year != b.year) return b.year.compareTo(a.year);
      return b.month.compareTo(a.month);
    });
    return list;
  }

  int countInMonth(YearMonth ym) {
    final days = _data[ym.year]?[ym.month];
    if (days == null) return 0;
    return days.values.fold<int>(0, (sum, list) => sum + list.length);
  }

  List<int> daysInMonth(int year, int month) {
    final days = _data[year]?[month]?.keys.toList() ?? [];
    days.sort();
    return days;
  }

  List<NoteEntry> entriesOn(int y, int m, int d) =>
      List.unmodifiable(_data[y]?[m]?[d] ?? const []);

  /// 🔹 NEW: All years (sorted descending)
  List<int> get years {
    final list = _data.keys.toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  /// 🔹 NEW: All months in a given year (sorted ascending)
  List<int> monthsIn(int year) {
    final months = _data[year]?.keys.toList() ?? [];
    months.sort();
    return months;
  }
}