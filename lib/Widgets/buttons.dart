import 'package:flutter/material.dart';
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
    _rows.add(TaskRowData(controller: TextEditingController())); // start with one empty row
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
          controller: TextEditingController(text: e.text),
        ));
      }
      _rows.insert(0, TaskRowData(controller: TextEditingController())); // always empty row at top
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
      _rows.insert(0, TaskRowData(controller: TextEditingController()));
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
        _rows.add(TaskRowData(controller: TextEditingController()));
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
    return Column(
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
            textDirection: TextDirection.rtl,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Vazir',
              color: Theme.of(context).colorScheme.primary,
            ),
          ),
        ),

        // Fixed-height scrollable window
        SizedBox(
          height: 200, // height of the "window"
          child: ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: _rows.length,
            itemBuilder: (context, index) {
              final row = _rows[index];
              return Container(
                margin: const EdgeInsets.only(bottom: 6), // smaller gap between rows
                decoration: BoxDecoration(
                  color: const Color.fromARGB(146, 255, 255, 255),
                  border: Border.all(
                    color: Theme.of(context).colorScheme.outline.withOpacity(0.3),
                  ),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Stack(
                  children: [
                    // Text field
                    TextField(
                      controller: row.controller,
                      textDirection: TextDirection.rtl,
                      textAlign: TextAlign.right,
                      style: const TextStyle(fontSize: 13), // smaller text
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.fromLTRB(70, 10, 10, 10), // less padding
                        hintText: 'عمل روزانه...',
                        hintTextDirection: TextDirection.rtl,
                      ),
                    ),

                    // Smaller plus/minus buttons
                    Positioned(
                      left: 6,
                      top: 6,
                      bottom: 6,
                      child: Row(
                        children: [
                          _squareIconButton(
                            icon: Icons.add,
                            color: Colors.green,
                            onPressed: () => _addTask(index),
                            size: 28, // smaller button
                            iconSize: 16,
                          ),
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
    );
  }
}

class TaskRowData {
  String? id;
  TextEditingController controller;

  TaskRowData({this.id, required this.controller});
}