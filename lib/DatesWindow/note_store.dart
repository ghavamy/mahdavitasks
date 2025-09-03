// note_store.dart
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shamsi_date/shamsi_date.dart';

class NoteEntry {
  final DateTime date; // Only Y/M/D used for grouping
  final String text;
  final String id;
  final DateTime createdAt;
  bool? status; // true = done, false = not done, null = unset

  NoteEntry({
    required DateTime date,
    required this.text,
    String? id,
    DateTime? createdAt,
    this.status,
  })  : date = DateTime(date.year, date.month, date.day),
        id = id ?? DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt = createdAt ?? DateTime.now();

  Map<String, dynamic> toJson() => {
        'date': date.toIso8601String(),
        'text': text,
        'id': id,
        'createdAt': createdAt.toIso8601String(),
        'status': status,
      };

  factory NoteEntry.fromJson(Map<String, dynamic> json) => NoteEntry(
        date: DateTime.parse(json['date'] as String),
        text: json['text'] as String,
        id: json['id'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        status: json['status'] as bool?,
      );

  NoteEntry copyWith({
    DateTime? date,
    String? text,
    String? id,
    DateTime? createdAt,
    bool? status,
  }) {
    return NoteEntry(
      date: date ?? this.date,
      text: text ?? this.text,
      id: id ?? this.id,
      createdAt: createdAt ?? this.createdAt,
      status: status ?? this.status,
    );
  }
}

class YearMonth {
  final int year; // Jalali year
  final int month; // Jalali month
  const YearMonth(this.year, this.month);

  @override
  bool operator ==(Object other) =>
      other is YearMonth && other.year == year && other.month == month;

  @override
  int get hashCode => Object.hash(year, month);
}

class NotesStore extends ChangeNotifier {
  // Structure: data[JalaliYear][JalaliMonth][JalaliDay] -> List<NoteEntry>
  final Map<int, Map<int, Map<int, List<NoteEntry>>>> _data = {};
  bool _isLoaded = false;
  static const _prefsKey = 'notes_data'; // keep same key for backward compatibility
  bool get isLoaded => _isLoaded;

  // -------- Persistence --------

  Future<void> loadData() async {
    if (_isLoaded) return;

    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_prefsKey);

    if (jsonString != null && jsonString.isNotEmpty) {
      try {
        final List<dynamic> jsonList = json.decode(jsonString);
        for (final item in jsonList) {
          final entry = NoteEntry.fromJson(Map<String, dynamic>.from(item));
          _addToMemory(entry);
        }
      } catch (e) {
        debugPrint('Error loading notes: $e');
      }
    }

    _isLoaded = true;
    notifyListeners();
  }

  Future<void> _saveLocal() async {
    final prefs = await SharedPreferences.getInstance();
    final allEntries = <NoteEntry>[];

    for (final yearMap in _data.values) {
      for (final monthMap in yearMap.values) {
        for (final dayList in monthMap.values) {
          allEntries.addAll(dayList);
        }
      }
    }

    // Optional: sort by createdAt asc for stable persistence
    allEntries.sort((a, b) => a.createdAt.compareTo(b.createdAt));

    final jsonString = json.encode(allEntries.map((e) => e.toJson()).toList());
    await prefs.setString(_prefsKey, jsonString);
  }

  Future<void> _saveData() async {
    await _saveLocal();
  }

  // -------- In-memory ops --------

  void _addToMemory(NoteEntry e) {
    final j = Jalali.fromDateTime(e.date);
    final y = j.year, m = j.month, d = j.day;

    _data.putIfAbsent(y, () => <int, Map<int, List<NoteEntry>>>{});
    _data[y]!.putIfAbsent(m, () => <int, List<NoteEntry>>{});
    _data[y]![m]!.putIfAbsent(d, () => <NoteEntry>[]);

    _data[y]![m]![d]!.add(e);
  }

  // -------- CRUD --------

  Future<void> add(NoteEntry e) async {
    _addToMemory(e);
    await _saveData();
    notifyListeners();
  }

  Future<void> update(NoteEntry updatedEntry) async {
    final j = Jalali.fromDateTime(updatedEntry.date);
    final y = j.year, m = j.month, d = j.day;

    final dayList = _data[y]?[m]?[d];
    if (dayList == null) return;

    final index = dayList.indexWhere((e) => e.id == updatedEntry.id);
    if (index == -1) return;

    dayList[index] = updatedEntry;
    await _saveData();
    notifyListeners();
  }

  Future<void> updateStatus(String id, bool status) async {
    for (final yearMap in _data.values) {
      for (final monthMap in yearMap.values) {
        for (final dayList in monthMap.values) {
          final index = dayList.indexWhere((e) => e.id == id);
          if (index != -1) {
            dayList[index].status = status;
            await _saveData();
            notifyListeners();
            return;
          }
        }
      }
    }
  }

  Future<void> remove(String id) async {
    for (final year in _data.keys.toList()) {
      for (final month in _data[year]!.keys.toList()) {
        for (final day in _data[year]![month]!.keys.toList()) {
          final dayList = _data[year]![month]![day]!;
          dayList.removeWhere((entry) => entry.id == id);

          if (dayList.isEmpty) {
            _data[year]![month]!.remove(day);
            if (_data[year]![month]!.isEmpty) {
              _data[year]!.remove(month);
              if (_data[year]!.isEmpty) {
                _data.remove(year);
              }
            }
          }
        }
      }
    }
    await _saveData();
    notifyListeners();
  }

  Future<void> clearAll() async {
    _data.clear();
    await _saveData();
    notifyListeners();
  }

  // -------- Queries / helpers --------

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
    final days = _data[year]?[month]?.keys.toList() ?? <int>[];
    days.sort();
    return days;
  }

  List<NoteEntry> entriesOn(int year, int month, int day) {
    final list = _data[year]?[month]?[day] ?? const <NoteEntry>[];
    // Optional: return sorted by createdAt desc for UI
    final copy = List<NoteEntry>.from(list);
    copy.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return List.unmodifiable(copy);
  }

  List<int> get years {
    final list = _data.keys.toList();
    list.sort((a, b) => b.compareTo(a));
    return list;
  }

  List<int> monthsIn(int year) {
    final months = _data[year]?.keys.toList() ?? <int>[];
    months.sort();
    return months;
  }

  bool allTasksDone(int year, int month, int day) {
    final dayList = _data[year]?[month]?[day];
    if (dayList == null || dayList.isEmpty) return false;
    return dayList.every((note) => note.status == true);
  }

  // -------- Backup / restore --------

  Future<String> exportJson() async {
    final allEntries = <NoteEntry>[];
    for (final yearMap in _data.values) {
      for (final monthMap in yearMap.values) {
        for (final dayList in monthMap.values) {
          allEntries.addAll(dayList);
        }
      }
    }
    return json.encode(allEntries.map((e) => e.toJson()).toList());
  }

  Future<void> importJson(String jsonString, {bool replace = false}) async {
    final List<dynamic> jsonList = json.decode(jsonString);
    if (replace) _data.clear();
    for (final item in jsonList) {
      final entry = NoteEntry.fromJson(Map<String, dynamic>.from(item));
      _addToMemory(entry);
    }
    await _saveData();
    notifyListeners();
  }
}