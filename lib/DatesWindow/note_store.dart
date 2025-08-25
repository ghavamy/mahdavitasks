// note_store.dart
import 'package:flutter/foundation.dart';
import 'package:shamsi_date/shamsi_date.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class NoteEntry {
  final DateTime date; // use only Y/M/D for grouping
  final String text;
  final String id;
  final DateTime createdAt;

  NoteEntry({
    required DateTime date, 
    required this.text,
    String? id,
    DateTime? createdAt,
  }) : date = DateTime(date.year, date.month, date.day),
       id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
       createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
    'date': date.toIso8601String(),
    'text': text,
    'id': id,
    'createdAt': createdAt.toIso8601String(),
  };

  factory NoteEntry.fromJson(Map<String, dynamic> json) => NoteEntry(
    date: DateTime.parse(json['date']),
    text: json['text'],
    id: json['id'],
    createdAt: DateTime.parse(json['createdAt']),
  );
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
  bool _isLoaded = false;

  Future<void> loadData() async {
    if (_isLoaded) return;
    
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString('notes_data');
    
    if (jsonString != null) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        for (final item in jsonList) {
          final entry = NoteEntry.fromJson(item);
          _addToMemory(entry);
        }
      } catch (e) {
        debugPrint('Error loading notes: $e');
      }
    }
    _isLoaded = true;
    notifyListeners();
  }

  void _addToMemory(NoteEntry e) {
    final shamsiDate = Jalali.fromDateTime(e.date);
    final y = shamsiDate.year, m = shamsiDate.month, d = shamsiDate.day;
    _data.putIfAbsent(y, () => {});
    _data[y]!.putIfAbsent(m, () => {});
    _data[y]![m]!.putIfAbsent(d, () => []);
    _data[y]![m]![d]!.add(e);
  }

  Future<void> add(NoteEntry e) async {
    _addToMemory(e);
    await _saveData();
    notifyListeners();
  }

  Future<void> update(NoteEntry updatedEntry) async {
    final shamsiDate = Jalali.fromDateTime(updatedEntry.date);
    final y = shamsiDate.year, m = shamsiDate.month, d = shamsiDate.day;

    final dayList = _data[y]?[m]?[d];
    if (dayList == null) return;

    final index = dayList.indexWhere((e) => e.id == updatedEntry.id);
    if (index == -1) return;

    dayList[index] = updatedEntry;
    await _saveData();
    notifyListeners();
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    final allEntries = <NoteEntry>[];
    
    for (final yearMap in _data.values) {
      for (final monthMap in yearMap.values) {
        for (final dayList in monthMap.values) {
          allEntries.addAll(dayList);
        }
      }
    }
    
    final jsonString = json.encode(allEntries.map((e) => e.toJson()).toList());
    await prefs.setString('notes_data', jsonString);
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