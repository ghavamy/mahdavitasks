import 'package:flutter/material.dart';
import 'package:mahdavitasks/BasicFiles/PersianFormats.dart';
import 'package:mahdavitasks/DatesWindow/note_store.dart';
import 'package:provider/provider.dart';
import 'package:shamsi_date/shamsi_date.dart';

class Buttons extends StatefulWidget {
  const Buttons({super.key});

  @override
  State<Buttons> createState() => _ButtonsState();
}

class _ButtonsState extends State<Buttons> {
  final List<TaskRowData> _rows = [];

  @override
  void initState() {
    super.initState();
    _rows.add(TaskRowData()); // start with one empty editable row
    WidgetsBinding.instance.addPostFrameCallback((_) => _loadTodayTasks());
  }

  Future<void> _loadTodayTasks() async {
    final store = context.read<NotesStore>();
    await store.loadData();

    final today = DateTime.now();
    final shamsi = Jalali.fromDateTime(today);
    final entries = store.entriesOn(shamsi.year, shamsi.month, shamsi.day);

    setState(() {
      _rows.clear();
      for (final e in entries) {
        _rows.add(TaskRowData(
          id: e.id,
          initialText: e.text,
          isEditing: false, // loaded tasks start locked
        ));
      }
      // always have an empty editable row at the top
      _rows.insert(0, TaskRowData());
    });
  }

  Future<void> _addTask(int index) async {
    final row = _rows[index];
    final text = row.controller.text.trim();
    if (text.isEmpty) return;

    final store = context.read<NotesStore>();
    final today = DateTime.now();

    final entry = NoteEntry(date: today, text: text);
    await store.add(entry);

    setState(() {
      row.id = entry.id;
      row.isEditing = false; // lock current row
      _rows.insert(0, TaskRowData()); // add new editable row at top
    });
  }

  Future<void> _removeTask(int index) async {
    final row = _rows[index];
    if (row.id != null) {
      final store = context.read<NotesStore>();
      await store.remove(row.id!);
    }
    setState(() {
      _rows.removeAt(index);
      if (_rows.isEmpty) {
        _rows.add(TaskRowData());
      }
    });
  }

  Widget _squareIconButton({
    required IconData icon,
    required Color color,
    required VoidCallback onPressed,
    double size = 36,
    double iconSize = 18,
  }) {
    return Container(
      width: size,
      height: size,
      margin: const EdgeInsets.symmetric(horizontal: 2),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(icon, size: iconSize, color: color),
        padding: EdgeInsets.zero,
        onPressed: onPressed,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Column(
        children: [
          // Section header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 32),
            decoration: BoxDecoration(
              color: const Color.fromARGB(146, 255, 255, 255),
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
                bottom: BorderSide(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                ),
              ),
            ),
            child: Text(
              'اعمال روزانه برای رضایت امام زمان',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Vazir',
                color: Theme.of(context).colorScheme.primary,
                decoration: TextDecoration.none,
              ),
            ),
          ),

          // Fixed-height scrollable window
          SizedBox(
            height: 200,
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _rows.length,
              itemBuilder: (context, index) {
                final row = _rows[index];
                final raw = row.controller.text.trimLeft();
                final display = forceRtlParagraph(
                  PersianUtils.toPersianDigits(raw),
                );

                return Container(
                  margin: const EdgeInsets.only(bottom: 6),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(146, 255, 255, 255),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                    ),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Stack(
                    children: [
                      row.isEditing
                          ? TextField(
                              controller: row.controller,
                              textDirection: TextDirection.rtl,
                              textAlign: TextAlign.right,
                              style: const TextStyle(
                                fontSize: 13,
                                decoration: TextDecoration.none,
                              ),
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.fromLTRB(70, 10, 10, 10),
                                hintText: 'عمل روزانه...',
                                hintTextDirection: TextDirection.rtl,
                              ),
                              onChanged: (_) => setState(() {}),
                            )
                          : Padding(
                              padding: const EdgeInsets.fromLTRB(70, 10, 10, 10),
                              child: Text(
                                display,
                                textDirection: TextDirection.rtl,
                                textAlign: TextAlign.start,
                                style: const TextStyle(
                                  fontSize: 13,
                                  fontFamily: 'Vazir',
                                  color: Colors.black87,
                                  decoration: TextDecoration.none,
                                ),
                              ),
                            ),

                      // Add/Remove buttons
                      Positioned(
                        left: 6,
                        top: 6,
                        bottom: 6,
                        child: Row(
                          children: [
                            if (row.isEditing)
                              _squareIconButton(
                                icon: Icons.add,
                                color: Colors.green,
                                onPressed: () => _addTask(index),
                                size: 28,
                                iconSize: 16,
                              )
                            else
                              _squareIconButton(
                                icon: Icons.remove,
                                color: Colors.red,
                                onPressed: () => _removeTask(index),
                                size: 28,
                                iconSize: 16,
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String forceRtlParagraph(String s) {
    if (s.isEmpty) return s;
    const rle = '\u202B'; // Right-to-Left Embedding
    const pdf = '\u202C'; // Pop Directional Formatting
    return '$rle$s$pdf';
  }
}

class TaskRowData {
  String? id;
  TextEditingController controller;
  bool isEditing;

  TaskRowData({
    this.id,
    String initialText = '',
    bool? isEditing,
    }) : controller = TextEditingController(text: initialText),
        isEditing = isEditing ?? initialText.trim().isEmpty;
}